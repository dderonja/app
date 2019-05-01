import 'package:flutter/material.dart';
class Diaden extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hol Dir Diaden!"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Zurück'),
        ),
      ),
    );
  }
}