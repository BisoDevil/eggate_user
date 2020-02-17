import 'package:eggate/models/Filters.dart';
import 'package:eggate/screens/ProductGridView.dart';

import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  final List<Filters> filters;
  FilterDrawer(this.filters);
  @override
  _FilterDrawerState createState() => _FilterDrawerState(this.filters);
}

class FilerValues {
  String code;
  int value;
  FilerValues({this.code, this.value});
}

class _FilterDrawerState extends State<FilterDrawer> {
  List<dynamic> selectedValues = [];
  List<Filters> filters;
  List<FilerValues> allFiltered = [];
  _FilterDrawerState(this.filters) {
    for (var item in filters) {
      selectedValues.add(item.values[0].value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Filters",
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  allFiltered.clear();
                  ProductGridView.of(context).products.clear();
                  ProductGridView.of(context).codes = this.allFiltered;
                  ProductGridView.of(context).getProductByCategory();
                  Navigator.of(context).pop();
                  setState(() {});
                },
              )
            ],
          ),
        ),
        for (var x = 0; x < filters.length; x++)
          ExpansionTile(
            title: Text(filters[x].label),
            children: <Widget>[
              for (var i = 0; i < filters[x].values.length; i++)
                RadioListTile(
                  activeColor: Theme.of(context).primaryColor,
                  title: Text(filters[x].values[i].display),
                  value: filters[x].values[i].value,
                  isThreeLine: false,
                  subtitle: Text("${filters[x].values[i].count} items"),
                  groupValue: selectedValues[x],
                  onChanged: (value) {
                    setState(() {
                      selectedValues[x] = value;
                      if (allFiltered.any((e) => e.code == filters[x].code)) {
                        int idx = allFiltered
                            .indexWhere((e) => e.code == filters[x].code);
                        allFiltered[idx] =
                            FilerValues(code: filters[x].code, value: value);
                      } else {
                        allFiltered.add(
                            FilerValues(code: filters[x].code, value: value));
                      }
                      ProductGridView.of(context).products.clear();
                      ProductGridView.of(context).codes = this.allFiltered;
                      ProductGridView.of(context).getProductByCategory();

                      print("Changed with ${allFiltered.length}");
                    });
                  },
                )
            ],
          )
      ]),
    );
  }
}
