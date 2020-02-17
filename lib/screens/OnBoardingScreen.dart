import 'package:eggate/screens/HomeScreen.dart';
import 'package:eggate/strings/lanaguage.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoardingScreen> {
  void _doneButtonClicked() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    var shared = await SharedPreferences.getInstance();
    shared.setBool("isFirst", true);
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      colorActiveDot: Colors.white,
      colorDot: Colors.white,
      listCustomTabs: <Widget>[
        Container(
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
          child: Center(
            heightFactor: 0.8,
            widthFactor: 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.85,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          "assets/images/intro_1.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, right: 32, left: 32, bottom: 8),
                        child: Text(
                          Languages.currentLocal.firstIntroTitle,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 32, right: 32, top: 4, bottom: 32),
                        child: Text(
                          Languages.currentLocal.firstIntroDescription,
                          style: Theme.of(context).textTheme.body1,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
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
          child: Center(
            heightFactor: 0.8,
            widthFactor: 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.85,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.asset(
                          "assets/images/intro_2.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                "assets/images/intro_3.png",
                fit: BoxFit.cover,
              ),
              Center(
                child: Text(
                  Languages.currentLocal.welcomeScreen,
                  style: Theme.of(context)
                      .textTheme
                      .display2
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
      onDonePress: this._doneButtonClicked,
      slides: [
        Slide(
          title: "What will you do?",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed d",
          pathImage: "assets/images/intro_1.png",
          colorBegin: Color(0xffb69876),
          centerWidget: Text("test center"),
          colorEnd: Color(0xffffc985),
          directionColorBegin: Alignment.topCenter,
          directionColorEnd: Alignment.bottomCenter,
        ),
        Slide(
          title: "What will you do?",
          description:
              "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed d",
          pathImage: "assets/images/intro_2.png",
          colorBegin: Color(0xffb69876),
          centerWidget: Text("test center"),
          colorEnd: Color(0xffffc985),
          directionColorBegin: Alignment.topCenter,
          directionColorEnd: Alignment.bottomCenter,
        ),
        Slide(
            styleDescription: Theme.of(context).textTheme.display3,
            description: "Welcome to EGGATE\nOnline Shop",
            backgroundImage: "assets/images/intro_3.png",
            backgroundImageFit: BoxFit.fill,
            backgroundOpacity: 0.1)
      ],
    );
  }
}
