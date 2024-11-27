part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitialState extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {
  final String? snackMsg;

  LoginSuccessState({this.snackMsg});
}

final class LoginFailerState extends LoginState {
  final String errorMessage;

  LoginFailerState(this.errorMessage);
}
