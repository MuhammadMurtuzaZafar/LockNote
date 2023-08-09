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

CustomAlertDialog({required context,required message,required void Function() done}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Message", style: Theme.of(context).textTheme.subtitle1),
      content: const Text("Do You Want To Delete Item ?"),
      actions: [

        MaterialButton(
          onPressed: () {
            FocusKeyboard.dismissKeyboard();
            Navigator.pop(context);
          },
          child: const Text("No"),
        ),
        MaterialButton(
          onPressed: done,
          child: const Text("Yes"),
        ),
      ],
    ),
  );
}
