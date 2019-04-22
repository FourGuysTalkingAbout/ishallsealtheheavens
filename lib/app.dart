import 'package:flutter/material.dart';
import 'join_create.dart';
import 'instance.dart';
import 'past_instance.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        initialRoute: '/',
        routes: {
          //todo: create a create gallery page
          '/' : (context) => JoinCreate(),
          'PastInst' : (context) => PastInstance(),
          'Instance' : (context) => InstancePage(),

        },
        title: 'Base app');
  }
}
