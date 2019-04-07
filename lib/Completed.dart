import 'package:flutter/material.dart';
import './Model/Todo.dart';
import './Model/Database.dart';

class Completed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompletedState();
  }
}

class _CompletedState extends State<Completed> {
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
        _filterUncompletedTask();
      });
    });
  }

  void _filterUncompletedTask() {
    todos = Map.fromIterable(todos.keys.where((k) => todos[k]['done']),
        key: (k) => k, value: (k) => todos[k]);
  }

  void _toggleList(int key, bool value) {
    setState(() {
      todos[key]['done'] = value;
      _db.update(
          Todo(id: key, subject: todos[key]['subject'], done: value ? 1 : 0));
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
                _db.deleteDone();
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
