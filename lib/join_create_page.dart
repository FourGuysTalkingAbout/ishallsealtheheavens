import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'gallery.dart';
import 'past_instance.dart';
import 'app_bar_bottom.dart';
import 'app_bar_top.dart';
import 'instance_page.dart';
import 'user_account_drawer.dart';
import 'logic/login_authProvider.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 1;
  List<Widget> _btmNavOptions = [
    PastInstance(),
    JoinCreatePage(),
    Gallery(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserAccountDrawer(),
      body: _btmNavOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTapped: _onItemTapped,
      ),
    );
  }
}

class JoinCreatePage extends StatefulWidget {

  @override
  _JoinCreatePageState createState() => _JoinCreatePageState();
}

class _JoinCreatePageState extends State<JoinCreatePage> {

  final TextEditingController _instanceNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  

  @override
  Widget build(BuildContext context) {

    FirebaseUser user = Provider.of<UserRepository>(context).user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InstanceNameTextFormField( //todo: remove text after join/create button pressed.
                  instanceNameController: _instanceNameController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 150,
                    child: RaisedButton(
                        child: Text('Create Instance'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            createInstance(context: context, user: user.uid);
                          }}),
                  ),
                  Container(
                    width: 150,
                    child: RaisedButton(
                      child: Text('Join Instance'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          joinInstance(context: context, user: user.uid);
                        }}),
                  )
                ]),
              ActiveInstancesView(),
            ],
          ),
        ),
      ),
    );
  }

  createCode() {
    Random code = Random();
    String createCryptoRandomString([int length = 6]) {
      var values = List<int>.generate(length, (i) => code.nextInt(15));
      return base64Url.encode(values);
    }
    return createCryptoRandomString();
  }

  createInstance({String user, BuildContext context}) async {
    DocumentReference docRef = await db.collection('instances').add({ // turn into a transaction && add instanceCode random
      'instanceName': _instanceNameController.text,
      'instanceCode': createCode(),
      'users': FieldValue.arrayUnion([user]),
      'date': FieldValue.serverTimestamp(),

    });
    Navigator.push(context, MaterialPageRoute(
            builder: (context) => InstancePage(
                  instanceName: _instanceNameController.text,
                  instanceId: docRef.documentID,
                )));
  }

  void joinInstance({String user, BuildContext context}) async {
    QuerySnapshot snapshot = await db
        .collection('instances')
        .where('instanceCode', isEqualTo: _instanceNameController.text)
        .getDocuments();
    print(snapshot.documents.length);
    snapshot.documents[0].reference.updateData({
      'users': FieldValue.arrayUnion([user])
    });
    Navigator.push(context, MaterialPageRoute(
            builder: (context) => InstancePage(
                  instanceName: snapshot.documents[0].data['instanceName'],
                  instanceId: snapshot.documents[0].documentID,
                )));
  }
  @override
  void dispose () {
    _instanceNameController.dispose();
    super.dispose();

  }
}

class InstanceNameTextFormField extends StatelessWidget {
  const InstanceNameTextFormField({
    Key key,
    @required TextEditingController instanceNameController,
  })  : _instanceNameController = instanceNameController,
        super(key: key);

  final TextEditingController _instanceNameController;

  @override
  Widget build(BuildContext context) {
    return Container(
//      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 7.5),
      color: Color(0xffC4C4C4),
      child: TextFormField(
        maxLength: 20,
        controller: _instanceNameController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            counterText: '',
//          contentPadding:
//          EdgeInsets.only(left: 5, top: 5, bottom: 10),
            border: InputBorder.none,
            hintText: 'Join/Enter a Instance',
            alignLabelWithHint: true),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Enter something';
          }
          return null;
        },
      ),
    );
  }
}

class ActiveInstancesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserRepository>(context);
    FirebaseUser user = provider.user;

    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('instances')
          .where("users", arrayContains: user.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading....');
          default:
            return ListView.builder(
              physics: PageScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data.documents[index];
//            var snap = document.reference.collection('photos').snapshots();
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, right: 8.0, left: 8.0, bottom: 0.0),
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                        border: Border(
                            left:
                                BorderSide(width: 8.0, color: Colors.grey[400]),
                            right:
                                BorderSide(width: 8.0, color: Colors.grey[400]),
                            top: BorderSide(
                                width: 8.0, color: Colors.grey[400]))),
                    child: GestureDetector(
                        child: GridTile(
                            // put gridTile in InstacePageDetails
//                        header:Center(child: Text('FOOTER')),
                            footer: Container(
                                height: 80,
                                color: Colors.grey[400],
                                child: Center(
                                    child: Text(document['instanceName'],
                                        style: TextStyle(fontSize: 24.0)))),
                            child: document['photoURL'] != null ? Image.network(
                              document['photoURL'][0],fit: BoxFit.fill,) : Text('')),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InstancePage(
                                    instanceId: document.documentID,
                                    instanceName: document['instanceName'])))),
                  ),
                );
              },

              // scrollDirection: Axis.horizontal, //Change to horizontal possible
//            children: snapshot.data.documents.map((DocumentSnapshot document) {
//            var  test = document.data.values.contains('photos');
//              return
//            }).toList(),
            );
        }
      },
    );
  }
}


