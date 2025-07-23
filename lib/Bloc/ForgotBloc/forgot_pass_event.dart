part of 'forgot_pass_bloc.dart';

@immutable
sealed class ForgotPassEvent {}

class ForgotPassButtonPressedEvent extends ForgotPassEvent {
  final String email;

  ForgotPassButtonPressedEvent({required this.email});
}
