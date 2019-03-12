import 'package:flutter/material.dart';
import 'package:frideos/frideos.dart';

import 'instance.dart';

class JoinCreate extends StatefulWidget {
  JoinCreate({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _JoinCreateState createState() => _JoinCreateState();
}

class _JoinCreateState extends State<JoinCreate> {
  String instanceName = '';

  final streamedInstanceName = StreamedValue<String>();

  @override
  initState() {
    super.initState();
    streamedInstanceName.value = instanceName;
  }

  @override
  void dispose() {
    streamedInstanceName.dispose();
    super.dispose();
  }

  final Function(String instanceName) onChangeInstanceName;

  _JoinCreateState({this.onChangeInstanceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new _textField(onChangeInstanceName: onChangeInstanceName),
            ]),
      ),
      bottomNavigationBar: CustomAppBar(),
    );
  }
}

class _textField extends StatelessWidget {
  const _textField({
    Key key,
    @required this.onChangeInstanceName,
  }) : super(key: key);

  final Function(String instanceName) onChangeInstanceName;

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLengthEnforced: true,
      maxLength: 10,
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "name the instance",
        labelText: "create instance",
        alignLabelWithHint: true,
      ),
      onChanged: (instanceName) {
        onChangeInstanceName(instanceName);
      },
      onSubmitted: (instanceName) {
        onChangeInstanceName(instanceName);
        print("instance name: $instanceName");
      },
    );
  }
}
