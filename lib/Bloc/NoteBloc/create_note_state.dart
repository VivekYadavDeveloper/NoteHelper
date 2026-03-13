part of 'create_note_bloc.dart';

@immutable
sealed class CreateNoteState {}

final class CreateNoteInitial extends CreateNoteState {}

final class CreateNoteLoading extends CreateNoteState {}

final class CreateNoteSuccess extends CreateNoteState {}

final class CreateNoteFailure extends CreateNoteState {
  final String errorMessage;

  CreateNoteFailure(this.errorMessage);
}

