import 'package:flutter/material.dart';

import 'join_create.dart';
import 'instance.dart';
import 'past_instance.dart';
import 'gallery.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),

        initialRoute: '/', // home basically
        routes: {
          '/' : (context) => JoinCreate(),
          'PastInst' : (context) => PastInstance(),
          'Instance' : (context) => InstancePage(),
          'Gallery'  : (context) => Gallery(),

        },
        title: 'Base app');
  }
}
