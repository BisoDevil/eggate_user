import 'package:eggate/models/product.dart';
import 'package:eggate/screens/HomeScreen.dart';
import 'package:eggate/screens/detail/detail.dart';
import 'package:eggate/services/magento.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product _product;
  ProductCard(this._product) {
    // print("Basem product is ${_product.sku}");
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(_product)));
      },
      child: Container(
        margin: EdgeInsets.all(2),
        width: 170,
        height: 280,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 2,
          child: _product.id == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.network(
                            _product.mediaGalleryEntries.first.file,
                            fit: BoxFit.fill,
                          ),
                          _product.extensionAttributes.discountPercentage !=
                                      null &&
                                  _product.extensionAttributes
                                          .discountPercentage >
                                      0.0
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                  ),
                                  child: Text(
                                    " ${_product.extensionAttributes.discountPercentage}% ",
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
                          _product.name,
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
                          if (_product.price !=
                              _product.extensionAttributes.discountedPrice)
                            Text(
                              "${_product.price} EGP",
                              style: Theme.of(context).textTheme.body1.copyWith(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          Text(
                            "${_product.extensionAttributes.discountedPrice} EGP",
                            style: Theme.of(context).textTheme.body1.copyWith(
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
                                MagentoApi().saveCartToLocal(product: _product);
                                HomeScreen.of(context).refreshScreen();
                                print("Basem button pressed ${_product.id}");
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
                              print("Basem button fav pressed ${_product.sku}");
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
