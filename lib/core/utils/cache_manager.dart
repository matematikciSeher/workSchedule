import 'dart:async';

/// Cache manager for performance optimization
/// State ve data caching için generic cache manager
class CacheManager {
  static final CacheManager _instance = CacheManager._internal();
  factory CacheManager() => _instance;
  CacheManager._internal();

  final Map<String, CacheEntry> _cache = {};
  final Duration _defaultTtl = const Duration(minutes: 5);

  /// Cache'e ekle
  void put<T>(String key, T value, {Duration? ttl}) {
    _cache[key] = CacheEntry(
      value: value,
      expiryTime: DateTime.now().add(ttl ?? _defaultTtl),
    );
  }

  /// Cache'den al
  T? get<T>(String key) {
    final entry = _cache[key];
    
    if (entry == null) return null;
    
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    
    return entry.value as T;
  }

  /// Cache'de var mı?
  bool containsKey(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    
    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }
    
    return true;
  }

  /// Cache'den sil
  void remove(String key) {
    _cache.remove(key);
  }

  /// Tüm cache'i temizle
  void clear() {
    _cache.clear();
  }

  /// Süresi dolmuş cache'leri temizle
  void clearExpired() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }

  /// Cache boyutunu al
  int get size => _cache.length;

  /// Otomatik temizleme başlat (optional)
  Timer? _cleanupTimer;
  
  void startAutoCleanup({Duration interval = const Duration(minutes: 1)}) {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(interval, (_) => clearExpired());
  }

  void stopAutoCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }
}

/// Cache entry model
class CacheEntry {
  final dynamic value;
  final DateTime expiryTime;

  CacheEntry({
    required this.value,
    required this.expiryTime,
  });

  bool get isExpired => DateTime.now().isAfter(expiryTime);
}

/// Date range cache için özel manager
class DateRangeCacheManager {
  static final DateRangeCacheManager _instance = DateRangeCacheManager._internal();
  factory DateRangeCacheManager() => _instance;
  DateRangeCacheManager._internal();

  final CacheManager _cacheManager = CacheManager();

  /// Tarih aralığı için key oluştur
  String _getKey(DateTime start, DateTime end) {
    return 'dateRange_${start.millisecondsSinceEpoch}_${end.millisecondsSinceEpoch}';
  }

  /// Cache'e ekle
  void put<T>(DateTime start, DateTime end, T value, {Duration? ttl}) {
    _cacheManager.put(_getKey(start, end), value, ttl: ttl);
  }

  /// Cache'den al
  T? get<T>(DateTime start, DateTime end) {
    return _cacheManager.get<T>(_getKey(start, end));
  }

  /// Cache'den sil
  void remove(DateTime start, DateTime end) {
    _cacheManager.remove(_getKey(start, end));
  }

  /// Tüm date range cache'lerini temizle
  void clearAll() {
    _cacheManager.clear();
  }
}

/// Event data için özel cache manager
class EventCacheManager {
  static final EventCacheManager _instance = EventCacheManager._internal();
  factory EventCacheManager() => _instance;
  EventCacheManager._internal();

  final CacheManager _cacheManager = CacheManager();
  final DateRangeCacheManager _dateRangeCache = DateRangeCacheManager();

  /// Event cache key oluştur
  String _getEventKey(String eventId) => 'event_$eventId';
  

  /// Single event cache'e ekle
  void putEvent<T>(String eventId, T event) {
    _cacheManager.put(_getEventKey(eventId), event, ttl: const Duration(hours: 1));
  }

  /// Single event cache'den al
  T? getEvent<T>(String eventId) {
    return _cacheManager.get<T>(_getEventKey(eventId));
  }

  /// Event'leri date range ile cache'e ekle
  void putEventsByDateRange<T>(DateTime start, DateTime end, List<T> events) {
    _dateRangeCache.put(start, end, events, ttl: const Duration(minutes: 5));
  }

  /// Event'leri date range ile cache'den al
  List<T>? getEventsByDateRange<T>(DateTime start, DateTime end) {
    return _dateRangeCache.get<List<T>>(start, end);
  }

  /// Event cache'i temizle
  void invalidateEvent(String eventId) {
    _cacheManager.remove(_getEventKey(eventId));
    // Date range cache'leri de temizle çünkü değişmiş olabilir
    _dateRangeCache.clearAll();
  }

  /// Tüm cache'leri temizle
  void clearAll() {
    _cacheManager.clear();
    _dateRangeCache.clearAll();
  }
}

