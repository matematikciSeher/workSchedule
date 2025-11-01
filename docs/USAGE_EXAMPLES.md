# 📚 Kullanım Örnekleri

Bu dokümanda, performans optimizasyonlarının pratik kullanım örnekleri bulunmaktadır.

## 🗂️ İçindekiler

1. [Paginated Event List](#1-paginated-event-list)
2. [Caching Kullanımı](#2-caching-kullanımı)
3. [Performance Utilities](#3-performance-utilities)
4. [Optimized Queries](#4-optimized-queries)

---

## 1. Paginated Event List

### Basit Kullanım

```dart
import 'package:flutter/material.dart';
import '../../shared/widgets/paginated_event_list_widget.dart';
import '../../domain/repositories/event_repository.dart';

class EventsPage extends StatelessWidget {
  final EventRepository eventRepository;
  final String userId;

  const EventsPage({
    super.key,
    required this.eventRepository,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinliklerim'),
      ),
      body: PaginatedEventListWidget(
        eventRepository: eventRepository,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        userId: userId,
        pageSize: 20,
        itemBuilder: (context, event) {
          return EventCard(event: event);
        },
        emptyBuilder: (context) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Henüz etkinlik yok',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Custom Event Card Örneği

```dart
class EventCard extends StatelessWidget {
  final EventEntity event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.event,
            color: Colors.white,
          ),
        ),
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formatDate(event.startDate)),
            if (event.location != null)
              Text('📍 ${event.location}'),
          ],
        ),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailPage(event: event),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
```

---

## 2. Caching Kullanımı

### Event Caching

```dart
import '../../core/utils/cache_manager.dart';

class EventService {
  final EventRepository eventRepository;
  final EventCacheManager cacheManager = EventCacheManager();

  EventService(this.eventRepository);

  /// Cache-aware event getter
  Future<EventEntity?> getEvent(String eventId) async {
    // Önce cache'den kontrol et
    final cachedEvent = cacheManager.getEvent<EventEntity>(eventId);
    if (cachedEvent != null) {
      return cachedEvent;
    }

    // Cache'de yoksa repository'den çek
    final event = await eventRepository.getEventById(eventId);
    
    if (event != null) {
      // Cache'e ekle
      cacheManager.putEvent(eventId, event);
    }

    return event;
  }

  /// Cache-aware date range events
  Future<List<EventEntity>> getEventsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    // Cache'den kontrol et
    final cachedEvents = cacheManager.getEventsByDateRange<EventEntity>(start, end);
    if (cachedEvents != null) {
      return cachedEvents;
    }

    // Repository'den çek
    final events = await eventRepository.getEventsByDateRange(
      start,
      end,
    );

    // Cache'e ekle
    cacheManager.putEventsByDateRange(start, end, events);

    return events;
  }

  /// Event değiştiğinde cache'i invalidate et
  Future<void> updateEvent(EventEntity event) async {
    final updatedEvent = await eventRepository.updateEvent(event);
    
    // Cache'i temizle
    cacheManager.invalidateEvent(event.id);
    
    // Date range cache'leri de temizle
    cacheManager.clearAll();
  }
}
```

### Generic Cache Kullanımı

```dart
class SettingsCache {
  final CacheManager cacheManager = CacheManager();

  /// User preferences cache
  Future<UserPreferences?> getUserPreferences() async {
    return cacheManager.get<UserPreferences>('user_preferences');
  }

  void setUserPreferences(UserPreferences preferences) {
    cacheManager.put(
      'user_preferences',
      preferences,
      ttl: const Duration(hours: 1),
    );
  }

  /// Calendar configuration cache
  Future<CalendarConfig?> getCalendarConfig() async {
    return cacheManager.get<CalendarConfig>('calendar_config');
  }

  void setCalendarConfig(CalendarConfig config) {
    cacheManager.put(
      'calendar_config',
      config,
      ttl: const Duration(minutes: 30),
    );
  }

