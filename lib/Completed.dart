import 'package:flutter/material.dart';
import './Model/Todo.dart';

class Completed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompletedState();
  }
}

class _CompletedState extends State<Completed> {
  Map<int, dynamic> todos = {};

  @override
  void initState() {
    List<Todo> _todos = [
      Todo(id: 01, subject: 'Feed Dogs', done: 0),
      Todo(id: 02, subject: 'Go to cinema', done: 1),
      Todo(id: 02, subject: 'Coding mobile', done: 1),
    ];
    _todos.forEach((Todo t) => todos.addAll(t.toMap()));

    _filterUncompletedTask();
    super.initState();
  }

  void _filterUncompletedTask() {
    todos = Map.fromIterable(todos.keys.where((k) => todos[k]['done']),
        key: (k) => k, value: (k) => todos[k]);
  }

  void _toggleList(int key, bool value) {
    setState(() {
      todos[key]['done'] = value;
      _filterUncompletedTask();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Completed'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                todos = {};
              });
            },
            icon: Icon(Icons.delete),
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
