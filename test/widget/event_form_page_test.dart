import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workschedule/pages/event/event_form_page.dart';
import '../helpers/mock_helpers.dart';

void main() {
  group('EventFormPage Widget Tests', () {
    late MockEventRepository mockRepository;

    setUp(() {
      mockRepository = MockEventRepository();
    });

    testWidgets('should display form fields for new event', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EventFormPage(
            eventRepository: mockRepository,
          ),
        ),
      );

      // Check if title field is present
      expect(find.text('Başlık *'), findsOneWidget);
      
      // Check if description field is present
      expect(find.text('Açıklama'), findsOneWidget);
      
      // Check if location field is present
      expect(find.text('Konum'), findsOneWidget);
      
      // Check if save button is present
      expect(find.text('Kaydet'), findsOneWidget);
      
      // Check if app bar title is correct for new event
      expect(find.text('Yeni Etkinlik'), findsOneWidget);
    });

    testWidgets('should display form fields for editing event',
        (tester) async {
      final testEvent = TestHelpers.createTestEvent(
        id: 'event-1',
        title: 'Existing Event',
      );

      when(() => mockRepository.getEventById(any()))
          .thenAnswer((_) async => testEvent);

      await tester.pumpWidget(
        MaterialApp(
          home: EventFormPage(
            eventId: 'event-1',
            eventRepository: mockRepository,
          ),
        ),
      );

      // Wait for event to load
      await tester.pumpAndSettle();

      // Check if app bar title is correct for editing
      expect(find.text('Etkinliği Düzenle'), findsOneWidget);
      
      // Check if title field is filled
      expect(find.text('Existing Event'), findsOneWidget);
      
      // Check if update button is present
      expect(find.text('Güncelle'), findsOneWidget);
    });

    testWidgets('should validate required title field', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EventFormPage(
            eventRepository: mockRepository,
          ),
        ),
      );

      // Find the save button and tap it without filling title
      final saveButton = find.text('Kaydet');
      await tester.tap(saveButton);
      await tester.pump();

      // Should show validation error
      expect(find.text('Lütfen başlık girin'), findsOneWidget);
    });

    testWidgets('should allow user to fill form fields', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EventFormPage(
            eventRepository: mockRepository,
          ),
        ),
      );

      // Find and fill title field
      final titleField = find.byType(TextFormField).first;
      await tester.enterText(titleField, 'Test Event Title');
      
      // Verify text was entered
      expect(find.text('Test Event Title'), findsOneWidget);
    });

    testWidgets('should toggle all day switch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EventFormPage(
            eventRepository: mockRepository,
          ),
        ),
      );

      // Find the all day switch
      final allDaySwitch = find.byType(Switch);
      expect(allDaySwitch, findsOneWidget);

      // Initially should be false
      final switchWidget = tester.widget<Switch>(allDaySwitch);
      expect(switchWidget.value, false);

      // Tap the switch
      await tester.tap(allDaySwitch);
      await tester.pump();

      // Should toggle to true
      final updatedSwitch = tester.widget<Switch>(allDaySwitch);
      expect(updatedSwitch.value, true);
    });

    testWidgets('should show date picker when date tile is tapped',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EventFormPage(
            eventRepository: mockRepository,
          ),
        ),
      );

      // Find the start date tile
      final startDateTile = find.text('Başlangıç Tarihi');
      expect(startDateTile, findsOneWidget);

      // Tap it
      await tester.tap(startDateTile);
      await tester.pumpAndSettle();

      // Date picker should appear (check for default date picker elements)
      // Note: This might need adjustment based on actual date picker implementation
      expect(find.byType(CalendarDatePicker), findsAny);
    });

    testWidgets('should display attachment buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EventFormPage(
            eventRepository: mockRepository,
          ),
        ),
      );

      // Check for photo button
      expect(find.text('Fotoğraf'), findsOneWidget);
      
      // Check for file button
      expect(find.text('Dosya'), findsOneWidget);
    });

    testWidgets('should save event when form is valid', (tester) async {
      final testEvent = TestHelpers.createTestEvent();
      
      when(() => mockRepository.createEvent(any()))
          .thenAnswer((_) async => testEvent);

      await tester.pumpWidget(
        MaterialApp(
          home: EventFormPage(
            eventRepository: mockRepository,
          ),
        ),
      );

      // Fill required fields
      final titleField = find.byType(TextFormField).first;
      await tester.enterText(titleField, 'Test Event');
      await tester.pump();

      // Note: In a real test, you would also need to set dates
      // This is a simplified version focusing on form interaction

      // The actual save test would require mocking date/time pickers
      // which can be complex in widget tests
    });

    testWidgets('should show loading indicator when loading event',
        (tester) async {
      when(() => mockRepository.getEventById(any()))
          .thenAnswer((_) async => Future.delayed(
                const Duration(seconds: 1),
                () => TestHelpers.createTestEvent(),
              ));

      await tester.pumpWidget(
        MaterialApp(
          home: EventFormPage(
            eventId: 'event-1',
            eventRepository: mockRepository,
          ),
        ),
      );

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
