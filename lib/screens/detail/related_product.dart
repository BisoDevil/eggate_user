import 'package:async/async.dart';
import 'package:eggate/models/product.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/widgets/product_card.dart';
import 'package:flutter/material.dart';

class RelatedProduct extends StatelessWidget {
  final Product product;
  final _memoizer = AsyncMemoizer<List<Product>>();

  RelatedProduct(this.product) {
    var cat = product.customAttributes
        .firstWhere((c) => c.attributeCode == "category_ids")
        .value;

    print("Basem category id is ${(cat as List).first}");
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Product>> getRelativeProducts() {
      var cat = product.customAttributes
          .firstWhere((c) => c.attributeCode == "category_ids")
          .value;
      return _memoizer.runOnce(() {
        return MagentoApi()
            .fetchProductsByCategory(categoryId: (cat as List).first);
      });
    }

    return LayoutBuilder(
      builder: (context, constraint) {
        return FutureBuilder<List<Product>>(
          future: getRelativeProducts(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Container(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                  );
                } else if (snapshot.data.length == 0) {
                  return Container();
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text(
                          "You might also like",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                          height: constraint.maxWidth * 0.6,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (var item in snapshot.data)
                                if (item.id != product.id) ProductCard(item)
                            ],
                          ))
                    ],
                  );
                }
            }
            return Container(); // unreachable
          },
        );
      },
    );
  }
}
