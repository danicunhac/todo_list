import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/todo.dart';

const String TBTodos = 'todos';
const String ColumnId = 'id';
const String ColumnName = 'name';
const String ColumnDone = 'done';

// Abrir a conexão com o banco de dados
Future<Database> getDatabase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, "todos.db");

    return openDatabase(path, onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE todos($ColumnId INTEGER PRIMARY KEY AUTOINCREMENT, $ColumnName TEXT, $ColumnDone INTEGER)");
    }, version: 1);
  });
}

Future<int> insert(Todo todo) {
  return getDatabase().then((db) {
    Map<String, dynamic> values = {};
    values[ColumnName] = todo.name;
    values[ColumnDone] = todo.done;

    return db.insert(TBTodos, values);
  });
}

Future<List<Todo>> findAll() {
  return getDatabase().then((db) {
    return db.query(TBTodos).then((listMaps) {
      List<Todo> todos = [];
      for (Map<String, Object?> map in listMaps) {
        Todo todo = Todo(map['name'] as String, map['done'] as int,
            id: map['id'] as int);

        todos.add(todo);
      }

      todos.sort((a, b) {
        if (a.done == 0 && b.done == 1) {
          return -1;
        } else if (a.done == 1 && b.done == 0) {
          return 1;
        } else {
          return 0;
        }
      });
      return todos;
    });
  });
}

Future<int> update(Todo todo) async {
  Database db = await getDatabase();

  Map<String, dynamic> values = {};
  values['name'] = todo.name;
  values['done'] = todo.done;

  return db.update(TBTodos, values, where: "id = ?", whereArgs: [todo.id]);
}

Future<int> delete(int id) async {
  var db = await getDatabase();

  return db.delete(TBTodos, where: 'id = ?', whereArgs: [id]);
}
