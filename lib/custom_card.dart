import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String instanceName;
  final String instanceId;
  final String instancePhoto;
  final String instanceCode;
  final String date;
  final Function onTap;

  CustomCard(
      {this.instanceId,
      this.instanceName,
      this.instancePhoto,
      this.date,
      this.instanceCode,
      this.onTap});

  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            height: 320,
            width: 300,
            child: Card(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 217.5,
                    width: 262.5,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(instancePhoto,targetWidth: 262, targetHeight: 217)
                    )
                  ),
                  ),
                  Text(instanceName),
                  Text(date)
                ],
              )
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
