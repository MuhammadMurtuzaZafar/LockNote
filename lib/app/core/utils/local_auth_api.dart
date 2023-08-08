import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes_app/app/core/utils/constants.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics(context) async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return await _auth.canCheckBiometrics || canAuthenticate;
    } on PlatformException catch (e) {
      SnackBarHelper.showSnackBar(context, e.message??"");

      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      return <BiometricType>[];
    }
  }

  static Future<bool> authenticate(BuildContext context) async {
    final isAvailable = await hasBiometrics(context);
    if (!isAvailable) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
          options: const AuthenticationOptions(biometricOnly: true,useErrorDialogs: true)
      );
    } on PlatformException catch (e) {
      print(e);
      SnackBarHelper.showSnackBar(context, e.message??"");
      return false;
    }
  }
}