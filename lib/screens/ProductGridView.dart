import 'package:eggate/models/Filters.dart';
import 'package:eggate/models/product.dart';
import 'package:eggate/screens/HomeScreen.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/widgets/FilterDrawer.dart';
import 'package:eggate/widgets/loading_widget.dart';
import 'package:eggate/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatefulWidget {
  final String catType;
  final int catId;
  static _ProductGridViewState of(BuildContext context) =>
      context.findAncestorStateOfType();
  ProductGridView(this.catType, this.catId);
  @override
  _ProductGridViewState createState() => _ProductGridViewState(catType, catId);
}

class _ProductGridViewState extends State<ProductGridView> {
  int _currentPage = 1;
  List<Product> products = [];
  List<Filters> filters = [];
  List<FilerValues> codes = [];
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<DropdownMenuItem> drops = [
    {"title": "Popularity", "value": null},
    {"title": "Price: High to Low", "value": "DESC"},
    {"title": "Price: Low to High", "value": "ASC"}
  ]
      .map((l) => DropdownMenuItem(
            child: Text(l["title"]),
            value: l["value"],
          ))
      .toList();
  String sortType;
  String _dataType;
  int typeId;

  _ProductGridViewState(this._dataType, this.typeId) {
    getProductByCategory();
    MagentoApi().getFilters(this.typeId).then((value) {
      setState(() {
        filters = value;
      });
    });
  }

  void getProductByCategory() {
    switch (_dataType) {
      case "Seller":
        MagentoApi()
            .fetchProductsByCategory(
                sellerID: typeId,
                page: _currentPage,
                orderBy: "price",
                filters: codes,
                order: sortType)
            .then((newData) {
          setState(() {
            products.addAll(newData);
            print("Basem product gridview setState fired ");
          });
        });
        break;
      case "Category":
        MagentoApi()
            .fetchProductsByCategory(
                categoryId: typeId,
                page: _currentPage,
                orderBy: "price",
                filters: codes,
                order: sortType)
            .then((newData) {
          setState(() {
            products.addAll(newData);
            print("Basem product gridview setState fired ");
          });
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            tabIndex: 3,
                          )));
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          )
        ],
        title: Text("EGGATE"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 45,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RawMaterialButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Filter"),
                        const SizedBox(width: 8.0),
                        Icon(Icons.sort),
                      ],
                    ),
                    onPressed: () {
                      _drawerKey.currentState.openEndDrawer();
                    },
                  ),
                ),
                Expanded(
                  child: DropdownButton(
                    underline: Container(),
                    hint: Text("Sort"),
                    value: sortType,
                    icon: Icon(Icons.swap_vert),
                    onChanged: (value) {
                      setState(() {
                        sortType = value;
                        products.clear();
                        getProductByCategory();
                      });
                    },
                    items: drops,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(
              child: LoadingWidget(),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification sn) {
                      if (sn is ScrollUpdateNotification &&
                          sn.metrics.pixels == sn.metrics.maxScrollExtent) {
                        setState(() {
                          _currentPage++;
                          getProductByCategory();
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
          ),
        ],
      ),
      endDrawer: FilterDrawer(filters),
    );
  }
}
