import 'package:flutter/material.dart';
import 'app_bar_bottom.dart';
import 'app_bar_top.dart';
import 'instance_page.dart';

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
      body: Center(
        child: Column(children: <Widget>[
          SecondAppBar(),
          SizedBox(height: 100),
          new InstanceNameTextFormField(
              instanceNameController: _instanceNameController),
          new InstanceNameRaisedButton(
              instanceNameController: _instanceNameController),
        ]),
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
        final route = new MaterialPageRoute(
          builder: (BuildContext context) =>
              new InstancePage(value: _instanceNameController.text),
        );
        Navigator.of(context).push(route);
      },
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
