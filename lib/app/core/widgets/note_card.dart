import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes_app/app/core/utils/constants.dart';
import 'package:notes_app/app/core/utils/local_auth_api.dart';

import '../../features/home/bloc/home_bloc.dart';
import '../../models/NoteModel.dart';

Widget noteCard(NoteModel note, context, bloc,) {
  return Card(
    elevation: 1.5,
    color: KColor.card_bg,
    child: Slidable(
      endActionPane:  ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (c)
            async{
              if(note.isLock==1)
              {
                if(await LocalAuthApi.authenticate(context))
                {
                  bloc.add(EditNoteEvent(note));

                }
              }
              else
              {
                bloc.add(EditNoteEvent(note));

              }

            },
            autoClose:true,
            backgroundColor: KColor.grey,
            foregroundColor: KColor.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (c){
              bloc.add(DeleteNoteEvent(note.dbId ?? 0));
            },
            autoClose:true,
            backgroundColor: KColor.kPrimaryRedColor,
            foregroundColor: KColor.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: note.isLock == 1 ? Text('*' * note.title!.length) : Text(
            note.title!),
        subtitle: note.isLock == 1 ? Text('*' * note.subTitle!.length) : Text(
            note.subTitle!),
        trailing: Text(note.timestamp.toString()),

      ),
    ),
  );
}
