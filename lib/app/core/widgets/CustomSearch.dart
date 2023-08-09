import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/app/core/widgets/note_card.dart';

import 'package:notes_app/app/models/NoteModel.dart';

import '../../features/home/bloc/home_bloc.dart';

class CustomSearch extends SearchDelegate {
  var bloc;
  BuildContext context;
  CustomSearch(this.context, this.bloc);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {

    return BlocBuilder<HomeBloc, HomeState>(
      bloc: bloc,
      builder: (context, state) {
        final suggestList = query.isEmpty
            ? []
            : bloc.noteList
            .where((element) =>
        element.title!.contains(query) ||
            element.timestamp.contains(query.toString()))
            .toList();
        return ListView.builder(
          itemCount: suggestList.length,
          itemBuilder: (context, index) {
            return noteCard(suggestList[index], context, bloc);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return BlocBuilder<HomeBloc, HomeState>(
      bloc: bloc,
      builder: (context, state) {
        final suggestList=query.isEmpty?bloc.noteList:bloc.noteList.where((NoteModel element)
        => element.title!.contains(query)||
            element.timestamp!.contains(query.toString())).toList();

        return ListView.builder(
          itemCount: suggestList.length,
          itemBuilder: (context, index) {
            return noteCard(suggestList[index], context, bloc);
          },
        );
      },
    );
  }

/*
  Widget myCard(NoteModel noteModel, context) {
    return Card(
      elevation: 1.5,
      color: const Color(0xFF4B4848),
      child: ListTile(
        onTap: () {
          query = noteModel.title!;
        },
        title: Text(noteModel.title!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(noteModel.subTitle.toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(noteModel.timestamp.toString()),
              ],
            ),
          ],
        ),

      ),
    );
  }
*/
/*
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    assert(theme != null);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        brightness: colorScheme.brightness,
        backgroundColor: Colors.black,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        textTheme: theme.textTheme.copyWith().apply(bodyColor: Colors.black),
      ),
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white, //<-- SEE HERE
            displayColor: Colors.white, //<-- SEE HERE
          ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
          ),
    );
  }*/
}
