import 'package:carousel_pro/carousel_pro.dart';
import 'package:eggate/models/product.dart';
import 'package:eggate/models/user.dart';
import 'package:eggate/screens/detail/detai_description.dart';
import 'package:eggate/screens/detail/detail_review.dart';
import 'package:eggate/screens/detail/detail_title.dart';
import 'package:eggate/screens/detail/related_product.dart';
import 'package:eggate/screens/login/Login.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/services/screen_animation.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product _product;

  ProductDetailScreen(this._product) {
    print("Basem product is ${_product.toJson()}");
  }

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void saveToCart() async {
    var user = await User().getUserLocal();
    if (user == null) {
      Navigator.of(context)
          .push(MyCustomRoute(builder: (q, w, e) => LoginScreen()));
      return;
    }
    MagentoApi().addToCart(product: widget._product).catchError((err) {
      _drawerKey.currentState.showSnackBar(SnackBar(
        content: Text(err.toString()),
      ));
    }).then((value) {
      if (value != null && value == true) {
        _drawerKey.currentState.showSnackBar(SnackBar(
          content: Text("Item Added"),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget._product.name),
        centerTitle: false,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 350,
            width: double.infinity,
            child: Carousel(
              images: List.generate(
                widget._product.mediaGalleryEntries.length,
                    (i) =>
                    Image.network(
                      widget._product.mediaGalleryEntries[i].file,
                      fit: BoxFit.cover,
                    ),
              ),
              autoplay: false,
              dotSize: 5.0,
              dotSpacing: 15.0,
              dotColor: Theme
                  .of(context)
                  .backgroundColor
                  .withOpacity(0.7),
              dotIncreasedColor:
              Theme
                  .of(context)
                  .primaryColor
                  .withOpacity(0.9),
              indicatorBgPadding: 5.0,
              dotBgColor: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductTitle(widget._product),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 30,
              right: 30,
            ),
            child: MaterialButton(
              height: 43,
              child: Text(
                "Add to cart",
                style: Theme
                    .of(context)
                    .textTheme
                    .title
                    .copyWith(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              color: Theme
                  .of(context)
                  .primaryColor,
              onPressed: () {
                saveToCart();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductDescription(widget._product),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductReview(widget._product),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RelatedProduct(widget._product),
          ),
        ],
      ),
    );
  }
}
