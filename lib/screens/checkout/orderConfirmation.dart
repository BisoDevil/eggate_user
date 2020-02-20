import 'package:eggate/screens/HomeScreen.dart';
import 'package:eggate/services/screen_animation.dart';
import 'package:flutter/material.dart';

class OrderConfirmation extends StatefulWidget {
  final int orderId;

  OrderConfirmation({@required this.orderId});

  @override
  _OrderConfirmationState createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  void goToHome() {
    Navigator.of(context).pushReplacement(MyCustomRoute(
      builder: (q, w, e) => HomeScreen(
        tabIndex: 0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/delivery.png",
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width * 0.50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Your order is on the way, will be delivered to you shortly, Thank you for shopping with us.",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      "continue shippong".toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      goToHome();
                    },
                    height: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  FlatButton(
                    child: Text("track your order".toUpperCase()),
                    onPressed: () {},
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
