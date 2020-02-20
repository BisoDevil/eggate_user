import 'package:eggate/services/magento.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var _firstName = TextEditingController();
  var _lastName = TextEditingController();
  var _mail = TextEditingController();
  var _password = TextEditingController();
  var _confirmPassword = TextEditingController();
  bool isLoading = false;
  bool isFirstValid = false;
  bool isLastValid = false;
  bool isMailValid = false;
  bool isPasswordValid = false;
  bool isConfirmValid = false;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  bool isValid() {
    if (_firstName.text.isEmpty) {
      showSnackError(text: "First name is required");
      return false;
    }
    if (_lastName.text.isEmpty) {
      showSnackError(text: "Last name is required");
      return false;
    }
    if (_mail.text.isEmpty) {
      showSnackError(text: "E-mail is required");
      return false;
    }
    if (_password.text.isEmpty) {
      showSnackError(text: "Password is required");
      return false;
    }

    if (_password.text != _confirmPassword.text) {
      showSnackError(text: "Confirm password doesn't match ");
      return false;
    }
    if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(_mail.text)) {
      showSnackError(text: "E-Mail is invalid");
      return false;
    }

    if (_password.text.length < 8 &&
        !RegExp(r'[a-zA-Z0-9]+').hasMatch(_password.text)) {
      showSnackError(
          text:
              "Password must contain at least on capital character and numbers ");
      return false;
    }
    return true;
  }

  void showSnackError({String text}) {
    final snack = SnackBar(
      duration: Duration(seconds: 3),
      content: Text(text),
    );
    _drawerKey.currentState.showSnackBar(snack);
  }

  void createUser() async {
    if (!isValid()) {
      print("Basem ${isValid()}");

      return;
    }
    try {
      setState(() {
        isLoading = true;
      });

      MagentoApi()
          .createUser(
              firstName: _firstName.text,
              lastName: _lastName.text,
              username: _mail.text,
              password: _password.text)
          .catchError((err) {
        setState(() {
          isLoading = false;
        });

        showSnackError(text: err.toString().replaceAll("Exception:", ""));
      }).then((u) {
        if (u != null) {
          Navigator.of(context).pop();
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
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
                      Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.fitWidth,
                        height: 130,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "First name",
                            icon: Icon(FontAwesomeIcons.user),
                            suffixIcon:
                            isFirstValid ? Icon(Icons.check) : null),
                        controller: _firstName,
                        onChanged: (String text) {
                          setState(() {
                            isFirstValid = _firstName.text.isNotEmpty;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Last  name",
                            icon: Icon(FontAwesomeIcons.user),
                            suffixIcon: isLastValid ? Icon(Icons.check) : null),
                        controller: _lastName,
                        onChanged: (String text) {
                          setState(() {
                            isLastValid = _lastName.text.isNotEmpty;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "E-Mail",
                            icon: Icon(Icons.mail_outline),
                            suffixIcon: isMailValid ? Icon(Icons.check) : null),
                        keyboardType: TextInputType.emailAddress,
                        controller: _mail,
                        onChanged: (String text) {
                          setState(() {
                            isMailValid = RegExp(
                                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                .hasMatch(_mail.text);
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Password",
                            icon: Icon(Icons.lock),
                            suffixIcon:
                            isPasswordValid ? Icon(Icons.check) : null),
                        obscureText: true,
                        controller: _password,
                        onChanged: (String text) {
                          setState(() {
                            isPasswordValid =
                                RegExp(r'[a-zA-Z0-9]+', multiLine: false)
                                    .hasMatch(_password.text) &&
                                    _password.text.length >= 8;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Confirm Password",
                            icon: Icon(Icons.lock),
                            suffixIcon:
                            isConfirmValid ? Icon(Icons.check) : null),
                        obscureText: true,
                        controller: _confirmPassword,
                        onChanged: (String text) {
                          setState(() {
                            isConfirmValid =
                                _password.text == _confirmPassword.text;
                          });
                        },
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      MaterialButton(
                        minWidth: MediaQuery
                            .of(context)
                            .size
                            .width * 0.6,
                        color: Theme
                            .of(context)
                            .primaryColor,
                        child: Text(
                          "Sigun up".toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          createUser();
                        },
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      if (isLoading) CircularProgressIndicator()
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
