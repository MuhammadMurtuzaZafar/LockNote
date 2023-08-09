import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features/home/bloc/home_bloc.dart';
import 'PermissionHandler.dart';
import 'constants.dart';

class CustomImagePicker extends StatelessWidget {
  var bloc;
   CustomImagePicker(this.bloc);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _getImageFromCamera(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Icon(Icons.camera,color: KColor.scaffold_bg),
                      ),
                    ),
                    Text("Camera")
                  ],
                ),
              ),
              const VerticalDivider(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _getImageFromGallery(context);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Icon(Icons.photo_camera_back_outlined,color: KColor.scaffold_bg),
                      ),
                    ),
                    const Text("Galllery")
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getImageFromCamera(context) async {

    try {
      await PermissionHandler.requestPermission();
      var status = await Permission.camera.status;
      if (status.isDenied) {
        SnackBarHelper.showSnackBar(context, "Please Give Permission First");
        return;
      }
      final _picker = ImagePicker();
      // PickedFile? imagePicked = await _picker.getImage(source: ImageSource.camera);
      XFile? imagePicked = await _picker.pickImage(
          source: ImageSource.camera, imageQuality: ConstantValues.IMG_QUALITY);

      if (imagePicked != null) {
        bloc.imagePicked = File(imagePicked.path);
        bloc.add(ImageUploadedEvent(true));
        print("Instance:" + imagePicked.path.toString());
      }
    } catch (e) {
      print("Exception:" + e.toString());
    }
  }

  _getImageFromGallery(context) async {
    try {
      await Permission.camera.request();
      var status = await Permission.camera.status;
      if (status.isDenied) {
        SnackBarHelper.showSnackBar(context, "Please Give Permission First");
        return;
      }

      final _picker = ImagePicker();
      XFile? imagePicked = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: ConstantValues.IMG_QUALITY);
      if (imagePicked != null) {
        bloc.imagePicked = File(imagePicked.path);
        bloc.add(ImageUploadedEvent(true));

      }
    } catch (e) {
      print("Exception:" + e.toString());
    }
  }
}
