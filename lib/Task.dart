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
      _db.getTasks().then((result) {
        List<Todo> _todos = result;
        setState(() {
          _todos.forEach((Todo t) => todos.addAll(t.toMap()));
        });
        _filterCompleteTask();
      });
    });
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
      todos.addAll(
        {newTask.getId: {
          'subject': task,
          'done': false
        }}
      );
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
      body: todos.keys.length == 0
          ? Center(
              child: Text('No data found..'),
            )
          : ListView(
              children: todos.keys.map((int key) {
                return CheckboxListTile(
                  title: Text(todos[key]['subject']),
                  value: todos[key]['done'],
                  onChanged: (bool value) {
                    _toggleList(key, value);
                  },
                );
              }).toList(),
            ),
    );
  }
}
