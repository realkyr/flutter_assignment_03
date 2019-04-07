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
      initTasks();
    });
  }

  Future<Map<int, dynamic>> initTasks() async {
    List<Todo> result = await _db.getTasks();
    List<Todo> _todos = result;
    setState(() {
      _todos.forEach((Todo t) => todos.addAll(t.toMap()));
    });
    _filterUncompletedTask();
    return todos;
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
        )
      );
  }
}
