import 'package:path/path.dart';
import 'package:sampleee/models/todo.dart';
import 'package:sqflite/sqflite.dart';

import 'models/task.dart';

class DatabaseHelper{
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todoo.db'),//creating a database
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");//creating "tasks" table in "todoo" database
        await db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");//creating "todo" table in "todoo" database
        //In the todo table, the taskid stores the id value of the task in task table
      },
      version: 1,//version of the DB
    );
  }
  //inserting a new task into tasks table
  Future<int> insertTask(Task task) async {
    int taskId=0;
    Database _db=await database();
    await _db.insert('tasks', task.toMap(),conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      taskId=value;
    });
    return taskId;
  }
  //Updating the title field of an existing task in the tasks table
  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  //Updating the description field of an existing task in the tasks table
  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  //inserting a new todo item into the todo table
  Future<void> insertTodo(Todo todo) async {
    Database _db=await database();
    await _db.insert('todo', todo.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]['id'],title: taskMap[index]['title'],description: taskMap[index]['description']);
    });
  }

  Future<List<Todo>> getTodo(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(id: todoMap[index]['id'],title: todoMap[index]['title'],taskId: todoMap[index]['taskId'],isDone: todoMap[index]['isDone']);
    });
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }

}