import 'package:tyrasoft_attendance/exception/api_exception.dart';
import 'package:tyrasoft_attendance/pages/web_select.dart';

class Api {
  List<WebUrlData> getUrl() {
    try {
      const responseUrlList = [
        WebUrlData(
            id: 1, name: "Matahati", url: "https://matahati.tyrasoft.com/"),
        WebUrlData(id: 2, name: "ERP", url: "https://erp.tyrasoft.com/")
      ];
      return responseUrlList;
    } catch (e) {
      throw ApiEexception(e.toString());
    }
  }
}
