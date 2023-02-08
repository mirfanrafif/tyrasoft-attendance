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

  @override
  void initState() {
    super.initState();
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
          if (state is UrlSuccess) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: getInputDecoration("Please Enter Company Name"),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  getButton("Go", () async {
                    await FirebaseAnalytics.instance.logEvent(
                        name: "open_web",
                        parameters: {"url": state.selectedUrl?.url ?? ""});
                    context
                        .read<UrlBloc>()
                        .add(UpdateSelectedUrlEvent(_nameController.text));
                    // moveToWebView(state.selectedUrl?.url);
                  })
                ],
              ),
            );
          } else if (state is UrlFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Error while retrieving page data",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          state.error,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        getButton("Retry", () {
                          context.read<UrlBloc>().add(const GetUrlEvent());
                        })
                      ],
                    ),
                  ),
                ),
              ),
            );
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
