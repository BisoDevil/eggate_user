import 'package:eggate/models/banner.dart';
import 'package:eggate/screens/home/home_sections/home_product_gallary.dart';
import 'package:eggate/screens/home/home_sections/home_slider.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

import 'home_sections/home_ads.dart';

class HomeMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  Future<HomePageStyle> _homePageStyle = MagentoApi().getHomePage();

  @override
  void initState() {
    MagentoApi().getHomePage().then((onValue) {
      print("Basem values ${onValue.toJson()}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// get images for Slider

    return FutureBuilder(
      future: _homePageStyle,
      builder: (context, snapshot) => !snapshot.hasData
          ? LoadingWidget()
          : ListView(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                HomeSectionSlider(
                  slides: (snapshot.data as HomePageStyle).slider,
                ),
                SizedBox(
                  height: 8,
                ),
                HomeProductGallary(),
                SizedBox(
                  height: 8,
                ),
                HomeAds(
                  ads: (snapshot.data as HomePageStyle).banner,
                ),
                SizedBox(
                  height: 4,
                ),
                for (var item in (snapshot.data as HomePageStyle).categoryList)
                  HomeProductGallary(
                    categoryList: item,
                  )
              ],
            ),
    );
  }
}
