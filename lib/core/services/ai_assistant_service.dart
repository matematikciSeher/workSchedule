import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../../domain/repositories/task_repository.dart';
import 'package:intl/intl.dart';

/// AI Asistan Servisi - Takvim sorgulama ve akıllı yanıtlar için
class AiAssistantService {
  final EventRepository? eventRepository;
  final TaskRepository? taskRepository;
  final String? apiKey; // OpenAI API key (opsiyonel)
  
  // Eğer API key yoksa, yerel akıllı yanıtlar verir
  final bool useLocalMode;

  AiAssistantService({
    this.eventRepository,
    this.taskRepository,
    this.apiKey,
    this.useLocalMode = true, // Varsayılan olarak yerel mod
  });

  /// Kullanıcının sorusuna yanıt ver
  Future<String> answerQuestion(String question) async {
    final lowerQuestion = question.toLowerCase().trim();

    // Soru tiplerini analiz et (özel kategoriler genel olanlardan önce)
    if (_isQuestionAboutHelp(lowerQuestion)) {
      return _getHelpMessage();
    } else if (_isQuestionAboutToday(lowerQuestion)) {
      return await _getTodaySchedule();
    } else if (_isQuestionAboutTomorrow(lowerQuestion)) {
      return await _getTomorrowSchedule();
    } else if (_isQuestionAboutWeekend(lowerQuestion)) {
      return await _getWeekendSchedule();
    } else if (_isQuestionAboutWeek(lowerQuestion)) {
      return await _getWeekSummary();
    } else if (_isQuestionAboutFreeTime(lowerQuestion)) {
      return await _getFreeTimeAnalysis();
    } else if (_isQuestionAboutOverdueTasks(lowerQuestion)) {
      return await _getOverdueTasksSummary();
    } else if (_isQuestionAboutPriorityTasks(lowerQuestion)) {
      return await _getPriorityTasksSummary();
    } else if (_isQuestionAboutNextEvent(lowerQuestion)) {
      return await _getNextEventSummary();
    } else if (_isQuestionAboutTasks(lowerQuestion)) {
      return await _getTasksSummary();
    } else if (_isQuestionAboutEvents(lowerQuestion)) {
      return await _getEventsSummary();
    } else if (_isQuestionAboutGreeting(lowerQuestion)) {
      return _getGreetingMessage();
    } else {
      // Genel sorular için AI'a yönlendir veya genel yanıt ver
      if (apiKey != null && !useLocalMode) {
        return await _getAiResponse(question);
      } else {
        return _getDefaultResponse(question);
      }
    }
  }

  /// "Bugün ne yapmalıyım?" sorusu mu?
  bool _isQuestionAboutToday(String question) {
    final todayKeywords = [
      'bugün', 'bugünkü', 'today', 'şimdi', 'şu an', 'gün içinde',
      'bugün ne', 'bugün ne yap', 'bugünkü görev', 'bugünkü plan',
      'bugünkü program', 'bugün ne var', 'bu gün',
    ];
    return todayKeywords.any((keyword) => question.contains(keyword));
  }

  /// "Yarın ne yapmalıyım?" sorusu mu?
  bool _isQuestionAboutTomorrow(String question) {
    final tomorrowKeywords = [
      'yarın', 'tomorrow', 'yarınki', 'yarın ne', 'yarın ne yap',
      'yarın ne var', 'yarınki plan', 'yarınki program',
    ];
    return tomorrowKeywords.any((keyword) => question.contains(keyword));
  }

  /// Hafta sonu sorgusu mu?
  bool _isQuestionAboutWeekend(String question) {
    final weekendKeywords = [
      'hafta sonu', 'weekend', 'cumartesi', 'pazar', 'haftasonu',
      'hafta sonu plan', 'hafta sonu ne',
    ];
    return weekendKeywords.any((keyword) => question.contains(keyword));
  }

  /// Boş zaman sorgusu mu?
  bool _isQuestionAboutFreeTime(String question) {
    final freeTimeKeywords = [
      'boş zaman', 'free time', 'müsait', 'ne zaman boş', 'serbest',
      'boş saat', 'boşluk var mı', 'boş zamanım var mı', 'uygun saat',
      'ne kadar boş', 'yoğun muyum', 'yoğun mu', 'dolu muyum',
    ];
    return freeTimeKeywords.any((keyword) => question.contains(keyword));
  }