  /// Clear all settings cache
  void clearAll() {
    cacheManager.clear();
  }
}
```

---

## 3. Performance Utilities

### Debounce ile Arama

```dart
import '../../core/utils/performance_utils.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final Function _debouncedSearch;
  List<EventEntity> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    
    // Debounce search with 500ms delay
    _debouncedSearch = PerformanceUtils.debounce(
      () {
        _performSearch();
      },
      delay: const Duration(milliseconds: 500),
    );
  }

  void _performSearch() async {
    setState(() => _isSearching = true);
    
    try {
      // Perform search
      final results = await eventRepository.getAllEvents();
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ara'),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Etkinlik ara...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _debouncedSearch();
              },
            ),
          ),
          
          // Search results
          if (_isSearching)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return EventCard(event: _searchResults[index]);
                },
              ),
            ),
        ],
      ),
    );
  }
}
```

### Throttle ile Scroll Tracking

```dart
class ScrollableEventsPage extends StatefulWidget {
  @override
  _ScrollableEventsPageState createState() => _ScrollableEventsPageState();
}

class _ScrollableEventsPageState extends State<ScrollableEventsPage> {
  late final Function _throttledScrollUpdate;
  double _scrollPosition = 0;

  @override
  void initState() {
    super.initState();
    
    _throttledScrollUpdate = PerformanceUtils.throttle(
      () {
        // Update scroll position
        if (mounted) {
          setState(() {
            _scrollPosition = _scrollController.offset;
          });
        }
      },
      delay: const Duration(milliseconds: 100),
    );
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _throttledScrollUpdate();
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(title: Text('Item $index'));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
```

### Memoization ile Expensive Computation

```dart
class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Expensive date formatting computation
  String _formatEventDate(DateTime date) {
    // Heavy computation
    return DateFormat('EEEE, d MMMM yyyy', 'tr_TR').format(date);
  }

  // Memoized version
  late final Function _memoizedFormatDate = PerformanceUtils.memoize(
    (DateTime date) => _formatEventDate(date),
  );

  @override
  Widget build(BuildContext context) {
    final events = [/* ... events ... */];
    
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        
        // İlk çağrı hesaplar, sonraki çağrılar cache'den gelir
        final formattedDate = _memoizedFormatDate(event.startDate);
        
        return ListTile(
          title: Text(event.title),
          subtitle: Text(formattedDate),
        );
      },
    );
  }
}
```

---

## 4. Optimized Queries

### Repository Kullanımı

```dart
class EventListViewModel {
  final EventRepository eventRepository;

  EventListViewModel(this.eventRepository);

  /// Get limited events
  Future<List<EventEntity>> getRecentEvents() async {
    return await eventRepository.getAllEvents(
      userId: currentUserId,
      limit: 10,
      ascending: false,
    );
  }

  /// Get events by date range
  Future<List<EventEntity>> getUpcomingEvents() async {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    
    return await eventRepository.getEventsByDateRange(
      now,
      nextWeek,
      userId: currentUserId,
    );
  }

  /// Realtime events stream
  Stream<List<EventEntity>> watchUpcomingEvents() {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    
    return eventRepository.listenEvents(
      userId: currentUserId,
      startDate: now,
      endDate: nextWeek,
      limit: 50,
    );
  }
}
```

### BLoC Pattern ile Kullanım

```dart
class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc(this.eventRepository) : super(EventInitial()) {
    on<LoadEventsEvent>(_onLoadEvents);
    on<RefreshEventsEvent>(_onRefreshEvents);
  }

  Future<void> _onLoadEvents(
    LoadEventsEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());
    
    try {
      final events = await eventRepository.getEventsByDateRange(
        event.startDate,
        event.endDate,
        userId: event.userId,
      );
      
      emit(EventLoaded(events: events));
    } catch (e) {
      emit(EventError(message: e.toString()));
    }
  }

  Future<void> _onRefreshEvents(
    RefreshEventsEvent event,
    Emitter<EventState> emit,
  ) async {
    final currentState = state;
    if (currentState is EventLoaded) {
      emit(EventRefreshing(events: currentState.events));
    }
    
    // Refresh logic
  }
}
```

---

## 🔗 İlgili Dosyalar

- `lib/shared/widgets/paginated_event_list_widget.dart` - Pagination widget
- `lib/core/utils/performance_utils.dart` - Performance utilities
- `lib/core/utils/cache_manager.dart` - Cache manager
- `lib/features/event/data/datasources/event_remote_datasource.dart` - Optimized queries
- `docs/PERFORMANCE_OPTIMIZATION.md` - Detaylı optimizasyon rehberi

