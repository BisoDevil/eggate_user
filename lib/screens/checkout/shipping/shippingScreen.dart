import 'package:eggate/models/orderModel.dart';
import 'package:eggate/models/product.dart';
import 'package:eggate/models/shippingMethod.dart';
import 'package:eggate/models/user.dart';
import 'package:eggate/screens/checkout/orderConfirmation.dart';
import 'package:eggate/screens/home/home_shopping.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/services/screen_animation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  List<CartModel> cartModels = [];

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
      print("Basem value $value");
    });
    super.initState();
  }

  void getItemFromCart() {
    cartModels.clear();
    MagentoApi().getCartItems().then((items) {
      setState(() {
        items.forEach((f) {
          cartModels.add(CartModel(
              quantity: f["quantity"],
              product: Product.fromJson(f["product"])));
        });
      });
    });
  }

  void placeOrder() {
    String method = _orderModel.paymentMethods[selectedMethod].code;

    MagentoApi()
        .createOrder(methodName: method, address: widget.address)
        .then((value) {
      if (value != null) {
        gotoSuccess(orderId: value);
      }
      print("Basem values from order screen");
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
        backgroundColor: Colors.white,
        iconTheme: Theme.of(context)
            .iconTheme
            .copyWith(color: Theme.of(context).primaryColor),
        title: Text(
          "Place order".toUpperCase(),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _orderModel == null
                ? Center(
                    child: CircularProgressIndicator(),
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
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            elevation: 1,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: selectedMethod == 0
                                      ? Icon(
                                          Icons.check,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Container(
                                          width: 14,
                                          height: 14,
                                        ),
                                  title: Text(
                                    _orderModel.paymentMethods[0].title,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedMethod = 0;
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
                                ListTile(
                                  leading: selectedMethod == 1
                                      ? Icon(
                                          Icons.check,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Container(
                                          width: 14,
                                          height: 14,
                                        ),
                                  title: Text(
                                    _orderModel.paymentMethods[1].title,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedMethod = 1;
                                    });
                                  },
                                  trailing: Icon(
                                    FontAwesomeIcons.creditCard,
                                    color: Theme.of(context).primaryColor,
                                  ),
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
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
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
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  trailing: Text(
                                    "EGP ${_orderModel.totals.subtotal}",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  leading: Text(
                                    "Shipping Fee",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  trailing: Text(
                                    "EGP ${_orderModel.totals.shippingAmount}",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
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
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: Text(
                                    "EGP ${_orderModel.totals.grandTotal}",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
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
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
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
                                  color: Theme.of(context).primaryColor,
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
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Card(
                            elevation: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                for (var item in cartModels)
                                  ListTile(
                                      isThreeLine: true,
                                      dense: true,
                                      leading: Stack(
                                        children: <Widget>[
                                          Image.network(
                                            item.product.mediaGalleryEntries
                                                .first.file
                                                .replaceFirst(
                                                    "https://eggate.shop/pub/media/catalog/product",
                                                    ""),
                                            height: 120,
                                            width: 100,
                                            fit: BoxFit.fitHeight,
                                          ),
                                          item.product.extensionAttributes
                                                          .discountPercentage !=
                                                      null &&
                                                  item
                                                          .product
                                                          .extensionAttributes
                                                          .discountPercentage >
                                                      0.0
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 20,
                                                  ),
                                                  child: Text(
                                                    " ${item.product.extensionAttributes.discountPercentage}% ",
                                                    style: TextStyle(
                                                        backgroundColor:
                                                            Colors.red,
                                                        color: Colors.white),
                                                    maxLines: 1,
                                                  ),
                                                )
                                              : Container(
                                                  width: 1,
                                                )
                                        ],
                                      ),
                                      title: Text(
                                        item.product.name,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      subtitle: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "QTY:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              Container(
                                                width: 10,
                                                child: Text(
                                                  item.quantity.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (item.product.price !=
                                              item.product.extensionAttributes
                                                  .discountedPrice)
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "${item.product.price} EGP",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                "${item.product.extensionAttributes.discountedPrice} EGP",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
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
