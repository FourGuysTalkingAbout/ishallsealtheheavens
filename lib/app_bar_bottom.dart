import 'package:flutter/material.dart';


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
                onPressed: () { //
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'PastInst', (route) => route.isCurrent
                          ? route.settings.name == "PastInst"
                          ? false : true : true);
                  }
                ),
          ),
          Container(
            child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: IconButton(
                    iconSize: 50.0,
                    icon: Image.asset('images/IconIcecream.png'),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil
                        ('Instance', (route) => route.isCurrent
                        ? route.settings.name == 'Instance'
                        ? false : true : true);
                    })),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.collections),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil
                  ('Gallery', (route) => route.isCurrent
                ? route.settings.name == 'Instance'
                ? false : true : true);
              },
            ),
          )
        ],
      ),
    );
  }
}
