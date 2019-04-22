import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset('images/IconIcecream.png',scale: .12,),
    );
  }
}
