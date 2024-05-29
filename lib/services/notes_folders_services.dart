import 'package:notes_app/model/notes_folders_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesFoldersServices {
  Database? _database;
  static const _tableName = "notesFolders";

  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return  _database!;
  }

  Future<Database> _initialize() async {
    String path = join(await getDatabasesPath(), "notes_folders.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate:(db, version) {
        return db.execute(
          '''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTO_INCREMENT,
            name TEXT NOT NULL
          )
          '''
        );
      },
    );
  }

  Future<List<NotesFoldersModel>> getNotesFolders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return [
      for (final {
        "id": id as int,
        "name": name as String
      } in maps )
      NotesFoldersModel(id: id, name: name),
    ];
  }

  Future<void> insertNotesFolder(NotesFoldersModel folder) async {
    final db = await database;

    await db.insert(
      _tableName, 
      {
        "name": folder
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> updateFolderName(int id, String newName) async {
    final db = await database;

    await db.update(
      _tableName, 
      {
        'name': newName
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteFolred(int id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id]
    );
  }
}