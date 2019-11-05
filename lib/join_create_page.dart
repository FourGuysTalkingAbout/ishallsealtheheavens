import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ishallsealtheheavens/GridTile.dart';
import 'package:ishallsealtheheavens/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart' as prefix0;
import 'package:timeago/timeago.dart' as timeago;

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

  List<Widget> _AppBarTitleOptions = [
    Text('Past Instance'),
    Text('Active Instances'),
    Text('Gallery'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AllTopAppBar(
        centerTitle: true,
        title: _AppBarTitleOptions.elementAt(_selectedIndex),
      ),
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
      backgroundColor: Colors.grey[400],
//      appBar: TopAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InstanceNameTextFormField(
                  //todo: remove text after join/create button pressed.
                  instanceNameController: _instanceNameController),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 150,
                      child: RaisedButton(
                          color: Colors.white,
                          child: Text('Create Instance'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              createInstance(context: context, user: user);
                            }
                          }),
                    ),
                    Container(
                      width: 150,
                      child: RaisedButton(
                          color: Colors.white,
                          child: Text('Join Instance'),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              joinInstance(context: context, user: user.uid);
                            }
                          }),
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

    return prefix0.randomAlpha(5);
  }

  createInstance({FirebaseUser user, BuildContext context}) async {
    String instanceCode = createCode();
    DocumentReference docRef = await db.collection('instances').add({
      // turn into a transaction && add instanceCode random
      'instanceName': _instanceNameController.text,
      'instanceCode': instanceCode,
      'userLimit': '10',
      'users': FieldValue.arrayUnion([user.displayName]),
      'date': FieldValue.serverTimestamp(),
      'active': true,
      'host': user.uid,
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InstancePage(
              instanceCode: instanceCode,
              instanceName: _instanceNameController.text,
              instanceId: docRef.documentID,
            )));
  }

  joinInstance({String user, BuildContext context}) async {
    QuerySnapshot snapshot = await db
        .collection('instances')
        .where('instanceCode', isEqualTo: _instanceNameController.text)
        .getDocuments();

    final snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        duration: Duration(seconds: 2),
        content: Text('It\'s full right now. Try again later.'));

    bool premium = snapshot.documents[0].data['premium'];
    // if it's a premium instance then don't have a limit
    // if it's not a premium then return limit >= 10
    if (snapshot.documents[0].data['premium'] == true) {
      int numberOfUsers = snapshot.documents[0].data['users']
          .length; //returns a int length of ['users'] data
      int userLimit = int.parse(snapshot.documents[0]
          .data['userLimit']); // default is 10. premium hosts can change number

      if (numberOfUsers >= userLimit) {
        return Scaffold.of(context)
            .showSnackBar(snackBar); //deny user if limit is reached.
      } else {
        snapshot.documents[0].reference.updateData({
          'users': FieldValue.arrayUnion([user])
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InstancePage(
                      instanceName: snapshot.documents[0].data['instanceName'],
                      instanceId: snapshot.documents[0].documentID,
                      instanceCode: snapshot.documents[0].data['instanceCode'],
                    )));
      }

      snapshot.documents[0].reference.updateData({
        'users': FieldValue.arrayUnion([user])
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InstancePage(
                    instanceName: snapshot.documents[0].data['instanceName'],
                    instanceId: snapshot.documents[0].documentID,
                    instanceCode: snapshot.documents[0].data['instanceCode'],
                  )));
    } else if (snapshot.documents[0].data['premium'] == false) {
      int numberOfUsers = snapshot.documents[0].data['users']
          .length; //returns a int length of ['users'] data
      int userLimit = int.parse(snapshot.documents[0]
          .data['userLimit']); // default is 10. premium hosts can change number

      if (numberOfUsers >= 10) {
        return Scaffold.of(context)
            .showSnackBar(snackBar); //deny user if limit is reached.
      } else {
        snapshot.documents[0].reference.updateData({
          'users': FieldValue.arrayUnion([user])
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InstancePage(
                      instanceName: snapshot.documents[0].data['instanceName'],
                      instanceId: snapshot.documents[0].documentID,
                      instanceCode: snapshot.documents[0].data['instanceCode'],
                    )));
      }
    } else {
      snapshot.documents[0].reference.updateData({
        'users': FieldValue.arrayUnion([user])
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InstancePage(
                    instanceName: snapshot.documents[0].data['instanceName'],
                    instanceId: snapshot.documents[0].documentID,
                    instanceCode: snapshot.documents[0].data['instanceCode'],
                  )));
    }
  }

  @override
  void dispose() {
    _instanceNameController.clear();
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
      color: Colors.white,
      child: TextFormField(
        maxLength: 20,
        controller: _instanceNameController,
        textAlign: TextAlign.center,
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp("[a-zA-Z --!]"))
        ],
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
    FirebaseUser user = Provider.of<UserRepository>(context).user;

    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('instances')
          .where("users", arrayContains: user.displayName)
          .where('active', isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading....');
          default:
            return ListView.builder(
              key: PageStorageKey<String>('Preseves scroll position'),
              physics: PageScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data.documents[index];
                DateTime docTime = document['date'] != null
                    ? document['date'].toDate()
                    : DateTime.now();
                var timeAgo = timeago.format(docTime);
                return CustomGridTile(
                  instanceCode: document['instanceCode'],
                  instanceId: document.documentID,
                  instanceName: document['instanceName'],
                  instancePhoto: document['photoURL'] == null ||
                          document['photoURL'].isEmpty
                      ? Container(color: Colors.black)
                      : Image.network(document['photoURL'][0],
                          fit: BoxFit.fill),
                  date: timeAgo,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstancePage(
                              instanceCode: document['instanceCode'],
                              instanceId: document.documentID,
                              instanceName: document['instanceName']))),
                );

//            var snap = document.reference.collection('photos').snapshots();
              },
            );
        }
      },
    );
  }
}
