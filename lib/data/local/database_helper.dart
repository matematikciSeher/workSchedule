import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// SQLite veritabanı yardımcı sınıfı
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Veritabanı instance'ını getir
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  /// Veritabanını başlat
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Veritabanı tablolarını oluştur
  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textNullableType = 'TEXT';
    const integerType = 'INTEGER NOT NULL';
    const integerNullableType = 'INTEGER';

    await db.execute('''
      CREATE TABLE tasks (
        id $idType,
        title $textType,
        description $textNullableType,
        dueDate $integerNullableType,
        createdAt $integerType,
        updatedAt $integerType,
        isCompleted $integerType DEFAULT 0,
        userId $textNullableType,
        color $textNullableType,
        priority $integerNullableType
      )
    ''');
  }

  /// Veritabanını kapat
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}

