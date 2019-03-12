import 'package:flutter/material.dart';
import 'join_create.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: JoinCreate(),
        title: 'Base app');
  }
}
