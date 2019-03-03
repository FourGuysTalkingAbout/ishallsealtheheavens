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
  TextEditingController _createInstanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _createInstanceController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    _createInstanceController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("instance name: ${_createInstanceController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
                controller: _createInstanceController,
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
                onFieldSubmitted: (text) {
                  print("instance name: $text");
                }),
          ],
        ),
      ),
      bottomNavigationBar: CustomAppBar(),
    );
  }
}
