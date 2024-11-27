part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressedEvent({required this.email, required this.password});
}
