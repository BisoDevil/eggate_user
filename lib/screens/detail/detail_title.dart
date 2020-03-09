import 'package:eggate/models/product.dart';
import 'package:eggate/services/magento.dart';
import 'package:flutter/material.dart';

class ProductTitle extends StatelessWidget {
  final Product product;
  final bool onSale = false;
  ProductTitle(this.product);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            product.name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text(
                "${product.extensionAttributes.discountedPrice} ${MagentoApi.currency}",
                style: Theme.of(context).textTheme.headline.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    )),
            if (product.extensionAttributes.discountedPrice != product.price)
              Row(
                children: <Widget>[
                  SizedBox(width: 5),
                  Text("${product.price} ${MagentoApi.currency}",
                      style: Theme.of(context).textTheme.headline.copyWith(
                          fontSize: 16,
                          color: Theme.of(context).accentColor,
                          decoration: TextDecoration.lineThrough)),
                  SizedBox(width: 5),
                ],
              )
          ],
        ),
      ],
    );
  }
}
