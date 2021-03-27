import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

class AddProfilePhotoScreen extends StatefulWidget {
  static const routeName = '/addProfilePhotoScreen';
  @override
  State<StatefulWidget> createState() {
    return _AddProfilePhotoState();
  }
}

class _AddProfilePhotoState extends State<AddProfilePhotoScreen> {
  _Controller ctrl;
  User user;
  Profile profile;
  File photo;
  String progressMessage;

  @override
  void initState() {
    super.initState();
    ctrl = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    profile ??= args[Constant.ARG_PROFILE];
    return Scaffold(
        // appBar: AppBar(
        //   actions: [],
        // ),
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                // borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: ListTile(
                title: Text(Constant.SRC_CAMERA),
                trailing: Icon(Icons.photo_camera),
                onTap: ctrl.getCameraPhoto,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                // borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              child: ListTile(
                title: Text(Constant.SRC_GALLERY),
                trailing: Icon(Icons.photo_library),
                onTap: ctrl.getLibraryPhoto,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: photo == null
                ? SizedBox(height: 1.0)
                : AspectRatio(
                    aspectRatio: 487 / 451,
                    child: Container(
                      child: Image.file(
                        photo,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
          ),
          photo == null
              ? SizedBox(height: 1.0)
              : Column(
                  children: [
                    SizedBox(height: 30.0),
                    Center(
                      child: RawMaterialButton(
                        onPressed: ctrl.submit,
                        elevation: 7.0,
                        fillColor: Colors.black,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 35.0,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 5.0),
          Center(
            child: RawMaterialButton(
              onPressed: () => Navigator.pop(context),
              elevation: 7.0,
              fillColor: Colors.black,
              child: Icon(
                Icons.arrow_back,
                color: Colors.red,
                size: 35.0,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    ));
  }
}

class _Controller {
  _AddProfilePhotoState state;
  _Controller(this.state);

  void getCameraPhoto() async {
    try {
      PickedFile _imageFile;
      var _picker = ImagePicker();
      _imageFile = await _picker.getImage(source: ImageSource.camera);
      if (_imageFile == null) return;
      state.render(() => state.photo = File(_imageFile.path));
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Oops',
        content: '$e',
      );
    }
  }

  void getLibraryPhoto() async {
    try {
      PickedFile _imageFile;
      var _picker = ImagePicker();
      _imageFile = await _picker.getImage(source: ImageSource.gallery);
      if (_imageFile == null) return;
      state.render(() => state.photo = File(_imageFile.path));
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Oops',
        content: '$e',
      );
    }
  }

  void submit() async {
    try {
      MyDialog.circularProgressStart(state.context);
      Map photoInfo = await FirebaseController.uploadProfilePicFile(
          photo: state.photo,
          uid: state.user.uid,
          listener: (double progress) {
            state.render(() {
              if (progress == null)
                state.progressMessage = null;
              else {
                progress *= 100;
                state.progressMessage = 'Uploading: ' + progress.toStringAsFixed(1) + '%';
              }
            });
          });

      state.profile.profilePhotoFilename = photoInfo[Constant.ARG_FILENAME];
      state.profile.profilePhotoURL = photoInfo[Constant.ARG_DOWNLOADURL];
      await FirebaseController.updateProfile(state.profile);
      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Upload photo failed!',
        content: '$e',
      );
    }
  }
}
