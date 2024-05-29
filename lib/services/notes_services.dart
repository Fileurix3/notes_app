import 'package:notes_app/model/notes_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesServices {
  Database? _database;
  static const _tableName = "notes";

  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return  _database!;
  }

  Future<Database> _initialize() async {
    String path = join(await getDatabasesPath(), "notes.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate:(db, version) {
        return db.execute(
          '''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            folderId INTEGER,
            name TEXT NOT NULL,
            description TEXT
          )
          '''
        );
      }
    );
  }

  Future<List<NotesModel>> getNotesByFolderId(folderId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "folderId = ?",
      whereArgs: [folderId]
    );

    return [
      for (final {
        "id": id as int,
        "folderId": folderId as int,
        "name": name as String,
        "description": description,
      } in maps )
      NotesModel(
        id: id, 
        folderId: folderId, 
        name: name, 
        description: description
      )
    ];
  }

  Future<void> insertNotesByFolderId(int folderId, String name) async {
    final db = await database;

    await db.insert(
      _tableName, 
      {
        "folderId": folderId,
        "name": name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> updateNotes(int id, String newName) async{
    final db = await database;

    await db.update(
      _tableName,
      {
        "name": newName
      },
      where: "id = ?",
      whereArgs: [id]
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id]
    );
  }


  Future<List<NotesModel>> getNoteById(id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id]
    );

    return [
      for (final {
        "id": id as int,
        "folderId": folderId as int,
        "name": name as String,
        "description": description,
      } in maps )
      NotesModel(
        id: id, 
        folderId: folderId, 
        name: name, 
        description: description
      )
    ];
  }
  Future<void> updateNoteDescription(int id, String description) async{
    final db = await database;

    await db.update(
      _tableName,
      {
        "description": description
      },
      where: "id = ?",
      whereArgs: [id]
    );
  }
}