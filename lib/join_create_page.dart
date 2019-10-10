
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ishallsealtheheavens/gallery.dart';
import 'package:ishallsealtheheavens/past_instance.dart';
import 'app_bar_bottom.dart';
import 'app_bar_top.dart';
import 'instance_page.dart';
import 'logic/login_authProvider.dart';
import 'user_account_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


final fbDatabase = Firestore.instance;

class JoinCreatePage extends StatelessWidget {
  final TextEditingController _instanceNameController = TextEditingController();
  JoinCreatePage({Key key, this.title, this.user}) : super(key: key);
  final FirebaseUser user;
  final String title;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(),
      //endDrawer: DrawerMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            InstanceNameTextFormField(instanceNameController: _instanceNameController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InstanceNameRaisedButton(
                  instanceNameController: _instanceNameController,
                  title: Text('Create Instance'),),
                InstanceNameRaisedButton(
                  instanceNameController: _instanceNameController,
                title: Text('Join Instance')
                ),
              ],
            ),
            ActiveInstancesView(),
          ],
        ),
      ),
    );
  }
}


class InstanceNameRaisedButton extends StatelessWidget {
  const InstanceNameRaisedButton({
    Key key, @required TextEditingController instanceNameController, this.title,
  })  : _instanceNameController = instanceNameController,
        super(key: key);

  final TextEditingController _instanceNameController;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: title,
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

   return Container(
//      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          horizontal: 50, vertical: 7.5),
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
          alignLabelWithHint: true
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Enter your email';
          }
          return null;
        },
      ),
    );

//    return TextField(
//      controller: _instanceNameController,
//      maxLengthEnforced: true,
//      maxLength: 10,
//      textAlign: TextAlign.center,
//      textCapitalization: TextCapitalization.characters,
//      textInputAction: TextInputAction.go,
//      decoration: InputDecoration(
//        border: OutlineInputBorder(),
//        hintText: "name the instance",
//        labelText: "create instance",
//        alignLabelWithHint: true,
//      ),
//    );
  }
}

class ActiveInstancesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserRepository>(context);
    FirebaseUser user = provider.user;

    return StreamBuilder<QuerySnapshot>(
      stream: fbDatabase.collection('instances').where("users", isEqualTo: user.uid ).snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading....');
          default: return ListView(
            physics: PageScrollPhysics(),
            shrinkWrap: true,
            // scrollDirection: Axis.horizontal, //Change to horizontal possible
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return Padding(
                padding: const EdgeInsets.only(top:20.0,right:8.0, left: 8.0, bottom: 0.0),
                child: Container(
                    height: 250,
                    decoration: BoxDecoration(border: Border(
                        left: BorderSide( width:8.0,color: Colors.grey[400]),
                        right: BorderSide( width:8.0,color: Colors.grey[400]),
                        top:BorderSide( width:8.0,color: Colors.grey[400]))),
                  child: GridTile( // put gridTile in InstacePageDetails
                      header:Center(child: Text('FOOTER')),
                      footer:Container(
                      height: 80,
                      color: Colors.grey[400],
                      child: Center(child: Text(document['instanceName'],style: TextStyle(fontSize: 24.0),))),
                      child: document['url'] != null ? Image.network(
                        document['url'],fit: BoxFit.fill,): Text('')
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}


class TestNavBar extends StatefulWidget {
  @override
  _TestNavBarState createState() => _TestNavBarState( );
}

class _TestNavBarState extends State<TestNavBar> {

  int _selectedIndex = 1;
  List<Widget> _navOptions = [
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
      body: _navOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTapped: _onItemTapped,),
    );
  }
}

