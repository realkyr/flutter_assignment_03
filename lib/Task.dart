import 'package:flutter/material.dart';
import './NewSubject.dart';
import './Model/Todo.dart';
import './Model/Database.dart';

class Task extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskState();
  }
}

class _TaskState extends State<Task> {
  Map<int, dynamic> todos = {};
  DBProvider _db = DBProvider();

  @override
  void initState() {
    super.initState();
    _db.initDB().then((result) {
      initTasks();
    });
  }

  Future<Map<int, dynamic>> initTasks() async {
    List<Todo> result = await _db.getTasks();
    List<Todo> _todos = result;
    setState(() {
      _todos.forEach((Todo t) => todos.addAll(t.toMap()));
    });
    _filterCompleteTask();
    return todos;
  }

  void _filterCompleteTask() {
    setState(() {
      todos = Map.fromIterable(todos.keys.where((k) => !todos[k]['done']),
          key: (k) => k, value: (k) => todos[k]);
    });
  }

  Future _addTask(String task) async {
    Todo todo = Todo(subject: task, done: 0);
    Todo newTask = await _db.insert(todo);
    print(newTask.getId);
    setState(() {
      todos.addAll({
        newTask.getId: {'subject': task, 'done': false}
      });
    });
  }

  void _toggleList(int key, bool value) {
    setState(() {
      todos[key]['done'] = value;
      _db.update(
          Todo(id: key, subject: todos[key]['subject'], done: value ? 1 : 0));
      _filterCompleteTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Task'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewSubject(
                            onAddNewTask: (String task) async {
                              await _addTask(task);
                            },
                          )),
                );
              },
              icon: Icon(Icons.add),
            )
          ],
        ),
        body: FutureBuilder<Map<int, dynamic>>(
          future: initTasks(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) return Center(child: Text(''));
            Map<int, dynamic> data = snapshot.data;
            return todos.keys.length == 0
                ? Center(
                    child: Text('No data found..'),
                  )
                : ListView.builder(
                    itemCount: data.keys.length,
                    itemBuilder: (context, index) {
                      int key = data.keys.toList()[index];
                      Map<String, dynamic> task = data[key];
                      return CheckboxListTile(
                        title: Text(task['subject']),
                        value: task['done'],
                        onChanged: (bool value) {
                          _toggleList(key, value);
                        },
                      );
                    });
          },
        ));
  }
}
