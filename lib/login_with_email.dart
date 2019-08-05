import 'package:flutter/material.dart';

class LoginWithEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff673AB7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            EmailForm(),
          ],
        ),
      ),
    );
  }
}

class EmailForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListBody(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 90, vertical: 7.5),
          color: const Color(0xffC4C4C4),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              border: InputBorder.none,
              hintText: 'Email',
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 90, vertical: 7.5),
          color: const Color(0xffC4C4C4),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              border: InputBorder.none,
              hintText: 'Password',
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 7.5),
          child: new SizedBox(
            width: 120,
            height: 30,
            child: MaterialButton(
              onPressed: () => {},
              textColor: Color(0xffFFC107),
              color: const Color(0xff757575),
              child: Text('Log In'),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 7.5),
          child: new SizedBox(
            width: 120,
            height: 30,
            child: MaterialButton(
              onPressed: () => Navigator.of(context).pushNamed('SignupEmail'),
              textColor: Color(0xffFFC107),
              color: const Color(0xff757575),
              child: Text('Sign Up'),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 7.5),
          child: new SizedBox(
            width: 120,
            height: 30,
            child: MaterialButton(
              onPressed: () => Navigator.of(context).pushNamed('/'),
              textColor: Color(0xffFFC107),
              color: const Color(0xff757575),
              child: Text('Back'),
            ),
          ),
        )
      ],
    );
  }
}

