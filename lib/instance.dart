import 'package:flutter/material.dart';

import 'app_bar_bottom.dart';
import 'app_bar_top_instance.dart';
import 'join_create.dart';

class InstancePage extends StatefulWidget {
  final String value;

  InstancePage({Key key, this.value}) : super(key: key);

  @override
  _InstancePageState createState() => _InstancePageState();
}

class _InstancePageState extends State<InstancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(widget.value)],
        ),
      ),
      bottomNavigationBar: CustomAppBar(),
    );
  }
}
