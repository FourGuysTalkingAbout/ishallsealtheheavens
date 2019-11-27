import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ishallsealtheheavens/gallery_page.dart';
import 'package:path_provider/path_provider.dart';

import 'package:random_string/random_string.dart' as prefix0;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'logic/login_authProvider.dart';
import 'user_account_drawer.dart';
import 'past_instance.dart';
import 'instance_page.dart';
import 'bottom_navbar.dart';
import 'custom_card.dart';
import 'app_bar.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  int _selectedIndex = 1;

  List<Widget> _btmNavOptions = [
    PastInstance(),
    JoinCreatePage(),
    TabBarView(children: <Widget>[
      Gallery(),
      AllPhotosList(),
  ])
  ];

  List<Widget> _appBarTitleOptions = [
    Text('Past Instance'),
    Text('Active Instance'),
    Text('Gallery'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    super.initState();
    requestWritePermission();
    createDeviceDirectory();
  }


  @override
  Widget build(BuildContext context) {
//    PermissionHandler().openAppSettings();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AllTopAppBar(
          centerTitle: true,
          title: _appBarTitleOptions.elementAt(_selectedIndex),
          bottom: _selectedIndex == 2 ? TabBar(
            tabs: <Widget>[
              Tab(text: 'Photos Taken/Saved'),
              Tab(text: 'All Photos')],
          ) : null
          ),
        drawer: UserAccountDrawer(),
        body:  _btmNavOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _selectedIndex,
          onTapped: _onItemTapped,
        ),
      ),
    );
  }

  requestWritePermission() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage, PermissionGroup.camera]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    print('Permission: $permission');
  }
  createDeviceDirectory()  async {

    final dir = Directory('storage/emulated/0/ISSTH');
    dir.exists().then((isThere) {
      if(isThere) {
        print('Directory already created');
        return;
      }
      else {
        print('creating directory');
        Directory('storage/emulated/0/ISSTH').createSync(recursive: true); //creates the Directory
      }
    });
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InstanceNameTextFormField(
                  //todo: remove text after join/create button pressed.
                  instanceNameController: _instanceNameController),
                user.isAnonymous ? Center(child: buildJoinButton(user)):
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    buildCreateButton(user),
                    buildJoinButton(user),
                  ]),
              ActiveInstancesView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildJoinButton(FirebaseUser user) {
    return Container(
      width: 150,
      child: RaisedButton(
          color: Colors.white,
          child: Text('Join Instance'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              joinInstance(context: context, user: user);
              _instanceNameController.clear();
            }
          }),
    );
  }
  Widget buildCreateButton(FirebaseUser user) {
    return   Container(
      width: 150,
      child: RaisedButton(
          color: Colors.white,
          child: Text('Create Instance'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              createInstance(context: context, user: user);
              _instanceNameController.clear();
            }
          }),
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
      'guests': 0,
      'userLimit': '10',
      'users': FieldValue.arrayUnion([user.uid]),
      'userNames': FieldValue.arrayUnion([user.displayName]),
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



  joinInstance({FirebaseUser user, BuildContext context}) async {
    QuerySnapshot snapshot = await db
        .collection('instances')
        .where('instanceCode', isEqualTo: _instanceNameController.text)
        .getDocuments();

    String instanceName = snapshot.documents[0].data['instanceName'];
    String instanceId = snapshot.documents[0].documentID;
    String instanceCode = snapshot.documents[0].data['instanceCode'];
    bool premium = snapshot.documents[0].data['premium'];


    final snackBar = SnackBar(
        behavior: SnackBarBehavior.fixed,
        duration: Duration(seconds: 2),
        content: Text('It\'s full right now. Try again later.'));



    // if it's a premium instance then don't have a limit
    // if it's not a premium then return limit >= 10
    if (snapshot.documents[0].data['premium'] == true) {
      int numberOfUsers = snapshot.documents[0].data['users'].length; //returns a int length of ['users'] data
      int userLimit = int.parse(snapshot.documents[0].data['userLimit']); // default is 10. premium hosts can change number

      if (numberOfUsers >= userLimit) {
        return Scaffold.of(context)
            .showSnackBar(snackBar); //deny user if limit is reached.
      } else {
        snapshot.documents[0].reference.updateData({
          'users': FieldValue.arrayUnion([user.uid]),
          'userNames': FieldValue.arrayUnion([user.displayName]),

        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InstancePage(
                      instanceName: instanceName,
                      instanceId: instanceId,
                      instanceCode: instanceCode,
                    )));
      }

      snapshot.documents[0].reference.updateData({
        'users': FieldValue.arrayUnion([user.uid]),
        'userNames': FieldValue.arrayUnion([user.displayName]),
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InstancePage(
                    instanceName: instanceName,
                    instanceId: instanceId,
                    instanceCode: instanceCode,
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
          'users': FieldValue.arrayUnion([user.uid]),
          'userNames': FieldValue.arrayUnion([user.displayName]),

        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InstancePage(
                      instanceName: instanceName,
                      instanceId: instanceId,
                      instanceCode: instanceCode,
                    )));
      }
    } else if (user.isAnonymous){
      snapshot.documents[0].reference.updateData({
        'guests': FieldValue.increment(1),
        'users': FieldValue.arrayUnion([user.uid]),
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InstancePage(
                instanceName: instanceName,
                instanceId: instanceId,
                instanceCode: instanceCode,
              )));

    } else{
      snapshot.documents[0].reference.updateData({
        'users': FieldValue.arrayUnion([user.uid]),
        'userNames': FieldValue.arrayUnion([user.displayName])
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InstancePage(
                instanceName: instanceName,
                instanceId: instanceId,
                instanceCode: instanceCode,
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
            border: InputBorder.none,
            hintText: 'Join/Enter a Instance',
            alignLabelWithHint: true),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Enter Code';
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
          .where("users", arrayContains: user.uid,)
          .where('active', isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading....');
          default:
            return ListView.builder(
              padding: EdgeInsets.all(20.0),
              key: PageStorageKey<String>('Preseves scroll position'),
              physics: PageScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {

                DocumentSnapshot document = snapshot.data.documents[index];
                String instanceCode = document['instanceCode'];
                String instanceId = document.documentID;
                String instanceName = document['instanceName'];

                DateTime docTime = document['date'] != null
                    ? document['date'].toDate()
                    : DateTime.now();
                var timeAgo = timeago.format(docTime);

                return CustomCard(
                  instanceCode: instanceCode,
                  instanceId: instanceId,
                  instanceName: instanceName,
                  instancePhoto: document['photoURL'] == null || document['photoURL'].isEmpty
                      ? '' : document['photoURL'][0],
                  date: timeAgo,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstancePage(
                              instanceCode: instanceCode,
                              instanceId: instanceId,
                              instanceName: instanceName))),
                );
              },
            );
        }
      },
    );
  }
}
