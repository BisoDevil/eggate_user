import 'dart:convert' as convert;

import 'package:eggate/models/Filters.dart';
import 'package:eggate/models/banner.dart';
import 'package:eggate/models/category.dart';
import 'package:eggate/models/country.dart';
import 'package:eggate/models/orderModel.dart';
import 'package:eggate/models/product.dart';
import 'package:eggate/models/reivew.dart';
import 'package:eggate/models/shippingMethod.dart';
import 'package:eggate/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/FilterDrawer.dart';

class MagentoApi {
  static final MagentoApi _instance = MagentoApi._internal();

  factory MagentoApi() => _instance;

  MagentoApi._internal();

  String domain = "https://eggate.shop/";
  String accessToken = "mo70do8nzd0k4kyl4q9h81m71or071ea";
  String locale;
  String storeCode;
  String cookie;

  // Map<String, ProductAttribute> attributes;

  Future<List<AppBanner>> getSliderImages() async {
    try {
      var response = await http.get("$domain/rest/default/V1/cmsBlock/25",
          headers: {'Authorization': 'Bearer ' + accessToken});
      String content = convert.jsonDecode(response.body)["content"];
      var jsonContent = convert
          .jsonDecode(content.replaceAll("<p>", "").replaceAll("</p>", ""));
      List<AppBanner> list = [];
      for (var item in jsonContent) {
        String type = item["type"];
        int id = item["id"];
        String image = item["image"];
        var baner = AppBanner(type, id, "$domain/pub/media/$image");
        list.add(baner);
      }

      return list;
    } catch (e) {}
    return [];
  }

// get User Token

  Future<bool> getCookie() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    cookie = sharedPreferences.getString("cookie") ?? "";
    return true;
  }

