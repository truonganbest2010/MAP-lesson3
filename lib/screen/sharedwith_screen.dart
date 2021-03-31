import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';
import 'package:lesson3/screen/onephotomemodetailed_screen.dart';

import 'myView/myimage.dart';

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
                    borderRadius: BorderRadius.all(Radius.circular(20)),
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
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    border: Border.all(color: Colors.black),
                    color: Colors.grey[700],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          shape: BoxShape.rectangle,
                          color: Colors.black,
                        ),
                        child: ListTile(
                          // Each item
                          leading: Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: NetworkImage(photoMemoList[index].photoURL)),
                              )),
                          // trailing: Icon(Icons.keyboard_arrow_right),
                          title: Text(photoMemoList[index].title,
                              style: Theme.of(context).textTheme.headline4),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(photoMemoList[index].memo.length >= 20
                                    ? photoMemoList[index].memo.substring(0, 20) + '...'
                                    : photoMemoList[index].memo),
                                Text('Created By: ${photoMemoList[index].createdBy}'),
                                Text('Shared With: ${photoMemoList[index].sharedWith}'),
                                Text('Time: ${photoMemoList[index].timestamp}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: RawMaterialButton(
                                onPressed: () {},
                                elevation: 7.0,
                                fillColor: Colors.black,
                                child: Icon(Icons.thumb_up),
                                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Expanded(
                              flex: 1,
                              child: RawMaterialButton(
                                onPressed: () => con.seeOnePhotoMemo(index),
                                elevation: 7.0,
                                fillColor: Colors.black,
                                child: Icon(Icons.message),
                                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
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

      List<String> ownerPhoto = <String>[];
      for (var c in commentList) {
        Profile p = await FirebaseController.getOneProfileDatabase(email: c.createdBy);
        ownerPhoto.add(p.profilePhotoURL);
      }
      Profile p = await FirebaseController.getOneProfileDatabase(
          email: state.photoMemoList[index].createdBy);

      await Navigator.pushNamed(state.context, OnePhotoMemoDetailedScreen.routeName,
          arguments: {
            Constant.ARG_USER: state.user,
            Constant.ARG_ONE_PHOTOMEMO: state.photoMemoList[index],
            Constant.ARG_COMMENTLIST: commentList,
            "PHOTO_MEMO_OWNER": p.name,
            "COMMENT_OWNER": ownerPhoto,
          });
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Comment List Load error',
        content: '$e',
      );
    }
  }
}
