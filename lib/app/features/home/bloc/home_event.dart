part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}


class FormTitleChangeEvent extends HomeEvent{
  String title;
  FormTitleChangeEvent(this.title);
}
class FormSubtitleChangeEvent extends HomeEvent{
  String subtitle;
  FormSubtitleChangeEvent(this.subtitle);
}
class FormSubmitEvent extends HomeEvent{
  String title;
  String subtitle;
  int isLock;

  FormSubmitEvent(this.title, this.subtitle,this.isLock);
}
class FetchNoteEvent extends HomeEvent{}
class DeleteNoteEvent extends HomeEvent{
  int id;

  DeleteNoteEvent(this.id);
}
class EditNoteEvent extends HomeEvent{
  NoteModel book;
  EditNoteEvent(this.book);
}
class EditSubmitEvent extends HomeEvent{
  NoteModel noteModel;
  EditSubmitEvent(this.noteModel);
}
class SwitchProtectionEvent extends HomeEvent{
  bool switchProtection;

  SwitchProtectionEvent(this.switchProtection);
}
class SwitchProtectionErrorEvent extends HomeEvent{
}