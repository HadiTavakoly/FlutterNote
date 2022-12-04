import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/notes_model.dart';

class NotesDatabase {
  NotesDatabase._init();
  static final NotesDatabase instanc = NotesDatabase._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String databaseName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databaseName);

    return openDatabase(path, version: 1, onCreate: _creatDB);
  }

  Future _creatDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT ';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
  CREATE TABLE $tableName (
    ${NotesFields.id} $idType ,
    ${NotesFields.title} $textType ,
    ${NotesFields.description} $textType
  )
  ''');
    version = 1;
  }

  Future<Note> creatNote(Note note) async {
    final db = await instanc.database;
    final id = await db.insert(tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instanc.database;
    final maps = await db.query(
      tableName,
      columns: NotesFields.values,
      where: '${NotesFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instanc.database;
    final result = await db.query(tableName);

    return result.map((e) => Note.fromJson(e)).toList();
  }

  Future<List<Note>> searchInNotes(String? keyword) async {
    final db = await instanc.database;
    final result = await db.query(
      tableName,
      where: '${NotesFields.title} LIKE ? OR ${NotesFields.description} LIKE ?',
      whereArgs: ['%$keyword%','%$keyword%'],
    );

    return result.map((e) => Note.fromJson(e)).toList();
  }

  Future<int> updateNote(Note note) async {
    final db = await instanc.database;
    return await db.update(
      tableName,
      note.toJson(),
      where: '${NotesFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instanc.database;
    return await db.delete(
      tableName,
      where: '${NotesFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instanc.database;
    db.close();
  }
}
