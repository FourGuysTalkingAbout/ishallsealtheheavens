import 'package:flutter/material.dart';
import 'logic/login_authProvider.dart';

class LoginWithEmail extends StatefulWidget {
  @override
  _LoginWithEmailState createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                margin: EdgeInsets.symmetric(
                    horizontal: 90, vertical: 7.5),
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
                margin: EdgeInsets.symmetric(
                    horizontal: 90, vertical: 7.5),
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
                margin: EdgeInsets.symmetric(vertical: 7.5),
                child: new SizedBox(
                  width: 120,
                  height: 30,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        authService.signInWithEmail(
                            _emailController.text,
                            _passwordController.text);
                      }
                    },
                    textColor: Color(0xffFFC107),
                    color: const Color(0xff757575),
                    child: Text('Log In'),
                  ),
                ),
              ),
              EmailForm()
            ],
          ),
        ),
      )
    );
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class EmailForm extends StatefulWidget {
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {

  @override
  Widget build(BuildContext context) {
    return ListBody( //changed this to column allows better control
      children: <Widget>[
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
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 7.5),
          child: MaterialButton(
            onPressed: () => Navigator.of(context).pushNamed('/'),
            textColor: Color(0xffFFC107),
            child: Text('Forgot Password?'),
          ),
        ),
      ],
    );
  }
}
