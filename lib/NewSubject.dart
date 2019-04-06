import 'package:flutter/material.dart';

class NewSubject extends StatefulWidget {
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
              }
              else {
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
