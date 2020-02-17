import 'package:eggate/screens/OnBoardingScreen.dart';
import 'package:eggate/strings/lanaguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Splash();
  }
}

class _Splash extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      bool logged = sharedPreferences.getBool("isFirst") ?? false;
      String local = sharedPreferences.getString("local") ?? "en";
      Languages().getLocal(local);
      if (logged) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoardingScreen()),
        );
      }
    });

    return Container(
      child: Image.asset(
        "assets/images/splash_screen.png",
        fit: BoxFit.fill,
      ),
    );
  }
}
