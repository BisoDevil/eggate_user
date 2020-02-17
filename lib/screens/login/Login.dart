import 'package:eggate/screens/register/Register.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/services/screen_animation.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _txtMail = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isMail;
  bool validPassword = false;
  bool isLoading = false;

  void checkMail(String text) {
    setState(() {
      isMail = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
          .hasMatch(text);
    });
  }

  void checkPassword(String text) {
    setState(() {
      validPassword = text.length > 8;
    });
  }

  void loginUser() {
    setState(() {
      isLoading = true;
    });
    String username = _txtMail.text;
    String password = _txtPassword.text;

    MagentoApi().loginCustomer(username, password).then((value) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Form(
              key: _formKey,
              child: Container(
                height: 350,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "E-Mail",
                        icon: Icon(Icons.mail),
                        suffixIcon: isMail == null
                            ? Container(
                          width: 24,
                        )
                            : isMail
                            ? Icon(Icons.check)
                            : Icon(Icons.error_outline),
                      ),
                      controller: _txtMail,
                      onChanged: (String text) {
                        checkMail(text);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(Icons.lock),
                        suffixIcon: validPassword == null
                            ? Container(
                          width: 24,
                        )
                            : validPassword
                            ? Icon(Icons.check)
                            : Icon(Icons.error_outline),
                      ),
                      obscureText: true,
                      onChanged: (String text) {
                        checkPassword(text);
                      },
                      controller: _txtPassword,
                    ),
                    SizedBox(height: 40),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width * 0.6,
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Login".toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        loginUser();
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(
                          "Forget password ?",
                        ),
                        onPressed: () {},
                      ),
                    ),
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height - 75,
            child: Container(
              child: Center(
                child: FlatButton(
                  textColor: Theme
                      .of(context)
                      .primaryColor,
                  child: Text(
                    "I'm a new user",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MyCustomRoute(
                        builder: (BuildContext context, d, s) =>
                            RegisterScreen()));
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
