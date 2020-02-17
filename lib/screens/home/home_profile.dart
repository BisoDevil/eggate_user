import 'package:eggate/models/user.dart';
import 'package:eggate/screens/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeProfile extends StatefulWidget {
  User user;
  HomeProfile();
  @override
  State<StatefulWidget> createState() => _HomeProfileState();
}

class _HomeProfileState extends State<HomeProfile> {
  @override
  void initState() {
    User().getUserLocal().then((usr) {
      setState(() {
        widget.user = usr;
      });
    });

    super.initState();
  }

  var wishListCount = 6;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          if (widget.user != null && widget.user.firstname != null)
            ListTile(
              leading: Icon(Icons.face),
              title: Text("${widget.user.firstname} ${widget.user.lastname}",
                  style: TextStyle(fontSize: 16)),
            ),
          if (widget.user != null && widget.user.email != null)
            ListTile(
              leading: Icon(Icons.email),
              title: Text(widget.user.email, style: TextStyle(fontSize: 16)),
            ),
          if (widget.user != null)
            Card(
              margin: EdgeInsets.only(bottom: 2.0),
              elevation: 0,
              child: ListTile(
                leading: Icon(
                  Icons.portrait,
                  size: 25,
                ),
                title: Text("Update user info", style: TextStyle(fontSize: 15)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                onTap: () {},
              ),
            ),
          if (widget.user == null)
            Card(
              margin: EdgeInsets.only(bottom: 2.0),
              elevation: 0,
              child: ListTile(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen())),
                leading: Icon(Icons.person),
                title: Text("Login", style: TextStyle(fontSize: 16)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ),
            ),
          if (widget.user != null)
            Card(
              margin: EdgeInsets.only(bottom: 2.0),
              elevation: 0,
              child: ListTile(
                onTap: () {
                  widget.user.logoutUser();

                  setState(() {
                    widget.user = null;
                  });
                },
                leading: Icon(Icons.exit_to_app),
                title: Text("Logout", style: TextStyle(fontSize: 16)),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ),
            ),
          SizedBox(height: 30.0),
          Text("General Setting",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 10.0),
          if (widget.user != null)
            Divider(
              color: Colors.black12,
              height: 1.0,
              indent: 75,
              //endIndent: 20,
            ),
          Card(
            margin: EdgeInsets.only(bottom: 2.0),
            elevation: 0,
            child: ListTile(
              leading: Icon(
                Icons.favorite_border,
                size: 26,
              ),
              title: Text("My wish list", style: TextStyle(fontSize: 15)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                if (wishListCount > 0)
                  Text(
                    "$wishListCount items",
                    style: TextStyle(
                        fontSize: 14, color: Theme.of(context).primaryColor),
                  ),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward_ios, size: 18)
              ]),
              onTap: () {
                // Navigator.pushNamed(context, "/wishlist");
              },
            ),
          ),
          Divider(
            color: Colors.black12,
            height: 1.0,
            indent: 75,
            //endIndent: 20,
          ),
          Divider(
            color: Colors.black12,
            height: 1.0,
            indent: 75,
            //endIndent: 20,
          ),
          Card(
            margin: EdgeInsets.only(bottom: 2.0),
            elevation: 0,
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => Language()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.language,
                  size: 24,
                ),
                title: Text("Language"),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.black12,
            height: 1.0,
            indent: 75,
            //endIndent: 20,
          ),
          Card(
            margin: EdgeInsets.only(bottom: 2.0),
            elevation: 0,
            child: ListTile(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => Currencies()));
              },
              leading: Icon(FontAwesomeIcons.dollarSign, size: 22),
              title: Text("Currencies", style: TextStyle(fontSize: 16)),
              trailing: Icon(Icons.arrow_forward_ios, size: 18),
            ),
          ),
          Divider(
            color: Colors.black12,
            height: 1.0,
            indent: 75,
            //endIndent: 20,
          ),
          SizedBox(height: 30.0),
          Text("Order details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 10.0),
          if (widget.user != null)
            GestureDetector(
              onTap: () {
                // Navigator.pushNamed(context, "/orders");
              },
              child: Card(
                margin: EdgeInsets.only(bottom: 2.0),
                elevation: 0,
                child: ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Theme.of(context).accentColor,
                    size: 24,
                  ),
                  title: Text("Order History", style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.grey),
                ),
              ),
            ),
          Divider(
            color: Colors.black12,
            height: 1.0,
            indent: 75,
            //endIndent: 20,
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
