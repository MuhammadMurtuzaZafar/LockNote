part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}


class NoteLoadingState extends HomeState {
  bool load;

  NoteLoadingState(this.load);
}

class NoteTitleValidState extends HomeState{}
class NoteSubtitleValidState extends HomeState{}

class NoteFormValidState extends HomeState{}

class NoteTitleErrorState extends HomeState{
  String error;
  NoteTitleErrorState(this.error);
}
class NoteSubtitleErrorState extends HomeState{
  String error;
  NoteSubtitleErrorState(this.error);
}
class NoteEditState extends HomeState
{
  NoteModel book;

  NoteEditState(this.book);
}
class NoteProtectedTrueState extends HomeState{}
class NoteProtectedFalseState extends HomeState{}
class NoteProtectedErrorState extends HomeState{}
