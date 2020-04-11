import 'package:eggate/models/banner.dart';
import 'package:eggate/models/product.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/widgets/product_card.dart';
import 'package:flutter/material.dart';

import '../../ProductGridView.dart';

class HomeProductGallary extends StatelessWidget {
  final CategoryList categoryList;

  HomeProductGallary({this.categoryList});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: categoryList == null
          ? MagentoApi().getLastProducts(1)
          : MagentoApi().fetchProductsByCategory(categoryId: categoryList.id),
      initialData: [
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product(),
        Product()
      ],
      builder: (content, snapshot) => Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    categoryList != null ? categoryList.name : "New arrivals",
                    style: Theme.of(context).textTheme.title,
                  ),
                  FlatButton(
                    child: Text(
                      "See more",
                      style: ThemeData.light().textTheme.body1,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProductGridView("Category", categoryList.id);
                      }));
                    },
                  ),
                ],
              )),
          Container(
            height: 280,
            child: ListView.builder(
              itemCount: snapshot.hasData
                  ? (snapshot.data as List<Product>).length
                  : 0,
              padding: EdgeInsets.only(left: 8, right: 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
                  ProductCard(snapshot.data[index]),
            ),
          )
        ],
      ),
    );
  }
}
