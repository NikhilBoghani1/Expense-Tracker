import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/item.dart';
import '../model/user.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  factory DbHelper() {
    return _instance;
  }

  DbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE, password TEXT)",
        );
        db.execute(
          "CREATE TABLE items(item_id INTEGER PRIMARY KEY AUTOINCREMENT, item_name TEXT, item_price REAL, item_description TEXT, user_id INTEGER, FOREIGN KEY(user_id) REFERENCES users(id))",
        );
      },
      version: 1,
    );
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  // Item operations
  Future<int> insertItem(Item item) async {
    final db = await database;
    return await db.insert('items', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Item>> getItemsByUserId(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Item.fromMap(maps[i]);
    });
  }

  Future<void> updateItem(Item item) async {
    final db = await database;
    await db.update(
      'items',
      item.toMap(),
      where: 'item_id = ?',
      whereArgs: [item.itemId],
    );
  }

  Future<void> deleteItem(int itemId) async {
    final db = await database;
    await db.delete(
      'items',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
  }
}
