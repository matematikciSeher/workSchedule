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

    // Soru tiplerini analiz et
    if (_isQuestionAboutToday(lowerQuestion)) {
      return await _getTodaySchedule();
    } else if (_isQuestionAboutTomorrow(lowerQuestion)) {
      return await _getTomorrowSchedule();
    } else if (_isQuestionAboutFreeTime(lowerQuestion)) {
      return await _getFreeTimeAnalysis();
    } else if (_isQuestionAboutTasks(lowerQuestion)) {
      return await _getTasksSummary();
    } else if (_isQuestionAboutEvents(lowerQuestion)) {
      return await _getEventsSummary();
    } else if (_isQuestionAboutWeek(lowerQuestion)) {
      return await _getWeekSummary();
    } else if (_isQuestionAboutHelp(lowerQuestion)) {
      return _getHelpMessage();
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
      'bugün ne', 'bugün ne yap', 'bugünkü görev', 'bugünkü plan'
    ];
    return todayKeywords.any((keyword) => question.contains(keyword));
  }

  /// "Yarın ne yapmalıyım?" sorusu mu?
  bool _isQuestionAboutTomorrow(String question) {
    final tomorrowKeywords = [
      'yarın', 'tomorrow', 'yarınki', 'yarın ne', 'yarın ne yap'
    ];
    return tomorrowKeywords.any((keyword) => question.contains(keyword));
  }

  /// Boş zaman sorgusu mu?
  bool _isQuestionAboutFreeTime(String question) {
    final freeTimeKeywords = [
      'boş zaman', 'free time', 'müsait', 'ne zaman boş', 'serbest',
      'boş saat', 'boşluk var mı', 'boş zamanım var mı'
    ];
    return freeTimeKeywords.any((keyword) => question.contains(keyword));
  }

  /// Görevler hakkında soru mu?
  bool _isQuestionAboutTasks(String question) {
    final taskKeywords = [
      'görev', 'task', 'yapılacak', 'todo', 'iş', 'ne yapmalı',
      'hangi görev', 'görevler', 'tamamlanmamış'
    ];
    return taskKeywords.any((keyword) => question.contains(keyword));
  }

  /// Etkinlikler hakkında soru mu?
  bool _isQuestionAboutEvents(String question) {
    final eventKeywords = [
      'etkinlik', 'event', 'toplantı', 'randevu', 'planlanan',
      'ne zaman', 'hangi etkinlik', 'etkinlikler'
    ];
    return eventKeywords.any((keyword) => question.contains(keyword));
  }

  /// Hafta hakkında soru mu?
  bool _isQuestionAboutWeek(String question) {
    final weekKeywords = [
      'hafta', 'week', 'bu hafta', 'haftalık', 'hafta plan'
    ];
    return weekKeywords.any((keyword) => question.contains(keyword));
  }

  /// Yardım sorusu mu?
  bool _isQuestionAboutHelp(String question) {
    final helpKeywords = [
      'yardım', 'help', 'ne sorabilirim', 'ne yapabilirsin', 'nasıl kullanılır'
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

    if (eventRepository != null) {
      try {
        final events = await eventRepository!.getEventsByDateRange(
          tomorrowStart,
          tomorrowEnd,
        );

        if (events.isNotEmpty) {
          buffer.writeln('🎯 **Etkinlikler:**');
          events.sort((a, b) => a.startDate.compareTo(b.startDate));
          
          for (var event in events) {
            final timeStr = DateFormat('HH:mm').format(event.startDate);
            final endTimeStr = DateFormat('HH:mm').format(event.endDate);
            buffer.writeln('• $timeStr-$endTimeStr: ${event.title}');
          }
          buffer.writeln('');
        } else {
          buffer.writeln('Yarın için planlanmış etkinlik bulunmuyor.');
          buffer.writeln('');
        }
      } catch (e) {
        buffer.writeln('Etkinlikler yüklenirken bir hata oluştu.');
      }
    }

    if (buffer.length < 50) {
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

📅 **Takvim Sorguları:**
• "Bugün ne yapmalıyım?"
• "Yarın ne var?"
• "Boş zamanım var mı?"
• "Bu hafta ne planlı?"

✅ **Görev Sorguları:**
• "Hangi görevlerim var?"
• "Tamamlanmamış görevler neler?"

📊 **Genel:**
• "Bu hafta özeti"
• "Etkinliklerim"

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
• "Boş zamanım var mı?"
• "Yarın ne var?"
• "Görevlerim neler?"
• "Bu hafta özeti"

Daha fazla yardım için "yardım" yazabilirsiniz.''';
  }
}

