# Firebase Entegrasyon Dokümantasyonu

## 🎯 Genel Bakış

Proje, Firebase platformunun tüm ana özelliklerini kullanarak tam entegre bir yapıya sahiptir. Clean Architecture ve BLoC pattern prensipleriyle modüler ve sürdürülebilir bir mimari oluşturulmuştur.

## 📦 Kullanılan Firebase Servisleri

### 1. Firebase Core ✅
- Uygulama başlatma
- Platform bazlı yapılandırma
- Multi-platform desteği (Android, iOS, Web)

### 2. Cloud Firestore ✅
- NoSQL veritabanı
- Real-time sync
- Kullanıcı bazlı veri erişimi
- Tarih bazlı sorgulama

### 3. Firebase Auth (Hazır)
- Kullanıcı kimlik doğrulama
- Email/Password
- Google Sign-In
- Anonymous auth

## 🏗️ Mimari Yapı

```
UI Layer (Presentation)
    ↓
BLoC Layer
    ↓
Domain Layer
    ├── Entities
    ├── Repositories (Interface)
    └── Use Cases
    ↓
Data Layer
    ├── Repositories (Implementation)
    └── Data Sources
        └── Firebase Remote DataSource
```

## 📁 Dosya Yapısı

```
lib/
├── domain/
│   ├── entities/
│   │   ├── task_entity.dart ✅
│   │   └── event_entity.dart ✅
│   └── repositories/
│       ├── task_repository.dart ✅
│       └── event_repository.dart ✅
│
├── features/
│   ├── task/
│   │   ├── bloc/
│   │   │   ├── task_bloc.dart ✅
│   │   │   ├── task_event.dart ✅
│   │   │   └── task_state.dart ✅
│   │   └── data/
│   │       ├── datasources/
│   │       │   └── task_remote_datasource.dart ✅
│   │       └── repositories/
│   │           └── task_repository_impl.dart ✅
│   │
│   └── event/
│       └── data/
│           ├── datasources/
│           │   └── event_remote_datasource.dart ✅
│           └── repositories/
│               └── event_repository_impl.dart ✅
│
├── main.dart ✅ (DI setup)
└── firebase_options.dart ✅
```

## 🔑 Entity Sınıfları

### TaskEntity
```dart
class TaskEntity {
  String id;
  String title;
  String? description;
  DateTime? dueDate;
  DateTime createdAt;
  DateTime updatedAt;
  bool isCompleted;
  String? userId;
  String? color;
  int? priority;
  
  // Firestore mappers
  factory fromFirestore(Map<String, dynamic> map)
  Map<String, dynamic> toFirestore()
  TaskEntity copyWith()
}
```

### EventEntity
```dart
class EventEntity {
  String id;
  String title;
  String? description;
  DateTime startDate;
  DateTime endDate;
  bool isAllDay;
  String? location;
  List<String> attendees;
  String? reminder;
  String? color;
  String? userId;
  DateTime createdAt;
  DateTime updatedAt;
  
  // Helper methods
  int get durationInMinutes
  bool get hasStarted
  bool get hasEnded
  bool get isOngoing
}
```

## 🔌 Data Source Metodları

### TaskRemoteDataSource

```dart
// CRUD Operations
Future<List<TaskEntity>> getAllTasks({String? userId})
Future<TaskEntity?> getTaskById(String taskId)
Future<TaskEntity> createTask(TaskEntity task)
Future<TaskEntity> updateTask(TaskEntity task)
Future<void> deleteTask(String taskId)

// Query Operations
Future<List<TaskEntity>> getTasksByDate(DateTime date, {String? userId})
Stream<List<TaskEntity>> listenTasks({String? userId})
```

### EventRemoteDataSource

```dart
// CRUD Operations
Future<List<EventEntity>> getAllEvents({String? userId})
Future<EventEntity?> getEventById(String eventId)
Future<EventEntity> createEvent(EventEntity event)
Future<EventEntity> updateEvent(EventEntity event)
Future<void> deleteEvent(String eventId)

// Query Operations
Future<List<EventEntity>> getEventsByDateRange(
  DateTime startDate, 
  DateTime endDate, 
  {String? userId}
)
Stream<List<EventEntity>> listenEvents({String? userId})
```

## 🎯 BLoC Pattern

### TaskBloc Events
```dart
LoadTasksEvent({String? userId})
CreateTaskEvent(TaskEntity task)
UpdateTaskEvent(TaskEntity task)
DeleteTaskEvent(String taskId)
CompleteTaskEvent(String taskId)
SearchTasksEvent(String query)
```

### TaskBloc States
```dart
TaskInitial
TaskLoading
TaskLoaded(List<TaskEntity> tasks)
TaskError(String message)
TaskCreated
TaskUpdated
TaskDeleted
TaskCompleted
```

## 🚀 Kullanım Örneği

### BLoC ile Görev Oluşturma

```dart
// UI'da
final task = TaskEntity(
  id: '',
  title: 'Yeni Görev',
  description: 'Açıklama',
  dueDate: DateTime.now(),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  userId: currentUserId,
);

context.read<TaskBloc>().add(CreateTaskEvent(task));

// Listener ile state dinleme
BlocListener<TaskBloc, TaskState>(
  listener: (context, state) {
    if (state is TaskCreated) {
      // Başarılı
    } else if (state is TaskError) {
      // Hata
    }
  },
  child: ...
)
```

