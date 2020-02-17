import 'dart:convert' as convert;

import 'package:eggate/models/Filters.dart';
import 'package:eggate/models/banner.dart';
import 'package:eggate/models/category.dart';
import 'package:eggate/models/product.dart';
import 'package:eggate/models/reivew.dart';
import 'package:eggate/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import '../widgets/FilterDrawer.dart';

class MagentoApi {
  static final MagentoApi _instance = MagentoApi._internal();
  factory MagentoApi() => _instance;
  MagentoApi._internal();
  String domain = "https://eggate.shop/";
  String accessToken = "mo70do8nzd0k4kyl4q9h81m71or071ea";
  String locale;
  String storeCode;
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
          items.add({"product": product.toJson(), "quantity": quantity});
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
    return getUserInfo(convert.jsonDecode(response.body));
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
}
