import 'package:flutter/material.dart';

import 'gallery.dart';
import 'instance_page.dart';
import 'join_create_page.dart';
import 'login_page.dart';
import 'past_instance.dart';

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
          '/': (context) => JoinCreatePage(),
          'JoinCreate': (context) => LoginPage(),
          'PastInst': (context) => PastInstance(),
          'Instance': (context) => InstancePage(),
          'Gallery': (context) => Gallery(),
        },
        title: 'Base app');
  }
}
