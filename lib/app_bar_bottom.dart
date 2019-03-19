import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return BottomAppBar(
      elevation: 1.0,
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: IconButton(
                  iconSize: 40.0,
                  icon: Icon(Icons.people),
                  onPressed: () {
                    print("I was tapped");
                  }),
            ),
          ),
          Container(
            child: InkWell(
              child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: IconButton(
                      iconSize: 50.0,
                      icon: Image.asset('images/IconIcecream.png'),
                      onPressed: () {
                        print('I was tapped');
                      })),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.collections),
              onPressed: () {
                print('I was tapped');
              },
            ),
          )
        ],
      ),
    );
  }
}
