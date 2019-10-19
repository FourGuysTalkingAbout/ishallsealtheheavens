import 'package:flutter/material.dart';


class CustomGridTile extends StatelessWidget {
  final String instanceName;
  final String instanceId;
  final String instancePhoto;
  final Function onTap;

  CustomGridTile({this.instanceId, this.instanceName, this.instancePhoto, this.onTap});

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0, bottom: 0.0),
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 8.0, color: Colors.white),
            right:BorderSide(width: 8.0, color: Colors.white),
            top: BorderSide(width: 8.0, color: Colors.white),
          ),
        ),
        child: GestureDetector(
            child: GridTile(
              // put gridTile in InstacePageDetails
//                        header:Center(child: Text('FOOTER')),
                footer: Container(
                    height: 60,
                    color: Colors.white,
                    child: Center(
                        child: Text(instanceName,
                            style: TextStyle(fontSize: 24.0)))),
                child: instancePhoto == null || instancePhoto.isEmpty ?  Container(color: Colors.black,):
                Image.network(
                  instancePhoto,fit: BoxFit.fill,)),
            onTap: onTap
//                () => Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (context) => InstancePage(
//                        instanceId: document.documentID,
//                        instanceName: document['instanceName']))),
        ),
      ),
    );
  }
}
