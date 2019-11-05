import 'package:flutter/material.dart';

class CustomGridTile extends StatelessWidget {
  final String instanceName;
  final String instanceId;
  final Widget instancePhoto;
  final String instanceCode;
  final String date;
  final Function onTap;

  CustomGridTile(
      {this.instanceId,
      this.instanceName,
      this.instancePhoto,
      this.date,
      this.instanceCode,
      this.onTap});

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 20.0, right: 24.0, left: 24.0, bottom: 0.0),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 8.0, color: Colors.grey[200]),
            right: BorderSide(width: 8.0, color: Colors.grey[200]),
            top: BorderSide(width: 8.0, color: Colors.grey[200]),
          ),
        ),
        child: GestureDetector(
          child: GridTile(
              footer: Container(
                  height: 60,
                  color: Colors.grey[200],
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(instanceName, style: TextStyle(fontSize: 24.0)),
                      Text(date,
                          style: TextStyle(
                              fontSize: 10.0, fontStyle: FontStyle.italic))
                    ],
                  ))),
              child: instancePhoto),
          onTap: onTap,
        ),
      ),
    );
  }
}
