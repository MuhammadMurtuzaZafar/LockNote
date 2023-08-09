import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes_app/app/core/utils/FocusKeyboard.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/image_dialog.dart';
import '../../../core/utils/local_auth_api.dart';
import '../../../core/widgets/custom_icon_btn.dart';
import '../../../core/widgets/general_alert.dart';
import '../../../models/NoteModel.dart';
import '../../home/bloc/home_bloc.dart';

class NoteEditor extends StatefulWidget {


  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  // final UserController userController = Get.find<UserController>();
  final TextEditingController titleController = TextEditingController();

  final TextEditingController bodyController = TextEditingController();
  int isLock = 0;

  NoteModel? noteModel;
  bool editAble = false;
  var bloc;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // your login goes here
      intentFunc();

    });

  }

  void intentFunc() async {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    bloc = args['bloc'];
    editAble=args['isEdit'];
    // debugger();

    bloc.add(ImageUploadedEvent(false));
    if (editAble) {
      noteModel=args['noteModel'];
      titleController.text = noteModel!.title ?? "";
      bodyController.text = noteModel?.subTitle ?? "";
      bloc.add(SwitchProtectionEvent(noteModel?.isLock == 1 ? true : false));
      String base64String = base64Encode(noteModel?.imageBinaryData ?? []);
      Uint8List bytes = base64Decode(base64String);
      if (bytes.isNotEmpty) {
        bloc!.imagePicked = await bloc.bytesToFile(bytes);
      } else {
        bloc!.imagePicked = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: (){
            FocusKeyboard.dismissKeyboard();
          },
          child: Container(
            height: size.height,
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: BlocConsumer<HomeBloc, HomeState>(
              bloc: bloc,
              listener: (context, state) {
                if (state is NoteFormValidState) {
                  Navigator.pop(context);
                } else if (state is NoteProtectedErrorState) {
                  SnackBarHelper.showSnackBar(
                      context, ConstantValues.fingerPrintErrorMsg);
                }
              },
              builder: (context, state) {
                return Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconBtn(
                        color: Theme.of(context).colorScheme.background,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_outlined,
                        ),
                      ),

                      const Text(
                        "Notes",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                       Row(
                         children: [
                           IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          "Upload Image",
                                          style: TextStyle(color:Colors.orange),
                                        ),
                                        content: CustomImagePicker(bloc),
                                      );
                                    });
                              },
                              icon: const Icon(
                                Icons.attach_file,
                                color: KColor.scaffold_bg,
                              )),
                           BlocBuilder<HomeBloc, HomeState>(bloc:bloc,
                               builder: (c,s){
                                 return Column(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Switch(
                                       value: s is NoteProtectedTrueState ? true : false,
                                       activeColor:Colors.orange,
                                       onChanged: (value) async {
                                         FocusKeyboard.dismissKeyboard();
                                         final isAvailable =
                                         await LocalAuthApi.hasBiometrics(context);
                                         final biometrics = await LocalAuthApi.getBiometrics();
                                         final hasFingerprint =
                                         biometrics.contains(BiometricType.fingerprint);

                                         if (value) {
                                           isLock = value ? 1 : 0;
                                           if (await LocalAuthApi.authenticate(context)) {
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
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            maxLines: null,
                            autofocus: true,
                            controller: titleController,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration.collapsed(
                              hintText: "Title",
                            ),
                            style: const TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: bodyController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: "Type something...",
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange)
                              ),
                              contentPadding: EdgeInsets.all(20.0),

                            ),
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          state is ImageUploadSuccess || bloc?.imagePicked != null
                              ? GestureDetector(
                              child: Image.file(
                                bloc!.imagePicked ?? "",
                                width: size.width*0.8,
                                height: size.height*0.3,
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
                              :Container()

                        ],
                      ),
                    ),
                  ),
                ]);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          if (titleController.text.isEmpty ||
              bodyController.text.isEmpty) {
            showEmptyTitleDialog(context);
          } else {
            FocusKeyboard.dismissKeyboard();

            if (editAble) {
              List<int> imageBinary = await bloc.fileToBase64String();

              bloc.add(EditSubmitEvent(NoteModel(
                  dbId: noteModel!.dbId,
                  title: titleController.text,
                  subTitle: bodyController.text,
                  isLock: isLock,
                  imageBinaryData: imageBinary)));
            } else {
              bloc.add(FormSubmitEvent(
                  titleController.text, bodyController.text, isLock));
            }

          }
        },
        label:  Text(editAble ? "Update" : "save"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}

void showEmptyTitleDialog(BuildContext context) {
  print("in dialog ");
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Text(
          "Notes is empty!",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'The content of the note cannot be empty to be saved.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Okay",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );

}
