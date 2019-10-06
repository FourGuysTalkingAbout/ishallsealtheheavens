import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'app_bar_bottom.dart';
import 'app_bar_top.dart';
import 'instance_page.dart';
import 'user_account_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';


final fbDatabase = Firestore.instance;


class JoinCreatePage extends StatefulWidget {

  JoinCreatePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _JoinCreatePageState createState() => _JoinCreatePageState();
}

class _JoinCreatePageState extends State<JoinCreatePage> {

  TextEditingController _instanceNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(),
      //endDrawer: DrawerMenu(),
      drawer: UserAccountDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            SecondAppBar(),
            SizedBox(height: 100),
            Text('HELLO'),
            new InstanceNameTextFormField(
                instanceNameController: _instanceNameController),
            new InstanceNameRaisedButton(
                instanceNameController: _instanceNameController),
            InstanceListView()
          ]),
        ),
      ),
      bottomNavigationBar: CustomAppBar(),
    );
  }
}

class InstanceNameRaisedButton extends StatelessWidget {
  const InstanceNameRaisedButton({
    Key key,
    @required TextEditingController instanceNameController,
  })  : _instanceNameController = instanceNameController,
        super(key: key);

  final TextEditingController _instanceNameController;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text("Create Instance"),
      onPressed: () {
        createInstance();
        final route = new MaterialPageRoute(
          builder: (BuildContext context) =>
              new InstancePage(value: _instanceNameController.text),
        );
        Navigator.of(context).push(route);
      },
    );
  }

  void createInstance() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    fbDatabase
        .collection('instances')
        .add({'instanceName': _instanceNameController.text, 'users': user.uid});
  }

  void joinInstance() {}
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
    return TextField(
      controller: _instanceNameController,
      maxLengthEnforced: true,
      maxLength: 10,
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.characters,
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "name the instance",
        labelText: "create instance",
        alignLabelWithHint: true,
      ),
    );
  }
}

class InstanceListView extends StatefulWidget {
  @override
  _InstanceListViewState createState() => _InstanceListViewState();
}

class _InstanceListViewState extends State<InstanceListView>  {
  User user;

  @override
  Widget build(BuildContext context) {
    String uid = '';

    return StreamBuilder<QuerySnapshot>(
      stream: fbDatabase.collection('instances').where("users", isEqualTo: uid ).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return Text('Loading....');
          default:return ListView(
            shrinkWrap: true,
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return Container(
                height: 100,
                child: Card(
                    child: Center(child: Text(document['instanceName']))
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

    getCurrentUser()  async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;
    return uid;
  }

}

class User {
  String email;
  String photoUrl;
  String uid;

  User({this.email,this.photoUrl,this.uid});

  getCurrentUser()  async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;

  }
}