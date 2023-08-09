import 'dart:developer';

import 'package:permission_handler/permission_handler.dart' as Per;

class PermissionHandler {


  static Future<void> requestPermission() async {
    await [
      Per.Permission.storage,
      Per.Permission.camera,
      Per.Permission.photos,
      // Per.Permission.phone,
    ].request();
  }

  static Future<bool> isGrantedOrNot() async {
    if (await Per.Permission.location.isDenied) {
      Per.PermissionStatus _status = await Per.Permission.location.request();
      if (_status.isDenied) {
        return false;
      }
    }
    if (await Per.Permission.storage.isDenied) {
      Per.PermissionStatus _status = await Per.Permission.storage.request();
      if (_status.isDenied) {
        return false;
      }
    } else if (await Per.Permission.camera.isDenied) {
      Per.PermissionStatus _status = await Per.Permission.camera.request();
      if (_status.isDenied) {
        return false;
      }
    }
    if (await Per.Permission.photos.isDenied) {
      Per.PermissionStatus _status = await Per.Permission.photos.request();
      if (_status.isDenied) {
        return false;
      }
    }
    // if (await Per.Permission.phone.isDenied) {
    //   Per.PermissionStatus _status = await Per.Permission.phone.request();
    //   if (_status.isDenied) {
    //     return false;
    //   }
    // }
    return true;
  }

  static Future<bool> isGrantedCameraPermission() async {
    Per.PermissionStatus _camerastatus = await Per.Permission.camera.request();
    Per.PermissionStatus _storagestatus =
    await Per.Permission.storage.request();
    Per.PermissionStatus _photos = await Per.Permission.photos.request();
    if (_camerastatus.isGranted &&
        _storagestatus.isGranted &&
        _photos.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}