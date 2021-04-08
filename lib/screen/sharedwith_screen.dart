import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shared With Me',
          style: TextStyle(
            fontFamily: "Pacifico",
            fontSize: 25.0,
          ),
        ),
        actions: [],
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
                          trailing: RawMaterialButton(
                            onPressed: () {},
                            elevation: 7.0,
                            fillColor: Colors.black,
                            child: Icon(Icons.flag),
                            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            shape: CircleBorder(),
                          ),
                          title: Text(photoMemoList[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
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
                                Text(photoMemoList[index].memo.length >= 15
                                    ? photoMemoList[index].memo.substring(0, 15) + '...'
                                    : photoMemoList[index].memo),
                                Text('Created By: ${photoMemoList[index].createdBy}'),
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

  void seeOnePhotoMemo(int index) async {
    try {
      List<Comment> commentList = await FirebaseController.getCommentList(
          photomemoId: state.photoMemoList[index].docId);

      List<Profile> commentOwner = <Profile>[];
      for (var c in commentList) {
        Profile p = await FirebaseController.getOneProfileDatabase(email: c.createdBy);
        commentOwner.add(p);
      }
      Profile p = await FirebaseController.getOneProfileDatabase(
          email: state.photoMemoList[index].createdBy);

      await Navigator.pushNamed(state.context, OnePhotoMemoDetailedScreen.routeName,
          arguments: {
            Constant.ARG_USER: state.user,
            Constant.ARG_ONE_PROFILE: state.userProfile,
            Constant.ARG_ONE_PHOTOMEMO: state.photoMemoList[index],
            Constant.ARG_COMMENTLIST: commentList,
            "PHOTO_MEMO_OWNER": p.name,
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
}
