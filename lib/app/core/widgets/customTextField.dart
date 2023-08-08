import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? errorText;
  final String? hintText;
  final Function(String)? onChanged;

  CustomTextField(
      {required this.textEditingController,
      this.errorText,
      this.hintText,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: textEditingController,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            errorText: errorText,
            hintText: hintText),
        onChanged: onChanged);
  }
}
