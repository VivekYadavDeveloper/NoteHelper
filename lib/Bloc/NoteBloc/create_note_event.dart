part of 'create_note_bloc.dart';

@immutable
sealed class CreateNoteEvent {}



class CreateNoteButtonEvent extends CreateNoteEvent{
  final String title ;
  final String description;

  CreateNoteButtonEvent({required this.title, required this.description});
}

class UpdateNoteButtonEvent extends CreateNoteEvent {
  final String taskId;
  final String title;
  final String description;

  UpdateNoteButtonEvent({
    required this.taskId,
    required this.title,
    required this.description,
  });
}