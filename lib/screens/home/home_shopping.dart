import 'package:eggate/models/cart.dart';
import 'package:eggate/screens/HomeScreen.dart';
import 'package:eggate/screens/checkout/address/AddressScreen.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/services/screen_animation.dart';
import 'package:eggate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class HomeShopping extends StatefulWidget {
  @override
  _HomeShoppingState createState() => _HomeShoppingState();
}

class _HomeShoppingState extends State<HomeShopping> {
  List<Cart> carts;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void goToCheckOut() {
    Navigator.of(context).push(MyCustomRoute(
        builder: (c, e, r) => AddressScreen(
              fromCheckOut: true,
            )));
//    MagentoApi().addToCart().catchError((err) {
//      _drawerKey.currentState.showSnackBar(SnackBar(
//        content: Text(/*"You are not logged in"*/ err.toString()),
//        duration: Duration(seconds: 5),
//        action: SnackBarAction(
//          label: "Login",
//          textColor: Theme.of(context).primaryColor,
//          onPressed: () {
//            Navigator.of(context)
//                .push(MyCustomRoute(builder: (c, s, f) => LoginScreen()));
//          },
//        ),
//      ));
//    }).then((value) {
//      print("Basem Futer comes with $value");
//      if (value != null && value == true)
//
//    });
  }

  @override
  void initState() {
    getItemFromCart();
    super.initState();
  }

  void getItemFromCart() {
    MagentoApi().getCartItems().then((items) {
      if (items != null)
        setState(() {
          carts = items;
          print("Carts count is ${carts.length}");
        });
    });
  }

  void deleteItemFromCart({int id}) {
    MagentoApi().deleteFromCart(itemId: id).then((value) {
      if (value != null && value == true) {
        setState(() {
          getItemFromCart();
          HomeScreen.of(context).refreshScreen();
        });
      }
    });
  }

  void updateItemQuantity({int idx, bool adding}) {
    var oldQty = carts[idx].qty;
    carts[idx].qty = adding ? ++carts[idx].qty : --carts[idx].qty;
    MagentoApi().updateItemFromCart(cart: carts[idx]).catchError((err) {
      setState(() {
        carts[idx].qty = oldQty;
      });
      _drawerKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    }).then((value) {
      if (value != null) {
        setState(() {
          getItemFromCart();
          HomeScreen.of(context).refreshScreen();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Colors.white,
      body: carts == null
          ? LoadingWidget()
          : carts.length > 0
          ? Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  for (var i = 0; i < carts.length; i++)
                    Container(
                      height: 145,
                      child: Card(
                        child: ListTile(
                            isThreeLine: true,
                            leading: Stack(
                              children: <Widget>[
                                Image.network(
                                  carts[i].extensionAttributes.image,
                                  height: 120,
                                  width: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              ],
                            ),
                            title: Text(
                              carts[i].name,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: FloatingActionButton(
                              heroTag: carts[i].itemId,
                              onPressed: () {
                                deleteItemFromCart(
                                    id: carts[i].itemId);
                              },
                              mini: true,
                              backgroundColor:
                              Theme
                                  .of(context)
                                  .primaryColor,
                              child: Icon(Icons.delete),
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "QTY:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      iconSize: 22,
                                      onPressed: () {
                                        setState(() {
                                          updateItemQuantity(
                                              idx: i, adding: false);
                                        });
                                      },
                                      icon: Icon(Icons
                                          .remove_circle_outline),
                                    ),
                                    Container(
                                      width: 10,
                                      child: Text(
                                        carts[i].qty.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      iconSize: 22,
                                      onPressed: () {
                                        setState(() {
                                          updateItemQuantity(
                                              idx: i, adding: true);
                                        });
                                      },
                                      icon: Icon(
                                          Icons.add_circle_outline),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "${carts[i].price} EGP",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ),
                    ),
                ],
              ),
            ),
          ),
          MaterialButton(
            child: Text(
              "Checkout".toUpperCase(),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            minWidth: MediaQuery
                .of(context)
                .size
                .width,
            height: 55,
            color: Theme
                .of(context)
                .primaryColor,
            onPressed: () {
              goToCheckOut();
            },
          )
        ],
      )
          : Padding(
        child: Column(
          children: <Widget>[
            EmptyCart(),
            MaterialButton(
              minWidth: MediaQuery
                  .of(context)
                  .size
                  .width * .8,
              color: Theme
                  .of(context)
                  .primaryColor,
              onPressed: () {
                HomeScreen
                    .of(context)
                    .tabController
                    .animateTo(0);
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
          top: MediaQuery
              .of(context)
              .size
              .height * 0.20,
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
