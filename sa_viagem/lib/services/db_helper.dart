import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'diario_viagens.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE viagens(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            destino TEXT,
            dataInicio TEXT,
            dataFim TEXT,
            descricao TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE entradas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            viagemId INTEGER,
            data TEXT,
            texto TEXT,
            caminhoImagem TEXT,
            FOREIGN KEY (viagemId) REFERENCES viagens(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
