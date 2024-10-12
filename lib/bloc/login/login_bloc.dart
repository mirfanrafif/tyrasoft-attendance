import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tyrasoft_attendance/bloc/login/login_event.dart';
import 'package:tyrasoft_attendance/bloc/login/login_state.dart';
import 'package:tyrasoft_attendance/datasource/api.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginAction>((event, emit) async {
      emit(LoginLoading());
      try {
        print('Login bloc');
        final response = await const Api(baseUrl: 'dev.piron.xyz')
            .login(LoginRequest(email: event.email, password: event.password));

        emit(LoginSuccess(response));
      } catch (e) {
        print('Error: ${e.toString()}');
        emit(LoginError(e.toString()));
      }
    });
  }
}
