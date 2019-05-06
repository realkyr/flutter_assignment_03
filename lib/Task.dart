import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './NewSubject.dart';

class Task extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskState();
  }
}

class _TaskState extends State<Task> {
  Map<String, dynamic> todos = {};

  @override
  void initState() {
    super.initState();
    initTasks();
  }

  Future<Map<String, dynamic>> initTasks() async {
    QuerySnapshot docs = await Firestore.instance
      .collection('todo')
      .where('done', isEqualTo: false)
      .getDocuments();
    Map<String, dynamic> _todos = {};
    docs.documents.forEach((doc) => _todos[doc.documentID] = doc.data);
    setState(() {
      todos = _todos;
    });
    return todos;
  }

  Future _addTask(String task) async {
    DocumentReference ref = await Firestore.instance
      .collection('todo')
      .add({
        'title': task,
        'done': false
      });

    setState(() {
      todos.addAll({
        ref.documentID: {'title': task, 'done': false}
      });
    });
  }

  void _toggleList(String key, bool value) {
    setState(() {
      dynamic data = todos.remove(key);
      if (data != null) {
        Firestore.instance
          .collection('todo')
          .document(key)
          .updateData({'done': true});
      }
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
        body: FutureBuilder<Map<String, dynamic>>(
          future: initTasks(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) return Center(child: Text(''));
            Map<String, dynamic> data = snapshot.data;
            return todos.keys.length == 0
                ? Center(
                    child: Text('No data found..'),
                  )
                : ListView.builder(
                    itemCount: data.keys.length,
                    itemBuilder: (context, index) {
                      String key = data.keys.toList()[index];
                      Map<String, dynamic> task = data[key];
                      return CheckboxListTile(
                        title: Text(task['title']),
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
