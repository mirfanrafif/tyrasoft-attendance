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
      var response = Api().getUrl();
      var selectedUrlId =
          (await SharedPreferences.getInstance()).getInt('selectedUrl');
      var selectedUrl = response.firstWhere(
        (element) => element.id == selectedUrlId,
        orElse: () => response.first,
      );
      emit(UrlSuccess(
        url: response,
        selectedUrl: selectedUrl,
      ));
    } on ApiEexception catch (e) {
      emit(UrlFailure(e.message, null));
    } catch (e) {
      emit(UrlFailure(e.toString(), null));
    }
  }

  Future<void> updateSelectedUrl(
      UpdateSelectedUrlEvent event, Emitter<UrlState> emit) async {
    (await SharedPreferences.getInstance())
        .setInt('selectedUrl', event.selectedUrl.id);
    emit(UrlSuccess(
      url: (state as UrlSuccess).url,
      selectedUrl: event.selectedUrl,
    ));
  }
}
