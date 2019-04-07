import 'package:flutter/material.dart';
import './NewSubject.dart';
import './Model/Todo.dart';

class Task extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskState();
  }
}

class _TaskState extends State<Task> {
  Map<int, dynamic> todos = {};

  @override
  void initState() {
    List<Todo> _todos = [
      Todo(id: 01, subject: 'Feed Dogs', done: 0),
      Todo(id: 02, subject: 'Go to cinema', done: 0),
      Todo(id: 02, subject: 'Coding mobile', done: 0),
    ];
    _todos.forEach((Todo t) => todos.addAll(t.toMap()));

    _filterCompleteTask();
    super.initState();
  }

  void _filterCompleteTask() {
    todos = Map.fromIterable(todos.keys.where((k) => !todos[k]['done']),
        key: (k) => k, value: (k) => todos[k]);
  }

  void _addTask(Map<int, dynamic> task) {
    todos.addAll(task);
  }

  void _toggleList(int key, bool value) {
    setState(() {
      todos[key]['done'] = value;
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
                          onAddNewTask: (Map<int, dynamic> task) {
                            _addTask(task);
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
