import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:eggate/models/user.dart';
import 'package:eggate/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'home/home_profile.dart';

class UpdateUserScreen extends StatefulWidget {
  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  User user;
  bool canEdit = false;
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _birth = TextEditingController();

  @override
  void initState() {
    User().getUserLocal().then((value) {
      if (!mounted) return;
      setState(() {
        user = value;
        _firstName.text = user.firstname;
        _lastName.text = user.lastname;
        _birth.text = user.dob;
      });
    });
    super.initState();
  }

  void saveUser() {
    if (!mounted) return;
    setState(() {
      user.firstname = _firstName.text;
      user.lastname = _lastName.text;
      user.dob = _birth.text;
      user.saveUserLocal(user);
      HomeProfile.of(context).loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile info".toUpperCase(),
        ),
      ),
      body: user == null
          ? LoadingWidget()
          : Column(
              children: <Widget>[
                Card(
                  elevation: 0.1,
                  child: ListTile(
                    title: Text(
                      "${user.firstname} ${user.lastname}",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(user.email),
                  ),
                ),
                Card(
                  elevation: 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "General information".toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            FlatButton(
                              child: canEdit
                                  ? Text(
                                      "cancel".toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    )
                                  : Text(
                                      "Edit".toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    ),
                              onPressed: () {
                                setState(() {
                                  canEdit = !canEdit;
                                });
                              },
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextFormField(
                            controller: _firstName,
                            decoration:
                                InputDecoration(labelText: "First Name"),
                            enabled: canEdit,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextFormField(
                            controller: _lastName,
                            decoration: InputDecoration(labelText: "Last Name"),
                            enabled: canEdit,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: DropdownButtonFormField(
                            items: [
                              DropdownMenuItem(
                                child: Text("Male"),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text("Female"),
                                value: 2,
                              )
                            ],
                            onChanged: (v) {
                              setState(() {
                                user.gender = v;
                              });
                            },
                            value: user.gender ?? 0,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Birth date".toUpperCase(),
                              ),
                              DateTimeField(
                                enabled: canEdit,
                                controller: _birth,
                                format: DateFormat("yyyy-MM-dd"),
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate:
                                          currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                              ),
                              SizedBox(
                                height: 24,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Save".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    saveUser();
                  },
                )
              ],
            ),
    );
  }
}
