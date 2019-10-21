import 'package:flutter/material.dart';
import 'package:ishallsealtheheavens/logic/login_authProvider.dart';
import 'package:provider/provider.dart';

import 'gallery.dart';
import 'instance_page.dart';
import 'join_create_page.dart';
import 'past_instance.dart';
import 'login_with_email.dart';
import 'signup_with_email.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Base app',
        home: Consumer(
          builder: (context, UserRepository user, _) {
            switch (user.status) {
              case Status.Uninitialized:
                return Container();
              case Status.Unauthenticated:
              case Status.Authenticating:
                return LoginButtons();
              case Status.Authenticated:
                return NavBar();
            }
            return Container();
          },
        ),
        routes: {
          'LoginEmail': (context) => LoginWithEmail(),
          'SignupEmail': (context) => SignUpWithEmail(),
          'JoinCreate': (context) => JoinCreatePage(),
          'PastInst': (context) => PastInstance(),
        'Instance': (context) => InstancePage(),
          'Gallery': (context) => Gallery(),
        },
      ),
    );
  }
}

//
//
//class App extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Base app',
//
//      theme: ThemeData(
//        primarySwatch: Colors.pink,
//      ),
//      // home basically
//      routes: {
////          '/': (context) => LoginPage(),
//        'LoginEmail': (context) => LoginWithEmail(),
//        'SignupEmail': (context) => SignUpWithEmail(),
//        'JoinCreate': (context) => JoinCreatePage(),
//        'PastInst': (context) => PastInstance(),
////        'Instance': (context) => InstancePage(),
//        'Gallery': (context) => Gallery(),
//      },
//    );
//  }
//}
