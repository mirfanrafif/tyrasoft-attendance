import 'dart:developer';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UrlBloc, UrlState>(
      builder: (context, state) => Scaffold(
        body: () {
          if (state is UrlSuccess) {
            log(state.selectedUrl?.url ?? "");
            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<WebUrlData>(
                    isExpanded: true,
                    value: state.selectedUrl,
                    items: state.url
                        .map(
                          (e) => DropdownMenuItem<WebUrlData>(
                            child: Text(e.name),
                            value: e,
                          ),
                        )
                        .toList(),
                    onChanged: (selected) {
                      context.read<UrlBloc>().add(
                          UpdateSelectedUrlEvent(selected ?? state.url.first));
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  getButton("Go", () async {
                    await FirebaseAnalytics.instance.logEvent(
                        name: "open_web",
                        parameters: {"url": state.selectedUrl?.url ?? ""});
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            WebViewPage(url: state.selectedUrl?.url ?? ""),
                      ),
                      (route) => false,
                    );
                  })
                ],
              ),
            );
          } else if (state is UrlFailure) {
            return Center(
              child: Text(state.error),
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
}

class WebUrlData {
  final int id;
  final String name;
  final String url;

  const WebUrlData({required this.id, required this.name, required this.url});
}
