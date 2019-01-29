import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget {
 const CustomAppBar();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BottomAppBar(
      elevation: 5.0,
        color: Colors.grey,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.menu),
            onPressed: null),
            IconButton(icon: Icon(Icons.search),
                onPressed: null)
          ],
        ),



      );
//    );
// Scaffold(
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      floatingActionButton: FloatingActionButton(child:
//      Icon(Icons.camera), onPressed: (null),),
//      bottomNavigationBar: BottomAppBar(
//        shape: CircularNotchedRectangle(),
//        notchMargin: 4.0,
//        color: Colors.deepPurple,
//        child: Row(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//           IconButton(icon: Icon(Icons.menu),
//               onPressed: null),
//            IconButton(icon: Icon(Icons.search),
//                onPressed: null)
//
//          ],
//        ),
//      ),
//    );
  }
}

