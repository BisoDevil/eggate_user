import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _fullname = TextEditingController();
  var _mail = TextEditingController();
  var _password = TextEditingController();
  var _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.black45,
            ),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Full Name",
                          icon: Icon(FontAwesomeIcons.user),
                        ),
                        controller: _fullname,
                        onChanged: (String text) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "E-Mail",
                          icon: Icon(Icons.mail_outline),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: _mail,
                        onChanged: (String text) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Password",
                          icon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        controller: _password,
                        onChanged: (String text) {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          icon: Icon(Icons.lock),
                        ),
                        obscureText: true,
                        controller: _confirmPassword,
                        onChanged: (String text) {},
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.6,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Sigun up".toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
