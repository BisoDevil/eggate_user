import 'package:eggate/models/cart.dart';
import 'package:eggate/models/orderModel.dart';
import 'package:eggate/models/shippingMethod.dart';
import 'package:eggate/models/user.dart';
import 'package:eggate/screens/checkout/orderConfirmation.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/services/screen_animation.dart';
import 'package:eggate/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../PayWebView.dart';

class OrderReview extends StatefulWidget {
  final ShippingMethod shippingMethod;
  final Address address;

  OrderReview({@required this.shippingMethod, @required this.address});

  @override
  _OrderReviewState createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  OrderModel _orderModel;
  int selectedMethod = 0;
  List<Cart> carts = [];

  @override
  void initState() {
    getItemFromCart();
    MagentoApi()
        .getOrderModel(
            address: widget.address, shippingMethod: widget.shippingMethod)
        .catchError((error) {
      print("Basem error $error");
    }).then((value) {
      if (value != null)
        setState(() {
          _orderModel = value;
        });
      print("Basem order model ${value.toJson()}");
    });
    super.initState();
  }

  void getItemFromCart() {
    carts.clear();
    MagentoApi().getCartItems().then((items) {
      setState(() {
        carts = items;
      });
    });
  }

  void placeOrder() {
    String method = _orderModel.paymentMethods[selectedMethod].code;

    MagentoApi()
        .createOrder(methodName: method, address: widget.address)
        .then((value) {
      if (value != null) {
        if (value is List) {
          print("Basem values is $value");
          String session = value[0].toString();
          String id = value[1].toString();
          Navigator.of(context).push(
            MyCustomRoute(
              builder: (q, w, e) => PayWebView(
                session: session,
                id: id,
              ),
            ),
          );
        } else {
          gotoSuccess(orderId: value);
        }
      }
    });
  }

  void gotoSuccess({int orderId}) {
    Navigator.of(context).pushReplacement(
      MyCustomRoute(
        builder: (q, w, e) => OrderConfirmation(
          orderId: orderId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Place order".toUpperCase(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _orderModel == null
                ? Center(
                    child: LoadingWidget(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "payment method".toUpperCase(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            elevation: 1,
                            child: Column(
                              children: <Widget>[
                                for (var i = 0;
                                    i < _orderModel.paymentMethods.length;
                                    i++)
                                  Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: selectedMethod == i
                                            ? Icon(
                                                Icons.check,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )
                                            : Container(
                                                width: 14,
                                                height: 14,
                                              ),
                                        title: Text(
                                          _orderModel.paymentMethods[i].title,
                                          style: selectedMethod == i
                                              ? TextStyle(
                                                  fontWeight: FontWeight.bold)
                                              : null,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedMethod = i;
                                          });
                                        },
                                        trailing: Icon(
                                          FontAwesomeIcons.moneyBillAlt,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Divider(
                                        indent: 30,
                                        endIndent: 30,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Order summary".toUpperCase(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            elevation: 1,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  dense: true,
                                  leading: Text(
                                    "Subtotal",
                                  ),
                                  trailing: Text(
                                    "${MagentoApi.currency} ${_orderModel.totals.subtotal}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Text(
                                    "Shipping Fee",
                                  ),
                                  trailing: Text(
                                    "${MagentoApi.currency} ${_orderModel.totals.shippingAmount}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Divider(
                                  indent: 30,
                                  endIndent: 30,
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Text(
                                    "Total",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Text(
                                    "${MagentoApi.currency} ${_orderModel.totals.grandTotal}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Ship to".toUpperCase(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            elevation: 1,
                            child: ListTile(
                              dense: true,
                              title: Text(
                                "${widget.address.firstname} ${widget.address.lastname}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${widget.address.street.first}"),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text("${widget.address.telephone}")
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "your order".toUpperCase(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Card(
                            elevation: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                for (var item in carts)
                                  Column(
                                    children: <Widget>[
                                      ListTile(
                                          dense: true,
                                          leading: Stack(
                                            children: <Widget>[
                                              Image.network(
                                                item.extensionAttributes.image,
                                                height: 120,
                                                width: 100,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ],
                                          ),
                                          title: Text(
                                            item.name,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "QTY:",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 10,
                                                    child: Text(
                                                      item.qty.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    "${item.price} ${MagentoApi.currency}",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                      Divider(
                                        indent: 40,
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            height: 60,
            child: Text(
              "Place order".toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              placeOrder();
            },
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
