import 'package:eggate/models/country.dart';
import 'package:eggate/models/user.dart';
import 'package:eggate/services/magento.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  var _firstName = TextEditingController();
  var _lastName = TextEditingController();
  var _phone = TextEditingController();
  var _postcode = TextEditingController();
  var _street = TextEditingController();
  var _region = TextEditingController();
  var _city = TextEditingController();
  var _selected;
  var _selectedRegion;
  bool _defaultBilling = false;
  bool _defaultShipping = false;
  List<Country> countries = [];
  List<AvailableRegion> regions = [];
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    _getCountries();
    super.initState();
  }

  void _getCountries() {
    MagentoApi().getCountries().then((items) {
      if (items != null) {
        setState(() {
          countries = items;
          _selected = countries.first.id;
          regions = countries.first.availableRegions;
          _selectedRegion = regions.first.id;
        });
      }
    });
  }

  bool isValid() {
    return _firstName.text.isNotEmpty &&
        _lastName.text.isNotEmpty &&
        _phone.text.isNotEmpty &&
        _city.text.isNotEmpty &&
        _street.text.isNotEmpty;
  }

  void saveAddress() {
    if (!isValid()) {
      _globalKey.currentState.showSnackBar(SnackBar(
        content: Text("Please fill the missing !"),
      ));
      return;
    }

    User().getUserLocal().then((u) {
      var reg = regions.firstWhere((r) => r.id == _selectedRegion);
      Address address = Address(
          firstname: _firstName.text,
          lastname: _lastName.text,
          telephone: _phone.text,
          countryId: _selected.toString(),
          regionId: int.parse(_selectedRegion),
          street: [_street.text],
          postcode: _postcode.text,
          city: _city.text,
          defaultBilling: _defaultBilling ? 1 : 0,
          customerId: u.id,
          region: Region(
              regionId: int.parse(reg.id),
              region: reg.name,
              regionCode: reg.code),
          defaultShipping: _defaultShipping ? 1 : 0);

      if (_defaultShipping) {
        u.addresses.forEach((a) {
          a.defaultShipping = 0;
        });
      }
      if (_defaultBilling) {
        u.addresses.forEach((a) {
          a.defaultBilling = 0;
        });
      }

      u.addresses.add(address);
      u.saveUserLocal(u);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(
          "New Address".toUpperCase(),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "First name",
                      icon: Icon(FontAwesomeIcons.user),
                      suffixIcon: _firstName.text.isNotEmpty
                          ? Icon(Icons.check)
                          : null),
                  controller: _firstName,
                  onChanged: (String text) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Last name",
                      icon: Icon(FontAwesomeIcons.user),
                      suffixIcon:
                          _lastName.text.isNotEmpty ? Icon(Icons.check) : null),
                  controller: _lastName,
                  onChanged: (String text) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Phone number",
                      icon: Icon(FontAwesomeIcons.mobileAlt),
                      suffixIcon:
                          _phone.text.isNotEmpty ? Icon(Icons.check) : null),
                  controller: _phone,
                  keyboardType: TextInputType.number,
                  onChanged: (String text) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  value: _selected,
                  items: <DropdownMenuItem>[
                    for (var item in countries)
                      DropdownMenuItem(
                        value: item.id,
                        child: Text(item.fullNameEnglish ?? "Basem"),
                      )
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selected = value;
                      regions = countries
                              .firstWhere((c) => c.id == _selected.toString())
                              .availableRegions ??
                          [];
                      _selectedRegion = regions.first.id ?? "";
//                      print("country is ${regions.length}");
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                regions.length > 0
                    ? DropdownButtonFormField(
                        value: _selectedRegion,
                        items: <DropdownMenuItem>[
                          for (var item in regions)
                            DropdownMenuItem(
                              value: item.id,
                              child: Text(item.name ?? "Atef"),
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedRegion = value;
                          });
                        },
                      )
                    : TextFormField(
                        decoration: InputDecoration(
                            labelText: "Region",
                            icon: Icon(FontAwesomeIcons.home),
                            suffixIcon: _region.text.isNotEmpty
                                ? Icon(Icons.check)
                                : null),
                        controller: _region,
                        onChanged: (String text) {
                          setState(() {});
                        },
                      ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "City",
                      icon: Icon(FontAwesomeIcons.home),
                      suffixIcon:
                          _city.text.isNotEmpty ? Icon(Icons.check) : null),
                  controller: _city,
                  onChanged: (String text) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Street",
                      icon: Icon(FontAwesomeIcons.road),
                      suffixIcon:
                          _street.text.isNotEmpty ? Icon(Icons.check) : null),
                  controller: _street,
                  onChanged: (String text) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Postcode",
                      icon: Icon(FontAwesomeIcons.mailBulk),
                      suffixIcon:
                          _postcode.text.isNotEmpty ? Icon(Icons.check) : null),
                  controller: _postcode,
                  onChanged: (String text) {
                    setState(() {});
                  },
                ),
                SwitchListTile(
                  title: Text("Use as my default shipping address"),
                  value: _defaultShipping,
                  onChanged: (value) {
                    setState(() {
                      _defaultShipping = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text("Use as my default billing address"),
                  value: _defaultBilling,
                  onChanged: (value) {
                    setState(() {
                      _defaultBilling = value;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  height: 40,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    saveAddress();
                  },
                  child: Text(
                    "Save".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
