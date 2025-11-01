import 'package:flutter/material.dart';
import '../services/wear_os_data_service.dart';
import '../models/wear_os_models.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/task_entity.dart';

/// Wear OS entegrasyonu için örnek kullanım dosyası
/// Ana uygulamada Event ve Task BLoC'larında kullanılabilir

class WearOsIntegrationExample {
  final WearOsDataService _wearOsService = WearOsDataService();

  /// 1. EVENT'LERİ SENKRONİZE ETME ÖRNEĞİ
  /// Ana uygulamada bir etkinlik oluşturulduğunda/güncellendiğinde çağrılır
  Future<void> syncEventsAfterCrud(List<EventEntity> events) async {
    try {
      print('🔄 Wear OS\'a ${events.length} etkinlik senkronize ediliyor...');
      await _wearOsService.syncEvents(events);
      print('✅ Etkinlikler başarıyla senkronize edildi');
    } catch (e) {
      print('❌ Wear OS senkronizasyon hatası: $e');
    }
  }

  /// 2. GÖREVLERİ SENKRONİZE ETME ÖRNEĞİ
  /// Ana uygulamada bir görev oluşturulduğunda/güncellendiğinde çağrılır
  Future<void> syncTasksAfterCrud(List<TaskEntity> tasks) async {
    try {
      print('🔄 Wear OS\'a ${tasks.length} görev senkronize ediliyor...');
      await _wearOsService.syncTasks(tasks);
      print('✅ Görevler başarıyla senkronize edildi');
    } catch (e) {
      print('❌ Wear OS senkronizasyon hatası: $e');
    }
  }

  /// 3. GÜNLÜK ÖZET GETİRME ÖRNEĞİ
  /// Ana uygulama dashboard'unda gösterebilirsiniz
  Future<Widget> buildDailySummaryWidget() async {
    try {
      final today = DateTime.now();
      final summary = await _wearOsService.getDailySummary(today);
      
      if (summary == null) {
        return const Text('Veri bulunamadı');
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Bugünün Özeti',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Etkinlikler: ${summary.events.length}'),
            Text(
              'Görevler: ${summary.completedTasksCount}/${summary.totalTasksCount}',
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: summary.completionPercentage,
            ),
          ],
        ),
      );
    } catch (e) {
      return Text('Hata: $e');
    }
  }

  /// 4. ACİL GÖREVLERİ GETİRME ÖRNEĞİ
  /// Ana uygulama ana sayfasında gösterilebilir
  Future<List<WearOsTask>> getUrgentTasks() async {
    try {
      final urgentTasks = await _wearOsService.getUrgentTasks();
      return urgentTasks;
    } catch (e) {
      print('❌ Acil görevler getirilemedi: $e');
      return [];
    }
  }

  /// 5. YAKLAŞAN ETKİNLİKLERİ GETİRME ÖRNEĞİ
  /// Ana uygulama ana sayfasında gösterilebilir
  Future<List<WearOsEvent>> getUpcomingEvents() async {
    try {
      final upcomingEvents = await _wearOsService.getUpcomingEvents();
      return upcomingEvents;
    } catch (e) {
      print('❌ Yaklaşan etkinlikler getirilemedi: $e');
      return [];
    }
  }

  /// 6. BELİRLİ BİR TARİH İÇİN VERİ GETİRME ÖRNEĞİ
  Future<Map<String, dynamic>> getDataForDate(DateTime date) async {
    try {
      final events = await _wearOsService.getEventsForDate(date);
      final tasks = await _wearOsService.getTasksForDate(date);
      
      return {
        'events': events,
        'tasks': tasks,
        'date': date,
      };
    } catch (e) {
      print('❌ Tarih verisi getirilemedi: $e');
      return {'events': [], 'tasks': [], 'date': date};
    }
  }

  /// 7. SON SENKRONİZASYON ZAMANINI KONTROL ETME ÖRNEĞİ
  Future<bool> shouldSync() async {
    try {
      final lastSync = await _wearOsService.getLastSyncTime();
      
      if (lastSync == null) return true;
      
      final now = DateTime.now();
      final difference = now.difference(lastSync);
      
      // Son 5 dakikadan fazla olduysa senkronize et
      return difference.inMinutes > 5;
    } catch (e) {
      return true;
    }
  }

  /// 8. VERİ TEMİZLEME ÖRNEĞİ (DEBUG/TEST İÇİN)
  Future<void> clearWearOsData() async {
    try {
      await _wearOsService.clearAllData();
      print('✅ Wear OS verileri temizlendi');
    } catch (e) {
      print('❌ Veri temizleme hatası: $e');
    }
  }
}

/// BLOC INTEGRATION ÖRNEK
/// Event BLoC içinde kullanım:
/*

import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/wear_os/examples/wear_os_integration_example.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;
  final WearOsIntegrationExample wearOsIntegration;

  EventBloc({
    required this.eventRepository,
    required this.wearOsIntegration,
  }) : super(EventInitial()) {
    on<LoadEventsEvent>(_onLoadEvents);
    on<CreateEventEvent>(_onCreateEvent);
    on<UpdateEventEvent>(_onUpdateEvent);
  }

  Future<void> _onLoadEvents(
    LoadEventsEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(EventLoading());
    try {
      final events = await eventRepository.getAllEvents();
      emit(EventLoaded(events));
      
      // Wear OS'a senkronize et
      await wearOsIntegration.syncEventsAfterCrud(events);
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  Future<void> _onCreateEvent(
    CreateEventEvent event,
    Emitter<EventState> emit,
  ) async {
    try {
      final createdEvent = await eventRepository.createEvent(event.event);
      final allEvents = await eventRepository.getAllEvents();
      emit(EventLoaded(allEvents));
      
      // Wear OS'a senkronize et
      await wearOsIntegration.syncEventsAfterCrud(allEvents);
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }

  // ... diğer handler'lar
}

*/

/// TASK BLOC INTEGRATION ÖRNEK
/// Task BLoC içinde kullanım:
/*

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  final WearOsIntegrationExample wearOsIntegration;

  TaskBloc({
    required this.taskRepository,
    required this.wearOsIntegration,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<CompleteTaskEvent>(_onCompleteTask);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await taskRepository.getAllTasks();
      emit(TaskLoaded(tasks));
      
      // Wear OS'a senkronize et
      await wearOsIntegration.syncTasksAfterCrud(tasks);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCompleteTask(
    CompleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await taskRepository.updateTask(
        event.task.copyWith(isCompleted: !event.task.isCompleted),
      );
      final allTasks = await taskRepository.getAllTasks();
      emit(TaskLoaded(allTasks));
      
      // Wear OS'a senkronize et
      await wearOsIntegration.syncTasksAfterCrud(allTasks);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}

*/

