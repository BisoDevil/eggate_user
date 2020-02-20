import 'package:eggate/models/product.dart';
import 'package:eggate/screens/HomeScreen.dart';
import 'package:eggate/screens/checkout/address/AddressScreen.dart';
import 'package:eggate/screens/login/Login.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/services/screen_animation.dart';
import 'package:flutter/material.dart';

class HomeShopping extends StatefulWidget {
  @override
  _HomeShoppingState createState() => _HomeShoppingState();
}

class CartModel {
  Product product;
  int quantity;

  CartModel({this.product, this.quantity});
}

class _HomeShoppingState extends State<HomeShopping> {
  List<CartModel> cartModels = [];
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void goToCheckOut() {
    MagentoApi().addToCart().catchError((err) {
      _drawerKey.currentState.showSnackBar(SnackBar(
        content: Text(/*"You are not logged in"*/ err.toString()),
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: "Login",
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context)
                .push(MyCustomRoute(builder: (c, s, f) => LoginScreen()));
          },
        ),
      ));
    }).then((value) {
      print("Basem Futer comes with $value");
      if (value != null && value == true)
        Navigator.of(context).push(MyCustomRoute(
            builder: (c, e, r) => AddressScreen(
                  fromCheckOut: true,
                )));
    });
  }

  @override
  void initState() {
    getItemFromCart();
    super.initState();
  }

  void getItemFromCart() {
    cartModels.clear();
    MagentoApi().getCartItems().then((items) {
      setState(() {
        items.forEach((f) {
          cartModels.add(CartModel(
              quantity: f["quantity"],
              product: Product.fromJson(f["product"])));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Colors.white,
      body: cartModels.length > 0
          ? Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        for (var item in cartModels)
                          Container(
                            height: 145,
                            child: Card(
                              child: ListTile(
                                  isThreeLine: true,
                                  leading: Stack(
                                    children: <Widget>[
                                      Image.network(
                                        item.product.mediaGalleryEntries.first
                                            .file
                                            .replaceFirst(
                                                "https://eggate.shop/pub/media/catalog/product",
                                                ""),
                                        height: 120,
                                        width: 100,
                                        fit: BoxFit.fitHeight,
                                      ),
                                      item.product.extensionAttributes
                                                      .discountPercentage !=
                                                  null &&
                                              item.product.extensionAttributes
                                                      .discountPercentage >
                                                  0.0
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 20,
                                              ),
                                              child: Text(
                                                " ${item.product.extensionAttributes.discountPercentage}% ",
                                                style: TextStyle(
                                                    backgroundColor: Colors.red,
                                                    color: Colors.white),
                                                maxLines: 1,
                                              ),
                                            )
                                          : Container(
                                              width: 1,
                                            )
                                    ],
                                  ),
                                  title: Text(
                                    item.product.name,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: FloatingActionButton(
                                    heroTag: item.product.id,
                                    onPressed: () {
                                      setState(() {
                                        MagentoApi().deleteFromCartLocal(
                                            product: item.product);
                                        getItemFromCart();
                                      });
                                    },
                                    mini: true,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
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
                                                item.quantity--;
                                              });
                                            },
                                            icon: Icon(
                                                Icons.remove_circle_outline),
                                          ),
                                          Container(
                                            width: 10,
                                            child: Text(
                                              item.quantity.toString(),
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
                                                item.quantity++;
                                              });
                                            },
                                            icon:
                                                Icon(Icons.add_circle_outline),
                                          ),
                                        ],
                                      ),
                                      if (item.product.price !=
                                          item.product.extensionAttributes
                                              .discountedPrice)
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "${item.product.price} EGP",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            "${item.product.extensionAttributes.discountedPrice} EGP",
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
                  minWidth: MediaQuery.of(context).size.width,
                  height: 55,
                  color: Theme.of(context).primaryColor,
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
