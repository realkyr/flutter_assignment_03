import 'package:sqflite/sqflite.dart';
import './Todo.dart';

final String _table = 'todo';
final String _primekey = '_id';
final String _firstCol = 'title';
final String _secCol = 'done';

class DBProvider {
  Database _database;

  Database get getDb => _database;

  Future initDB() async {
    String dbPath = await getDatabasesPath();
    String path = dbPath + "Todo.db";

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute("""CREATE TABLE $_table (
            $_primekey integer primary key AUTOINCREMENT,
            $_firstCol text not null,
            $_secCol integer not null
          )
        """);
      },
    );
  }

  Future<int> add(Todo task) async {
    int callback = await _database.insert(_table, task.toMapDB());
    return callback;
  }

  Future<List<Todo>> getTasks() async {
    List<Map> data = await _database.query(_table);
    return data.map((i) => Todo.fromJson(i)).toList();
  }

  Future<int> update(Todo todo) async {
    return await _database.update(_table, todo.toMapDB(),
        where: '$_primekey = ?', whereArgs: [todo.getId]);
  }

  Future<Todo> insert(Todo todo) async {
    todo.setId = await _database.insert(_table, todo.toMapDB());
    return todo;
  }

  Future<void> deleteDone() async {
    await _database.delete(
      _table,
      where: '$_secCol = 1',
    );
  }
}
