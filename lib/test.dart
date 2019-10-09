import 'package:flutter/material.dart';
import 'package:ishallsealtheheavens/join_create_page.dart';
import 'package:ishallsealtheheavens/logic/login_authProvider.dart';
import 'package:provider/provider.dart';

import 'login_with_email.dart';


class TestAuthProvider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Container();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginWithEmail();
            case Status.Authenticated:
              return JoinCreatePage(user: user.user);
          }
          return Container();
        },
      ),
    );
  }
}
