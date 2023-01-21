import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tyrasoft_attendance/datasource/api.dart';
import 'package:tyrasoft_attendance/exception/api_exception.dart';
import 'package:tyrasoft_attendance/pages/web_select.dart';

part 'url_event.dart';

part 'url_state.dart';

class UrlBloc extends Bloc<UrlEvent, UrlState> {
  UrlBloc() : super(const UrlInitial(null)) {
    on<UrlEvent>((event, emit) async {
      if (event is GetUrlEvent) {
        // Get the url
        await getUrl(event, emit);
      } else if (event is UpdateSelectedUrlEvent && state is UrlSuccess) {
        // Update the selected url
        updateSelectedUrl(event, emit);
      }
    });
  }

  Future<void> getUrl(UrlEvent event, Emitter<UrlState> emit) async {
    emit(const UrlLoading(null));
    try {
      var response = await Api().getUrl();
      var selectedUrlId =
          (await SharedPreferences.getInstance()).getInt('selectedUrl');
      var selectedUrl = selectedUrlId != null && selectedUrlId != -1
          ? response.firstWhere((element) => element.id == selectedUrlId)
          : null;
      if (selectedUrl != null) {
        emit(UrlSaved(
          url: response,
          selectedUrl: selectedUrl,
        ));
      } else {
        emit(UrlSuccess(
          url: response,
          selectedUrl: response.first,
        ));
      }
    } on ApiEexception catch (e) {
      emit(UrlFailure(e.message, null));
    } catch (e) {
      emit(UrlFailure(e.toString(), null));
    }
  }

  Future<void> updateSelectedUrl(
      UpdateSelectedUrlEvent event, Emitter<UrlState> emit) async {
    if ((state as UrlSuccess).url.any(
          (element) =>
              element.name.toLowerCase() == event.companyName.toLowerCase(),
        )) {
      var selectedUrl = (state as UrlSuccess).url.firstWhere((element) =>
          element.name.toLowerCase() == event.companyName.toLowerCase());

      (await SharedPreferences.getInstance())
          .setInt('selectedUrl', (state as UrlSuccess).selectedUrl?.id ?? -1);

      emit(UrlSaved(
        url: (state as UrlSuccess).url,
        selectedUrl: selectedUrl,
      ));
    } else {
      var url = (state as UrlSuccess).url;
      var selectedUrl = (state as UrlSuccess).selectedUrl;
      emit(UrlNotFound(
          state.selectedUrl, 'No url found for company ${event.companyName}'));
      emit(UrlSuccess(
        url: url,
        selectedUrl: selectedUrl,
      ));
    }
  }
}
