import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tyrasoft_attendance/bloc/url_bloc.dart';
import 'package:tyrasoft_attendance/pages/webview.dart';
import 'package:tyrasoft_attendance/style/style.dart';

class WebSelect extends StatefulWidget {
  const WebSelect({Key? key}) : super(key: key);

  @override
  State<WebSelect> createState() => _WebSelectState();
}

class _WebSelectState extends State<WebSelect> {
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget getForm(UrlInitial state) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _urlController,
            decoration: getInputDecoration("Please Enter Master API"),
          ),
          const SizedBox(
            height: 24,
          ),
          TextField(
            controller: _nameController,
            decoration: getInputDecoration("Please Enter Company Name"),
          ),
          const SizedBox(
            height: 24,
          ),
          getButton("Go", () async {
            await FirebaseAnalytics.instance.logEvent(
                name: "open_web", parameters: {"url": _nameController.text});
            context.read<UrlBloc>().add(UpdateSelectedUrlEvent(
                _nameController.text, _urlController.text));
            // moveToWebView(state.selectedUrl?.url);
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UrlBloc, UrlState>(
      listener: (context, state) {
        if (state is UrlNotFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) => Scaffold(
        body: () {
          if (state is UrlInitial) {
            return getForm(state);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }(),
      ),
    );
  }

  void moveToWebView(String? url) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: url ?? ""),
      ),
      (route) => false,
    );
  }
}

class WebUrlData {
  final int id;
  final String name;
  final String url;

  const WebUrlData({required this.id, required this.name, required this.url});
}
