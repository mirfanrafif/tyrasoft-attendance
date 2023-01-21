part of 'url_bloc.dart';

abstract class UrlState extends Equatable {
  const UrlState({required this.selectedUrl});

  final WebUrlData? selectedUrl;

  @override
  List<Object?> get props => [selectedUrl];
}

class UrlInitial extends UrlState {
  const UrlInitial(WebUrlData? selectedUrl) : super(selectedUrl: selectedUrl);
}

class UrlLoading extends UrlState {
  const UrlLoading(WebUrlData? selectedUrl) : super(selectedUrl: selectedUrl);
}

class UrlSuccess extends UrlState {
  final List<WebUrlData> url;

  const UrlSuccess({
    required this.url,
    WebUrlData? selectedUrl,
  }) : super(selectedUrl: selectedUrl);

  @override
  List<Object?> get props => [url, selectedUrl];
}

class UrlSaved extends UrlState {
  final List<WebUrlData> url;

  const UrlSaved({
    required this.url,
    WebUrlData? selectedUrl,
  }) : super(selectedUrl: selectedUrl);

  @override
  List<Object?> get props => [url, selectedUrl];
}

class UrlNotFound extends UrlState {
  final String errorMessage;
  const UrlNotFound(WebUrlData? selectedUrl, this.errorMessage)
      : super(selectedUrl: selectedUrl);
}

class UrlFailure extends UrlState {
  final String error;

  const UrlFailure(this.error, WebUrlData? selectedUrl)
      : super(selectedUrl: selectedUrl);

  @override
  List<Object> get props => [error];
}
