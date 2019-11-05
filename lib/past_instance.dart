import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'logic/login_authProvider.dart';
import 'closed_instance.dart';
import 'GridTile.dart';


class PastInstance extends StatefulWidget {
  @override
  _PastInstanceState createState() => _PastInstanceState();
}

class _PastInstanceState extends State<PastInstance> {


  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toLocal();
    final formatter = DateFormat.MMMMEEEEd().add_Hm();
    final date = formatter.format(now);
    
    return Scaffold(
        backgroundColor: Colors.grey[400],
        body: _buildGridList()
        );
  }

  Widget _buildGridList() {
    FirebaseUser user = Provider.of<UserRepository>(context).user;
    final now = DateTime.now().toLocal();
    final formatter = DateFormat.MMMMEEEEd().add_Hm();
    final date = formatter.format(now);
    return StreamBuilder<QuerySnapshot>(
        stream: db.collection('instances').where('users', arrayContains: user.displayName).where('active', isEqualTo: false).orderBy('date', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            key: PageStorageKey<String>('Preseves scroll position'),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot document = snapshot.data.documents[index];
              var timeAgo = timeago.format(document['date'].toDate());
              return CustomGridTile(
                instanceCode: document['instanceCode'],
                instanceId: document.documentID,
                instanceName: document['instanceName'],
                instancePhoto:  document['photoURL'] == null || document['photoURL'].isEmpty ? Container(color: Colors.black)  : Image.network(
                    document['photoURL'][0],fit: BoxFit.fill),
                date: timeAgo,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClosedInstancePage(
                            instanceCode: document['instanceCode'],
                            instanceId: document.documentID,
                            instanceName: document['instanceName']))),
              );
            },
          );
        });
  }

}


