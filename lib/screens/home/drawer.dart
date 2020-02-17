import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StartDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffb69876),
              Color(0xffffc985),
            ],
            stops: [0, 1],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            Spacer(),
            ListTile(
              title: Text(
                "Home",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.white),
              ),
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text(
                "Category",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.white),
              ),
              leading: Icon(
                Icons.category,
                color: Colors.white,
              ),
              trailing: Icon(
                Icons.arrow_right,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text(
                "Notification",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.white),
              ),
              leading: Icon(
                Icons.notifications_active,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text(
                "Favourites",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.white),
              ),
              leading: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text(
                "Cart",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.white),
              ),
              leading: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text(
                "Logout",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.white),
              ),
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 60, top: 120),
              height: 90,
              child: ListTile(
                leading: CircleAvatar(
                  radius: 23,
                  child: Icon(
                    FontAwesomeIcons.userAlt,
                    color: Colors.black45,
                  ),
                  backgroundColor: Colors.white,
                ),
                title: Text(
                  "Basem adbuallah",
                  style: Theme.of(context).textTheme.body1.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                ),
                subtitle: Text(
                  "babdallah@eggate.com",
                  style: Theme.of(context).textTheme.body1.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                ),
                trailing: Icon(
                  Icons.settings,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