// get Deals API
  Future<List<AppBanner>> getDeals() async {
    try {
      var response = await http.get("$domain/rest/default/V1/cmsPage/14",
          headers: {'Authorization': 'Bearer ' + accessToken});
      String content = convert.jsonDecode(response.body)["content"];
      var jsonContent = convert
          .jsonDecode(content.replaceAll("<p>", "").replaceAll("</p>", ""));
      List<AppBanner> list = [];
      for (var item in jsonContent) {
        String type = item["type"];
        int id = item["id"];
        String image = item["image"];
        var baner = AppBanner(type, id, "$domain/pub/media/$image");
        list.add(baner);
      }

      return list;
    } catch (e) {}
    return [];
  }

  Future<List<Product>> getLastProducts(int currentPage) async {
    try {
      var response = await http.get(
          "$domain/rest/default/V1/products?searchCriteria[sortOrders][0][field]=created_at&searchCriteria[pageSize]=25&searchCriteria[sortOrders][0][direction]=DESC&searchCriteria[currentPage]=$currentPage",
          headers: {'Authorization': 'Bearer ' + accessToken});
      var items = convert.jsonDecode(response.body)["items"];
      List<Product> list = [];
      for (var item in items) {
        Product product = Product.fromMap(item);
        if (product.price > 1) {
          list.add(product);
        }
      }

      print("Basem count last  is ${list.length}");
      return list;
    } catch (e) {
      print("Basem error last products is ${e.toString()}");
      return [];
    }
  }

  Future<List<Product>> fetchProductsByCategory(
      {categoryId,
      page,
      minPrice,
      maxPrice,
      List<FilerValues> filters,
      orderBy,
      order,
      sellerID}) async {
    try {
      var endPoint = "?";
      if (categoryId != null) {
        endPoint +=
            "searchCriteria[filter_groups][0][filters][0][field]=category_id&searchCriteria[filter_groups][0][filters][0][value]=$categoryId&searchCriteria[filter_groups][0][filters][0][condition_type]=eq";
      }
      if (sellerID != null) {
        endPoint +=
            "searchCriteria[filter_groups][0][filters][0][field]=seller_id&searchCriteria[filter_groups][0][filters][0][value]=$sellerID&searchCriteria[filter_groups][0][filters][0][condition_type]=eq";
      }
      if (maxPrice != null) {
        endPoint +=
            "&searchCriteria[filter_groups][0][filters][1][field]=price&searchCriteria[filter_groups][0][filters][1][value]=$maxPrice&searchCriteria[filter_groups][0][filters][1][condition_type]=lteq";
      }
      if (page != null) {
        endPoint += "&searchCriteria[currentPage]=$page";
      }
      if (orderBy != null) {
        endPoint +=
            "&searchCriteria[sortOrders][1][field]=${orderBy == "date" ? "created_at" : orderBy}";
      }
      if (order != null) {
        endPoint +=
            "&searchCriteria[sortOrders][1][direction]=${(order as String).toUpperCase()}";
      }
      if (filters != null && filters.isNotEmpty) {
        for (var i = 0; i < filters.length; i++) {
          endPoint +=
              "&searchCriteria[filter_groups][0][filters][${i + 1}][field]=${filters[i].code}&searchCriteria[filter_groups][0][filters][${i + 1}][value]=${filters[i].value}&searchCriteria[filter_groups][0][filters][${i + 1}][condition_type]=eq";
        }
      }
      endPoint += "&searchCriteria[pageSize]=10";

      // endPoint +=
      //     "&searchCriteria[filter_groups][0][filters][2][field]=type_id&searchCriteria[filter_groups][0][filters][2][value]=configurable&searchCriteria[filter_groups][0][filters][2][condition_type]=eq";
      debugPrint("Basem links is $endPoint");
      var response = await http.get("$domain/rest/default/V1/products$endPoint",
          headers: {'Authorization': 'Bearer ' + accessToken});

      List<Product> list = [];
      if (response.statusCode == 200) {
        for (var item in convert.jsonDecode(response.body)["items"]) {
          Product product = Product.fromMap(item);
          if (product.price != null || product.price > 1) {
            list.add(product);
          }
        }
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      var response = await http.get("$domain/rest/default/V1/mma/categories",
          headers: {'Authorization': 'Bearer ' + accessToken});
      var items = convert.jsonDecode(response.body)["children_data"];

      List<Category> list = [];
      for (var item in items) {
        Category product = Category.fromMap(item);
        if (product.image != null) {
          list.add(product);
        }
        if (product.childrenData.isNotEmpty) {
          for (var sub in product.childrenData) {
            if (sub.image != null) {
              list.add(sub);
            }
            if (sub.childrenData.isNotEmpty) {
              for (var child in sub.childrenData) {
                if (child.image != null) {
                  list.add(child);
                }
              }
            }
          }
        }
      }
      print("Basem category is $list");
      return list;
    } catch (e) {}
    return [];
  }

  Future<List<Review>> getProductReviews(String productSku) async {
    try {
      var response = await http.get(
          //EG201570000036
          "$domain/rest/default/V1/products/$productSku/reviews",
          headers: {'Authorization': 'Bearer ' + accessToken});
      var items = convert.jsonDecode(response.body);
      List<Review> list = [];
      for (var item in items) {
        Review review = Review.fromMap(item);
        list.add(review);
      }

      print("Basem count reviews  is ${list.length}");
      return list;
    } catch (e) {
      print("Basem error last review is ${e.toString()}");
      return [];
    }
  }

// save product to cart
  void saveCartToLocal({Product product, int quantity = 1}) async {
    final LocalStorage storage = new LocalStorage("eggate");
    try {
      final ready = await storage.ready;
      if (ready) {
        List items = await storage.getItem("cart");
        if (items != null && items.isNotEmpty) {
          bool here = items.any((p) => p["product"] == product.toJson());
          if (here) {
            int idx =
                items.lastIndexWhere((p) => p["product"] == product.toJson());
            items[idx]["quantity"]++;
          } else {
            items.add({"product": product.toJson(), "quantity": quantity});
          }
        } else {
          items = [
            {"product": product.toJson(), "quantity": quantity}
          ];
        }
        await storage.setItem("cart", items);
        print("Basem Saved to local store");
      }
    } catch (err) {
      print(err);
    }
  }

  Future<List> getCartItems() async {
    final LocalStorage storage = new LocalStorage("eggate");
    final ready = await storage.ready;

    if (ready) {
      List items = await storage.getItem("cart");

      return items;
    }
    return [];
  }

  // delete product from cart

  void deleteFromCartLocal({Product product}) async {
    final LocalStorage storage = new LocalStorage("eggate");
    final ready = await storage.ready;
    List items = await storage.getItem("cart");
    var it = items
        .lastWhere((p) =>
    Product
        .fromJson(p["product"])
        .sku == product.sku);

    items.remove(it);
    await storage.setItem("cart", items);
  }

  // save to wish list

  void saveToWishListLocal({Product product}) async {
    final LocalStorage storage = new LocalStorage("eggate");
    final ready = await storage.ready;
  }

// get category filters
  Future<List<Filters>> getFilters(int categoryId) async {
    try {
      var response = await http.get(
        //EG201570000036
          "$domain/rest/default/V1/categories/$categoryId/filterable",
          headers: {'Authorization': 'Bearer ' + accessToken});
      var items = convert.jsonDecode(response.body);
      List<Filters> list = [];
      for (var item in items) {
        Filters review = Filters.fromMap(item);
        list.add(review);
      }

      print("Basem count filters  is ${list.length}");
      return list;
    } catch (e) {
      print("Basem error last  is ${e.toString()}");
      return [];
    }
  }

  Future<User> loginCustomer(String username, String password) async {
    var response = await http.post(
        "$domain/rest/default/V1/integration/customer/token",
        body: convert.jsonEncode({"username": username, "password": password}),
        headers: {"Content-Type": "application/json"});
    print("Basem ${response.body}");
    String cookie = convert.jsonDecode(response.body);
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString("cookie", cookie);
    return getUserInfo(cookie);
  }

  Future<User> getUserInfo(token) async {
    var res = await http.get("$domain/rest/default/V1/customers/me", headers: {
      'Authorization': 'Bearer ' + token,
      "Content-Type": "application/json"
    });
    print("Basem user is ${res.body}");

    var user = User.fromMap(convert.jsonDecode(res.body));
    user.saveUserLocal(user);

    return user;
  }

  Future<User> createUser({firstName, lastName, username, password}) async {
    try {
      var response = await http.post("$domain/rest/default/V1/customers",
          body: convert.jsonEncode({
            "customer": {
              "firstname": firstName,
              "lastname": lastName,
              "email": username
            },
            "password": password
          }),
          headers: {"content-type": "application/json"});

      if (response.statusCode == 200) {
        return await this.loginCustomer(username, password);
      } else {
        final body = convert.jsonDecode(response.body);
        String message = body["message"];

        throw Exception(message != null ? message : "Can not get token");
      }
    } catch (err) {
      throw err;
    }
  }

// order processing
  Future<bool> addToCart() async {
    String qoute = await createQuote();
    List items = await getCartItems();
    print("Basem qoute from cart $qoute");
    await Future.forEach(items, (f) async {
      Product product = Product.fromJson(f["product"]);
      int qty = f["quantity"];
      try {
        var response =
        await http.post("$domain/rest/default/V1/carts/mine/items",
            body: convert.jsonEncode({
              "cartItem": {
                "sku": product.sku,
                "qty": qty,
                "quote_id": qoute
              }
            }),
            headers: {
              "content-type": "application/json",
              'Authorization': 'Bearer ' + cookie,
            });
        if (response.statusCode != 200) {
          var body = convert.jsonDecode(response.body);
          String message = body["message"];
          throw Exception(message);
        }
        return;
      } catch (e) {
        throw e;
      }
    });

    return true;
  }

  Future<String> createQuote() async {
    await getCookie();
    print("Basem Cookie $cookie");
    try {
      var response =
      await http.post("$domain/rest/default/V1/carts/mine", headers: {
        "content-type": "application/json",
        'Authorization': 'Bearer ' + cookie,
      });
      if (response.statusCode == 200) {
        var qouteId = convert.jsonDecode(response.body);
        print("Basem qoute Id is $qouteId");
        return qouteId.toString();
      } else if (response.statusCode == 401) {
        final body = convert.jsonDecode(response.body);
        String message = body["message"];

        throw Exception(message != null ? message : "Can not get token");
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<Country>> getCountries() async {
    //V1/directory/countries
    var res =
    await http.get("$domain/rest/default/V1/directory/countries", headers: {
      "content-type": "application/json",
      'Authorization': 'Bearer ' + accessToken,
    });
    if (res.statusCode == 200) {
      List<Country> list = [];
      for (var item in convert.jsonDecode(res.body)) {
        Country country = Country.fromMap(item);
        if (country.fullNameEnglish != null &&
            country.fullNameEnglish.isNotEmpty) {
          list.add(country);
        }
      }
      print("Basem $list");
      return list;
    }

    return [];
  }

  Future<List<ShippingMethod>> getShippingMethod(Address address) async {
    await getCookie();
    var response = await http.post(
        "$domain/rest/default/V1/carts/mine/estimate-shipping-methods",
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer ' + cookie,
        },
        body: convert.jsonEncode(
          {
            "address": {
              "region_id": address.regionId,
              "country_id": address.countryId
            }
          },
        ));
    List<ShippingMethod> list = [];
    if (response.statusCode == 200) {
      for (var item in convert.jsonDecode(response.body)) {
        list.add(ShippingMethod.fromMap(item));
      }
      return list;
    }
    return [];
  }

  Future<OrderModel> getOrderModel(
      {Address address, ShippingMethod shippingMethod}) async {
    await getCookie();
    var response = await http.post(
        "$domain/rest/default/V1/carts/mine/shipping-information",
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer ' + cookie,
        },
        body: convert.jsonEncode({
          "addressInformation": {
            "shipping_address": {
              "region_id": address.regionId,
              "country_id": address.countryId
            },
            "billing_address": {
              "region_id": address.regionId,
              "country_id": address.countryId
            },
            "shipping_carrier_code": shippingMethod.carrierCode,
            "shipping_method_code": shippingMethod.methodCode
          }
        }));
    if (response.statusCode == 200) {
      return OrderModel.fromMap(convert.jsonDecode(response.body));
    }
    return throw Exception(response.body);
  }

  Future createOrder({String methodName, Address address}) async {
    await getCookie();

    var requestBody = convert.jsonEncode(
      {
        "paymentMethod": {"method": methodName},
        "billing_address": {
          "region": address.region.region,
          "region_id": address.regionId,
          "region_code": address.region.regionCode,
          "country_id": address.countryId,
          "street": address.street,
          "postcode": address.postcode,
          "city": address.city,
          "telephone": address.telephone,
          "firstname": address.firstname,
          "lastname": address.lastname
        }
      },
    );

    print("Basem request body $requestBody");

    var response = await http.post(
        "$domain/rest/default/V1/carts/mine/payment-information",
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer ' + cookie,
        },
        body: requestBody);
    var body = convert.jsonDecode(response.body);
    print("Basem $body");
    if (response.statusCode == 200) {
      print("BAsem created order $body");
    }
  }
}
