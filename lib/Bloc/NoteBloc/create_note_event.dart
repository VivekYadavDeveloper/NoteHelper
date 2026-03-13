part of 'create_note_bloc.dart';

@immutable
sealed class CreateNoteEvent {

}


class CreateNoteButtonEvent extends CreateNoteEvent{
  final String title ;
  final String description;

  CreateNoteButtonEvent({required this.title, required this.description});
}