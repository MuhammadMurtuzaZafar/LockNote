import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../features/home/bloc/home_bloc.dart';
import '../../models/NoteModel.dart';
import '../utils/FocusKeyboard.dart';
import '../utils/constants.dart';
import '../utils/local_auth_api.dart';
import 'customTextField.dart';
 NoteInsertAlert (context, bloc, {NoteModel? noteModel, bool editAble = false}) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  int isLock=0;

    if (editAble) {
      titleController.text = noteModel!.title??"";
      subtitleController.text = noteModel.subTitle??"";
      bloc.add(SwitchProtectionEvent(noteModel.isLock==1?true:false));
    }

    return  showDialog(
      context: context,
      builder: (context) => BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is NoteFormValidState) {
            Navigator.pop(context);
          }
          else if(state is NoteProtectedErrorState)
          {
            SnackBarHelper.showSnackBar(context, ConstantValues.fingerPrintErrorMsg);
          }
        },
        bloc: bloc,
        builder: (context, state) {
          return AlertDialog(
            title: Text(editAble ? "Edit" : "Add New",style: Theme.of(context).textTheme.subtitle1),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  textEditingController:titleController,
                  errorText: state is NoteTitleErrorState ? state.error : null,
                  hintText: "Enter a Note Title",
                  onChanged: (val){
                    bloc.add(FormTitleChangeEvent(val));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  textEditingController:subtitleController,
                  errorText: state is NoteSubtitleErrorState ? state.error : null,
                  hintText: "Enter a Note Subtitle",
                  onChanged: (val){
                    bloc.add(FormSubtitleChangeEvent(val));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                Row(
                  children:  [
                    const Text("Do You to use protection ?"),
                    Switch(
                      value: state is NoteProtectedTrueState? true: false,
                      onChanged: (value)async {
                        FocusKeyboard.dismissKeyboard();
                        final isAvailable = await LocalAuthApi.hasBiometrics(context);
                        final biometrics = await LocalAuthApi.getBiometrics();

                        final hasFingerprint = biometrics.contains(BiometricType.fingerprint);
                        if(isAvailable)
                        {
                          isLock=value?1:0;
                          bloc.add(SwitchProtectionEvent(value));
                        }
                        else
                        {
                          bloc.add(SwitchProtectionErrorEvent());
                        }

                      },
                    ),
                  ],
                )
              ],
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  FocusKeyboard.dismissKeyboard();

                  if (editAble) {
                    bloc.add(EditSubmitEvent(NoteModel(dbId: noteModel!.dbId,title: titleController.text,subTitle: subtitleController.text,isLock: isLock)));
                  } else {
                    bloc.add(FormSubmitEvent(titleController.text, subtitleController.text,isLock));
                  }
                },
                child:  Text(editAble?"Update":"Add"),
              ),
            ],
          );
        },
      ),
    );

}
