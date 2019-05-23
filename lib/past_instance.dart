import 'package:flutter/material.dart';
import 'app_bar_past_instance.dart';
import 'app_bar_bottom.dart';


Color partyBackgroundColor = Color(0xFFE5E5E5);
class PastInstance extends StatefulWidget {
  @override
  _PastInstanceState createState() => _PastInstanceState();
}

class _PastInstanceState extends State<PastInstance> {
  List<String> instanceNames = <String>[//TODO: GET NAMES FROM DATABASE
    'HQ PARTY',
    'JAV Awards',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: InstanceTopAppBar(),
        backgroundColor: partyBackgroundColor,
        endDrawer: DrawerMenu(),
        bottomNavigationBar: CustomAppBar(),
        body: Center(
            child: ListView.builder(
          itemCount: instanceNames.length,
//          separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black,),
          itemBuilder: (BuildContext context, int index) {
            return Container(color: partyBackgroundColor,
              height: 150,
              child: GridTile(
                  header: Container(
                    color: Colors.white,
                    height: 30,
//                    width:,
                    child: Padding(
                      padding: const EdgeInsets.only(left:20.0,right: 15.0),
                      child: Row(mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(instanceNames[index],style: TextStyle(fontSize:20.0,
                          decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),),
                          Text('Date')
                        ],
                      ),
                    ),
                  ),
              child: Center(child: Text('Put Image Here')),),
            );
          },
        )));
  }
}
