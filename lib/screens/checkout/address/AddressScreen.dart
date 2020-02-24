import 'package:eggate/models/shippingMethod.dart';
import 'package:eggate/models/user.dart';
import 'package:eggate/screens/checkout/address/AddAddressScreen.dart';
import 'package:eggate/screens/checkout/shipping/shippingScreen.dart';
import 'package:eggate/services/magento.dart';
import 'package:eggate/services/screen_animation.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  final bool fromCheckOut;

  AddressScreen({this.fromCheckOut = false});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  List<Address> address = [];
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  ShippingMethod _shippingMethod;

  void _addNewAddress() {
    Navigator.of(context)
        .push(MyCustomRoute(builder: (q, w, e) => AddAddressScreen()));
  }

  Address selectedAddress;

  void selectAddress(Address item) {
    setState(() {
      address.forEach((a) => a.defaultShipping = false);
      item.defaultShipping = true;
      selectedAddress = item;
      if (!widget.fromCheckOut) {
        address.firstWhere((a) => a.id == item.id).defaultShipping = true;
        User().getUserLocal().then((u) {
          u.addresses = this.address;
          u.saveUserLocal(u);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    User().getUserLocal().then((u) {
      setState(() {
        address = u.addresses;
        selectedAddress = address.firstWhere((a) => a.defaultShipping == true);
      });
    });
  }

  void removeAddress(Address item) {
    if (item.defaultShipping) {
      _globalKey.currentState.showSnackBar(SnackBar(
        content: Text("You can't remove default shipping address"),
      ));
      return;
    }
    User().getUserLocal().then((u) {
      setState(() {
        address.remove(item);
        u.addresses = address;
        u.saveUserLocal(u);
      });
    });
  }

  void goToShipping() {
    MagentoApi().getShippingMethod(selectedAddress).catchError((e) {
      print("Basem error shipping ${e.toString()}");
    }).then((value) {
      if (value != null && value.isNotEmpty) {
        setState(() {
          _shippingMethod = value.first;
          Navigator.of(context).push(MyCustomRoute(
              builder: (q, w, e) => OrderReview(
                    shippingMethod: _shippingMethod,
                    address: selectedAddress,
                  )));
        });

        print("Basem shipping method ${value.length}");
      }
    });
  }

  // Create view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(
          "Address",
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (var item in address)
                    AddressWidget(
                      address: item,
                      onClick: () {
                        selectAddress(item);
                        print("Basem clicked");
                      },
                      onIconPressed: () {
                        removeAddress(item);

                        print("Icon pressed ");
                      },
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  FlatButton.icon(
                      onPressed: () {
                        _addNewAddress();
                      },
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                      label: Text(
                        "add new address".toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ),
            ),
          ),
          if (widget.fromCheckOut)
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 60,
              child: Text(
                "Next".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                goToShipping();
              },
              color: Theme.of(context).primaryColor,
            )
        ],
      ),
    );
  }
}

class AddressWidget extends StatefulWidget {
  final Address address;
  final Function onClick;
  final Function onIconPressed;

  AddressWidget(
      {this.address, @required this.onClick, @required this.onIconPressed});

  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "${widget.address.firstname} ${widget.address.lastname}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          isThreeLine: true,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.address.street.first),
              SizedBox(
                height: 3,
              ),
              Text(
                widget.address.telephone,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              if (widget.onIconPressed != null) {
                widget.onIconPressed();
              }
            },
          ),
          leading: widget.address.defaultShipping
              ? Icon(
                  Icons.check,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                )
              : Container(
                  width: 30,
                  height: 30,
                ),
          onTap: () {
            widget.onClick();
          },
        ),
        Divider(
          indent: 20,
          endIndent: 20,
        )
      ],
    );
  }
}
