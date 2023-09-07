import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrasoft_attendance/datasource/api.dart';
import 'package:tyrasoft_attendance/exception/api_exception.dart';
import 'package:tyrasoft_attendance/pages/web_select.dart';
import 'package:collection/collection.dart';
part 'url_event.dart';

part 'url_state.dart';

const SELECTED_URL = 'selectedUrl';

class UrlBloc extends Bloc<UrlEvent, UrlState> {
  UrlBloc() : super(const UrlInitial(null)) {
    on<UrlEvent>((event, emit) async {
      if (event is GetUrlEvent) {
        // Get the url
        await getUrl(event, emit);
      } else if (event is UpdateSelectedUrlEvent) {
        // Update the selected url
        await updateSelectedUrl(event, emit);
      }
    });
  }

  Future<void> getUrl(GetUrlEvent event, Emitter<UrlState> emit) async {
    var savedUrl =
        (await SharedPreferences.getInstance()).getString(SELECTED_URL);

    if (savedUrl != null) {
      emit(UrlSaved(
        url: const [],
        selectedUrl: savedUrl,
      ));
    }
  }

  Future<void> updateSelectedUrl(
      UpdateSelectedUrlEvent event, Emitter<UrlState> emit) async {
    emit(const UrlLoading(null));

    var sharedPref = await SharedPreferences.getInstance();

    try {
      var response = await Api(baseUrl: event.url).getUrl();

      var selectedUrl = response
          .firstWhereOrNull((element) => element.name == event.companyName);

      if (selectedUrl == null) {
        emit(UrlNotFound(state.selectedUrl,
            'No url found for company ${event.companyName}'));
        emit(const UrlInitial(null));
      } else {
        //save to shared preferences
        sharedPref.setString(SELECTED_URL, selectedUrl.url);

        emit(UrlSaved(
          url: response,
          selectedUrl: selectedUrl.url,
        ));
      }
    } on ApiEexception catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      emit(UrlNotFound(
          state.selectedUrl, 'No url found for company ${event.companyName}'));
      emit(const UrlInitial(null));
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace);

      emit(UrlNotFound(
          state.selectedUrl, 'No url found for company ${event.companyName}'));
      emit(const UrlInitial(null));
    }
  }
}
