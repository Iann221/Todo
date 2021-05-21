import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_app_coba/todo.dart';

class Helper{
  static final Helper instance = Helper._instance();
  static Database _db;

  Helper._instance();//constructur

  String tabelTodo = 'tabel_todo';
  String colId = 'id';
  String colJudul = 'judul';
  String colUdah = 'udah';
  String colWarna = 'warna';
  String colDate = 'date';
  String colWaktu = 'waktu';
  String colDesk = 'desk';

  Future<Database> _initDb() async{
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDb = await openDatabase(path, version: 2, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $tabelTodo($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colJudul TEXT, $colUdah INTEGER, $colWarna INTEGER, $colDate TEXT, $colWaktu TEXT, $colDesk TEXT)');
    print('created!');
  }

  Future<Database> get db async{
    if (_db == null){
      _db = await _initDb();
    }
    return _db;
  }

  // ambil maplist dari db
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    print('getmaplist');
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tabelTodo);
    return result;
  }

  // convert jadi list of todos
  Future<List<Todo>> getTodoList() async {
    print('gettodolist');
    final List<Map<String, dynamic>> todoMapList = await getTodoMapList();
    final List<Todo> todoList = [];
    todoMapList.forEach((todoMap){
      todoList.add(Todo.fromMap(todoMap));
    });
    return todoList;
  }

  // filter todos
  Future<List<Todo>> searchTodoList(queryString) async{
    Database db = await this.db;
    final List<Map<String,dynamic>> result = await db.query('$tabelTodo', where: "$colJudul LIKE ?", whereArgs: ['%$queryString%']);
    final List<Todo> todoList = [];
    result.forEach((todoMap){
      todoList.add(Todo.fromMap(todoMap));
    });
    return todoList;
  }

  // nyari yg done
  Future<List<Todo>> getDoneTodoList() async{
    final List<Map<String, dynamic>> todoMapList = await getTodoMapList();
    final List<Todo> todoList = [];
    todoMapList.forEach((todoMap){
      if(todoMap['udah'] == 1){
        todoList.add(Todo.fromMap(todoMap));
      }
    });
    return todoList;
  }

  // masukin todos ke db as map
  Future<int> insertTodo(Todo todo) async{
    print('masukin todo');
    Database db = await this.db;
    final int result = await db.insert(tabelTodo, todo.toMap());
    return result;
  }

  // update
  Future updateTodo(Todo todo) async{
    print('updatetodo');
    Database db = await this.db;
    final int result = await db.update(
        tabelTodo,
        todo.toMap(),
        where: '$colId = ?',
        whereArgs: [todo.id],
    );
    return result;
  }

  // delete
  Future<int> deleteTodo(int id) async{
    Database db = await this.db;
    final int result = await db.delete(
      tabelTodo,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}