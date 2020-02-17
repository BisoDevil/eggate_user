import 'package:eggate/models/product.dart';
import 'package:eggate/widgets/ExpansionInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class ProductDescription extends StatelessWidget {
  final Product product;
  ProductDescription(this.product);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (product.customAttributes
                .firstWhere((c) => c.attributeCode == "description") !=
            null)
          ExpansionInfo(
              title: "Description",
              children: <Widget>[
                HtmlWidget(
                  product.customAttributes
                      .firstWhere((c) => c.attributeCode == "description")
                      .value,
                  textStyle: TextStyle(color: Colors.black54),
                ),
              ],
              expand: true),
      ],
    );
  }
}
