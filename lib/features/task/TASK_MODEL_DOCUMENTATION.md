# 📋 Görev Yönetimi - Veri Modeli Dokümantasyonu

## 🗄️ Veri Modeli

### TaskEntity (Domain Katmanı)

```dart
class TaskEntity {
  final String id;                    // Görev benzersiz ID'si
  final String title;                 // Görev başlığı (zorunlu)
  final String? description;          // Görev açıklaması (opsiyonel)
  final DateTime? dueDate;            // Son teslim tarihi (opsiyonel)
  final DateTime createdAt;          // Oluşturulma tarihi (zorunlu)
  final DateTime updatedAt;           // Güncellenme tarihi (zorunlu)
  final bool isCompleted;            // Tamamlanma durumu (varsayılan: false)
  final String? userId;              // Kullanıcı ID'si (opsiyonel, çoklu kullanıcı için)
  final String? color;                // Görev rengi (opsiyonel)
  final int? priority;                // Öncelik seviyesi (1: Düşük, 2: Orta, 3: Yüksek)
}
```

### TaskModel (Data Katmanı)

TaskModel, TaskEntity'den türetilmiş ve SQLite veritabanı ile çalışmak için Map dönüşümleri içerir:

```dart
class TaskModel extends TaskEntity {
  // TaskEntity'den tüm özellikleri devralır
  
  // SQLite Map'ten model oluşturma
  factory TaskModel.fromMap(Map<String, dynamic> map)
  
  // Model'i SQLite Map'e çevirme
  Map<String, dynamic> toMap()
  
  // TaskEntity'ye dönüştürme
  TaskEntity toEntity()
  
  // Entity'den model oluşturma
  factory TaskModel.fromEntity(TaskEntity entity)
}
```

## 🗂️ SQLite Veritabanı Şeması

### tasks Tablosu

```sql
CREATE TABLE tasks (
  id TEXT PRIMARY KEY,                    -- Görev benzersiz ID'si
  title TEXT NOT NULL,                     -- Görev başlığı
  description TEXT,                        -- Görev açıklaması (NULL olabilir)
  dueDate INTEGER,                         -- Son teslim tarihi (timestamp, NULL olabilir)
  createdAt INTEGER NOT NULL,              -- Oluşturulma tarihi (timestamp)
  updatedAt INTEGER NOT NULL,               -- Güncellenme tarihi (timestamp)
  isCompleted INTEGER NOT NULL DEFAULT 0,  -- Tamamlanma durumu (0: false, 1: true)
  userId TEXT,                             -- Kullanıcı ID'si (NULL olabilir)
  color TEXT,                              -- Görev rengi (NULL olabilir)
  priority INTEGER                         -- Öncelik seviyesi (NULL olabilir)
);
```

## 📊 Veri Akışı

```
UI Layer (TaskListPage, TaskFormPage)
    ↓
BLoC Layer (TaskBloc)
    ↓ Events: LoadTasksEvent, CreateTaskEvent, UpdateTaskEvent, DeleteTaskEvent, CompleteTaskEvent
    ↓ States: TaskInitial, TaskLoading, TaskLoaded, TaskError, TaskCreated, TaskUpdated, TaskDeleted, TaskCompleted
    ↓
Repository Layer (TaskRepository)
    ↓ Interface: TaskRepository (domain)
    ↓ Implementation: TaskRepositoryImpl (data)
    ↓
DataSource Layer (TaskLocalDataSource)
    ↓ CRUD Operations: getAllTasks, getTaskById, createTask, updateTask, deleteTask, getTasksByDate
    ↓
SQLite Database (DatabaseHelper)
    ↓ Database: tasks.db
```

## 🔄 CRUD İşlemleri

### 1. **Create (Oluşturma)**
- Event: `CreateTaskEvent`
- İşlem: Yeni görev SQLite'a kaydedilir
- State: `TaskCreated` → `TaskLoaded`

### 2. **Read (Okuma)**
- Event: `LoadTasksEvent`
- İşlem: Tüm görevler SQLite'dan okunur
- State: `TaskLoaded`

### 3. **Update (Güncelleme)**
- Event: `UpdateTaskEvent`
- İşlem: Mevcut görev SQLite'da güncellenir
- State: `TaskUpdated` → `TaskLoaded`

### 4. **Delete (Silme)**
- Event: `DeleteTaskEvent`
- İşlem: Görev SQLite'dan silinir
- State: `TaskDeleted`

### 5. **Complete (Tamamlama)**
- Event: `CompleteTaskEvent`
- İşlem: Görevin `isCompleted` durumu değiştirilir
- State: `TaskCompleted` → `TaskLoaded`

## 📁 Dosya Yapısı

```
lib/
├── data/
│   └── local/
│       └── database_helper.dart          # SQLite veritabanı helper
│
├── features/
│   └── task/
│       ├── bloc/
│       │   ├── task_bloc.dart            # BLoC sınıfı
│       │   ├── task_event.dart           # BLoC event'leri
│       │   └── task_state.dart            # BLoC state'leri
│       └── data/
│           ├── datasources/
│           │   └── task_local_datasource.dart  # SQLite CRUD işlemleri
│           ├── models/
│           │   └── task_model.dart              # SQLite model
│           └── repositories/
│               └── task_repository_impl.dart    # Repository implementasyonu
│
├── domain/
│   ├── entities/
│   │   └── task_entity.dart              # Domain entity
│   └── repositories/
│       └── task_repository.dart          # Repository interface
│
└── pages/
    └── task/
        ├── task_list_page.dart           # Görev listesi UI
        └── task_form_page.dart           # Görev ekleme/düzenleme UI
```

## 🎯 Kullanım Örnekleri

### Görev Ekleme

```dart
final task = TaskEntity(
  id: DateTime.now().millisecondsSinceEpoch.toString(),
  title: 'Yeni Görev',
  description: 'Görev açıklaması',
  dueDate: DateTime(2024, 12, 31),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  isCompleted: false,
  priority: 2, // Orta öncelik
);

context.read<TaskBloc>().add(CreateTaskEvent(task));
```

### Görev Listeleme

```dart
context.read<TaskBloc>().add(const LoadTasksEvent());

BlocBuilder<TaskBloc, TaskState>(
  builder: (context, state) {
    if (state is TaskLoaded) {
      return ListView.builder(
        itemCount: state.tasks.length,
        itemBuilder: (context, index) {
          return TaskListItem(task: state.tasks[index]);
        },
      );
    }
    return CircularProgressIndicator();
  },
);
```

### Görev Güncelleme

```dart
final updatedTask = task.copyWith(
  title: 'Güncellenmiş Başlık',
  updatedAt: DateTime.now(),
);

context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
```

### Görev Silme

```dart
context.read<TaskBloc>().add(DeleteTaskEvent(taskId));
```

### Görev Tamamlama

```dart
context.read<TaskBloc>().add(CompleteTaskEvent(taskId));
```

## 🔍 Özellikler

✅ Görev ekleme (Create)  
✅ Görev listeleme (Read)  
✅ Görev düzenleme (Update)  
✅ Görev silme (Delete)  
✅ Görev tamamlama (Complete)  
✅ Tarihe göre filtreleme  
✅ Öncelik seviyesi belirleme  
✅ SQLite yerel veritabanı  
✅ Clean Architecture (Domain, Data, Presentation)  
✅ BLoC Pattern  
✅ Repository Pattern  

