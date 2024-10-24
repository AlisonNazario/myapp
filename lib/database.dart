import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'main.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  initDb() async {
    String path = join(await getDatabasesPath(), 'torneio.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE inscricao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        cidade TEXT,
        jogadores TEXT,
        valor INTEGER
      )
    ''');
  }

  Future<int> insertInscricao(Map<String, dynamic> inscricao) async {
    var dbClient = await db;
    return await dbClient.insert('inscricao', inscricao);
  }

  Future<List<Map<String, dynamic>>> getTimes() async {
    var dbClient = await db;
    return await dbClient.query('inscricao');
  }

  Future<int> updateInscricao(int id, Map<String, dynamic> inscricao) async {
    var dbClient = await db;
    return await dbClient.update('inscricao', inscricao, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteInscricao(int id) async {
    var dbClient = await db;
    return await dbClient.delete('inscricao', where: 'id = ?', whereArgs: [id]);
  }
  
}
