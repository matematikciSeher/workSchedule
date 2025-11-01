# Test Dokümantasyonu

Bu proje için kapsamlı test yapısı oluşturulmuştur. Testler unit, widget ve integration testleri içermektedir.

## 📁 Test Yapısı

```
test/
├── helpers/
│   └── mock_helpers.dart          # Mock repository'ler ve test helper'ları
├── unit/
│   ├── entities/
│   │   ├── event_entity_test.dart    # EventEntity unit testleri
│   │   └── task_entity_test.dart     # TaskEntity unit testleri
│   └── bloc/
│       └── task_bloc_test.dart       # TaskBloc unit testleri
├── widget/
│   ├── event_form_page_test.dart    # EventFormPage widget testleri
│   └── task_form_page_test.dart     # TaskFormPage widget testleri
├── integration/
│   └── app_test.dart                # Integration test örnekleri
├── README.md                         # Bu dosya
└── test_runner.md                    # Test çalıştırma kılavuzu
```

## 🧪 Test Türleri

### 1. Unit Testler

**Konum:** `test/unit/`

**Amaç:** Domain entity'lerinin ve BLoC'ların iş mantığını test eder.

**Dosyalar:**
- `entities/event_entity_test.dart` - EventEntity için testler
  - ✅ Entity oluşturma ve özellikler
  - ✅ Duration hesaplama
  - ✅ Tarih kontrol metodları (hasStarted, hasEnded, isOngoing)
  - ✅ copyWith metodu
  - ✅ Firestore dönüşümleri
  - ✅ Equality kontrolleri

- `entities/task_entity_test.dart` - TaskEntity için testler
  - ✅ Entity oluşturma ve özellikler
  - ✅ Tarih kontrol metodları
  - ✅ Subtask completion percentage hesaplama
  - ✅ Recurring task desteği
  - ✅ Firestore dönüşümleri

- `bloc/task_bloc_test.dart` - TaskBloc için testler
  - ✅ LoadTasksEvent
  - ✅ CreateTaskEvent
  - ✅ UpdateTaskEvent
  - ✅ DeleteTaskEvent
  - ✅ CompleteTaskEvent
  - ✅ SearchTasksEvent
  - ✅ AddSubtaskEvent
  - ✅ Error handling

### 2. Widget Testleri

**Konum:** `test/widget/`

**Amaç:** UI bileşenlerinin davranışını ve kullanıcı etkileşimlerini test eder.

**Dosyalar:**
- `event_form_page_test.dart` - EventFormPage widget testleri
  - ✅ Form alanlarının görüntülenmesi
  - ✅ Yeni etkinlik ve düzenleme modları
  - ✅ Form validasyonu
  - ✅ Kullanıcı etkileşimleri
  - ✅ Loading state'leri

- `task_form_page_test.dart` - TaskFormPage widget testleri
  - ✅ Form alanlarının görüntülenmesi
  - ✅ BLoC state yönetimi
  - ✅ Form validasyonu

### 3. Integration Testleri

**Konum:** `test/integration/`

**Amaç:** Uygulamanın end-to-end akışını test eder.

**Dosya:**
- `app_test.dart` - Integration test örnekleri
  - 📝 Uygulama başlatma testi
  - 📝 Görev oluşturma akışı
  - 📝 Etkinlik oluşturma akışı
  - 📝 Görev tamamlama akışı
  - 📝 Arama fonksiyonu

**Not:** Integration testler için `flutter pub get` çalıştırarak `integration_test` paketini yükleyin.

## 🔧 Test Helper'ları

### Mock Helpers (`test/helpers/mock_helpers.dart`)

Mock repository'ler ve test verisi oluşturma yardımcıları:

```dart
// Mock repository kullanımı
final mockRepository = MockTaskRepository();

// Test verisi oluşturma
final task = TestHelpers.createTestTask(
  id: 'test-id',
  title: 'Test Task',
);

final tasks = TestHelpers.createTestTaskList(5); // 5 görevli liste
final events = TestHelpers.createTestEventList(3); // 3 etkinlikli liste
```

## 🚀 Test Çalıştırma

Detaylı bilgi için `test_runner.md` dosyasına bakın.

**Hızlı Başlangıç:**
```bash
# Tüm testleri çalıştır
flutter test

# Belirli bir test dosyası
flutter test test/unit/entities/task_entity_test.dart

# Coverage raporu oluştur
flutter test --coverage
```

## 📊 Test Coverage

Test coverage'ı görüntülemek için:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # MacOS
# veya
start coverage/html/index.html  # Windows
```

## ✅ Test Örnekleri

### Unit Test Örneği

```dart
test('should calculate duration correctly', () {
  final event = EventEntity(
    id: '1',
    title: 'Test',
    startDate: DateTime(2024, 1, 1, 10, 0),
    endDate: DateTime(2024, 1, 1, 12, 0),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  
  expect(event.durationInMinutes, 120);
});
```

### Widget Test Örneği

```dart
testWidgets('should display form fields', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: EventFormPage(),
    ),
  );
  
  expect(find.text('Başlık *'), findsOneWidget);
  expect(find.text('Kaydet'), findsOneWidget);
});
```

### BLoC Test Örneği

```dart
blocTest<TaskBloc, TaskState>(
  'emits [TaskLoading, TaskLoaded] when LoadTasksEvent is added',
  build: () {
    when(() => mockRepository.getAllTasks())
        .thenAnswer((_) async => testTasks);
    return taskBloc;
  },
  act: (bloc) => bloc.add(const LoadTasksEvent()),
  expect: () => [
    const TaskLoading(),
    TaskLoaded(testTasks),
  ],
);
```

## 🎯 Test Best Practices

1. **Arrange-Act-Assert Pattern:**
   - Test verilerini hazırla
   - Test edilecek aksiyonu gerçekleştir
   - Sonuçları doğrula

2. **Test İzolasyonu:**
   - Her test bağımsız olmalı
   - `setUp()` ve `tearDown()` kullanın

3. **Mock Kullanımı:**
   - External bağımlılıkları mock'layın
   - Her test için yeni mock instance'ı

4. **İsimlendirme:**
   - Açıklayıcı test isimleri: `should_<expected_behavior>_when_<condition>`

## 🔍 Sorun Giderme

### Test çalışmıyor
- `flutter pub get` çalıştırın
- Import'ların doğru olduğundan emin olun

### Mock hatası
- `when()` çağrılarının doğru yapıldığından emin olun
- `verify()` kullanarak çağrıları doğrulayın

### Widget test hatası
- MaterialApp ile wrap edin
- `pumpAndSettle()` kullanın

## 📝 Notlar

- Integration testler için `integration_test` paketi Flutter SDK'da mevcuttur
- Test coverage hedefi: %70+ için çaba gösterin
- CI/CD pipeline'a test eklenmesi önerilir

## 🎓 Sonraki Adımlar

1. ✅ Unit testler oluşturuldu
2. ✅ Widget testler oluşturuldu
3. ✅ Integration test şablonu hazırlandı
4. ⏳ Daha fazla widget testi eklenebilir
5. ⏳ Repository testleri eklenebilir
6. ⏳ Use case testleri eklenebilir
