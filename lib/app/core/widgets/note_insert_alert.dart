import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes_app/app/core/utils/image_dialog.dart';

import '../../features/home/bloc/home_bloc.dart';
import '../../models/NoteModel.dart';
import '../utils/FocusKeyboard.dart';
import '../utils/constants.dart';
import '../utils/local_auth_api.dart';
import 'customTextField.dart';
import 'general_alert.dart';

NoteInsertAlert(ctx, bloc,
    {NoteModel? noteModel, bool editAble = false}) async {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  int isLock = 0;
  // bloc.clearImage();
  bloc.add(ImageUploadedEvent(false));

  if (editAble) {
    titleController.text = noteModel!.title ?? "";
    subtitleController.text = noteModel.subTitle ?? "";
    bloc.add(SwitchProtectionEvent(noteModel.isLock == 1 ? true : false));
    String base64String = base64Encode(noteModel.imageBinaryData ?? []);
    Uint8List bytes = base64Decode(base64String);
    if (bytes.length > 0) {
      bloc!.imagePicked = await bloc.bytesToFile(bytes);
    } else {
      bloc!.imagePicked = null;
    }
  }

  return showDialog(
    context: ctx,
    builder: (context) => BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is NoteFormValidState) {
          Navigator.pop(context);
        } else if (state is NoteProtectedErrorState) {
          SnackBarHelper.showSnackBar(
              context, ConstantValues.fingerPrintErrorMsg);
        }
      },
      bloc: bloc,
      builder: (context, state) {
        return AlertDialog(
          title: Text(editAble ? "Edit" : "Add New",
              style: Theme.of(context).textTheme.subtitle1),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      state is ImageUploadSuccess || bloc!.imagePicked != null
                          ? GestureDetector(
                              child: Image.file(
                                bloc!.imagePicked ?? "",
                                width: 80,
                                height: 100,
                              ),
                              onTap: () {
                                CustomAlertDialog(
                                    context: context,
                                    message: "Do You want to Delete Image?",
                                    done: () async {
                                      Navigator.pop(context);
                                      bloc.add(ImageUploadedEvent(false));
                                      bloc!.imagePicked = null;
                                    });
                              })
                          : IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Upload Image",
                                          style: TextStyle(color: KColor.white),
                                        ),
                                        content: CustomImagePicker(bloc),
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.upload,
                                color: KColor.scaffold_bg,
                              )),
                      const Text("Upload Image")
                    ],
                  ),
                ),
                CustomTextField(
                  textEditingController: titleController,
                  errorText: state is NoteTitleErrorState ? state.error : null,
                  hintText: "Enter a Note Title",
                  onChanged: (val) {
                    bloc.add(FormTitleChangeEvent(val));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  textEditingController: subtitleController,
                  errorText:
                      state is NoteSubtitleErrorState ? state.error : null,
                  hintText: "Enter a Note Subtitle",
                  onChanged: (val) {
                    bloc.add(FormSubtitleChangeEvent(val));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<HomeBloc, HomeState>(bloc:bloc,
                    builder: (c,s){
                  return Row(
                    children: [
                      const Text("Do You to use protection ?"),
                      Switch(
                        value: s is NoteProtectedTrueState ? true : false,
                        focusColor: Colors.orange,
                        onChanged: (value) async {
                          FocusKeyboard.dismissKeyboard();
                          final isAvailable =
                          await LocalAuthApi.hasBiometrics(context);
                          final biometrics = await LocalAuthApi.getBiometrics();
                          final hasFingerprint =
                          biometrics.contains(BiometricType.fingerprint);

                          if (value) {
                            isLock = value ? 1 : 0;
                            if (await LocalAuthApi.authenticate(ctx)) {
                              bloc.add(SwitchProtectionEvent(value));
                            } else {
                              bloc.add(SwitchProtectionErrorEvent());
                            }
                          } else {
                            isLock = value ? 1 : 0;
                            bloc.add(SwitchProtectionEvent(value));
                          }
                        },
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () async {
                FocusKeyboard.dismissKeyboard();

                if (editAble) {
                  List<int> imageBinary = await bloc.fileToBase64String();

                  bloc.add(EditSubmitEvent(NoteModel(
                      dbId: noteModel!.dbId,
                      title: titleController.text,
                      subTitle: subtitleController.text,
                      isLock: isLock,
                      imageBinaryData: imageBinary)));
                } else {
                  bloc.add(FormSubmitEvent(
                      titleController.text, subtitleController.text, isLock));
                }
              },
              child: Text(editAble ? "Update" : "Add"),
            ),
          ],
        );
      },
    ),
  );
}
