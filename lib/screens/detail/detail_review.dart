import 'package:async/async.dart';
import 'package:eggate/models/product.dart';
import 'package:eggate/models/reivew.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/widgets/ExpansionInfo.dart';
import 'package:eggate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductReview extends StatelessWidget {
  final Product product;
  final _memoizer = AsyncMemoizer<List<Review>>();

  ProductReview(this.product);

  @override
  Widget build(BuildContext context) {
    Future<List<Review>> getProductReviews() {
      return _memoizer.runOnce(() {
        return MagentoApi().getProductReviews(product.sku);
      });
    }

    return LayoutBuilder(
      builder: (context, constraint) {
        return FutureBuilder<List<Review>>(
          future: getProductReviews(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Review>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Container(
                  height: 100,
                  child: Center(
                    child: LoadingWidget(),
                  ),
                );
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                    ),
                  );
                } else if (snapshot.data.length == 0) {
                  return Container();
                } else {
                  return ExpansionInfo(
                    expand: true,
                    children: <Widget>[
                      for (var item in snapshot.data)
                        ListTile(
                          contentPadding: EdgeInsets.all(4),
                          title: Text(item.nickname),
                          subtitle: Text(item.detail),
                          trailing: Text(
                            DateFormat("MMM d yyyy").format(item.createdAt),
                            style:
                                Theme.of(context).textTheme.subtitle.copyWith(
                                      fontSize: 10,
                                    ),
                          ),
                          isThreeLine: true,
                        )
                    ],
                    title: "Reviews",
                  );
                }
            }
            return Container(); // unreachable
          },
        );
      },
    );
  }
}
