import 'package:flutter/material.dart';

import 'app_bar_bottom.dart';

class PastInstance extends StatefulWidget {
  @override
  _PastInstanceState createState() => _PastInstanceState();
}

class _PastInstanceState extends State<PastInstance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomAppBar(),

    );
  }
}
