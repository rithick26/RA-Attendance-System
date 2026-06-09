import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('attendance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        rollNo TEXT UNIQUE,
        name TEXT,
        year TEXT
      )
    ''');
    await db.execute('''
    CREATE TABLE attendance (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      rollNo TEXT,
      date TEXT,
      status INTEGER
    )
  ''');
  }

  Future<int> insertStudent(Map<String, dynamic> student) async {
    final db = await instance.database;

    return await db.insert(
      'students',
      student,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await instance.database;

    return await db.query('students', orderBy: 'rollNo ASC');
  }

  Future<int> deleteStudent(String rollNo) async {
    final db = await instance.database;

    return await db.delete(
      'students',
      where: 'rollNo = ?',
      whereArgs: [rollNo],
    );
  }

  Future<void> markAttendance({
    required String rollNo,
    required String date,
    required bool present,
  }) async {
    final db = await instance.database;

    await db.delete(
      'attendance',
      where: 'rollNo = ? AND date = ?',
      whereArgs: [rollNo, date],
    );

    await db.insert('attendance', {
      'rollNo': rollNo,
      'date': date,
      'status': present ? 1 : 0,
    });
  }

  Future<List<Map<String, dynamic>>> getAttendanceByDate(String date) async {
    final db = await instance.database;

    return await db.query('attendance', where: 'date = ?', whereArgs: [date]);
  }

  Future<List<Map<String, dynamic>>> getAttendance(String date) async {
    final db = await instance.database;

    return await db.query('attendance', where: 'date = ?', whereArgs: [date]);
  }

  Future<List<Map<String, dynamic>>> getAttendanceByRollNo(
    String rollNo,
  ) async {
    final db = await instance.database;

    return await db.query(
      'attendance',
      where: 'rollNo = ?',
      whereArgs: [rollNo],
    );
  }

  Future<Map<String, dynamic>> getStudentAttendanceStats(String rollNo) async {
    final db = await instance.database;

    final result = await db.query(
      'attendance',
      where: 'rollNo = ?',
      whereArgs: [rollNo],
    );
    print("Stats for $rollNo = $result");
    int total = result.length;

    int present = result.where((row) => row['status'] == 1).length;

    double percentage = total == 0 ? 0 : (present / total) * 100;

    return {'present': present, 'total': total, 'percentage': percentage};
  }

  Future<List<Map<String, dynamic>>> getAllAttendance() async {
    final db = await instance.database;
    return await db.query('attendance');
  }
}
