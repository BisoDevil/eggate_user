import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eggate/models/banner.dart';
import 'package:eggate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

import '../../ProductGridView.dart';

class HomeSectionSlider extends StatelessWidget {
  final List<HomeBaner> slides;

  HomeSectionSlider({this.slides});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      enableInfiniteScroll: true,
      enlargeCenterPage: true,
      autoPlay: true,
      pauseAutoPlayOnTouch: Duration(seconds: 5),
      autoPlayAnimationDuration: Duration(seconds: 2),
      autoPlayInterval: Duration(seconds: 5),
      items: <Widget>[
        for (var slide in slides)
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProductGridView(slide.type, slide.id);
              }));
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
                  borderRadius: BorderRadius.circular(6)),
              child: CachedNetworkImage(
                imageUrl: slide.image,
                placeholder: (q, w) => LoadingWidget(),
                placeholderFadeInDuration: Duration(milliseconds: 400),
              ),
            ),
          )
      ],
    );
  }
}
