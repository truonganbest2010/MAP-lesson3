import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

import 'myView/myimage.dart';

class OnePhotoMemoDetailedScreen extends StatefulWidget {
  static const routeName = "/sharedWithDetailedScreen";
  @override
  State<StatefulWidget> createState() {
    return _OnePhotoMemoDetailedState();
  }
}

class _OnePhotoMemoDetailedState extends State<OnePhotoMemoDetailedScreen> {
  _Controller ctrl;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  User user;
  Profile userProfile;
  PhotoMemo photoMemo;
  List<Comment> commentList;
  String photoMemoOwner;
  List<Profile> commentOwner;

  final commentTextField = TextEditingController();

  @override
  void initState() {
    super.initState();
    ctrl = _Controller(this);
  }

  void render(fn) => (setState(fn));

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    userProfile ??= args[Constant.ARG_ONE_PROFILE];
    photoMemo ??= args[Constant.ARG_ONE_PHOTOMEMO];
    commentList ??= args[Constant.ARG_COMMENTLIST];
    photoMemoOwner ??= args["PHOTO_MEMO_OWNER"];
    commentOwner ??= args["COMMENT_OWNER"];
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('$photoMemoOwner \'s PhotoMemo'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          formKey.currentState.reset();
        },
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: MyImage.network(
                              url: photoMemo.photoURL,
                              context: context,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10.0,
                          bottom: 0.0,
                          child: RawMaterialButton(
                            onPressed: () => ctrl.showWhomLiked(),
                            elevation: 7.0,
                            fillColor: Colors.black,
                            child: Text(
                              '${photoMemo.likeList.length.toString()} people liked this photo memo',
                              style:
                                  TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                            ),
                            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: RawMaterialButton(
                            onPressed: () {},
                            elevation: 7.0,
                            fillColor: Colors.black,
                            child: Icon(Icons.share),
                            padding: EdgeInsets.all(10.0),
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[800],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${photoMemo.title}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(// mm/dd/yyyy
                                    photoMemo.timestamp.toString().substring(5, 7) + // mm
                                        photoMemo.timestamp
                                            .toString()
                                            .substring(7, 10) + // dd
                                        '-' +
                                        photoMemo.timestamp
                                            .toString()
                                            .substring(0, 4) + // yyyy
                                        '   ' +
                                        photoMemo.timestamp.toString().substring(10, 16)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                photoMemo.memo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 20.0,
                      color: Colors.black,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            commentList.length == 0
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 40.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: Colors.black,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'No comment',
                                            style: Theme.of(context).textTheme.headline5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : ctrl.getCommentList(commentList, context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0, left: 10.0, right: 10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Divider(
                      height: 20.0,
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              color: Colors.black,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Type comment . . .',
                                ),
                                autocorrect: true,
                                validator: Comment.validateComment,
                                onSaved: ctrl.saveComment,
                                controller: commentTextField,
                                maxLines: 2,
                                keyboardType: TextInputType.multiline,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: RawMaterialButton(
                            onPressed: ctrl.submit,
                            elevation: 7.0,
                            fillColor: Colors.black,
                            child: Icon(
                              Icons.send,
                              color: Colors.blue[500],
                              size: 30.0,
                            ),
                            padding: EdgeInsets.only(
                              left: 15.0,
                            ),
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _OnePhotoMemoDetailedState state;
  _Controller(this.state);
  Comment tempComment = Comment();

  void showWhomLiked() async {
    if (state.photoMemo.likeList.length == 0) return;
    List<Profile> likedProfileList = <Profile>[];
    try {
      for (var email in state.photoMemo.likeList) {
        var p = await FirebaseController.getOneProfileDatabase(email: email);
        likedProfileList.add(p);
      }
    } catch (e) {
      MyDialog.info(context: state.context, title: 'Cant load', content: '$e');
    }

    showDialog(
      context: state.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Icon(Icons.thumb_up),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var p in likedProfileList)
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.grey,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: p.profilePhotoURL != null
                                      ? BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(p.profilePhotoURL)),
                                        )
                                      : BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                  child: p.profilePhotoURL != null
                                      ? SizedBox()
                                      : Icon(
                                          Icons.person,
                                          size: 40,
                                        )),
                            ),
                            Expanded(
                              flex: 2,
                              child: p.name == state.userProfile.name
                                  ? Text(
                                      '${p.name} (You)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                      ),
                                    )
                                  : Text(
                                      p.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                      ),
                                    ),
                            ),
                          ],
                        ),
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
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void submit() async {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();

    MyDialog.circularProgressStart(state.context);
    try {
      // granted permission for admin
      List<Profile> profileList =
          await FirebaseController.getProfileList(email: state.user.email);
      List<dynamic> grantedPermissionList = <dynamic>[];
      for (var p in profileList) {
        if (p.admin == true) {
          grantedPermissionList.add(p.createdBy);
        }
      }
      tempComment.grantedPermission = grantedPermissionList;
      tempComment.timestamp = DateTime.now();
      tempComment.photoMemoId = state.photoMemo.docId;
      tempComment.createdBy = state.user.email;
      tempComment.sharedWith = state.photoMemo.createdBy;
      String commentId = await FirebaseController.addComment(tempComment);
      tempComment.commentId = commentId;
      state.commentList.insert(0, tempComment);
      state.commentList =
          await FirebaseController.getCommentList(photomemoId: state.photoMemo.docId);

      List<Profile> cOwner = <Profile>[];
      for (var c in state.commentList) {
        Profile p = await FirebaseController.getOneProfileDatabase(email: c.createdBy);
        cOwner.add(p);
      }
      state.commentOwner = cOwner;
      MyDialog.circularProgressStop(state.context);
      state.render(() {
        clearText();
      });
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Submit Comment Error',
        content: '$e',
      );
    }
  }

  void saveComment(String value) {
    tempComment.comment = value;
  }

  void clearText() {
    state.commentTextField.clear();
  }

  Widget getCommentList(List<Comment> commentList, BuildContext context) {
    return Column(
      children: [
        for (var c in commentList)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: state.commentOwner[commentList.indexOf(c)]
                                                .profilePhotoURL !=
                                            null
                                        ? Container(
                                            width: 30.0,
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fitHeight,
                                                  image: NetworkImage(state
                                                      .commentOwner[
                                                          commentList.indexOf(c)]
                                                      .profilePhotoURL)),
                                            ))
                                        : Container(
                                            width: 30.0,
                                            height: 30.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey,
                                            ),
                                            child: Icon(
                                              Icons.person,
                                              size: 20,
                                            ),
                                          ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.commentOwner[commentList.indexOf(c)].name,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${c.comment}',
                                                // style: Theme.of(context).textTheme.headline6,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.grey,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${c.timestamp.toString().substring(0, 19)}',
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
            ],
          )
      ],
    );
  }
}
