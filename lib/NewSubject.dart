import 'package:flutter/material.dart';
import 'dart:math';

typedef TaskCallback = void Function(Map<int, dynamic> task);

class NewSubject extends StatefulWidget {
  const NewSubject({this.onAddNewTask});
  final TaskCallback onAddNewTask;

  @override
  State<StatefulWidget> createState() {
    return _NewSubjectState();
  }
}

class _NewSubjectState extends State<NewSubject> {
  final TextEditingController _text = TextEditingController();
  String _errorMessage = '';

  void _setError(String error) {
    setState(() {
      _errorMessage = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Subject'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        children: <Widget>[
          TextField(
            controller: _text,
            decoration: InputDecoration(
              labelText: 'Subject',
              errorText: _errorMessage == '' ? null : _errorMessage,
            ),
          ),
          RaisedButton(
            child: Text('Save'),
            onPressed: () {
              if (_text.text == '') {
                _setError('Please fill subject');
              } else {
                dynamic rng = Random();
                rng = int.parse(rng.nextInt(99999).toString());
                print(rng.runtimeType);
                widget.onAddNewTask({
                  rng: {'subject': _text.text, 'done': false}
                });
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
