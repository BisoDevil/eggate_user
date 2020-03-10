import 'package:cached_network_image/cached_network_image.dart';
import 'package:eggate/models/product.dart';
import 'package:eggate/models/user.dart';
import 'package:eggate/screens/HomeScreen.dart';
import 'package:eggate/screens/detail/detail.dart';
import 'package:eggate/screens/login/Login.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/services/screen_animation.dart';
import 'package:flutter/material.dart';

import 'loading_widget.dart';

class ProductCard extends StatefulWidget {
  final Product _product;

  ProductCard(this._product) {
    // print("Basem product is ${_product.sku}");
  }

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  void _saveToCart() async {
    var user = await User().getUserLocal();
    if (user == null) {
      Navigator.of(context)
          .push(MyCustomRoute(builder: (q, w, e) => LoginScreen()));
      return;
    }
    MagentoApi().addToCart(product: widget._product).catchError((err) {
      showSnack(text: "You need to login");
    }).then((value) {
      if (value != null && value == true) {
        showSnack(text: "Item Added");
        MagentoApi().getCartItems().then((item) {
          HomeScreen.of(context).refreshScreen();
        });
      }
    });

    print("Basem button pressed ${widget._product.id}");
  }

  void showSnack({String text}) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
          onPressed: () {
            Navigator.of(context)
                .push(MyCustomRoute(builder: (q, w, e) => LoginScreen()));
          },
          label: "Login",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(widget._product)));
      },
      child: AspectRatio(
        aspectRatio: 9 / 13.5,
        child: Container(
          margin: EdgeInsets.all(2),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 1,
            child: widget._product.id == null
                ? Center(
                    child: LoadingWidget(),
                  )
                : Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: widget
                                  ._product.mediaGalleryEntries.first.file,
                              fit: BoxFit.fill,
                              placeholder: (q, w) => LoadingWidget(),
                              placeholderFadeInDuration:
                                  Duration(milliseconds: 300),
                            ),
                            widget._product.extensionAttributes
                                            .discountPercentage !=
                                        null &&
                                    widget._product.extensionAttributes
                                            .discountPercentage >
                                        0.0
                          ? Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Text(
                          " ${widget._product.extensionAttributes.discountPercentage}% ",
                          style: ThemeData.light()
                              .textTheme
                              .body1
                              .copyWith(
                            backgroundColor: Colors.red,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget._product.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    left: 8,
                  ),
                  child: Column(
                    children: <Widget>[
                      if (widget._product.price !=
                          widget._product.extensionAttributes
                              .discountedPrice)
                        Text(
                          "${widget._product.price} ${MagentoApi.currency}",
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(
                              fontSize: 12,
                              color: Colors.black54,
                              decoration: TextDecoration.lineThrough),
                        ),
                      Text(
                        "${widget._product.extensionAttributes
                            .discountedPrice} ${MagentoApi.currency}",
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1
                            .copyWith(
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          onPressed: () {
                            _saveToCart();
                          },
                          child: Text(
                            "Add to cart",
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(
                                fontSize: 12, color: Colors.white),
                          ),
                          height: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        iconSize: 20,
                        icon: Icon(
                          Icons.favorite_border,
                        ),
                        onPressed: () {
                          print(
                              "Basem button fav pressed ${widget._product.sku}");
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
