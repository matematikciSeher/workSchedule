# 🏗️ BLoC Mimarisi - Klasör Yapısı

## 📁 Genel Yapı

```
lib/
├── core/                           # Çekirdek yapı
│   ├── bloc/                      # Genel BLoC yapıları
│   │   └── app_bloc_observer.dart
│   ├── constants/                 # Uygulama sabitleri
│   │   └── app_constants.dart
│   ├── routes/                    # Route yönetimi
│   │   ├── app_routes.dart
│   │   └── route_generator.dart
│   ├── errors/                    # Hata yönetimi
│   │   └── failures.dart
│   ├── extensions/                # Extension'lar
│   │   ├── date_extensions.dart
│   │   └── string_extensions.dart
│   ├── utils/                     # Yardımcı fonksiyonlar
│   │   └── input_validators.dart
│   ├── network/                   # Network yapıları (gelecek)
│   ├── theme/                     # Tema dosyaları (review gerekli)
│   ├── config/                    # Konfigürasyon (gelecek)
│   └── di/                        # Dependency Injection (gelecek)
│
├── features/                      # Özellik bazlı yapı
│   ├── calendar/                  # Takvim özelliği
│   │   ├── bloc/                 # BLoC katmanı
│   │   │   ├── states/
│   │   │   ├── events/
│   │   │   └── calendar_bloc.dart
│   │   ├── data/                 # Data katmanı
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/               # İş mantığı katmanı
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/         # UI katmanı
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── task/                      # Görev özelliği
│   │   ├── bloc/
│   │   │   ├── states/
│   │   │   ├── events/
│   │   │   ├── task_bloc.dart ✅
│   │   │   ├── task_event.dart ✅
│   │   │   └── task_state.dart ✅
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── event/                     # Etkinlik özelliği
│   │   ├── bloc/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── settings/                  # Ayarlar özelliği
│       ├── bloc/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── shared/                        # Paylaşımlı yapılar
│   ├── blocs/                     # Paylaşımlı BLoC'lar
│   │   └── base_bloc.dart
│   ├── widgets/                   # Paylaşımlı widget'lar ✅
│   │   ├── loading_widget.dart
│   │   ├── error_widget.dart
│   │   ├── empty_state_widget.dart
│   │   └── custom_app_bar.dart
│   ├── models/                    # Paylaşımlı modeller
│   └── providers/                 # Paylaşımlı provider'lar
│
├── data/                          # Global data katmanı
│   ├── models/
│   ├── repositories/
│   ├── datasources/
│   ├── local/
│   └── remote/
│
├── domain/                        # Global domain katmanı
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── pages/                         # Eski sayfa yapısı (migration gerekli)
│   ├── calendar/
│   ├── event/
│   ├── home/
│   ├── settings/
│   ├── task/
│   └── widget_preview/
│
├── firebase_options.dart
└── main.dart ✅                   # Ana dosya (BLoC'e geçirildi)
```

## ✅ Tamamlanan İşler

1. ✅ pubspec.yaml'a BLoC paketleri eklendi (flutter_bloc, bloc, equatable)
2. ✅ Temel klasör yapısı oluşturuldu (features, core, shared, data, domain)
3. ✅ Core klasörleri organize edildi (constants, extensions, utils, errors, routes)
4. ✅ Features klasörleri oluşturuldu (calendar, task, event, settings)
5. ✅ Shared widgets oluşturuldu (loading, error, empty state, app bar)
6. ✅ main.dart BLoC mimarisine geçirildi
7. ✅ Örnek Task BLoC oluşturuldu (events, states, bloc)
8. ✅ App BLoC Observer eklendi
9. ✅ Bağımlılıklar başarıyla kuruldu
10. ✅ Import path'ler düzeltildi

## 🔄 Yapılması Gerekenler

### 1. Pagelerin Features'a Taşınması
- ❌ `lib/pages/calendar/*` → `lib/features/calendar/presentation/pages/*`
- ❌ `lib/pages/task/*` → `lib/features/task/presentation/pages/*`
- ❌ `lib/pages/event/*` → `lib/features/event/presentation/pages/*`
- ❌ `lib/pages/settings/*` → `lib/features/settings/presentation/pages/*`
- ❌ `lib/pages/home/*` → Yeni home feature oluşturulmalı

