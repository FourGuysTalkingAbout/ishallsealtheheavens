import 'package:flutter/material.dart';
import 'package:ishallsealtheheavens/gallery.dart';
import 'package:ishallsealtheheavens/join_create_page.dart';
import 'package:ishallsealtheheavens/past_instance.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar();

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0.0,
      color: Color(0xFFE5E5E5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                iconSize: 40.0,
                icon: Icon(Icons.people),
                onPressed: () {
                  //
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'PastInst',
                      (route) => route.isCurrent
                          ? route.settings.name == "PastInst" ? false : true
                          : true);
                }),
          ),
          Container(
            child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: IconButton(
                    iconSize: 50.0,
                    icon: Image.asset('images/IconIcecream.png'),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'Instance',
                          (route) => route.isCurrent
                              ? route.settings.name == 'JoinCreate' ? false : true
                              : true);
                    })),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.collections),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    'Gallery',
                    (route) => route.isCurrent
                        ? route.settings.name == 'Gallery' ? false : true
                        : true);
              },
            ),
          )
        ],
      ),
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






class BottomNavBar extends StatelessWidget {
  BottomNavBar({@required this.onTapped, @required this.currentIndex});
  int currentIndex;
  Function onTapped;
  
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem> [
        BottomNavigationBarItem(icon: Icon(Icons.people),title: Text('')),
        BottomNavigationBarItem(icon: ImageIcon(AssetImage('images/IconIcecream.png')),title: Text('')),
        BottomNavigationBarItem(icon: Icon(Icons.collections),title: Text('')),
      ],
      selectedItemColor: Colors.black,
      currentIndex: currentIndex,
      backgroundColor: Colors.deepPurple,
      unselectedItemColor: Colors.white,
      onTap:  onTapped,
    );
  }
}