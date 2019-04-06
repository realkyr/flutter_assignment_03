import 'package:flutter/material.dart';
import './NewSubject.dart';

class Task extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskState();
  }
}

class _TaskState extends State<Task> {
  Map<String, bool> todos = {};

  @override
  void initState() {
    todos = {
      'Feed Dogs': true,
      'Go to cinema': false,
      'Coding mobile': false,
    };
    _filterCompleteTask();
    super.initState();
  }

  void _filterCompleteTask() {
    todos = Map.fromIterable(todos.keys.where((k) => todos[k] == false),
        key: (k) => k, value: (k) => todos[k]);
  }

  void _toggleList(String key, bool value) {
    setState(() {
      todos[key] = value;
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
                MaterialPageRoute(builder: (context) => NewSubject()),
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
              children: todos.keys.map((String key) {
                return CheckboxListTile(
                  title: Text(key),
                  value: todos[key],
                  onChanged: (bool value) {
                    _toggleList(key, value);
                  },
                );
              }).toList(),
            ),
    );
  }
}
