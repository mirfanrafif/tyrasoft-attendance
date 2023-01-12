import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  const WebViewPage({Key? key, required this.url }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewPage> {
  String _latitude = "";
  String _longitude = "";
  bool _isMockLocation = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    TrustLocation.stop();
  }
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    TrustLocation.start(5);
  }

  Future<void> getLocation() async {
    try {
      TrustLocation.onChange.listen((values) => setState(() {
            _latitude = values.latitude ?? "";
            _longitude = values.longitude ?? "";
            _isMockLocation = values.isMockLocation ?? false;
          }));
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  /// request location permission at runtime.
  void requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      getLocation();
    }
    if (status.isDenied) {
      Map<Permission, PermissionStatus> result =
          await [Permission.location].request();
    }

    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: getView(),
      ),
    );
  }

  Widget getView() {
    if (!_isMockLocation) {
      return const WebView(
        initialUrl: "https://www.google.com",
        javascriptMode: JavascriptMode.unrestricted,
      );
    } else {
      return const Center(
        child: Text("Please turn off mock location"),
      );
    }
  }
}
