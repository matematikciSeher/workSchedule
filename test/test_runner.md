# Test Çalıştırma Kılavuzu

Bu dokümantasyon, proje için oluşturulmuş testlerin nasıl çalıştırılacağını açıklar.

## Test Yapısı

```
test/
├── helpers/
│   └── mock_helpers.dart          # Mock repository'ler ve test helper'ları
├── unit/
│   ├── entities/
│   │   ├── event_entity_test.dart
│   │   └── task_entity_test.dart
│   └── bloc/
│       └── task_bloc_test.dart
├── widget/
│   ├── event_form_page_test.dart
│   └── task_form_page_test.dart
└── integration/
    └── app_test.dart
```

## Test Türleri

### 1. Unit Testler

Domain entity'lerinin ve BLoC'ların mantığını test eder.

**Çalıştırma:**
```bash
# Tüm unit testler
flutter test test/unit/

# Belirli bir test dosyası
flutter test test/unit/entities/task_entity_test.dart

# Belirli bir test grubu
flutter test test/unit/bloc/task_bloc_test.dart
```

**Kapsam:**
- ✅ EventEntity testleri (duration, date checks, equality)
- ✅ TaskEntity testleri (subtasks, completion percentage)
- ✅ TaskBloc testleri (tüm event handler'lar)

### 2. Widget Testleri

UI bileşenlerinin davranışını test eder.

**Çalıştırma:**
```bash
# Tüm widget testler
flutter test test/widget/

# Belirli bir widget testi
flutter test test/widget/event_form_page_test.dart
```

**Kapsam:**
- ✅ EventFormPage widget testleri
- ✅ TaskFormPage widget testleri
- ✅ Form validasyon testleri
- ✅ User interaction testleri

### 3. Integration Testleri

Uygulamanın end-to-end akışını test eder. Gerçek cihazda veya emulatörde çalışır.

**Çalıştırma:**
```bash
# Integration test driver oluştur (bir kez)
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=test/integration/app_test.dart
```

**Not:** Integration testler için `test_driver/integration_test.dart` dosyası oluşturulmalıdır.

## Test Coverage

Coverage raporu oluşturmak için:

```bash
# Test coverage'ı topla
flutter test --coverage

# HTML rapor oluştur (lcov gerekli)
genhtml coverage/lcov.info -o coverage/html
```

## Test Bağımlılıkları

Proje aşağıdaki test bağımlılıklarını kullanır:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.1.5      # BLoC testleri için
  mocktail: ^1.0.0       # Mock objeler için
  integration_test:      # Integration testler için
    sdk: flutter
```

## Mock Kullanımı

Mock repository'ler `test/helpers/mock_helpers.dart` dosyasında tanımlanmıştır:

```dart
import '../helpers/mock_helpers.dart';

final mockRepository = MockTaskRepository();
when(() => mockRepository.getAllTasks())
    .thenAnswer((_) async => testTasks);
```

## Test Best Practices

1. **Arrange-Act-Assert Pattern:**
   - Arrange: Test verilerini hazırla
   - Act: Test edilecek aksiyonu gerçekleştir
   - Assert: Sonuçları doğrula

2. **Mock Kullanımı:**
   - External bağımlılıkları mock'layın
   - Her test için yeni mock instance'ı oluşturun

3. **Test İzolasyonu:**
   - Her test bağımsız olmalı
   - setUp ve tearDown kullanın

4. **Test İsimlendirme:**
   - Açıklayıcı test isimleri kullanın
   - "should ... when ..." formatını tercih edin

## Sorun Giderme

### Test çalışmıyor
- `flutter pub get` çalıştırın
- Test dosyalarının doğru import'lara sahip olduğundan emin olun

### Mock hatası
- `when()` çağrılarının doğru yapıldığından emin olun
- `verify()` kullanarak mock çağrılarını doğrulayın

### Widget test hatası
- MaterialApp veya Material widget'ı ile wrap edin
- `pumpAndSettle()` kullanarak async işlemleri bekleyin

## Sonraki Adımlar

1. ✅ Unit testler oluşturuldu
2. ✅ Widget testler oluşturuldu
3. ⏳ Integration test driver oluşturulmalı
4. ⏳ Test coverage hedefleri belirlenmeli
5. ⏳ CI/CD pipeline'a test eklenmeli
