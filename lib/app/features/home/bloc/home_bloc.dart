import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes_app/app/models/NoteModel.dart';
import 'package:notes_app/app/repositories/note_repo/note_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NoteRepository _noteRepo = NoteRepository();
  List<NoteModel> noteList = [];

  HomeBloc() : super(HomeInitial()) {
    on<SwitchProtectionErrorEvent>((event,emit){
       emit(NoteProtectedErrorState());
    });

    on<FormTitleChangeEvent>((event, emit) {
      if (event.title.isEmpty) {
        return emit(NoteTitleErrorState("Please Enter a Note Title"));
      } else {
        return emit(NoteTitleValidState());
      }
    });

    on<SwitchProtectionEvent>((event, emit) {

      if(event.switchProtection)
      {

        emit(NoteProtectedTrueState());
      }
      else
      {
        emit(NoteProtectedFalseState());

      }

    });
    on<FormSubtitleChangeEvent>((event, emit) {
      if (event.subtitle.isEmpty) {
        return emit(NoteSubtitleErrorState("Please Enter a Note Subtitle"));
      } else {
        return emit(NoteSubtitleValidState());
      }
    });

    on<FormSubmitEvent>((event, emit) {
      if (event.title.isEmpty) {
        return emit(NoteTitleErrorState("Please Enter a Note Title"));
      } else if (event.subtitle.isEmpty) {
        return emit(NoteSubtitleErrorState("Please Enter Note Subtitle"));
      }
/*      else if (!_isNumeric(event.year)) {
        return emit(NoteYearErrorState("Please Enter a Year Name"));
      } */
      else {
        _noteRepo.insert(NoteModel(title: event.title,subTitle: event.subtitle,isLock: event.isLock));
        add(FetchNoteEvent());
        return emit(NoteFormValidState());
      }
    });
    on<FetchNoteEvent>((event, emit) async {
      emit(NoteLoadingState(true));
      noteList = await _noteRepo.getAll();
      emit(NoteLoadingState(false));
    });

    on<DeleteNoteEvent>((event, emit) {
      _noteRepo.delete(event.id);
      add(FetchNoteEvent());
    });

    on<EditNoteEvent>((event, emit) {
      emit(NoteEditState(event.book));
    });

    on<EditSubmitEvent>((event, emit) {
      if (event.noteModel.title!.isEmpty) {
        return emit(NoteTitleErrorState("Please Enter a Note Title"));
      } else if (event.noteModel.subTitle.toString().isEmpty) {
        return emit(NoteSubtitleErrorState("Please Enter a Year Name"));
      }
    /*  else if (!_isNumeric(event.noteModel.isLock.toString())) {
        return emit(NoteYearErrorState("Please Enter a Year Name"));
      } */
      else {
        _noteRepo.update(event.noteModel);
        add(FetchNoteEvent());
        return emit(NoteFormValidState());
      }
    });
    add(FetchNoteEvent());
  }
  bool _isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }
}
