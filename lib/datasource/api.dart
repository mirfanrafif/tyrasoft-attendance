import 'package:tyrasoft_attendance/pages/web_select.dart';

class Api {
  List<WebUrlData> getUrl() {
    const responseUrlList = [
      WebUrlData(
          id: 1, name: "Matahati", url: "https://matahati.tyrasoft.com/"),
      WebUrlData(id: 1, name: "ERP", url: "https://erp.tyrasoft.com/")
    ];
    return responseUrlList;
  }
}
