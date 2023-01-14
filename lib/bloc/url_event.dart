part of 'url_bloc.dart';

abstract class UrlEvent extends Equatable {
  const UrlEvent();

  @override
  List<Object> get props => [];
}

class GetUrlEvent extends UrlEvent {
  const GetUrlEvent();
}

class UpdateSelectedUrlEvent extends UrlEvent {
  final WebUrlData selectedUrl;

  const UpdateSelectedUrlEvent(this.selectedUrl);

  @override
  List<Object> get props => [selectedUrl];
}
