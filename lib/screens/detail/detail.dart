import 'package:carousel_pro/carousel_pro.dart';

import 'package:eggate/models/product.dart';
import 'package:eggate/screens/detail/detai_description.dart';
import 'package:eggate/screens/detail/detail_review.dart';
import 'package:eggate/screens/detail/detail_title.dart';
import 'package:eggate/screens/detail/related_product.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product _product;
  ProductDetailScreen(this._product) {
    print("Basem product is ${_product.toJson()}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_product.name),
        centerTitle: false,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 350,
            width: double.infinity,
            child: Carousel(
              images: List.generate(
                _product.mediaGalleryEntries.length,
                (i) => Image.network(
                  _product.mediaGalleryEntries[i].file,
                  fit: BoxFit.cover,
                ),
              ),
              autoplay: false,
              dotSize: 5.0,
              dotSpacing: 15.0,
              dotColor: Theme.of(context).backgroundColor.withOpacity(0.7),
              dotIncreasedColor:
                  Theme.of(context).primaryColor.withOpacity(0.9),
              indicatorBgPadding: 5.0,
              dotBgColor: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductTitle(_product),
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
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductDescription(_product),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProductReview(_product),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RelatedProduct(_product),
          ),
        ],
      ),
    );
  }
}
