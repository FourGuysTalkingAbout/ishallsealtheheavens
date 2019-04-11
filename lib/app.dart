import 'package:flutter/material.dart';
import 'join_create.dart';
import 'instance.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: InstancePage(),
        title: 'Base app');
  }
}