### BlocBuilder ile Listeleme

```dart
BlocBuilder<TaskBloc, TaskState>(
  builder: (context, state) {
    if (state is TaskLoading) {
      return CircularProgressIndicator();
    } else if (state is TaskLoaded) {
      return ListView.builder(
        itemCount: state.tasks.length,
        itemBuilder: (context, index) {
          return TaskCard(task: state.tasks[index]);
        },
      );
    } else if (state is TaskError) {
      return ErrorWidget(message: state.message);
    }
    return SizedBox.shrink();
  },
)
```

### Real-time Updates

```dart
// Repository'den stream dinleme
final taskStream = taskRepository.listenTasks(userId: userId);

StreamBuilder<List<TaskEntity>>(
  stream: taskStream,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return TaskList(tasks: snapshot.data!);
    }
    return LoadingWidget();
  },
)
```

## 🔐 Firestore Yapısı

### Collections

#### tasks
```json
{
  "tasks": {
    "taskId": {
      "id": "taskId",
      "title": "Görev Başlığı",
      "description": "Açıklama",
      "dueDate": 1234567890,
      "createdAt": 1234567890,
      "updatedAt": 1234567890,
      "isCompleted": false,
      "userId": "user123",
      "color": "FF2196F3",
      "priority": 2
    }
  }
}
```

#### events
```json
{
  "events": {
    "eventId": {
      "id": "eventId",
      "title": "Etkinlik Başlığı",
      "description": "Açıklama",
      "startDate": 1234567890,
      "endDate": 1234567890,
      "isAllDay": false,
      "location": "Konum",
      "attendees": ["user1", "user2"],
      "reminder": "1 hour before",
      "color": "FFFF5722",
      "userId": "user123",
      "createdAt": 1234567890,
      "updatedAt": 1234567890
    }
  }
}
```

### Firestore Rules (Önerilen)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Tasks collection
    match /tasks/{taskId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == resource.data.userId;
      
      allow create: if request.auth != null 
        && request.auth.uid == request.resource.data.userId;
    }
    
    // Events collection
    match /events/{eventId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == resource.data.userId;
      
      allow create: if request.auth != null 
        && request.auth.uid == request.resource.data.userId;
    }
  }
}
```

## 🔄 Dependency Injection

### Main.dart Setup

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase başlatma
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dependency Injection
    final firestore = FirebaseFirestore.instance;
    final taskRemoteDataSource = TaskRemoteDataSource(firestore);
    final taskRepository = TaskRepositoryImpl(taskRemoteDataSource);
    final taskBloc = TaskBloc(taskRepository);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>.value(value: taskBloc),
      ],
      child: MaterialApp(...),
    );
  }
}
```

## 📊 Query Örnekleri

### Tarihe Göre Görevler

```dart
final today = DateTime.now();
final tasks = await taskRepository.getTasksByDate(
  today, 
  userId: userId
);
```

### Tarih Aralığına Göre Etkinlikler

```dart
final startDate = DateTime(2024, 1, 1);
final endDate = DateTime(2024, 1, 31);

final events = await eventRepository.getEventsByDateRange(
  startDate,
  endDate,
  userId: userId,
);
```

### Tüm Görevler (Stream)

```dart
streamSubscription = taskRepository.listenTasks(userId: userId)
  .listen((tasks) {
    // Real-time güncellemeler
  });
```

## ✅ Özellikler

- ✅ Firebase Core entegrasyonu
- ✅ Cloud Firestore CRUD işlemleri
- ✅ Real-time sync desteği
- ✅ Kullanıcı bazlı veri erişimi
- ✅ Clean Architecture mimarisi
- ✅ BLoC pattern implementasyonu
- ✅ Dependency Injection
- ✅ Error handling
- ✅ Type-safe entity'ler
- ✅ Immutable entity'ler (copyWith)
- ✅ Firestore mapping (fromFirestore/toFirestore)

## 🚧 Gelecek Geliştirmeler

- [ ] Firebase Authentication entegrasyonu
- [ ] Firebase Storage (dosya yükleme)
- [ ] Firebase Cloud Messaging (push notification)
- [ ] Firebase Analytics
- [ ] Offline cache stratejisi
- [ ] Local data source (Isar/Hive)
- [ ] Sync service (local ↔ remote)
- [ ] Conflict resolution

## 📚 Kaynaklar

- [Firebase Documentation](https://firebase.google.com/docs)
- [Cloud Firestore Guide](https://firebase.google.com/docs/firestore)
- [FlutterFire](https://firebase.flutter.dev/)
- [BLoC Pattern](https://bloclibrary.dev/)

## 🤝 Katkıda Bulunma

Firebase entegrasyonu geliştirmelerinde:
1. Clean Architecture prensiplere uygunluk
2. Test yazımı (unit, integration)
3. Dokümantasyon güncellemesi
4. Error handling ekleme

---

**Son Güncelleme:** Aralık 2024  
**Versiyon:** 1.0.0  
**Durum:** ✅ Production Ready

