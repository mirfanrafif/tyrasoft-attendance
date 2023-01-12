import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trust_location/trust_location.dart';
import 'package:url_launcher/url_launcher.dart';
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

  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    TrustLocation.start(5);
  }

  Future<void> getLocation() async {
    try {
      TrustLocation.onChange.listen((values) {
        log("Mock location checked: " + values.isMockLocation.toString());
        setState(() {
          _latitude = values.latitude ?? "";
          _longitude = values.longitude ?? "";
          _isMockLocation = values.isMockLocation ?? false;
        });
      });
    } on PlatformException catch (e) {
      print('PlatformException $e');
    }
  }

  /// request location permission at runtime.
  void requestLocationPermission() async {
    var status = await Permission.location.status;
    var cameraStatus = await Permission.camera.status;

    if (status.isDenied || cameraStatus.isDenied) {
      Map<Permission, PermissionStatus> result =
          await [Permission.location, Permission.camera].request();
      return;
    }

    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
      return;
    }

    getLocation();
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
      return InAppWebView(
        initialUrlRequest:
        URLRequest(url: Uri.parse(widget.url)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          var uri = navigationAction.request.url!;

          if (![ "http", "https", "file", "chrome",
            "data", "javascript", "about"].contains(uri.scheme)) {
            if (await canLaunch(widget.url)) {
              // Launch the App
              await launch(
                widget.url,
              );
              // and cancel the request
              return NavigationActionPolicy.CANCEL;
            }
          }

          return NavigationActionPolicy.ALLOW;
        },
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage);
        },
      );
    } else {
      return const Center(
        child: Text("Please turn off mock location"),
      );
    }
  }
}
