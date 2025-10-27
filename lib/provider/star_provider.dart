import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/star.dart';

class StarProvider with ChangeNotifier {
  static const String _dbName = 'stars.db';
  static const String _tableName = 'stars';

  Database? _database;
  List<Star> _stars = [];

  List<Star> get stars => [..._stars];

  // ✅ ไม่ init DB ใน constructor อีกต่อไป
  Future<void> _initDatabase() async {
    if (_database != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            brightness REAL,
            distance REAL,
            size REAL,
            imagePath TEXT,
            date TEXT,
            isUserAdded INTEGER DEFAULT 1
          )
        ''');
      },
    );
  }

  Future<void> fetchAndSetStars() async {
    await _initDatabase();
    final dataList = await _database!.query(_tableName, orderBy: 'date DESC');
    _stars = dataList.map((item) => Star.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addStar(
    String name,
    double brightness,
    double distance,
    double size,
    DateTime date, {
    String? imagePath,
  }) async {
    await _initDatabase();
    final star = Star(
      name: name,
      brightness: brightness,
      distance: distance,
      size: size,
      imagePath: imagePath,
      date: date,
      isUserAdded: 1,
    );

    final id = await _database!.insert(_tableName, star.toMap());
    _stars.insert(
      0,
      Star(
        id: id,
        name: name,
        brightness: brightness,
        distance: distance,
        size: size,
        imagePath: imagePath,
        date: date,
        isUserAdded: 1,
      ),
    );
    notifyListeners();
  }

  Future<void> updateStar(int id, Star newStar) async {
    await _initDatabase();
    await _database!.update(
      _tableName,
      newStar.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    final index = _stars.indexWhere((s) => s.id == id);
    if (index >= 0) {
      _stars[index] = newStar;
      notifyListeners();
    }
  }

  Future<void> deleteStar(int id) async {
    await _initDatabase();
    await _database!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
    _stars.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
