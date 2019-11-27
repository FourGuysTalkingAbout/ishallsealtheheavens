import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({@required this.onTapped, @required this.currentIndex});
  final int currentIndex;
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('')),
        BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('images/IconIcecream.png')),
            title: Text('')),
        BottomNavigationBarItem(icon: Icon(Icons.collections), title: Text('')),
      ],
      selectedItemColor: Colors.black,
      currentIndex: currentIndex,
      backgroundColor: Colors.deepPurple,
      unselectedItemColor: Colors.white,
      onTap: onTapped,
    );
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;

  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-2, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
