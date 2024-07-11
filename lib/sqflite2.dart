import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqflite2 {
  static Database? _db;

  Future<Database?> get dB async {
    _db ??= await initialDB();
    return _db;
  }

  initialDB() async {
    String databasePath = await getDatabasesPath();
    String databaseName = "cart.db";

    String path = join(databasePath, databaseName);
    Database? myDb = await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return myDb;
  }

  deleteDB() async {
    String databasePath = await getDatabasesPath();
    String databaseName = "cart.db";

    String path = join(databasePath, databaseName);
    await deleteDatabase(path);
  }

  final myTable = "cart";
  final id = "id";
  final email = "email";

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $myTable (
      $id integer, 
      $email string,  
      PRIMARY KEY ($id, $email)
      )
    ''');
    print("Created $myTable");
  }


  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute('''
      CREATE TABLE "new_note"(
        "id" INTEGER PRIMARY KEY AUTOINCREMENT,
        "title" TEXT NOT NULL,
        "description" TEXT NOT NULL
      )
  ''');

    await db.execute('''
    INSERT INTO "new_note" ("id","title","description")
    SELECT id,title,description FROM "note";
''');

    await db.execute('''
    DROP TABLE "note"
''');

    await db.execute('''
    ALTER TABLE "new_note" RENAME TO "note";
''');
    print("onUpgrade Done");
  }

  // Create || INSERT
  insertData(String sql) async {
    Database? myDb = await dB;
    int response = await myDb!.rawInsert(sql);
    return response;
  }

  // Read
  readData(String sql) async {
    Database? myDb = await dB;
    List<Map> response = await myDb!.rawQuery(sql);
    return response;
  }

  // Update
  updateData(String sql) async {
    Database? myDb = await dB;
    int response = await myDb!.rawUpdate(sql);
    return response;
  }

  // Delete
  deleteData(String sql) async {
    Database? myDb = await dB;
    int response = await myDb!.rawDelete(sql);
    return response;
  }

}