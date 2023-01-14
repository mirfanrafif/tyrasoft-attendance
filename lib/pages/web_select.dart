import 'package:flutter/material.dart';
import 'package:tyrasoft_attendance/pages/webview.dart';
import 'package:tyrasoft_attendance/style/style.dart';

class WebSelect extends StatefulWidget {
  const WebSelect({Key? key}) : super(key: key);

  @override
  State<WebSelect> createState() => _WebSelectState();
}

class _WebSelectState extends State<WebSelect> {
  List<WebUrlData> urlList = [];

  WebUrlData? selectedUrl;

  @override
  void initState() {
    super.initState();
    const responseUrlList = [
      WebUrlData(
          id: 1, name: "Matahati", url: "https://matahati.tyrasoft.com/"),
      WebUrlData(id: 1, name: "ERP", url: "https://erp.tyrasoft.com/")
    ];
    setState(() {
      urlList.addAll(responseUrlList);
      selectedUrl = responseUrlList.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<WebUrlData>(
                isExpanded: true,
                value: selectedUrl,
                items: urlList
                    .map(
                      (e) => DropdownMenuItem<WebUrlData>(
                        child: Text(e.name),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (selected) {
                  setState(() {
                    selectedUrl = selected;
                  });
                },
              ),
              const SizedBox(
                height: 24,
              ),
              getButton("Go", () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) =>
                        WebViewPage(url: selectedUrl?.url ?? ""),
                  ),
                  (route) => false,
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}

class WebUrlData {
  final int id;
  final String name;
  final String url;

  const WebUrlData({required this.id, required this.name, required this.url});
}
