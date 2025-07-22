part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {
  final String? snakeMessage;

  SignupSuccess({required this.snakeMessage});
}

final class SignupFailer extends SignupState {
  final String errorMessage;

  SignupFailer(this.errorMessage);
}
