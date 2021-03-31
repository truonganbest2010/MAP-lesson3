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
  PhotoMemo photoMemo;
  List<Comment> commentList;
  String photoMemoOwner;

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
    photoMemo ??= args[Constant.ARG_ONE_PHOTOMEMO];
    commentList ??= args[Constant.ARG_COMMENTLIST];
    photoMemoOwner ??= args["PHOTO_MEMO_OWNER"];
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
                          right: 0.0,
                          bottom: 0.0,
                          child: RawMaterialButton(
                            onPressed: () {},
                            elevation: 7.0,
                            fillColor: Colors.black,
                            child: Icon(Icons.thumb_up),
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    ),
                    Container(
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
                                Text('${photoMemo.title}',
                                    style: Theme.of(context).textTheme.headline5),
                                Text(photoMemo.timestamp.toString().substring(0, 16)),
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
                              child: Text(photoMemo.memo,
                                  style: Theme.of(context).textTheme.headline6),
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
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.black,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
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

  void submit() async {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();

    try {
      tempComment.timestamp = DateTime.now();
      tempComment.photoMemoId = state.photoMemo.docId;
      tempComment.createdBy = state.user.email;
      tempComment.sharedWith = state.photoMemo.createdBy;
      Profile p = await FirebaseController.getOneProfileDatabase(email: state.user.email);
      tempComment.profilePicURL = p.profilePhotoURL;
      String commentId = await FirebaseController.addComment(tempComment);
      tempComment.commentId = commentId;
      state.commentList.insert(0, tempComment);
      state.commentList =
          await FirebaseController.getCommentList(photomemoId: state.photoMemo.docId);

      state.render(() {
        clearText();
      });
    } catch (e) {
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
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.black,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: c.profilePicURL != null
                                    ? Container(
                                        width: 30.0,
                                        height: 30.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: NetworkImage(c.profilePicURL)),
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
                                flex: 7,
                                child: Column(
                                  children: [
                                    Text(
                                      '${c.comment}',
                                      // style: Theme.of(context).textTheme.headline6,
                                    ),
                                    SizedBox(height: 5.0),
                                  ],
                                ),
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
                          borderRadius: BorderRadius.circular(20.0),
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
