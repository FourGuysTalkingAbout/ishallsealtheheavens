import 'package:flutter/material.dart';
import  'app_bar_past_instance.dart';
import 'app_bar_bottom.dart';

class PastInstance extends StatefulWidget {
  @override
  _PastInstanceState createState() => _PastInstanceState();
}

class _PastInstanceState extends State<PastInstance> {
  List<String> instanceNames = <String> ['A','B','C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InstanceTopAppBar(),
      backgroundColor: Color(0xFFE5E5E5),
      endDrawer: DrawerMenu(),
      bottomNavigationBar: CustomAppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            ListView.separated(itemBuilder: (BuildContext context, int index){

            }, separatorBuilder: null, itemCount: null)
          ],
        ),
      ),

    );
  }
}
