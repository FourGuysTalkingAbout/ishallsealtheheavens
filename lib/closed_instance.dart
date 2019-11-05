import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'logic/login_authProvider.dart';
import 'app_bar_top_instance.dart';
import 'user_account_drawer.dart';
import 'details_page.dart';

final userRepository = UserRepository.instance();

class ClosedInstancePage extends StatefulWidget {
  final String instanceName;
  final String instanceId;
  final String instanceCode;

  ClosedInstancePage(
      {Key key, this.instanceName, this.instanceId, this.instanceCode})
      : super(key: key);

  @override
  _ClosedInstancePageState createState() => _ClosedInstancePageState();
}

class _ClosedInstancePageState extends State<ClosedInstancePage> {
  @override
  Widget build(BuildContext context) {
    FirebaseUser user = Provider.of<UserRepository>(context).user;

    return StreamBuilder(
        stream: db.collection('instances').document(widget.instanceId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container();
          String instanceName = snapshot.data['instanceName'];

          return Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: Colors.grey[400],
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: InstanceAppBar(
                    instanceID: widget.instanceId, title: Text(instanceName))),
            drawer: UserAccountDrawer(),
            body: Center(
              child: PhotoGridView(
                docId: widget.instanceId,
                instanceName: widget.instanceName,
              ),
            ),
          );
        });
  }
}

class PhotoGridView extends StatelessWidget {
  final String instanceName;
  final String docId;

  PhotoGridView({this.instanceName, this.docId});

  Stream<List<dynamic>> getPics() {
    DocumentReference docRef = db.collection('instances').document(docId);
    return docRef.snapshots().map((document) {
      List<dynamic> info = document.data['photoURL'].toList();
      return info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getPics(),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return Container();
        } else {
          return GridView.builder(
              key: PageStorageKey<String>('Preseves scroll position'),
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  crossAxisCount: 2),
              padding: EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    elevation: 5.0,
                    child: Hero(
                        tag: snapshot.data[index],
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: Image.network(snapshot.data[index],
                              fit: BoxFit.fill),
                        )),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsPage(
                                id: snapshot.data[index],
                                imageUrl: snapshot.data[index],
                              ))),
                );
              });
        }
      },
    );
  }
}
