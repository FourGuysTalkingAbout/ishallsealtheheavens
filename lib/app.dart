import 'package:flutter/material.dart';

import 'gallery.dart';
import 'instance_page.dart';
import 'join_create_page.dart';
import 'login_page.dart';
import 'past_instance.dart';
import 'login_with_email.dart';
import 'signup_with_email.dart';

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
          '/': (context) => LoginPage(),
          'LoginEmail': (context) => LoginWithEmail(),
          'SignupEmail': (context) => SignUpWithEmail(),
          'JoinCreate': (context) => JoinCreatePage(),
          'PastInst': (context) => PastInstance(),
          'Instance': (context) => InstancePage(),
          'Gallery': (context) => Gallery(),
        },
        title: 'Base app');
  }
}
