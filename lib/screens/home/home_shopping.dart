import 'package:eggate/models/product.dart';
import 'package:eggate/screens/HomeScreen.dart';

import 'package:flutter/material.dart';

class HomeShopping extends StatefulWidget {
  @override
  _HomeShoppingState createState() => _HomeShoppingState();
}

class _HomeShoppingState extends State<HomeShopping> {
  List<Product> products = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: products.length > 0
          ? SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (var item in products)
                    ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.price.toString()),
                      leading:
                          Image.network(item.mediaGalleryEntries.first.file),
                      trailing: Text("3"),
                    )
                ],
              ),
            )
          : Padding(
              child: Column(
                children: <Widget>[
                  EmptyCart(),
                  MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * .8,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      HomeScreen.of(context).tabController.animateTo(0);
                    },
                    child: Text(
                      "Start Shopping".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.20,
              ),
            ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Container(
          width:
              screenSize.width / (2 / (screenSize.height / screenSize.width)),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 60),
                  Text("Your bag is empty",
                      style: TextStyle(
                        fontSize: 28,
                      ),
                      textAlign: TextAlign.center),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                        "Looks like you haven’t added any items to the bag yet. Start shopping to fill it in.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 50)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
