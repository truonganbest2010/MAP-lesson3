import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/follow.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

import 'myView/myimage.dart';

class DetailedViewScreen extends StatefulWidget {
  static const routeName = '/detailedViewScreen';
  @override
  State<StatefulWidget> createState() {
    return _DetailedViewState();
  }
}

class _DetailedViewState extends State<DetailedViewScreen> {
  _Controller con;
  User user;
  PhotoMemo onePhotoMemoOriginal;
  PhotoMemo onePhotoMemoTemp;
  bool editMode = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String progressMessage;

  String sharedWithOption;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    onePhotoMemoOriginal ??= args[Constant.ARG_ONE_PHOTOMEMO];
    onePhotoMemoTemp ??= PhotoMemo.clone(onePhotoMemoOriginal);
    if (onePhotoMemoTemp.sharedWithMyFollowers == true) {
      sharedWithOption = Constant.SRC_FOLLOWERS;
    } else if (onePhotoMemoTemp.sharedWithMyFollowers == false) {
      if (onePhotoMemoTemp.sharedWith.isEmpty) {
        sharedWithOption = Constant.SRC_ONLY_ME;
      } else
        sharedWithOption = Constant.SRC_ONLY_WITH;
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          editMode
              ? IconButton(
                  icon: Icon(Icons.check),
                  onPressed: con.update,
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: con.edit,
                ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: con.photoFile == null
                        ? MyImage.network(
                            url: onePhotoMemoTemp.photoURL,
                            context: context,
                          )
                        : Image.file(
                            con.photoFile,
                            fit: BoxFit.fill,
                          ),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.black,
                      ),
                      child: PopupMenuButton<String>(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        icon: Icon(Icons.menu),
                        enabled: editMode,
                        onSelected: con.getPhoto,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: Constant.SRC_CAMERA,
                            child: Row(
                              children: [
                                Icon(Icons.photo_camera),
                                SizedBox(width: 10.0),
                                Text(Constant.SRC_CAMERA),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: Constant.SRC_GALLERY,
                            child: Row(
                              children: [
                                Icon(Icons.photo_album),
                                SizedBox(width: 10.0),
                                Text(Constant.SRC_GALLERY),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              progressMessage == null
                  ? SizedBox(height: 1.0)
                  : Text(
                      progressMessage,
                      style: Theme.of(context).textTheme.headline6,
                    ),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                  child: TextFormField(
                    enabled: editMode,
                    style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(
                      hintText: 'Enter title',
                    ),
                    initialValue: onePhotoMemoTemp.title,
                    autocorrect: true,
                    validator: PhotoMemo.validateTitle,
                    onSaved: con.saveTitle,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                  child: TextFormField(
                    enabled: editMode,
                    style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(
                      hintText: 'Enter memo',
                    ),
                    initialValue: onePhotoMemoTemp.memo,
                    autocorrect: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    validator: PhotoMemo.validateMemo,
                    onSaved: con.saveMemo,
                  ),
                ),
              ),
              // TextFormField(
              //   enabled: editMode,
              //   style: Theme.of(context).textTheme.headline6,
              //   decoration: InputDecoration(
              //     hintText: 'Enter Shared With (email list)',
              //   ),
              //   initialValue: onePhotoMemoTemp.sharedWith.join(','),
              //   autocorrect: true,
              //   keyboardType: TextInputType.multiline,
              //   maxLines: 2,
              //   validator: PhotoMemo.validateSharedWith,
              //   onSaved: con.saveSharedWith,
              // ),
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text('Share With:'),
                      ),
                      Expanded(
                        flex: 4,
                        child: Row(
                          children: [
                            Text(sharedWithOption),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: PopupMenuButton<String>(
                            enabled: editMode,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            icon: sharedWithOption == Constant.SRC_FOLLOWERS
                                ? Icon(Icons.public)
                                : sharedWithOption == Constant.SRC_ONLY_WITH
                                    ? Icon(Icons.group)
                                    : sharedWithOption == Constant.SRC_ONLY_ME
                                        ? Icon(Icons.lock)
                                        : Icon(Icons.menu),
                            onSelected: con.getSharedWith,
                            itemBuilder: (context) => <PopupMenuEntry<String>>[
                              PopupMenuItem(
                                value: Constant.SRC_FOLLOWERS,
                                child: Row(
                                  children: [
                                    Icon(Icons.public),
                                    SizedBox(width: 10.0),
                                    Text(Constant.SRC_FOLLOWERS),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: Constant.SRC_ONLY_WITH,
                                child: Row(
                                  children: [
                                    Icon(Icons.group),
                                    SizedBox(width: 10.0),
                                    Text(Constant.SRC_ONLY_WITH),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: Constant.SRC_ONLY_ME,
                                child: Row(
                                  children: [
                                    Icon(Icons.lock),
                                    SizedBox(width: 10.0),
                                    Text(Constant.SRC_ONLY_ME),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Constant.DEV
                  ? Text(
                      'Image Labels generated by ML',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  : SizedBox(
                      height: 1.0,
                    ),
              Constant.DEV
                  ? Text(onePhotoMemoTemp.imageLables.join('  |  '))
                  : SizedBox(
                      height: 1.0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _DetailedViewState state;
  _Controller(this.state);
  File photoFile; // cam or gallery

  List<String> sharedWithList = <String>[];

  Map<String, bool> tempFollowerMap = {};

  void update() async {
    if (!state.formKey.currentState.validate()) return;

    state.formKey.currentState.save();
    // state.render(() => state.editMode = false);

    try {
      MyDialog.circularProgressStart(state.context);
      Map<String, dynamic> updateInfo = {};
      if (photoFile != null) {
        Map photoInfo = await FirebaseController.uploadPhotoFile(
          photo: photoFile,
          filename: state.onePhotoMemoTemp.photoFilename,
          uid: state.user.uid,
          listener: (double message) {
            state.render(() {
              if (message == null)
                state.progressMessage = null;
              else {
                message *= 100;
                state.progressMessage = 'Uploading: ' + message.toStringAsFixed(1) + ' %';
              }
            });
          },
        );

        state.onePhotoMemoTemp.photoURL = photoInfo[Constant.ARG_DOWNLOADURL];
        state.render(() => state.progressMessage == 'ML image labeler started');
        List<dynamic> labels =
            await FirebaseController.getImageLabels(photoFile: photoFile);
        state.onePhotoMemoTemp.imageLables = labels;

        updateInfo[PhotoMemo.PHOTO_URL] = photoInfo[Constant.ARG_DOWNLOADURL];
        updateInfo[PhotoMemo.IMAGE_LABELS] = labels;
      }

      // determine updated fields
      if (state.onePhotoMemoOriginal.title != state.onePhotoMemoTemp.title) {
        updateInfo[PhotoMemo.TITLE] = state.onePhotoMemoTemp.title;
      }
      if (state.onePhotoMemoOriginal.memo != state.onePhotoMemoTemp.memo) {
        updateInfo[PhotoMemo.MEMO] = state.onePhotoMemoTemp.memo;
      }
      if (!listEquals(
          state.onePhotoMemoOriginal.sharedWith, state.onePhotoMemoTemp.sharedWith)) {
        updateInfo[PhotoMemo.SHARED_WITH] = state.onePhotoMemoTemp.sharedWith;
      }
      if (state.onePhotoMemoOriginal.sharedWithMyFollowers !=
          state.onePhotoMemoTemp.sharedWithMyFollowers) {
        updateInfo[PhotoMemo.SHARED_WITH_ALL_FOLLOWERS] =
            state.onePhotoMemoTemp.sharedWithMyFollowers;
      }

      updateInfo[PhotoMemo.TIMESTAMP] = DateTime.now();
      await FirebaseController.updatePhotoMemos(state.onePhotoMemoTemp.docId, updateInfo);

      state.onePhotoMemoOriginal.assign(state.onePhotoMemoTemp);
      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
          context: state.context, title: 'Update PhotoMemo error', content: '$e');
    }
  }

  void edit() {
    state.render(() => state.editMode = true);
  }

  void getPhoto(String src) async {
    try {
      PickedFile _photoFile;
      if (src == Constant.SRC_CAMERA) {
        _photoFile = await ImagePicker().getImage(source: ImageSource.camera);
      } else {
        _photoFile = await ImagePicker().getImage(source: ImageSource.gallery);
      }
      if (_photoFile == null) return; // selection canceled
      state.render(() => photoFile = File(_photoFile.path));
    } catch (e) {
      MyDialog.info(context: state.context, title: 'Get Photo error', content: '$e');
    }
  }

  void getSharedWith(String src) async {
    try {
      List<Follow> followerList = await FirebaseController.getFollowerList(
          email: state.user.email, pendingStatus: false);
      List<Profile> profile = <Profile>[];
      for (var p in followerList) {
        profile.add(await FirebaseController.getOneProfileDatabase(email: p.follower));
      }

      if (src == Constant.SRC_FOLLOWERS) {
        state.render(() => state.sharedWithOption = Constant.SRC_FOLLOWERS);

        sharedWithList.clear();
        for (var f in followerList) {
          sharedWithList.add(f.follower);
        }
        state.render(() {
          state.onePhotoMemoTemp.sharedWith = sharedWithList;
          state.onePhotoMemoTemp.sharedWithMyFollowers = true;
        });
      }
      if (src == Constant.SRC_ONLY_WITH) {
        if (tempFollowerMap.length != followerList.length) {
          for (var f in followerList) {
            if (state.onePhotoMemoOriginal.sharedWith.contains(f.follower)) {
              tempFollowerMap[f.follower] = true;
            } else
              tempFollowerMap[f.follower] = false;
          }
        }
        showDialog(
          context: state.context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('Only With ...'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var f in followerList)
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: profile[followerList.indexOf(f)].profilePhotoURL !=
                                        null
                                    ? Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  profile[followerList.indexOf(f)]
                                                      .profilePhotoURL)),
                                        ),
                                      )
                                    : Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                        ),
                                      ),
                              ),
                              Expanded(
                                flex: 4,
                                child: CheckboxListTile(
                                  title: Text(profile[followerList.indexOf(f)].name),
                                  value: tempFollowerMap[f.follower],
                                  activeColor: Colors.blue,
                                  checkColor: Colors.white,
                                  onChanged: (value) {
                                    setState(() {
                                      tempFollowerMap[f.follower] = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      elevation: 7.0,
                      fillColor: Colors.black,
                      child: Icon(Icons.arrow_back),
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        sharedWithList.clear();
                        tempFollowerMap.forEach((key, value) {
                          if (value == true) {
                            sharedWithList.add(key);
                          }
                        });
                        if (sharedWithList.length == 0) {
                          MyDialog.info(
                            context: context,
                            title: 'No user added',
                            content: 'Choose users to share your photo memo',
                          );

                          state.render(() {
                            state.onePhotoMemoTemp.sharedWith = sharedWithList;
                            state.onePhotoMemoTemp.sharedWithMyFollowers = false;
                          });
                        } else {
                          state.render(() {
                            state.onePhotoMemoTemp.sharedWith = sharedWithList;
                            state.onePhotoMemoTemp.sharedWithMyFollowers = false;
                          });
                          Navigator.pop(context);
                        }
                      },
                      elevation: 7.0,
                      fillColor: Colors.black,
                      child: Icon(Icons.check),
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ],
                );
              },
            );
          },
        );
      }
      if (src == Constant.SRC_ONLY_ME) {
        sharedWithList.clear();

        state.render(() {
          state.onePhotoMemoTemp.sharedWith = sharedWithList;
          state.onePhotoMemoTemp.sharedWithMyFollowers = false;
        });
      }
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Oops',
        content: '$e',
      );
    }
  }

  void saveTitle(String value) {
    state.onePhotoMemoTemp.title = value;
  }

  void saveMemo(String value) {
    state.onePhotoMemoTemp.memo = value;
  }

  // void saveSharedWith(String value) {
  //   if (value.trim().length != 0) {
  //     state.onePhotoMemoTemp.sharedWith =
  //         value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
  //   }
  // }
}
