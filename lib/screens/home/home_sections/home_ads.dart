import 'package:cached_network_image/cached_network_image.dart';
import 'package:eggate/models/banner.dart';
import 'package:eggate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

import '../../ProductGridView.dart';

class HomeAds extends StatelessWidget {
  final List<HomeBaner> ads;

  HomeAds({this.ads});

  List<Widget> getChildren(int count, BuildContext context) {
    switch (count) {
      case 1:
        return [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                var ad = ads.first;
                return ProductGridView(ad.type, ad.id);
              }));
            },
            child: CachedNetworkImage(
              imageUrl: ads.first.image,
              placeholder: (q, w) => LoadingWidget(),
              fit: BoxFit.fitWidth,
              placeholderFadeInDuration: Duration(milliseconds: 300),
            ),
          )
        ];
      case 2:
        return [
          Row(
            children: <Widget>[
              for (var item in ads)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProductGridView(item.type, item.id);
                      }));
                    },
                    child: CachedNetworkImage(
                      imageUrl: item.image,
                      placeholder: (q, w) => LoadingWidget(),
                      fit: BoxFit.fill,
                      placeholderFadeInDuration: Duration(milliseconds: 300),
                    ),
                  ),
                )
            ],
          )
        ];
      case 3:
        return [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                var ad = ads.first;
                return ProductGridView(ad.type, ad.id);
              }));
            },
            child: CachedNetworkImage(
              imageUrl: ads.first.image,
              placeholder: (q, w) => LoadingWidget(),
              fit: BoxFit.fitWidth,
              placeholderFadeInDuration: Duration(milliseconds: 300),
            ),
          ),
          Row(
            children: <Widget>[
              for (int i = 1; i < ads.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ProductGridView(ads[i].type, ads[i].id);
                      }));
                    },
                    child: CachedNetworkImage(
                      imageUrl: ads[i].image,
                      placeholder: (q, w) => LoadingWidget(),
                      fit: BoxFit.fill,
                      placeholderFadeInDuration: Duration(milliseconds: 300),
                    ),
                  ),
                )
            ],
          )
        ];
      default:
        return [
          for (int i = 0; i < ads.length; i++)
            i % 2 == 0
                ? Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProductGridView(ads[i].type, ads[i].id);
                              }));
                            },
                            child: CachedNetworkImage(
                              imageUrl: ads[i].image,
                              placeholder: (q, w) => LoadingWidget(),
                              fit: BoxFit.fill,
                              placeholderFadeInDuration:
                                  Duration(milliseconds: 300),
                            ),
                          ),
                        ),
                      ),
                      ads.length - 1 > i
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ProductGridView(
                                          ads[i + 1].type, ads[i + 1].id);
                                    }));
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: ads[i + 1].image,
                                    placeholder: (q, w) => LoadingWidget(),
                                    fit: BoxFit.fill,
                                    placeholderFadeInDuration:
                                        Duration(milliseconds: 300),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  )
                : Container()
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ads != null
        ? Column(children: getChildren(ads.length, context))
        : null;
  }
}
