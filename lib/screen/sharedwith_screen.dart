import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/model/report.dart';
import 'package:lesson3/screen/myView/myDialog.dart';
import 'package:lesson3/screen/onephotomemodetailed_screen.dart';

class SharedWithScreen extends StatefulWidget {
  static const routeName = '/sharedWithScreen';
  @override
  State<StatefulWidget> createState() {
    return _SharedWithState();
  }
}

class _SharedWithState extends State<SharedWithScreen> {
  _Controller con;
  User user;
  Profile userProfile;
  List<PhotoMemo> photoMemoList;
  List<Profile> profileList;
  String sortOption;

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
    userProfile ??= args[Constant.ARG_ONE_PROFILE];
    photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];
    profileList ??= args[Constant.ARG_PROFILE_LIST];
    sortOption ??= args["sortOption"];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shared With Me',
          style: TextStyle(
            fontFamily: "Pacifico",
            fontSize: 25.0,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            icon: Icon(Icons.sort),
            onSelected: con.getSortOption,
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: Constant.SRC_SORT_NEWEST_POST_FIRST,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: sortOption == Constant.SRC_SORT_NEWEST_POST_FIRST
                          ? Colors.blue
                          : Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      Constant.SRC_SORT_NEWEST_POST_FIRST,
                      style: TextStyle(
                        color: sortOption == Constant.SRC_SORT_NEWEST_POST_FIRST
                            ? Colors.blue
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: Constant.SRC_SORT_OLDEST_POST_FIRST,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: sortOption == Constant.SRC_SORT_OLDEST_POST_FIRST
                          ? Colors.blue
                          : Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      Constant.SRC_SORT_OLDEST_POST_FIRST,
                      style: TextStyle(
                        color: sortOption == Constant.SRC_SORT_OLDEST_POST_FIRST
                            ? Colors.blue
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: Constant.SRC_SORT_POST_TO_ALL_FOLLOWERS,
                child: Row(
                  children: [
                    Icon(
                      Icons.public,
                      color: sortOption == Constant.SRC_SORT_POST_TO_ALL_FOLLOWERS
                          ? Colors.blue
                          : Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      Constant.SRC_SORT_POST_TO_ALL_FOLLOWERS,
                      style: TextStyle(
                        color: sortOption == Constant.SRC_SORT_POST_TO_ALL_FOLLOWERS
                            ? Colors.blue
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: Constant.SRC_SORT_POST_TO_A_GROUP,
                child: Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: sortOption == Constant.SRC_SORT_POST_TO_A_GROUP
                          ? Colors.blue
                          : Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      Constant.SRC_SORT_POST_TO_A_GROUP,
                      style: TextStyle(
                        color: sortOption == Constant.SRC_SORT_POST_TO_A_GROUP
                            ? Colors.blue
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: photoMemoList.length == 0
          ? Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.black),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Nothing\'s shared with you',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            )
          : ListView.builder(
              itemCount: photoMemoList.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    border: Border.all(color: Colors.black),
                    color: Colors.grey[900],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          shape: BoxShape.rectangle,
                          color: Colors.grey[800],
                        ),
                        child: ListTile(
                          // Each item
                          leading: Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(photoMemoList[index].photoURL)),
                              )),
                          trailing: userProfile.admin == true
                              ? SizedBox(width: 1.0)
                              : RawMaterialButton(
                                  onPressed: () => con.report(index),
                                  elevation: 7.0,
                                  fillColor: Colors.black,
                                  child: Icon(Icons.flag),
                                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                  shape: CircleBorder(),
                                ),
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                photoMemoList[index].sharedWithMyFollowers == true
                                    ? Icon(Icons.public)
                                    : photoMemoList[index].sharedWith.isEmpty
                                        ? Icon(Icons.lock)
                                        : Icon(Icons.group),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(profileList[index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    )),
                              ],
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(photoMemoList[index].title,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    )),
                                Text(photoMemoList[index].memo.length >= 15
                                    ? photoMemoList[index].memo.substring(0, 15) + '...'
                                    : photoMemoList[index].memo),
                                Text('Date: ' +
                                    photoMemoList[index]
                                        .timestamp
                                        .toString()
                                        .substring(5, 7) + // mm
                                    photoMemoList[index]
                                        .timestamp
                                        .toString()
                                        .substring(7, 10) + // dd
                                    '-' +
                                    photoMemoList[index]
                                        .timestamp
                                        .toString()
                                        .substring(0, 4)),
                              ],
                            ),
                          ),
                          onTap: () => con.seeOnePhotoMemo(index),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: RawMaterialButton(
                                onPressed:
                                    photoMemoList[index].likeList.contains(user.email)
                                        ? () => con.unlikePost(index)
                                        : () => con.likePost(index),
                                elevation: 7.0,
                                fillColor:
                                    photoMemoList[index].likeList.contains(user.email)
                                        ? Colors.blue
                                        : Colors.black,
                                child: Row(
                                  children: [
                                    Expanded(flex: 4, child: Icon(Icons.thumb_up)),
                                    Expanded(
                                        flex: 2,
                                        child: Text(
                                          photoMemoList[index].likeList.length.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        )),
                                  ],
                                ),
                                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Expanded(
                              flex: 1,
                              child: RawMaterialButton(
                                onPressed: () => con.seeOnePhotoMemo(index),
                                elevation: 7.0,
                                fillColor: Colors.black,
                                child: Icon(Icons.message),
                                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                          ],
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
  _SharedWithState state;
  _Controller(this.state);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String reportInput;

  void seeOnePhotoMemo(int index) async {
    try {
      List<Comment> commentList = await FirebaseController.getCommentList(
          photomemoId: state.photoMemoList[index].docId);

      List<Profile> commentOwner = <Profile>[];
      for (var c in commentList) {
        Profile p = await FirebaseController.getOneProfileDatabase(email: c.createdBy);
        commentOwner.add(p);
      }

      await Navigator.pushNamed(state.context, OnePhotoMemoDetailedScreen.routeName,
          arguments: {
            Constant.ARG_USER: state.user,
            Constant.ARG_ONE_PROFILE: state.userProfile,
            Constant.ARG_ONE_PHOTOMEMO: state.photoMemoList[index],
            Constant.ARG_COMMENTLIST: commentList,
            "PHOTO_MEMO_OWNER": state.profileList[index].name,
            "COMMENT_OWNER": commentOwner,
          });
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Comment List Load error',
        content: '$e',
      );
    }
  }

  void likePost(int index) async {
    try {
      var likeList =
          await FirebaseController.getLikeList(state.photoMemoList[index].docId);
      likeList.add(state.user.email);
      Map<String, dynamic> updateLike = {};
      updateLike[PhotoMemo.LIKE_LIST] = likeList;
      await FirebaseController.updatePhotoMemos(
          state.photoMemoList[index].docId, updateLike);
      state.render(
        () => state.photoMemoList[index].likeList.add(state.user.email),
      );
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Cant load',
        content: '$e',
      );
    }
  }

  void unlikePost(int index) async {
    try {
      var likeList =
          await FirebaseController.getLikeList(state.photoMemoList[index].docId);
      likeList.remove(state.user.email);
      Map<String, dynamic> updateLike = {};
      updateLike[PhotoMemo.LIKE_LIST] = likeList;
      await FirebaseController.updatePhotoMemos(
          state.photoMemoList[index].docId, updateLike);
      state.render(
        () => state.photoMemoList[index].likeList.remove(state.user.email),
      );
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Cant load',
        content: '$e',
      );
    }
  }

  void report(int index) {
    try {
      showDialog(
        context: state.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  'Report',
                  style: TextStyle(
                    fontFamily: "Pacifico",
                    fontSize: 30.0,
                  ),
                ),
                content: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: 5.0, top: 50.0, right: 20.0, bottom: 20.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(20.0),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(30.0),
                                      ),
                                    ),
                                    hintText: 'Feedback',

                                    fillColor: Colors
                                        .grey[900], // Theme.of(context).backgroundColor,
                                    filled: true,
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 10,
                                  autocorrect: true,
                                  validator: validateReport,
                                  onSaved: saveReport,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  RawMaterialButton(
                    onPressed: () => sendReport(index),
                    elevation: 7.0,
                    fillColor: Colors.black,
                    child: Text('Send'),
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Cant report',
        content: '$e',
      );
    }
  }

  void sendReport(int index) async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    try {
      Report tempReport = Report();
      tempReport.photoMemoId = state.photoMemoList[index].docId;
      tempReport.report = reportInput;
      tempReport.timestamp = DateTime.now();
      List<Profile> profileList =
          await FirebaseController.getProfileList(email: state.user.email);
      for (var p in profileList) {
        if (p.admin == true) {
          tempReport.grantedPermission.add(p.createdBy);
        }
      }
      await FirebaseController.createReport(tempReport);
      formKey.currentState.reset();
      showDialog(
        context: state.context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Thanks for letting us know!'),
          content: Text(''),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.button,
                ))
          ],
        ),
      );
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Failed',
        content: '$e',
      );
    }
  }

  String validateReport(String value) {
    if (value.length < 5)
      return 'add feedback';
    else
      return null;
  }

  void saveReport(String value) {
    reportInput = value;
  }

  void getSortOption(String src) async {
    try {
      MyDialog.circularProgressStart(state.context);
      if (src == Constant.SRC_SORT_NEWEST_POST_FIRST) {
        state.sortOption = Constant.SRC_SORT_NEWEST_POST_FIRST;
        List<PhotoMemo> photoMemoList = await FirebaseController.getPhotoMemoSharedWithMe(
            email: state.user.email, sortOption: Constant.SRC_SORT_NEWEST_POST_FIRST);
        List<Profile> profileList = <Profile>[];
        for (var pm in photoMemoList) {
          profileList
              .add(await FirebaseController.getOneProfileDatabase(email: pm.createdBy));
        }
        MyDialog.circularProgressStop(state.context);
        state.render(() {
          state.photoMemoList = photoMemoList;
          state.profileList = profileList;
        });
      }
      if (src == Constant.SRC_SORT_OLDEST_POST_FIRST) {
        state.sortOption = Constant.SRC_SORT_OLDEST_POST_FIRST;
        List<PhotoMemo> photoMemoList = await FirebaseController.getPhotoMemoSharedWithMe(
            email: state.user.email, sortOption: Constant.SRC_SORT_OLDEST_POST_FIRST);
        List<Profile> profileList = <Profile>[];
        for (var pm in photoMemoList) {
          profileList
              .add(await FirebaseController.getOneProfileDatabase(email: pm.createdBy));
        }
        MyDialog.circularProgressStop(state.context);
        state.render(() {
          state.photoMemoList = photoMemoList;
          state.profileList = profileList;
        });
      }
      if (src == Constant.SRC_SORT_POST_TO_ALL_FOLLOWERS) {
        state.sortOption = Constant.SRC_SORT_POST_TO_ALL_FOLLOWERS;
        List<PhotoMemo> photoMemoList = await FirebaseController.getPhotoMemoSharedWithMe(
            email: state.user.email, sortOption: Constant.SRC_SORT_POST_TO_ALL_FOLLOWERS);
        List<Profile> profileList = <Profile>[];
        for (var pm in photoMemoList) {
          profileList
              .add(await FirebaseController.getOneProfileDatabase(email: pm.createdBy));
        }
        MyDialog.circularProgressStop(state.context);
        state.render(() {
          state.photoMemoList = photoMemoList;
          state.profileList = profileList;
        });
      }
      if (src == Constant.SRC_SORT_POST_TO_A_GROUP) {
        state.sortOption = Constant.SRC_SORT_POST_TO_A_GROUP;
        List<PhotoMemo> photoMemoList = await FirebaseController.getPhotoMemoSharedWithMe(
            email: state.user.email, sortOption: Constant.SRC_SORT_POST_TO_A_GROUP);
        List<Profile> profileList = <Profile>[];
        for (var pm in photoMemoList) {
          profileList
              .add(await FirebaseController.getOneProfileDatabase(email: pm.createdBy));
        }
        MyDialog.circularProgressStop(state.context);
        state.render(() {
          state.photoMemoList = photoMemoList;
          state.profileList = profileList;
        });
      }
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Failed',
        content: '$e',
      );
    }
  }
}
