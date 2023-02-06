import 'dart:convert';
import 'dart:developer';

import 'package:tyrasoft_attendance/exception/api_exception.dart';
import 'package:tyrasoft_attendance/model/web_url_data.dart';
import 'package:tyrasoft_attendance/pages/web_select.dart';
import 'package:http/http.dart';

class Api {
  final String baseUrl = "erp.tyrasoft.com";

  Future<List<WebUrlData>> getUrl() async {
    try {
      // var response = await get(Uri.https(baseUrl, "get_mobile_api"));
      // log(response.body);
      // var data = MobileApiResponse.fromJson(jsonDecode(response.body));
      //
      // return data.data.map((e) => WebUrlData(id: e.id ?? 0, name: e.name ?? "", url: e.link ?? "")).toList();
      const responseUrlList = [
        WebUrlData(
            id: 1, name: "Matahati", url: "https://matahati.tyrasoft.com/"),
        WebUrlData(id: 1, name: "ERP", url: "https://erp.tyrasoft.com/")
      ];
      return responseUrlList;
    } catch (e) {
      throw ApiEexception(e.toString());
    }
  }
}
