import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_demo/note.dart';
class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }
  // Future<Database> get database async {
  //   if (_database != null) {
  //     return _database;
  //   }
  //
  //   _database = await initializeDatabase();
  //   return _database;


  Future<Database> initializeDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'my_database.db');

    // Open/create the database at a given path
    var database = await openDatabase(path, version: 1, onCreate: _createDB);
    return database;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE notes ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'title TEXT,'
        'content TEXT'
        ')');
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    int id = await db.insert('notes', note.toMap());
    return id;
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query('notes');
    return results.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    int rowsUpdated = await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
    return rowsUpdated;
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    int rowsDeleted = await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsDeleted;
  }
}