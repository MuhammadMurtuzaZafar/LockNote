import 'package:flutter/material.dart';

class FocusKeyboard {
  static void dismissKeyboard() {
    return FocusManager.instance.primaryFocus?.unfocus();
  }

  static void dismissKeyboardOnTap(BuildContext context) {
    FocusScopeNode? currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}