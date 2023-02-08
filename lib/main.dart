import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tyrasoft_attendance/pages/web_select.dart';
import 'package:tyrasoft_attendance/pages/webview.dart';

import 'bloc/url_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (exception, stackTrace) {
    FirebaseCrashlytics.instance
        .recordError(exception, stackTrace, fatal: false);
    return true;
  };

  await FirebaseAnalytics.instance.logAppOpen();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UrlBloc()..add(const GetUrlEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Tyrasoft Attendance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        home: BlocBuilder<UrlBloc, UrlState>(
          builder: (context, state) {
            if (state is UrlSaved && state.selectedUrl != null) {
              return WebViewPage(url: state.selectedUrl?.url ?? "");
            } else {
              return const WebSelect();
            }
          },
        ),
      ),
    );
  }
}
