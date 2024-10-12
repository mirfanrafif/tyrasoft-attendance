import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class LoginAction extends LoginEvent {
  final String email;
  final String password;

  LoginAction({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
