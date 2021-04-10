import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/follow.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

class AddPhotoMemoScreen extends StatefulWidget {
  static const routeName = '/addPhotoMemoScreen';
  @override
  State<StatefulWidget> createState() {
    return _AddPhotoMemoState();
  }
}

class _AddPhotoMemoState extends State<AddPhotoMemoScreen> {
  _Controller con;
  User user;
  List<PhotoMemo> photoMemoList;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File photo;
  String progressMessage;

  String sharedWithOption = Constant.SRC_ONLY_ME;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    con.tempMemo.sharedWithMyFollowers = false;
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(icon: Icon(Icons.check), onPressed: con.save)],
        title: Text('Add Photo Memo'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: photo == null
                            ? Icon(
                                Icons.photo_library,
                                size: 300.0,
                              )
                            : Image.file(
                                photo,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    Positioned(
                      right: 20.0,
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
                          onSelected: con.getPhoto,
                          itemBuilder: (context) => <PopupMenuEntry<String>>[
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
                    ),
                  ],
                ),
                progressMessage == null
                    ? SizedBox(
                        height: 1.0,
                      )
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
                      decoration: InputDecoration(
                        hintText: 'Title',
                      ),
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
                      decoration: InputDecoration(
                        hintText: 'Memo',
                      ),
                      autocorrect: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      validator: PhotoMemo.validateMemo,
                      onSaved: con.saveMemo,
                    ),
                  ),
                ),
                // TextFormField(
                //   decoration: InputDecoration(
                //     hintText: 'ShareWith (comma separated email list)',
                //   ),
                //   autocorrect: false,
                //   keyboardType: TextInputType.emailAddress,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AddPhotoMemoState state;
  _Controller(this.state);
  PhotoMemo tempMemo = PhotoMemo();
  List<String> sharedWithList = <String>[];

  Map<String, bool> tempFollowerMap = {};

  void save() async {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();

    MyDialog.circularProgressStart(state.context);
    try {
      Map photoInfo = await FirebaseController.uploadPhotoFile(
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

      // image labels by ML
      state.render(() => state.progressMessage = 'ML Image Labeler Started!');
      List<dynamic> imageLabels =
          await FirebaseController.getImageLabels(photoFile: state.photo);
      state.render(() => state.progressMessage = null);

      // granted permission for admin
      List<Profile> profileList =
          await FirebaseController.getProfileList(email: state.user.email);
      List<dynamic> grantedPermissionList = <dynamic>[];
      for (var p in profileList) {
        if (p.admin == true) {
          grantedPermissionList.add(p.createdBy);
        }
      }

      //
      tempMemo.photoFilename = photoInfo[Constant.ARG_FILENAME];
      tempMemo.photoURL = photoInfo[Constant.ARG_DOWNLOADURL];
      tempMemo.timestamp = DateTime.now();
      tempMemo.createdBy = state.user.email;
      tempMemo.sharedWith = sharedWithList;
      tempMemo.imageLables = imageLabels;
      tempMemo.grantedPermission = grantedPermissionList;
      String docId = await FirebaseController.addPhotoMemo(tempMemo);
      tempMemo.docId = docId;
      state.photoMemoList.insert(0, tempMemo);

      Profile p = await FirebaseController.getOneProfileDatabase(email: state.user.email);
      p.commentsCount.putIfAbsent(docId, () => null);
      await FirebaseController.updateProfile(p);
      MyDialog.circularProgressStop(state.context);
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Save PhotoMemo Error',
        content: '$e',
      );
    }
  }

  void getPhoto(String src) async {
    try {
      PickedFile _imageFile;
      var _picker = ImagePicker();
      if (src == Constant.SRC_CAMERA) {
        _imageFile = await _picker.getImage(source: ImageSource.camera);
      } else {
        _imageFile = await _picker.getImage(source: ImageSource.gallery);
      }
      if (_imageFile == null) return;
      state.render(() => state.photo = File(_imageFile.path));
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Failed to get photo',
        content: '$e',
      );
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
        tempMemo.sharedWithMyFollowers = true;
        sharedWithList.clear();
        for (var f in followerList) {
          sharedWithList.add(f.follower);
        }
      }
      if (src == Constant.SRC_ONLY_WITH) {
        tempMemo.sharedWithMyFollowers = false;
        if (tempFollowerMap.length == 0) {
          for (var f in followerList) {
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
                          state.render(
                              () => state.sharedWithOption = Constant.SRC_ONLY_ME);
                        } else {
                          state.render(
                              () => state.sharedWithOption = Constant.SRC_ONLY_WITH);
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
        tempMemo.sharedWithMyFollowers = false;
        sharedWithList.clear();
        state.render(() => state.sharedWithOption = Constant.SRC_ONLY_ME);
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
    tempMemo.title = value;
  }

  void saveMemo(String value) {
    tempMemo.memo = value;
  }

  // void saveSharedWith(String value) {
  //   if (value.trim().length != 0) {
  //     tempMemo.sharedWith = value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
  //   }
  // }
}
