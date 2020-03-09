import 'package:carousel_slider/carousel_slider.dart';
import 'package:eggate/models/banner.dart';
import 'package:eggate/models/product.dart';
import 'package:eggate/screens/ProductGridView.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/widgets/loading_widget.dart';
import 'package:eggate/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomeMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  Future<List<AppBanner>> bannerImages = MagentoApi().getSliderImages();
  Future<List<AppBanner>> dealsImages = MagentoApi().getDeals();
  Future<List<Product>> products = MagentoApi().getLastProducts(1);

  Future<List<Product>> replicas =
      MagentoApi().fetchProductsByCategory(categoryId: 137);
  Future<List<Product>> deals =
      MagentoApi().fetchProductsByCategory(categoryId: 50);
  @override
  Widget build(BuildContext context) {
// get images for Slider

    return ListView(
      padding: EdgeInsets.only(
        top: 12,
      ),
      children: <Widget>[
        // bannder
        FutureBuilder(
          future: bannerImages,
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              CarouselSlider(
            enableInfiniteScroll: true,
            enlargeCenterPage: true,
            autoPlay: true,
            pauseAutoPlayOnTouch: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(seconds: 2),
            autoPlayInterval: Duration(seconds: 5),
            items: List.generate(
              snapshot.hasData ? (snapshot.data as List<AppBanner>).length : 3,
              (i) => GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    AppBanner appBanner = (snapshot.data as List<AppBanner>)[i];
                    return ProductGridView(appBanner.type, appBanner.id);
                  }));
                  debugPrint("Clicked ");
                },
                child: Card(
                  elevation: 3,
                  color: Colors.white,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        style: BorderStyle.none,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: snapshot.hasData
                      ? Image.network(
                    (snapshot.data as List<AppBanner>)[i].image,
                          fit: BoxFit.fitWidth,
                        )
                      : Center(
                    child: LoadingWidget(),
                        ),
                ),
              ),
            ),
          ),
        ),
        // Deals section
        FutureBuilder(
          future: dealsImages,
          builder: (BuildContext context, AsyncSnapshot snapshot) => Wrap(
            spacing: 4,
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: snapshot.hasData
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                AppBanner appBanner =
                                    (snapshot.data as List<AppBanner>)[0];
                                return ProductGridView(
                                    appBanner.type, appBanner.id);
                              }));
                              debugPrint("Clicked ");
                            },
                            child: Image.network(
                              (snapshot.data as List<AppBanner>)[0].image,
                              fit: BoxFit.fitWidth,
                              height: MediaQuery.of(context).size.height * 0.28,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.topCenter,
                            ),
                          )
                        : Container(
                            height: 180,
                            child: Center(
                              child: LoadingWidget(),
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: snapshot.hasData
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        AppBanner appBanner = (snapshot.data
                                            as List<AppBanner>)[1];
                                        return ProductGridView(
                                            appBanner.type, appBanner.id);
                                      }));
                                      debugPrint("Clicked ");
                                    },
                                    child: Image.network(
                                      (snapshot.data as List<AppBanner>)[1]
                                          .image,
                                      fit: BoxFit.fill,
                                      scale: 0.8,
                                    ),
                                  )
                                : Container(
                                    height: 120,
                                    child: Center(
                                      child: LoadingWidget(),
                                    )),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: snapshot.hasData
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        AppBanner appBanner = (snapshot.data
                                            as List<AppBanner>)[2];
                                        return ProductGridView(
                                            appBanner.type, appBanner.id);
                                      }));
                                      debugPrint("Clicked ");
                                    },
                                    child: Image.network(
                                      (snapshot.data as List<AppBanner>)[2]
                                          .image,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : Container(
                                    height: 120,
                                    child: Center(
                                      child: LoadingWidget(),
                                    )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
          ),
          child: Text(
            "New Arrivals",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        FutureBuilder(
          future: products,
          initialData: [
            Product(),
            Product(),
            Product(),
            Product(),
            Product(),
            Product()
          ],
          builder: (content, snapshot) => Container(
            height: 280,
            child: ListView.builder(
              itemCount: snapshot.hasData
                  ? (snapshot.data as List<Product>).length
                  : 0,
              padding: EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
                  ProductCard(snapshot.data[index]),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "EG-Gate Deals",
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
                      return ProductGridView("Category", 50);
                    }));
                    debugPrint("new arrival clicked ");
                  },
                ),
              ],
            )),
        FutureBuilder(
          future: deals,
          initialData: [
            Product(),
            Product(),
            Product(),
            Product(),
            Product(),
            Product()
          ],
          builder: (content, snapshot) => Container(
            height: 280,
            child: ListView.builder(
              itemCount: snapshot.hasData
                  ? (snapshot.data as List<Product>).length
                  : 0,
              padding: EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
                  ProductCard(snapshot.data[index]),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Replica Collection",
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
                      return ProductGridView("Category", 137);
                    }));
                    debugPrint("new arrival clicked ");
                  },
                ),
              ],
            )),
        FutureBuilder(
          future: replicas,
          initialData: [
            Product(),
            Product(),
            Product(),
            Product(),
            Product(),
            Product()
          ],
          builder: (content, snapshot) => Container(
            height: 280,
            child: ListView.builder(
              itemCount: snapshot.hasData
                  ? (snapshot.data as List<Product>).length
                  : 0,
              padding: EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) =>
                  ProductCard(snapshot.data[index]),
            ),
          ),
        ),
      ],
    );
  }
}
