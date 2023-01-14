part of 'url_bloc.dart';

abstract class UrlState extends Equatable {
  const UrlState({required this.selectedUrl});

  final WebUrlData? selectedUrl;

  @override
  List<Object> get props => [];
}

class UrlInitial extends UrlState {
  const UrlInitial(WebUrlData? selectedUrl) : super(selectedUrl: selectedUrl);
}

class UrlLoading extends UrlState {
  const UrlLoading(WebUrlData? selectedUrl) : super(selectedUrl: selectedUrl);
}

class UrlSuccess extends UrlState {
  final List<WebUrlData> url;

  UrlSuccess({
    required this.url,
    WebUrlData? selectedUrl,
  }) : super(
            selectedUrl:
                selectedUrl ?? url.firstWhere((element) => element.id == 1));

  @override
  List<Object> get props => [url];
}

class UrlFailure extends UrlState {
  final String error;

  const UrlFailure(this.error, WebUrlData? selectedUrl)
      : super(selectedUrl: selectedUrl);

  @override
  List<Object> get props => [error];
}
