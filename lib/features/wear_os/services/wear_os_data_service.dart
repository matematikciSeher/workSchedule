import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wear_os_models.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/task_entity.dart';

/// Wear OS companion uygulama için veri senkronizasyon servisi
/// Ana uygulamadan Wear OS'a veri aktarımı için shared preferences kullanır
class WearOsDataService {
  static const String _eventsKey = 'wear_os_events';
  static const String _tasksKey = 'wear_os_tasks';
  static const String _lastSyncKey = 'wear_os_last_sync';
  static const String _summaryKey = 'wear_os_daily_summary';

  /// Ana uygulamadan gelen eventleri Wear OS formatına dönüştür ve kaydet
  Future<void> syncEvents(List<EventEntity> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wearOsEvents =
          events.map((e) => WearOsEvent.fromEntity(e)).toList();

      // JSON olarak kaydet
      final eventsJson = wearOsEvents.map((e) => e.toJson()).toList();
      await prefs.setString(_eventsKey, jsonEncode(eventsJson));

      // Son senkronizasyon zamanını kaydet
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());

      // Günlük özeti güncelle
      await _updateDailySummary(prefs);
    } catch (e) {
      print('WearOsDataService: Event sync error: $e');
    }
  }

  /// Ana uygulamadan gelen taskleri Wear OS formatına dönüştür ve kaydet
  Future<void> syncTasks(List<TaskEntity> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wearOsTasks = tasks.map((t) => WearOsTask.fromEntity(t)).toList();

      // JSON olarak kaydet
      final tasksJson = wearOsTasks.map((t) => t.toJson()).toList();
      await prefs.setString(_tasksKey, jsonEncode(tasksJson));

      // Son senkronizasyon zamanını kaydet
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());

      // Günlük özeti güncelle
      await _updateDailySummary(prefs);
    } catch (e) {
      print('WearOsDataService: Task sync error: $e');
    }
  }

  /// Wear OS'tan eventleri oku
  Future<List<WearOsEvent>> getEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJsonStr = prefs.getString(_eventsKey);

      if (eventsJsonStr == null) return [];

      final List<dynamic> eventsJson = jsonDecode(eventsJsonStr);
      return eventsJson
          .map((e) => WearOsEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('WearOsDataService: Get events error: $e');
      return [];
    }
  }

  /// Wear OS'tan taskleri oku
  Future<List<WearOsTask>> getTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJsonStr = prefs.getString(_tasksKey);

      if (tasksJsonStr == null) return [];

      final List<dynamic> tasksJson = jsonDecode(tasksJsonStr);
      return tasksJson
          .map((t) => WearOsTask.fromJson(t as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('WearOsDataService: Get tasks error: $e');
      return [];
    }
  }

  /// Belirli bir tarih için etkinlikleri getir
  Future<List<WearOsEvent>> getEventsForDate(DateTime date) async {
    final events = await getEvents();
    return events.where((e) {
      return e.startDate.year == date.year &&
          e.startDate.month == date.month &&
          e.startDate.day == date.day;
    }).toList();
  }

  /// Belirli bir tarih için görevleri getir
  Future<List<WearOsTask>> getTasksForDate(DateTime date) async {
    final tasks = await getTasks();
    return tasks.where((t) {
      if (t.dueDate == null) return false;
      return t.dueDate!.year == date.year &&
          t.dueDate!.month == date.month &&
          t.dueDate!.day == date.day;
    }).toList();
  }

  /// Günlük özeti getir
  Future<WearOsDailySummary?> getDailySummary(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final summaryKey =
          '${_summaryKey}_${date.year}_${date.month}_${date.day}';
      final summaryJsonStr = prefs.getString(summaryKey);

      if (summaryJsonStr == null) {
        // Eğer özet yoksa, şimdi oluştur
        return await _generateDailySummary(date);
      }

      final summaryJson = jsonDecode(summaryJsonStr) as Map<String, dynamic>;

      final eventsJson = summaryJson['events'] as List? ?? [];
      final tasksJson = summaryJson['tasks'] as List? ?? [];

      final events = eventsJson
          .map((e) => WearOsEvent.fromJson(e as Map<String, dynamic>))
          .toList();
      final tasks = tasksJson
          .map((t) => WearOsTask.fromJson(t as Map<String, dynamic>))
          .toList();

      return WearOsDailySummary(
        date: date,
        events: events,
        tasks: tasks,
        completedTasksCount: summaryJson['completedTasksCount'] as int? ?? 0,
        totalTasksCount: summaryJson['totalTasksCount'] as int? ?? 0,
      );
    } catch (e) {
      print('WearOsDataService: Get daily summary error: $e');
      return await _generateDailySummary(date);
    }
  }

  /// Günlük özeti oluştur
  Future<WearOsDailySummary> _generateDailySummary(DateTime date) async {
    final events = await getEventsForDate(date);
    final tasks = await getTasksForDate(date);

    final completedTasksCount = tasks.where((t) => t.isCompleted).length;
    final totalTasksCount = tasks.length;

    return WearOsDailySummary(
      date: date,
      events: events,
      tasks: tasks,
      completedTasksCount: completedTasksCount,
      totalTasksCount: totalTasksCount,
    );
  }

  /// Günlük özeti güncelle
  Future<void> _updateDailySummary(SharedPreferences prefs) async {
    try {
      final today = DateTime.now();
      final summaryKey =
          '${_summaryKey}_${today.year}_${today.month}_${today.day}';

      final events = await getEventsForDate(today);
      final tasks = await getTasksForDate(today);

      final completedTasksCount = tasks.where((t) => t.isCompleted).length;
      final totalTasksCount = tasks.length;

      final summary = {
        'date': today.toIso8601String(),
        'events': events.map((e) => e.toJson()).toList(),
        'tasks': tasks.map((t) => t.toJson()).toList(),
        'completedTasksCount': completedTasksCount,
        'totalTasksCount': totalTasksCount,
      };

      await prefs.setString(summaryKey, jsonEncode(summary));
    } catch (e) {
      print('WearOsDataService: Update daily summary error: $e');
    }
  }

  /// Son senkronizasyon zamanını getir
  Future<DateTime?> getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSyncStr = prefs.getString(_lastSyncKey);

      if (lastSyncStr == null) return null;
      return DateTime.parse(lastSyncStr);
    } catch (e) {
      print('WearOsDataService: Get last sync time error: $e');
      return null;
    }
  }

  /// Belirli bir eventi bul
  Future<WearOsEvent?> getEventById(String eventId) async {
    final events = await getEvents();
    try {
      return events.firstWhere((e) => e.id == eventId);
    } catch (e) {
      return null;
    }
  }

  /// Belirli bir taski bul
  Future<WearOsTask?> getTaskById(String taskId) async {
    final tasks = await getTasks();
    try {
      return tasks.firstWhere((t) => t.id == taskId);
    } catch (e) {
      return null;
    }
  }

  /// Yaklaşan etkinlikleri getir (sonraki 24 saat)
  Future<List<WearOsEvent>> getUpcomingEvents() async {
    final now = DateTime.now();
    final next24Hours = now.add(const Duration(hours: 24));

    final events = await getEvents();
    return events
        .where((e) =>
            e.startDate.isAfter(now) && e.startDate.isBefore(next24Hours))
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  /// Acil görevleri getir
  Future<List<WearOsTask>> getUrgentTasks() async {
    final tasks = await getTasks();
    return tasks
        .where((t) => !t.isCompleted && t.urgencyLevel == 'urgent')
        .toList();
  }

  /// Verileri temizle (test/debug için)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eventsKey);
    await prefs.remove(_tasksKey);
    await prefs.remove(_lastSyncKey);

    // Tüm günlük özetleri temizle
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_summaryKey)) {
        await prefs.remove(key);
      }
    }
  }
}
