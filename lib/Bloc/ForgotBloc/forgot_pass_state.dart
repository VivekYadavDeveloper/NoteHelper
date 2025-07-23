part of 'forgot_pass_bloc.dart';

@immutable
sealed class ForgotPassState {}

final class ForgotPassInitial extends ForgotPassState {}

final class ForgotPassLoading extends ForgotPassState {}

final class ForgotPassSuccess extends ForgotPassState {
  final String? snakeMessage;

  ForgotPassSuccess({required this.snakeMessage});
}

final class ForgotPassFailer extends ForgotPassState {
  final String errorMessage;

  ForgotPassFailer({required this.errorMessage});
}
