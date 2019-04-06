import 'package:flutter/material.dart';
import 'Holder.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int index = 0;

  final List<Widget> _children = [Holder('Task'), Holder('Completed')];

  void _navHandler(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: _navHandler,
          currentIndex: index,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Task'),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.done_all),
              title: Text('Completed'),
            )
          ],
        ),
        body: _children[index]);
  }
}
