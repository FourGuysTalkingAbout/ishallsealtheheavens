import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ishallsealtheheavens/instance_page.dart';
import 'package:ishallsealtheheavens/logic/login_authProvider.dart';
import 'package:provider/provider.dart';
import 'app_bar_past_instance.dart';
import 'package:timeago/timeago.dart' as timeago;

const Color partyBackgroundColor = Color(0xFFE5E5E5);


class PastInstance extends StatefulWidget {
  @override
  _PastInstanceState createState() => _PastInstanceState();
}

class _PastInstanceState extends State<PastInstance> {
  

  List<String> instanceNames = <String>[//TODO: GET NAMES FROM DATABASE
    'HQ PARTY',
    'JAV Awards',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K'
  ];

  Widget _buildGridlist() {
        final user = Provider.of<UserRepository>(context);

     final now = DateTime.now().toLocal();
    final formatter = DateFormat.MMMMEEEEd().add_Hm();
    final date = formatter.format(now);

    return StreamBuilder<QuerySnapshot>(
      stream: db.collection('instances').where('users', isEqualTo: user.user.uid).snapshots(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index) {
            DocumentSnapshot document = snapshot.data.documents[index];
            var test = timeago.format(document['date'].toDate());
            return Container(color: partyBackgroundColor,
              height: 150,
              child: GridTile(
                  header: Container(
                    color: Colors.white,
                    height: 30,
//                    width:,
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0,right: 15.0),
                      child: Row(mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(document['instanceName'],style: TextStyle(fontSize:20.0,
                          decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),),
                          Text(test)

                        ],
                      ),
                    ),
                  ),
              child: Center(child: Text('Put Image Here')),),
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
        backgroundColor: partyBackgroundColor,
        endDrawer: DrawerMenu(),
        body: _buildGridlist()
        );
  }

}


