import 'package:flutter/material.dart';

import 'instance.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),

      home: MyHomePage(title: 'Base app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Function(String instanceName) onChangeInstanceName;

  _MyHomePageState({this.onChangeInstanceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
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
                  print("instance name: $instanceName");
                },
              ),
            ]),
      ),
      bottomNavigationBar: CustomAppBar(),
    );
  }
}
