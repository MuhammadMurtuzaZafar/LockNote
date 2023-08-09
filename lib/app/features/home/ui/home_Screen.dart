import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/app/core/utils/FocusKeyboard.dart';
import 'package:notes_app/app/core/utils/constants.dart';
import 'package:notes_app/app/features/home/bloc/home_bloc.dart';
import 'package:notes_app/app/models/NoteModel.dart';
import 'package:notes_app/app/routes/app_routes.dart';
import '../../../core/widgets/app_bar.dart';
import '../../../core/widgets/customTextField.dart';
import '../../../core/widgets/note_card.dart';
import '../../../core/widgets/note_insert_alert.dart';

class HomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<HomeBloc>(context,listen: true);
    return GestureDetector(
      onTap: () => FocusKeyboard.dismissKeyboard(),
      child: Scaffold(
        appBar: CustomAppBar(context: context,bloc:bloc),
        body: BlocConsumer<HomeBloc, HomeState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is NoteEditState) {
              // NoteInsertAlert(context, bloc, noteModel: state.book, editAble: true);
              Navigator.pushNamed(context, Routes.NoteEditor,arguments: {
                'bloc': bloc,
                'noteModel':  state.noteModel,
                'isEdit': true,
              },);
            }

          },
          builder: (context, state) {
            return state is NoteLoadingState && state.load
                ? const Center(
                    child: CupertinoActivityIndicator(
                    color: Colors.white,
                  ))
                : RefreshIndicator(
                    onRefresh: () async {
                      bloc.add(FetchNoteEvent());
                    },
                    child: ListView.builder(
                      itemCount: bloc.noteList.length,
                      itemBuilder: (context, index) {
                        return noteCard(bloc.noteList[index], context,bloc);
                      },
                    ),
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FocusKeyboard.dismissKeyboard();
            // NoteInsertAlert(context, bloc);
            Navigator.pushNamed(context, Routes.NoteEditor,arguments: {
              'bloc': bloc,
            },);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }


}
