part of 'url_bloc.dart';

abstract class UrlState extends Equatable {
  const UrlState({required this.selectedUrl});

  final String? selectedUrl;

  @override
  List<Object?> get props => [selectedUrl];
}

class UrlInitial extends UrlState {
  const UrlInitial(String? selectedUrl) : super(selectedUrl: selectedUrl);
}

class UrlLoading extends UrlState {
  const UrlLoading(String? selectedUrl) : super(selectedUrl: selectedUrl);
}

class UrlSaved extends UrlState {
  final List<WebUrlData> url;

  const UrlSaved({
    required this.url,
    String? selectedUrl,
  }) : super(selectedUrl: selectedUrl);

  @override
  List<Object?> get props => [url, selectedUrl];
}

class UrlNotFound extends UrlState {
  final String errorMessage;
  const UrlNotFound(String? selectedUrl, this.errorMessage)
      : super(selectedUrl: selectedUrl);
}

class UrlFailure extends UrlState {
  final String error;

  const UrlFailure(this.error, String? selectedUrl)
      : super(selectedUrl: selectedUrl);

  @override
  List<Object> get props => [error];
}
