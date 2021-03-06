import 'package:eggate/screens/home/home_categories.dart';
import 'package:eggate/screens/home/home_main.dart';
import 'package:eggate/screens/home/home_profile.dart';
import 'package:eggate/screens/home/home_sale.dart';
import 'package:eggate/screens/home/home_shopping.dart';
import 'package:eggate/screens/search/SearchScreen.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/services/screen_animation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  final int tabIndex;
  HomeScreen({this.tabIndex = 0});
  static _Home of(BuildContext context) => context.findAncestorStateOfType();
  @override
  State<StatefulWidget> createState() {
    return _Home(tabIndex);
  }
}

class _Home extends State<HomeScreen> with SingleTickerProviderStateMixin {
  // functions for building data
  TabController tabController;
  int _itemCount = 0;
  var _tabs;
  List<Widget> _pages;
  int tabIndex = 0;

  _Home(this.tabIndex);

  @override
  void initState() {
    refreshScreen();
    _getTabs();
    tabController = TabController(length: _pages.length, vsync: this);

    super.initState();
    tabController.index = tabIndex;
  }

  void refreshScreen() {
    MagentoApi().getCartItems().then((items) {
      setState(() {
        _itemCount = items.length ?? 0;
        _getTabs();
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  _getTabs() {
    _tabs = <Widget>[
      Tab(
          icon: Icon(
            FontAwesomeIcons.home,
            size: 20,
          ),
          text: "Home"),
      Tab(
          icon: Icon(
            Icons.storage,
            size: 20,
          ),
          text: "Categories"),
      Tab(
          icon: Icon(
            Icons.local_offer,
            size: 20,
          ),
          text: "Sale"),
      Tab(
        icon: _itemCount > 0
            ? Stack(
                children: <Widget>[
                  Icon(Icons.shopping_cart),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: new Text(
                        _itemCount.toString(),
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              )
            : Icon(Icons.shopping_basket),
        text: "Cart",
      ),
      Tab(
          icon: Icon(
            FontAwesomeIcons.user,
            size: 20,
          ),
          text: "Profile"),
    ];
    // pages
    _pages = [
      HomeMain(),
      HomeCategories(),
      HomeSale(),
      HomeShopping(),
      HomeProfile(),
    ];
  }

  //  Drawing UI
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
                maxLines: 1,
                readOnly: true,
                onTap: () {
                  Navigator.of(context).push(
                      MyCustomRoute(builder: (q, w, e) => SearchScreen()));
                  print("Search clicked");
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  hintText: "I'm looking for",
                  hintStyle: TextStyle(color: Colors.white),
                  hintMaxLines: 1,
                  filled: true,
                ),
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        children: _pages,
        controller: tabController,
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          labelStyle: Theme.of(context).textTheme.body1.copyWith(
                fontSize: 10,
              ),
          tabs: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.black45,
          controller: tabController,
        ),
      ),
    );
  }
}
