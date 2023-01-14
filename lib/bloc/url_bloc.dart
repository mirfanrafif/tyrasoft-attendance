import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tyrasoft_attendance/datasource/api.dart';
import 'package:tyrasoft_attendance/pages/web_select.dart';

part 'url_event.dart';
part 'url_state.dart';

class UrlBloc extends Bloc<UrlEvent, UrlState> {
  UrlBloc() : super(const UrlInitial(null)) {
    on<UrlEvent>((event, emit) {
      if (event is GetUrlEvent) {
        // Get the url
        getUrl(event, emit);
      } else if (event is UpdateSelectedUrlEvent && state is UrlSuccess) {
        // Update the selected url
        emit(UrlSuccess(
          url: (state as UrlSuccess).url,
          selectedUrl: event.selectedUrl,
        ));
      }
    });
  }

  void getUrl(UrlEvent event, Emitter<UrlState> emit) {
    emit(const UrlLoading(null));
    try {
      var response = Api().getUrl();
      emit(UrlSuccess(
        url: response,
      ));
    } catch (e) {
      emit(UrlFailure(e.toString(), null));
    }
  }
}
