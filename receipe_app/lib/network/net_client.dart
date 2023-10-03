import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:receipe_app/model/response_filter.dart';
import 'package:receipe_app/model/respose_detail.dart';

class NetClient {
  String baseURL = "www.themealdb.com";


  Future<ResponseFilter?> fetchDataMeals(int currentIndex) async {
    const endPoint = "/api/json/v1/1/filter.php";
    Map<String, String> queryParams;
    if (currentIndex == 0) {
      queryParams = {"c": "Seafood"};
    } else {
      queryParams = {"c": "Dessert"};
    }
    try {
      final uri = Uri.https(baseURL, endPoint, queryParams);
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final jsonD = jsonDecode(res.body);
        ResponseFilter result = ResponseFilter.fromJson(jsonD);
        return result;    
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ResponseDetail?> fetchDetailMealsById(String id) async {
    const endPoint = "/api/json/v1/1/lookup.php";
    Map<String, String> queryParams = {"i" : id};
    try {
      final uri = Uri.https(baseURL, endPoint, queryParams);
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        var json = jsonDecode(res.body);
        ResponseDetail data = ResponseDetail.fromJson(json);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}