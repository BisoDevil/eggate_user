import 'package:eggate/models/category.dart';
import 'package:eggate/screens/ProductGridView.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class HomeCategories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  Future<List<Category>> _mainCategories = MagentoApi().getCategories();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _mainCategories,
      builder: (BuildContext context, AsyncSnapshot snapshot) => !snapshot
              .hasData
          ? Center(
              child: LoadingWidget(),
            )
          : ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductGridView(
                              "Category", snapshot.data[index].id)));
                  print("Basem category id is ${snapshot.data[index].id}");
                },
                child: Container(
                  height: 220,
                  width: double.infinity,
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.all(8),
                    child: Image.network(
                      snapshot.data[index].image,
                      alignment: Alignment.center,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