  /// Geciken görevler sorgusu mu?
  bool _isQuestionAboutOverdueTasks(String question) {
    final overdueKeywords = [
      'geciken', 'gecikmiş', 'geç kalmış', 'süresi geçmiş', 'overdue',
      'geçmiş görev', 'gecikmiş görev', 'vadesi geçmiş', 'kaçırdığım',
    ];
    return overdueKeywords.any((keyword) => question.contains(keyword));
  }

  /// Öncelikli görevler sorgusu mu?
  bool _isQuestionAboutPriorityTasks(String question) {
    final priorityKeywords = [
      'öncelikli', 'acil', 'yüksek öncelik', 'önemli görev',
      'priority', 'kritik', 'önce ne yapmalı', 'en önemli',
    ];
    return priorityKeywords.any((keyword) => question.contains(keyword));
  }

  /// Sıradaki etkinlik sorgusu mu?
  bool _isQuestionAboutNextEvent(String question) {
    final nextEventKeywords = [
      'sıradaki', 'bir sonraki', 'yaklaşan etkinlik', 'en yakın',
      'sonraki etkinlik', 'next event', 'bir sonraki toplantı',
      'sıradaki toplantı', 'sıradaki randevu', 'ne zaman toplantı',
    ];
    return nextEventKeywords.any((keyword) => question.contains(keyword));
  }

  /// Görevler hakkında soru mu?
  bool _isQuestionAboutTasks(String question) {
    final taskKeywords = [
      'görev', 'task', 'yapılacak', 'todo', 'iş listesi',
      'ne yapmalı', 'hangi görev', 'görevler', 'tamamlanmamış',
      'yapılacaklar', 'checklist', 'bekleyen görev', 'tamamlanan',
    ];
    return taskKeywords.any((keyword) => question.contains(keyword));
  }

  /// Etkinlikler hakkında soru mu?
  bool _isQuestionAboutEvents(String question) {
    final eventKeywords = [
      'etkinlik', 'event', 'toplantı', 'randevu', 'planlanan',
      'hangi etkinlik', 'etkinlikler', 'ajandam', 'programım',
      'takvimim', 'ne planlı',
    ];
    return eventKeywords.any((keyword) => question.contains(keyword));
  }

  /// Hafta hakkında soru mu?
  bool _isQuestionAboutWeek(String question) {
    final weekKeywords = [
      'bu hafta', 'haftalık', 'hafta plan', 'hafta özeti',
      'week', 'haftam nasıl', 'haftalık özet',
    ];
    return weekKeywords.any((keyword) => question.contains(keyword)) ||
        (question.contains('hafta') && !question.contains('hafta sonu'));
  }

  /// Selamlama mı?
  bool _isQuestionAboutGreeting(String question) {
    final greetingKeywords = [
      'merhaba', 'selam', 'hey', 'günaydın', 'iyi akşamlar',
      'hello', 'hi', 'naber', 'nasılsın',
    ];
    final trimmed = question.replaceAll(RegExp(r'[!?.]'), '').trim();
    return greetingKeywords.any((keyword) => trimmed == keyword || trimmed.startsWith('$keyword '));
  }

  /// Yardım sorusu mu?
  bool _isQuestionAboutHelp(String question) {
    final helpKeywords = [
      'yardım', 'help', 'ne sorabilirim', 'ne yapabilirsin',
      'nasıl kullanılır', 'komutlar', 'neler sorabilirim',
      'neler yapabilirsin', 'örnek sorular',
    ];
    return helpKeywords.any((keyword) => question.contains(keyword));
  }

