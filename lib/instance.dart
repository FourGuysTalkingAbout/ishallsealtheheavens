import 'package:flutter/material.dart';
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
    return Container(child: Text(widget.value));
  }
}
