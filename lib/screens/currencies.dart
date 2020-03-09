import 'package:eggate/models/store_config.dart';
import 'package:eggate/services/magento.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Currencies extends StatefulWidget {
  @override
  _CurrenciesState createState() => _CurrenciesState();
}

class _CurrenciesState extends State<Currencies> {
  StoreConfig _storeConfig;
  String _selectedCurrency;

  @override
  void initState() {
    var mag = MagentoApi();
    mag.getStoreConfigLocal().then((value) {
      setState(() {
        _storeConfig = value;
      });
    });
    mag.getCurrency().then((v) {
      setState(() {
        _selectedCurrency = v;
      });
    });
    super.initState();
  }

  void selectCurrency({String text}) async {
    setState(() {
      _selectedCurrency = text;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("currency", text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Currencies",
        ),
      ),
      body: _storeConfig == null
          ? Container()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (var item in _storeConfig.exchangeRates)
                    Column(
                      children: <Widget>[
                        ListTile(
                          leading: item.currencyTo == _selectedCurrency
                              ? Icon(Icons.check)
                              : SizedBox(),
                          title: Text(
                            item.currencyTo,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          onTap: () {
                            selectCurrency(text: item.currencyTo);
                          },
                        ),
                        Divider(
                          indent: 60,
                        )
                      ],
                    )
                ],
              ),
            ),
    );
  }
}
