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
  final String companyName;
  final String url;

  const UpdateSelectedUrlEvent(this.companyName, this.url);

  @override
  List<Object> get props => [companyName];
}