### 2. BLoC'ların Tamamlanması
- ❌ Calendar BLoC (events, states, bloc)
- ❌ Event BLoC (events, states, bloc)
- ❌ Settings BLoC (events, states, bloc)

### 3. Tema Yapısının Yeniden Oluşturulması
- ❌ Material 3 destekli tema yapısı
- ❌ BLoC veya Provider ile tema yönetimi

### 4. Data Katmanı
- ❌ Repository pattern implementasyonu
- ❌ Local database (Isar) entegrasyonu
- ❌ Remote datasource (Firebase) entegrasyonu

### 5. Domain Katmanı
- ❌ Entity'lerin oluşturulması
- ❌ Use case'lerin oluşturulması

### 6. Testing
- ❌ Unit testler
- ❌ Widget testler
- ❌ BLoC testler

## 📦 Kullanılan Paketler

### State Management
- `flutter_bloc: ^8.1.6` - BLoC pattern
- `bloc: ^8.1.4` - BLoC core
- `equatable: ^2.0.5` - State comparison

### Database
- `isar: ^3.1.0+1` - Local NoSQL database
- `isar_flutter_libs: ^3.1.0+1` - Isar Flutter support
- `shared_preferences: ^2.2.2` - Key-value storage

### Firebase
- `firebase_core: ^2.24.2` - Firebase core
- `firebase_auth: ^4.15.3` - Authentication
- `cloud_firestore: ^4.13.6` - Firestore database

### Calendar
- `table_calendar: ^3.0.9` - Calendar widget
- `intl: ^0.19.0` - Internationalization

### Notifications
- `flutter_local_notifications: ^16.2.0` - Local notifications
- `timezone: ^0.9.2` - Timezone support

### Others
- `connectivity_plus: ^5.0.2` - Network connectivity
- `google_fonts: ^6.1.0` - Google Fonts
- `share_plus: ^7.2.1` - Share functionality

### Dev Dependencies
- `bloc_test: ^9.1.5` - BLoC testing
- `mocktail: ^1.0.0` - Mocking for tests
- `build_runner: ^2.4.7` - Code generation
- `isar_generator: ^3.1.0+1` - Isar code generation

## 🎯 BLoC Pattern Özet

### Temel Yapı
```
BLoC (Business Logic Component)
├── Events (Inputs)
│   ├── User interactions
│   └── System events
├── States (Outputs)
│   ├── UI states
│   └── Error states
└── Logic
    ├── Business rules
    └── Data transformation
```

### Örnek Kullanım

```dart
// 1. Event tanımla
class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

// 2. State tanımla
class TaskLoaded extends TaskState {
  final List<Task> tasks;
  const TaskLoaded(this.tasks);
}

// 3. BLoC'da handle et
on<LoadTasksEvent>(_onLoadTasks);

Future<void> _onLoadTasks(
  LoadTasksEvent event,
  Emitter<TaskState> emit,
) async {
  emit(TaskLoading());
  try {
    final tasks = await repository.getTasks();
    emit(TaskLoaded(tasks));
  } catch (e) {
    emit(TaskError(e.toString()));
  }
}

// 4. UI'da kullan
BlocBuilder<TaskBloc, TaskState>(
  builder: (context, state) {
    if (state is TaskLoaded) {
      return TaskList(tasks: state.tasks);
    }
    if (state is TaskError) {
      return ErrorWidget(message: state.message);
    }
    return LoadingWidget();
  },
)
```

## 🔗 Faydalı Linkler

- [BLoC Documentation](https://bloclibrary.dev/)
- [Flutter BLoC Tutorial](https://www.flutter-tutorial.com/flutter-bloc)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Isar Database](https://isar.dev/) (Not: isar_generator versiyon uyumsuzluğu nedeniyle dev_dependencies'ten kaldırıldı)
- [Material 3](https://m3.material.io/)

## 📝 Notlar

- Material 3 desteği için `useMaterial3: true` kullanın
- Null safety aktif
- Her feature bağımsız olarak geliştirilebilir
- Test coverage hedefi: %70+
- Kod standartları için `flutter_lints` kullanılıyor
- isar_generator versiyon uyumsuzluğu nedeniyle kaldırıldı (ileride eklenebilir)
- Riverpod bağımlılıkları kaldırıldı, proje tamamen BLoC'e geçirildi

---

**Son Güncelleme:** 2024  
**Versiyon:** 1.0  
**Durum:** Temel Yapı Tamamlandı ✅

