import 'package:flutter/material.dart';

class Completed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompletedState();
  }
}

class _CompletedState extends State<Completed> {
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
    todos = Map.fromIterable(todos.keys.where((k) => todos[k] == true),
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
