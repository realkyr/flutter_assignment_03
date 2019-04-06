import 'package:flutter/material.dart';

class Holder extends StatelessWidget {
  final String title;

  Holder(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(children: <Widget>[
        Center(child: Text(title)),
        ],
      ),
    );
  }
}