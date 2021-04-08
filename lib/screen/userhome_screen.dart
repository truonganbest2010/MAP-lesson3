import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

import 'addphotomemo_screen.dart';
import 'detailedview_screen.dart';
import 'onephotomemodetailed_screen.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = '/userHomeScreen';
  @override
  State<StatefulWidget> createState() {
    return _UserHomeState();
  }
}

class _UserHomeState extends State<UserHomeScreen> {
  _Controller con;
  User user;
  List<PhotoMemo> photoMemoList;
  Profile userProfile;
  Map<dynamic, dynamic> commentsCount;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool editToggle = false;

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
    commentsCount ??= args[Constant.ARG_COMMENTS_COUNT];
    // print(profile.commentsCount);
    // print(commentsCount);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        editToggle = false;
        render(() => con.delIndex = null);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home',
              style: TextStyle(
                fontFamily: "Pacifico",
                fontSize: 30.0,
              )),
          actions: [
            con.delIndex != null
                ? IconButton(icon: Icon(Icons.cancel), onPressed: con.cancelDelete)
                : Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabled: editToggle,
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                            hintText: 'Search',
                            fillColor:
                                Colors.grey[900], // Theme.of(context).backgroundColor,
                            filled: true,
                          ),
                          autocorrect: true,
                          onSaved: con.saveSearchKeyString,
                        ),
                      ),
                    ),
                  ),
            con.delIndex != null
                ? IconButton(icon: Icon(Icons.delete), onPressed: con.delete)
                : editToggle == true
                    ? IconButton(
                        icon: Icon(Icons.check),
                        onPressed: con.search,
                      )
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: con.search,
                      ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: con.addButton,
        ),
        body: photoMemoList.length == 0
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'You haven\'t shared anything',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: photoMemoList.length,
                itemBuilder: (BuildContext context, int index) => Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      shape: BoxShape.rectangle,
                      color: con.delIndex != null && con.delIndex == index
                          ? Theme.of(context).highlightColor
                          : Colors.grey[900],
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                            shape: BoxShape.rectangle,
                            color: con.delIndex != null && con.delIndex == index
                                ? Theme.of(context).highlightColor
                                : Theme.of(context).scaffoldBackgroundColor,
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
                            trailing: IconButton(
                              onPressed: () => con.onTap(index),
                              icon: Icon(Icons.settings),
                            ),
                            title: Text(
                                photoMemoList[index].title.length > 10
                                    ? photoMemoList[index].title.substring(0, 10) + ' ...'
                                    : photoMemoList[index].title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                )),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  photoMemoList[index].sharedWithMyFollowers == true
                                      ? Icon(Icons.public)
                                      : photoMemoList[index].sharedWith.isEmpty
                                          ? Icon(Icons.lock)
                                          : Icon(Icons.group),
                                  SizedBox(height: 10.0),
                                  Text(photoMemoList[index].memo.length > 10
                                      ? photoMemoList[index].memo.substring(0, 10) +
                                          ' ...'
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
                            onTap: () => con.seePhotoMemo(index),
                            onLongPress: () => con.onLongPress(index),
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
                                            photoMemoList[index]
                                                .likeList
                                                .length
                                                .toString(),
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
                                  onPressed: () =>
                                      con.seePhotoMemo(index), // Check comment
                                  elevation: 7.0,
                                  fillColor: userProfile.commentsCount[
                                              photoMemoList[index].docId] ==
                                          null
                                      ? Colors.black
                                      : userProfile.commentsCount[
                                                  photoMemoList[index].docId] ==
                                              commentsCount[photoMemoList[index].docId]
                                          ? Colors.black
                                          : Colors.red,
                                  child: Icon(
                                    Icons.message,
                                    color: userProfile.commentsCount[
                                                photoMemoList[index].docId] ==
                                            null
                                        ? Colors.white
                                        : userProfile.commentsCount[
                                                    photoMemoList[index].docId] ==
                                                commentsCount[photoMemoList[index].docId]
                                            ? Colors.white
                                            : Colors.black,
                                  ),
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
      ),
    );
  }
}

