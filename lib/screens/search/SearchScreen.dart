import 'package:eggate/models/product.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/widgets/product_card.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _currentPage = 1;
  String searchWord = "";
  bool isSearching = false;
  List<Product> products = [];

  void _search() {
    setState(() {
      isSearching = true;
    });
    MagentoApi()
        .searchProducts(name: searchWord, page: _currentPage)
        .then((values) {
      setState(() {
        products.addAll(values);
        isSearching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: TextField(
                autocorrect: true,
                style: TextStyle(color: Colors.white),
                maxLines: 1,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  hintText: "I'm looking for",
                  hintMaxLines: 1,
                  hintStyle: TextStyle(color: Colors.white),
                  filled: true,
                ),
                onChanged: (values) {
                  searchWord = values;
                  _search();
                },
              ),
            ),
          ),
        ),
      ),
      body: isSearching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : products.isEmpty
              ? Container()
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification sn) {
                    if (sn is ScrollUpdateNotification &&
                        sn.metrics.pixels == sn.metrics.maxScrollExtent) {
                      setState(() {
                        _currentPage++;
                        _search();
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
                    children: products.map((p) => ProductCard(p)).toList(),
                  ),
                ),
    );
  }
}
