import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/app/core/utils/FocusKeyboard.dart';
import 'package:notes_app/app/core/utils/constants.dart';
import 'package:notes_app/app/core/utils/date_converter.dart';
import 'package:notes_app/app/core/utils/local_auth_api.dart';

import '../../features/home/bloc/home_bloc.dart';
import '../../models/NoteModel.dart';
import 'general_alert.dart';

Widget noteCard(
  NoteModel note,
  context,
  bloc,
) {
  return Card(
    elevation: 1.5,
    child: Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (c) async {
              if (note.isLock == 1) {
                if (await LocalAuthApi.authenticate(context)) {
                  bloc.add(EditNoteEvent(note));
                }
              } else {
                bloc.add(EditNoteEvent(note));
              }
            },
            autoClose: true,
            backgroundColor: KColor.grey,
            foregroundColor: KColor.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (c) {
              CustomAlertDialog(
                  context: context,
                  message: "Do You want to Delete Item?",
                  done: () async {
                    Navigator.pop(context);
                    if (note.isLock == 1) {
                      if (await LocalAuthApi.authenticate(context)) {
                        FocusKeyboard.dismissKeyboard();
                        bloc.add(DeleteNoteEvent(note.dbId ?? 0));
                      }
                    } else {
                      bloc.add(DeleteNoteEvent(note.dbId ?? 0));
                    }
                  });
            },
            autoClose: true,
            backgroundColor: KColor.kPrimaryRedColor,
            foregroundColor: KColor.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: note.isLock == 1
            ? Text('*' * note.title!.length)
            : Text(note.title!),
        subtitle: note.isLock == 1
            ? Text('*' * note.subTitle!.length)
            : Text(note.subTitle!),
        trailing: Text(DateConverter.formatDateTime(note.timestamp.toString()),style: TextStyle(color: KColor.disableColor),),
      ),
    ),
  );
}
