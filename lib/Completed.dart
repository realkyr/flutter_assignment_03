import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Completed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompletedState();
  }
}

class _CompletedState extends State<Completed> {
  Map<String, dynamic> todos = {};

  @override
  void initState() {
    super.initState();
    initTasks();
  }

  Future<Map<String, dynamic>> initTasks() async {
    QuerySnapshot docs = await Firestore.instance
      .collection('todo')
      .where('done', isEqualTo: true)
      .getDocuments();
    Map<String, dynamic> _todos = {};
    docs.documents.forEach((doc) => _todos[doc.documentID] = doc.data);
    setState(() {
      todos = _todos;
    });
    return todos;
  }

  void deleteAll() {
    todos.forEach((k, v) {
      Firestore.instance
        .collection('todo')
        .document(k)
        .delete();
    });
    setState(() {
      todos = {};
    });
  }

  void _toggleList(String key, bool value) {
    setState(() {
      dynamic data = todos.remove(key);
      if (data != null) {
        Firestore.instance
          .collection('todo')
          .document(key)
          .updateData({'done': false});
      }
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
                deleteAll();
              },
              icon: Icon(Icons.delete),
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
