import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ishallsealtheheavens/instance_page.dart';
import 'package:ishallsealtheheavens/logic/login_authProvider.dart';
import 'package:ishallsealtheheavens/GridTile.dart';
import 'package:provider/provider.dart';
import 'app_bar_past_instance.dart';
import 'package:timeago/timeago.dart' as timeago;



class PastInstance extends StatefulWidget {
  @override
  _PastInstanceState createState() => _PastInstanceState();
}

class _PastInstanceState extends State<PastInstance> {

  Widget _buildGridList() {
    FirebaseUser user = Provider.of<UserRepository>(context).user;
     final now = DateTime.now().toLocal();
    final formatter = DateFormat.MMMMEEEEd().add_Hm();
    final date = formatter.format(now);
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('instances').where('users', arrayContains: user.uid).where('active', isEqualTo: false).orderBy('date', descending: true).snapshots(),
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      }
        return ListView.builder(
          key: PageStorageKey<String>('Preseves scroll position'),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot document = snapshot.data.documents[index];
            var timeAgo = timeago.format(document['date'].toDate());
            return CustomGridTile(
              instanceId: document.documentID,
              instanceName: document['instanceName'],
              instancePhoto:  document['photoURL'] == null || document['photoURL'].isEmpty ? Container(color: Colors.black)  : Image.network(
              document['photoURL'][0],fit: BoxFit.fill),
              date: timeAgo,
            );
          },
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toLocal();
    final formatter = DateFormat.MMMMEEEEd().add_Hm();
    final date = formatter.format(now);
    
    return Scaffold(

        appBar: InstanceTopAppBar(),
        backgroundColor: Colors.grey[400],
        endDrawer: DrawerMenu(),
        body: _buildGridList()
        );
  }

}


