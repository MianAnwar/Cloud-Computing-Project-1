import 'package:flutter/material.dart';

class CPage extends StatefulWidget {
  final list; //
  CPage(this.list);

  @override
  _CPageState createState() => _CPageState();
}

class _CPageState extends State<CPage> {
  @override
  Widget build(BuildContext context) {
    ///
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
              title: Container(
            color: Colors.black,
            child: Image.network(
              widget.list[index],
              scale: 0.5,
            ),
          ));
        },
      ),
    );
  }
}
