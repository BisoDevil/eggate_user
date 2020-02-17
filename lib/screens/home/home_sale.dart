import 'package:eggate/models/product.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomeSale extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeSalesState();
  }
}

class _HomeSalesState extends State<HomeSale> {
  int _currentPage = 1;
  List<Product> _products = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    MagentoApi()
        .fetchProductsByCategory(
      categoryId: 50,
      page: _currentPage,
      orderBy: "price",
    )
        .then((newData) {
      setState(() {
        _products.addAll(newData);
        print("Basem product count is ${_products.length}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _products.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification sn) {
              if (sn is ScrollUpdateNotification &&
                  sn.metrics.pixels == sn.metrics.maxScrollExtent) {
                setState(() {
                  _currentPage++;
                  getData();
                  print("Basem count added");
                });
              }
              return true;
            },
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              childAspectRatio: 9 / 14,
              padding: EdgeInsets.symmetric(horizontal: 8),
              children: _products.map((p) => ProductCard(p)).toList(),
            ),
          );
  }
}