class _Controller {
  _UserHomeState state;
  _Controller(this.state);
  int delIndex;
  String keyString;

  void addButton() async {
    await Navigator.pushNamed(
      state.context,
      AddPhotoMemoScreen.routeName,
      arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_PHOTOMEMOLIST: state.photoMemoList,
      },
    );
    state.userProfile =
        await FirebaseController.getOneProfileDatabase(email: state.user.email);
    state.render(() {});
  }

  void onTap(int index) async {
    if (delIndex != null) return;
    await Navigator.pushNamed(
      state.context,
      DetailedViewScreen.routeName,
      arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_ONE_PHOTOMEMO: state.photoMemoList[index]
      },
    );
    state.render(() {});
  }

  void onLongPress(int index) {
    if (delIndex != null) return;
    state.render(() => delIndex = index);
  }

  void cancelDelete() {
    state.render(() => delIndex = null);
  }

  void delete() async {
    MyDialog.circularProgressStart(state.context);
    try {
      PhotoMemo p = state.photoMemoList[delIndex];
      await FirebaseController.deletePhotoMemo(p);
      await FirebaseController.deleteComment(p.docId);
      state.userProfile.commentsCount.removeWhere((key, value) => key == p.docId);
      await FirebaseController.updateProfile(state.userProfile);

      state.render(() {
        state.photoMemoList.removeAt(delIndex);
        delIndex = null;
      });
      MyDialog.circularProgressStop(state.context);
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Delete PhotoMemo error',
        content: '$e',
      );
    }
  }

  void saveSearchKeyString(String value) {
    keyString = value;
  }

  void search() async {
    state.formKey.currentState.save();

    if (state.editToggle == true) {
      var keys = keyString.split(',').toList();
      List<String> searchKeys = [];

      for (var k in keys) {
        if (k.trim().isNotEmpty) searchKeys.add(k.trim().toLowerCase());
      }
      // print('$searchKey');
      try {
        List<PhotoMemo> results;
        if (searchKeys.isNotEmpty) {
          results = await FirebaseController.searchImage(
            createdBy: state.user.email,
            searchLabels: searchKeys,
          );
        } else {
          results = await FirebaseController.getPhotoMemoList(email: state.user.email);
        }
        state.render(() => state.photoMemoList = results);
      } catch (e) {
        MyDialog.info(context: state.context, title: 'Search error', content: '$e');
      }
    }
    state.editToggle = !state.editToggle;
    state.render(() {});
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

  void seePhotoMemo(int index) async {
    state.render(() => delIndex = null);
    try {
      var docId = state.photoMemoList[index].docId;
      var commentList = await FirebaseController.getCommentList(photomemoId: docId);
      var commentOwner = <Profile>[];
      for (var c in commentList) {
        Profile p = await FirebaseController.getOneProfileDatabase(email: c.createdBy);
        commentOwner.add(p);
      }
      state.userProfile.commentsCount[docId] = state.commentsCount[docId];

      await FirebaseController.updateProfile(state.userProfile);

      await Navigator.pushNamed(state.context, OnePhotoMemoDetailedScreen.routeName,
          arguments: {
            Constant.ARG_USER: state.user,
            Constant.ARG_ONE_PROFILE: state.userProfile,
            Constant.ARG_ONE_PHOTOMEMO: state.photoMemoList[index],
            Constant.ARG_COMMENTLIST: commentList,
            "PHOTO_MEMO_OWNER": state.userProfile.name,
            "COMMENT_OWNER": commentOwner,
          });

      state.photoMemoList =
          await FirebaseController.getPhotoMemoList(email: state.user.email);
      state.userProfile =
          await FirebaseController.getOneProfileDatabase(email: state.user.email);
      state.render(() {});
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Comment List Load error',
        content: '$e',
      );
    }
  }
}
