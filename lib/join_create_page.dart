import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ishallsealtheheavens/gallery.dart';
import 'package:ishallsealtheheavens/past_instance.dart';
import 'app_bar_bottom.dart';
import 'app_bar_past_instance.dart';
import 'app_bar_top.dart';
import 'app_bar_top_gallery.dart';
import 'instance_page.dart';
import 'logic/login_authProvider.dart';
import 'user_account_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';

class JoinCreatePage extends StatelessWidget {
  final TextEditingController _instanceNameController = TextEditingController();
  JoinCreatePage({Key key, this.title, this.user}) : super(key: key);
  final FirebaseUser user;
  final String title;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(),
      //endDrawer: DrawerMenu(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InstanceNameTextFormField(
                  instanceNameController: _instanceNameController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InstanceNameRaisedButton(
                    instanceNameController: _instanceNameController,
                    title: Text('Create Instance'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        createInstance(user: user.user.uid);
                        final route = MaterialPageRoute(
                          builder: (BuildContext context) => new InstancePage(
                            instanceName: _instanceNameController.text,
                          ),
                        );
                        Navigator.of(context).push(route);
                      }
                    },
                  ),
                  InstanceNameRaisedButton(
                      instanceNameController: _instanceNameController,
                      title: Text('Join Instance'),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          joinInstance(context: context, user: user.user.uid);
                        }
                      }),
                ],
              ),
              ActiveInstancesView(),
            ],
          ),
        ),
      ),
    );
  }

  void createInstance({String user}) async {
    db // turn into a transaction && add instanceCode random
        .collection('instances')
        .add({
      'instanceName': _instanceNameController.text,
      'users': FieldValue.arrayUnion([user])
    });
  }

//  TODO: add error when instanceCode isn't correct or doesn't exists
  void joinInstance({String user, BuildContext context}) async {
    QuerySnapshot snapshot = await db
        .collection('instances')
        .where('instanceCode', isEqualTo: _instanceNameController.text)
        .getDocuments();
    print(snapshot.documents.length);
    snapshot.documents[0].reference.updateData({
      'users': FieldValue.arrayUnion([user])
    });
    final route = MaterialPageRoute(
        builder: (BuildContext context) => InstancePage(
            instanceName: snapshot.documents[0].data['instanceName']));
    Navigator.of(context).push(route);
  }
}

class InstanceNameRaisedButton extends StatelessWidget {
  const InstanceNameRaisedButton(
      {Key key,
      @required TextEditingController instanceNameController,
      this.title,
      this.onPressed})
      : _instanceNameController = instanceNameController,
        super(key: key);

  final TextEditingController _instanceNameController;
  final Widget title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: title,
      onPressed: onPressed,
    );
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
                                    child: Row(
                                  children: <Widget>[
//                                  Text(test),
                                    Text(document.documentID),
                                    Text(document['instanceName'],
                                        style: TextStyle(fontSize: 24.0)),
                                  ],
                                ))),
                            child: document['photoURL'] != null
                                ? Image.network(
                                    document['photoURL'][0],
                                    fit: BoxFit.fill,
                                  )
                                : Text('')),
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

class TestNavBar extends StatefulWidget {
  @override
  _TestNavBarState createState() => _TestNavBarState();
}

class _TestNavBarState extends State<TestNavBar> {
  int _selectedIndex = 1;
  List<Widget> _btmNavOptions = [
    PastInstance(),
    JoinCreatePage(),
    Gallery(),
  ];

  List<Widget> _topNavOptions = [
    TopAppBar(),
    InstanceTopAppBar(),
    GalleryTopAppBar(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserRepository>(context);
    final FirebaseUser user = provider.user;
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
