import 'package:flutter/material.dart';
import 'logic/login_authProvider.dart';


class SignUpWithEmail extends StatefulWidget {
  @override
  _SignUpWithEmailState createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  final  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff673AB7),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 48,
                  height: 128,
                  child: Image(
                    image: AssetImage('images/icecreamcolour.png'),
                  )),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 90, vertical: 7.5),
                color: Color(0xffC4C4C4),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    border: InputBorder.none,
                    hintText: 'Email',
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Enter your email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 90, vertical: 7.5),
                color: Color(0xffC4C4C4),
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    border: InputBorder.none,
                    hintText: 'Password',
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 90, vertical: 7.5),
                color: const Color(0xffC4C4C4),
                child: TextFormField(
                  controller: _passwordController2,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                    border: InputBorder.none,
                    hintText: 'Confirm Password',
                  ),
                  validator: (String value) {
                    if (value != _passwordController.text) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 7.5),
                child: new SizedBox(
                  width: 120,
                  height: 30,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        authService.registerWithEmail(
                            _emailController.text, _passwordController.text);
                      }
                    },
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
                    onPressed: () => Navigator.of(context).pop(),
                    textColor: Color(0xffFFC107),
                    color: const Color(0xff757575),
                    child: Text('Back'),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    super.dispose();
  }
}

