import 'package:nyobatugasakhir2/services/encryptionHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<bool> isUsernameExists(String username) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    return result.isNotEmpty; // Jika hasilnya tidak kosong, berarti username sudah ada
  }


  Future<void> addUser(String username, String password) async {
    final db = await instance.database;

    String hashedPassword = hashPassword(password); // Hash password

    await db.insert('users', {
      'username': username,
      'password': hashedPassword,
    });
  }


  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  Future<bool> authenticate(String username, String password) async {
    final db = await instance.database;

    String hashedPassword = hashPassword(password); // Hash password untuk verifikasi

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
    );

    return result.isNotEmpty;
  }

  Future<void> deleteUser(int id) async {
    final db = await instance.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