  /// Bugünkü programı getir
  Future<String> _getTodaySchedule() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day, 0, 0);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59);

    final buffer = StringBuffer();
    buffer.writeln('📅 **Bugünkü Programınız**');
    buffer.writeln('');

    // Etkinlikleri getir
    if (eventRepository != null) {
      try {
        final events = await eventRepository!.getEventsByDateRange(
          todayStart,
          todayEnd,
        );

        if (events.isNotEmpty) {
          buffer.writeln('🎯 **Etkinlikler:**');
          events.sort((a, b) => a.startDate.compareTo(b.startDate));
          
          for (var event in events) {
            final timeStr = DateFormat('HH:mm').format(event.startDate);
            final endTimeStr = DateFormat('HH:mm').format(event.endDate);
            buffer.writeln('• $timeStr-$endTimeStr: ${event.title}');
            if (event.location != null) {
              buffer.writeln('  📍 ${event.location}');
            }
          }
          buffer.writeln('');
        }
      } catch (e) {
        // Hata durumunda sessizce devam et
      }
    }

    // Görevleri getir
    if (taskRepository != null) {
      try {
        final tasks = await taskRepository!.getTasksByDate(now);

        if (tasks.isNotEmpty) {
          buffer.writeln('✅ **Görevler:**');
          tasks.sort((a, b) {
            final aDue = a.dueDate ?? DateTime.now().add(const Duration(days: 365));
            final bDue = b.dueDate ?? DateTime.now().add(const Duration(days: 365));
            return aDue.compareTo(bDue);
          });

          for (var task in tasks) {
            final icon = task.isCompleted ? '✓' : '○';
            if (task.dueDate != null) {
              final timeStr = DateFormat('HH:mm').format(task.dueDate!);
              buffer.writeln('• $icon [$timeStr] ${task.title}');
            } else {
              buffer.writeln('• $icon ${task.title}');
            }
          }
          buffer.writeln('');
        }
      } catch (e) {
        // Hata durumunda sessizce devam et
      }
    }

    // Boş zaman analizi ekle
    if (eventRepository != null) {
      final freeTimeSlots = await _calculateFreeTimeSlots(todayStart, todayEnd);
      if (freeTimeSlots.isNotEmpty) {
        buffer.writeln('⏰ **Boş Zamanlar:**');
        for (var slot in freeTimeSlots) {
          buffer.writeln('• ${slot['start']} - ${slot['end']} (${slot['duration']} dakika)');
        }
      }
    }

    if (buffer.length < 50) {
      return '✅ Bugün için planlanmış etkinlik veya görev görünmüyor. Rahat bir gününüz var! 🎉';
    }

    return buffer.toString();
  }

  /// Yarınki programı getir
  Future<String> _getTomorrowSchedule() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowStart = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 0, 0);
    final tomorrowEnd = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59);

    final buffer = StringBuffer();
    buffer.writeln('📅 **Yarınki Programınız**');
    buffer.writeln('');

    var hasEvents = false;
    var hasTasks = false;

    if (eventRepository != null) {
      try {
        final events = await eventRepository!.getEventsByDateRange(
          tomorrowStart,
          tomorrowEnd,
        );

        if (events.isNotEmpty) {
          hasEvents = true;
          buffer.writeln('🎯 **Etkinlikler:**');
          events.sort((a, b) => a.startDate.compareTo(b.startDate));

          for (var event in events) {
            final timeStr = DateFormat('HH:mm').format(event.startDate);
            final endTimeStr = DateFormat('HH:mm').format(event.endDate);
            buffer.writeln('• $timeStr-$endTimeStr: ${event.title}');
          }
          buffer.writeln('');
        }
      } catch (e) {
        buffer.writeln('Etkinlikler yüklenirken bir hata oluştu.');
      }
    }

    if (taskRepository != null) {
      try {
        final tasks = await taskRepository!.getTasksByDate(tomorrow);

        if (tasks.isNotEmpty) {
          hasTasks = true;
          buffer.writeln('✅ **Görevler:**');
          tasks.sort((a, b) {
            final aDue = a.dueDate ?? DateTime.now().add(const Duration(days: 365));
            final bDue = b.dueDate ?? DateTime.now().add(const Duration(days: 365));
            return aDue.compareTo(bDue);
          });

          for (var task in tasks) {
            final icon = task.isCompleted ? '✓' : '○';
            if (task.dueDate != null) {
              final timeStr = DateFormat('HH:mm').format(task.dueDate!);
              buffer.writeln('• $icon [$timeStr] ${task.title}');
            } else {
              buffer.writeln('• $icon ${task.title}');
            }
          }
          buffer.writeln('');
        }
      } catch (e) {
        // Sessizce devam et
      }
    }

    if (!hasEvents && !hasTasks) {
      return '✅ Yarın için henüz planlanmış etkinlik veya görev görünmüyor.';
    }

    return buffer.toString();
  }

  /// Boş zaman analizi
  Future<String> _getFreeTimeAnalysis() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day, 8, 0); // 08:00'den başla
    final todayEnd = DateTime(now.year, now.month, now.day, 22, 0); // 22:00'ye kadar

    if (eventRepository == null) {
      return 'Etkinlik bilgilerine erişilemiyor.';
    }

    final freeTimeSlots = await _calculateFreeTimeSlots(todayStart, todayEnd);

    if (freeTimeSlots.isEmpty) {
      return '🔴 Bugün çok yoğun görünüyorsunuz! Boş zaman bulunmuyor. Dinlenmeyi unutmayın! 😊';
    }

    final buffer = StringBuffer();
    buffer.writeln('⏰ **Bugünkü Boş Zamanlarınız:**');
    buffer.writeln('');

    int totalFreeMinutes = 0;
    for (var slot in freeTimeSlots) {
      final duration = slot['duration'] as int;
      totalFreeMinutes += duration;
      buffer.writeln('• ${slot['start']} - ${slot['end']}');
      buffer.writeln('  ⏱️ ${duration} dakika (${(duration / 60).toStringAsFixed(1)} saat)');
      buffer.writeln('');
    }

    buffer.writeln('📊 **Toplam boş zaman:** ${totalFreeMinutes} dakika (${(totalFreeMinutes / 60).toStringAsFixed(1)} saat)');

    if (totalFreeMinutes < 60) {
      buffer.writeln('\n⚠️ Bugün çok yoğunsunuz! Dinlenmeyi unutmayın.');
    } else if (totalFreeMinutes > 240) {
      buffer.writeln('\n✅ Yeterince boş zamanınız var. İyi planlanmış bir gün!');
    }

    return buffer.toString();
  }

  /// Boş zaman slotlarını hesapla
  Future<List<Map<String, dynamic>>> _calculateFreeTimeSlots(
    DateTime dayStart,
    DateTime dayEnd,
  ) async {
    if (eventRepository == null) return [];

    try {
      final events = await eventRepository!.getEventsByDateRange(dayStart, dayEnd);
      events.sort((a, b) => a.startDate.compareTo(b.startDate));

      final freeSlots = <Map<String, dynamic>>[];
      DateTime currentTime = dayStart;

      for (var event in events) {
        // Eğer event başlamadan önce boşluk varsa
        if (currentTime.isBefore(event.startDate)) {
          final duration = event.startDate.difference(currentTime).inMinutes;
          if (duration >= 15) { // En az 15 dakika boşluk
            freeSlots.add({
              'start': DateFormat('HH:mm').format(currentTime),
              'end': DateFormat('HH:mm').format(event.startDate),
              'duration': duration,
            });
          }
        }

        // Event bitiş zamanına geç
        if (event.endDate.isAfter(currentTime)) {
          currentTime = event.endDate;
        }
      }

      // Gün sonuna kadar boşluk varsa
      if (currentTime.isBefore(dayEnd)) {
        final duration = dayEnd.difference(currentTime).inMinutes;
        if (duration >= 15) {
          freeSlots.add({
            'start': DateFormat('HH:mm').format(currentTime),
            'end': DateFormat('HH:mm').format(dayEnd),
            'duration': duration,
          });
        }
      }

      return freeSlots;
    } catch (e) {
      return [];
    }
  }

  /// Görevler özeti
  Future<String> _getTasksSummary() async {
    if (taskRepository == null) {
      return 'Görev bilgilerine erişilemiyor.';
    }

    try {
      final tasks = await taskRepository!.getAllTasks();
      final incompleteTasks = tasks.where((t) => !t.isCompleted).toList();
      final completedTasks = tasks.where((t) => t.isCompleted).toList();

      final buffer = StringBuffer();
      buffer.writeln('📋 **Görev Özeti**');
      buffer.writeln('');
      buffer.writeln('✅ Tamamlanan: ${completedTasks.length}');
      buffer.writeln('⏳ Bekleyen: ${incompleteTasks.length}');
      buffer.writeln('');

      if (incompleteTasks.isNotEmpty) {
        buffer.writeln('**Yapılacaklar:**');
        for (var task in incompleteTasks.take(10)) {
          if (task.dueDate != null) {
            final dateStr = DateFormat('dd.MM.yyyy HH:mm').format(task.dueDate!);
            buffer.writeln('• $dateStr - ${task.title}');
          } else {
            buffer.writeln('• ${task.title}');
          }
        }
        if (incompleteTasks.length > 10) {
          buffer.writeln('... ve ${incompleteTasks.length - 10} görev daha');
        }
      }

      return buffer.toString();
    } catch (e) {
      return 'Görevler yüklenirken bir hata oluştu.';
    }
  }

  /// Etkinlikler özeti
  Future<String> _getEventsSummary() async {
    if (eventRepository == null) {
      return 'Etkinlik bilgilerine erişilemiyor.';
    }

    try {
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 7));

      final events = await eventRepository!.getEventsByDateRange(weekStart, weekEnd);

      if (events.isEmpty) {
        return 'Bu hafta için planlanmış etkinlik bulunmuyor.';
      }

      final buffer = StringBuffer();
      buffer.writeln('📅 **Bu Hafta Etkinlikleri**');
      buffer.writeln('');

      final eventsByDate = <DateTime, List<EventEntity>>{};
      for (var event in events) {
        final date = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
        eventsByDate.putIfAbsent(date, () => []).add(event);
      }

      final sortedDates = eventsByDate.keys.toList()..sort();

      for (var date in sortedDates) {
        buffer.writeln('**${DateFormat('EEEE, dd MMMM', 'tr_TR').format(date)}:**');
        for (var event in eventsByDate[date]!) {
          final timeStr = DateFormat('HH:mm').format(event.startDate);
          buffer.writeln('• $timeStr - ${event.title}');
        }
        buffer.writeln('');
      }

      return buffer.toString();
    } catch (e) {
      return 'Etkinlikler yüklenirken bir hata oluştu.';
    }
  }

  /// Hafta sonu programı
  Future<String> _getWeekendSchedule() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    late final DateTime saturday;
    late final DateTime sunday;
    if (now.weekday == DateTime.saturday) {
      saturday = today;
      sunday = today.add(const Duration(days: 1));
    } else if (now.weekday == DateTime.sunday) {
      saturday = today.subtract(const Duration(days: 1));
      sunday = today;
    } else {
      saturday = today.add(Duration(days: DateTime.saturday - now.weekday));
      sunday = saturday.add(const Duration(days: 1));
    }

    final weekendEnd = DateTime(sunday.year, sunday.month, sunday.day, 23, 59);

    final buffer = StringBuffer();
    buffer.writeln('📅 **Hafta Sonu Planınız**');
    buffer.writeln('');

    if (eventRepository != null) {
      try {
        final events = await eventRepository!.getEventsByDateRange(
          DateTime(saturday.year, saturday.month, saturday.day),
          weekendEnd,
        );

        if (events.isNotEmpty) {
          events.sort((a, b) => a.startDate.compareTo(b.startDate));
          for (var event in events) {
            final dateStr = DateFormat('EEEE dd.MM', 'tr_TR').format(event.startDate);
            final timeStr = DateFormat('HH:mm').format(event.startDate);
            final endTimeStr = DateFormat('HH:mm').format(event.endDate);
            buffer.writeln('• $dateStr $timeStr-$endTimeStr: ${event.title}');
          }
          buffer.writeln('');
        } else {
          buffer.writeln('Hafta sonu için planlanmış etkinlik bulunmuyor.');
          buffer.writeln('');
        }
      } catch (e) {
        buffer.writeln('Etkinlikler yüklenirken bir hata oluştu.');
      }
    }

    if (taskRepository != null) {
      try {
        final saturdayTasks = await taskRepository!.getTasksByDate(saturday);
        final sundayTasks = await taskRepository!.getTasksByDate(sunday);
        final weekendTasks = [...saturdayTasks, ...sundayTasks]
            .where((t) => !t.isCompleted)
            .toList();

        if (weekendTasks.isNotEmpty) {
          buffer.writeln('✅ **Hafta Sonu Görevleri:**');
          for (var task in weekendTasks) {
            if (task.dueDate != null) {
              final dayStr = DateFormat('EEEE', 'tr_TR').format(task.dueDate!);
              buffer.writeln('• [$dayStr] ${task.title}');
            } else {
              buffer.writeln('• ${task.title}');
            }
          }
        }
      } catch (e) {
        // Sessizce devam et
      }
    }

    if (buffer.length < 50) {
      return '✅ Hafta sonu için henüz planlanmış bir şey görünmüyor. Dinlenmek için güzel bir fırsat! 🌿';
    }

    return buffer.toString();
  }

  /// Geciken görevler özeti
  Future<String> _getOverdueTasksSummary() async {
    if (taskRepository == null) {
      return 'Görev bilgilerine erişilemiyor.';
    }

    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final overdueTasks = (await taskRepository!.getAllTasks())
          .where((t) =>
              !t.isCompleted &&
              t.dueDate != null &&
              t.dueDate!.isBefore(todayStart))
          .toList()
        ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));

      if (overdueTasks.isEmpty) {
        return '✅ Harika! Geciken göreviniz yok. Her şey yolunda! 🎉';
      }

      final buffer = StringBuffer();
      buffer.writeln('⚠️ **Geciken Görevler** (${overdueTasks.length} adet)');
      buffer.writeln('');

      for (var task in overdueTasks.take(10)) {
        final dateStr = DateFormat('dd.MM.yyyy').format(task.dueDate!);
        final daysLate = todayStart.difference(
          DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day),
        ).inDays;
        buffer.writeln('• $dateStr - ${task.title} ($daysLate gün gecikti)');
      }

      if (overdueTasks.length > 10) {
        buffer.writeln('... ve ${overdueTasks.length - 10} görev daha');
      }

      buffer.writeln('\n💡 Bu görevleri önceliklendirmenizi öneririm.');
      return buffer.toString();
    } catch (e) {
      return 'Geciken görevler yüklenirken bir hata oluştu.';
    }
  }

  /// Öncelikli görevler özeti
  Future<String> _getPriorityTasksSummary() async {
    if (taskRepository == null) {
      return 'Görev bilgilerine erişilemiyor.';
    }

    try {
      final priorityTasks = (await taskRepository!.getAllTasks())
          .where((t) => !t.isCompleted && (t.priority ?? 0) >= 3)
          .toList()
        ..sort((a, b) {
          final priorityCompare = (b.priority ?? 0).compareTo(a.priority ?? 0);
          if (priorityCompare != 0) return priorityCompare;
          final aDue = a.dueDate ?? DateTime.now().add(const Duration(days: 365));
          final bDue = b.dueDate ?? DateTime.now().add(const Duration(days: 365));
          return aDue.compareTo(bDue);
        });

      if (priorityTasks.isEmpty) {
        return '✅ Yüksek öncelikli bekleyen göreviniz yok.';
      }

      final buffer = StringBuffer();
      buffer.writeln('🔥 **Öncelikli Görevler**');
      buffer.writeln('');

      for (var task in priorityTasks.take(10)) {
        final priorityLabel = task.priority == 3 ? 'Yüksek' : 'Orta';
        if (task.dueDate != null) {
          final dateStr = DateFormat('dd.MM.yyyy HH:mm').format(task.dueDate!);
          buffer.writeln('• [$priorityLabel] $dateStr - ${task.title}');
        } else {
          buffer.writeln('• [$priorityLabel] ${task.title}');
        }
      }

      if (priorityTasks.length > 10) {
        buffer.writeln('... ve ${priorityTasks.length - 10} görev daha');
      }

      return buffer.toString();
    } catch (e) {
      return 'Öncelikli görevler yüklenirken bir hata oluştu.';
    }
  }

  /// Sıradaki etkinlik
  Future<String> _getNextEventSummary() async {
    if (eventRepository == null) {
      return 'Etkinlik bilgilerine erişilemiyor.';
    }

    try {
      final now = DateTime.now();
      final weekEnd = now.add(const Duration(days: 30));
      final events = await eventRepository!.getEventsByDateRange(now, weekEnd);
      final upcoming = events.where((e) => e.startDate.isAfter(now)).toList()
        ..sort((a, b) => a.startDate.compareTo(b.startDate));

      if (upcoming.isEmpty) {
        return '📭 Önümüzdeki 30 gün içinde planlanmış etkinlik bulunmuyor.';
      }

      final next = upcoming.first;
      final dateStr = DateFormat('EEEE, dd MMMM', 'tr_TR').format(next.startDate);
      final timeStr = DateFormat('HH:mm').format(next.startDate);
      final endTimeStr = DateFormat('HH:mm').format(next.endDate);

      final buffer = StringBuffer();
      buffer.writeln('📌 **Sıradaki Etkinliğiniz**');
      buffer.writeln('');
      buffer.writeln('• **${next.title}**');
      buffer.writeln('  📅 $dateStr');
      buffer.writeln('  ⏰ $timeStr - $endTimeStr');
      if (next.location != null) {
        buffer.writeln('  📍 ${next.location}');
      }

      final timeUntil = next.startDate.difference(now);
      if (timeUntil.inDays > 0) {
        buffer.writeln('\n⏳ ${timeUntil.inDays} gün ${timeUntil.inHours % 24} saat sonra');
      } else if (timeUntil.inHours > 0) {
        buffer.writeln('\n⏳ ${timeUntil.inHours} saat ${timeUntil.inMinutes % 60} dakika sonra');
      } else {
        buffer.writeln('\n⏳ ${timeUntil.inMinutes} dakika sonra');
      }

      if (upcoming.length > 1) {
        buffer.writeln('\n📋 Sonrasında: ${upcoming[1].title}');
      }

      return buffer.toString();
    } catch (e) {
      return 'Sıradaki etkinlik yüklenirken bir hata oluştu.';
    }
  }

  /// Selamlama yanıtı
  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Günaydın'
        : hour < 18
            ? 'Merhaba'
            : 'İyi akşamlar';

    return '''$greeting! 👋 Ben kişisel takvim asistanınızım.

Size şunları sorabilirsiniz:
• "Bugün ne yapmalıyım?"
• "Sıradaki etkinliğim ne?"
• "Geciken görevlerim var mı?"
• "Boş zamanım var mı?"

Tüm komutlar için "yardım" yazabilirsiniz.''';
  }

  /// Hafta özeti
  Future<String> _getWeekSummary() async {
    final buffer = StringBuffer();
    buffer.writeln('📊 **Bu Hafta Özeti**');
    buffer.writeln('');

    final eventsSummary = await _getEventsSummary();
    buffer.writeln(eventsSummary);
    buffer.writeln('');

    final tasksSummary = await _getTasksSummary();
    buffer.writeln(tasksSummary);

    return buffer.toString();
  }

  /// Yardım mesajı
  String _getHelpMessage() {
    return '''🤖 **AI Asistan Yardım**

Ben size şu konularda yardımcı olabilirim:

📅 **Günlük Plan:**
• "Bugün ne yapmalıyım?"
• "Yarın ne var?"
• "Hafta sonu planım ne?"
• "Boş zamanım var mı?"
• "Bugün yoğun muyum?"

📌 **Etkinlikler:**
• "Sıradaki etkinliğim ne?"
• "Bu hafta ne planlı?"
• "Etkinliklerim neler?"

✅ **Görevler:**
• "Görevlerim neler?"
• "Geciken görevlerim var mı?"
• "Öncelikli görevlerim neler?"
• "Tamamlanmamış görevler"

📊 **Özet:**
• "Bu hafta özeti"
• "Haftalık özet"

Sormak istediğiniz herhangi bir soruyu doğal dil ile sorabilirsiniz!''';
  }

  /// OpenAI API ile yanıt al (opsiyonel)
  Future<String> _getAiResponse(String question) async {
    if (apiKey == null) {
      return _getDefaultResponse(question);
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'Sen bir takvim asistanısın. Kullanıcının takvim ve görev bilgilerine yardımcı ol. Kısa ve net yanıtlar ver.',
            },
            {
              'role': 'user',
              'content': question,
            },
          ],
          'max_tokens': 200,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        return _getDefaultResponse(question);
      }
    } catch (e) {
      return _getDefaultResponse(question);
    }
  }

  /// Varsayılan yanıt
  String _getDefaultResponse(String question) {
    return '''🤖 Anlamadım, ama şunları sorabilirsiniz:

• "Bugün ne yapmalıyım?"
• "Sıradaki etkinliğim ne?"
• "Geciken görevlerim var mı?"
• "Boş zamanım var mı?"
• "Hafta sonu planım ne?"
• "Bu hafta özeti"

Daha fazla yardım için "yardım" yazabilirsiniz.''';
  }
}

