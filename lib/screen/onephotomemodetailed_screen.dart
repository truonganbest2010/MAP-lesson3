import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
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
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('\'s PhotoMemo'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
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
                    right: 15.0,
                    bottom: 0.0,
                    child: RaisedButton(
                      elevation: 7.0,
                      onPressed: () {},
                      child: Icon(Icons.thumb_up),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: commentList.length == 0
                      ? Center(
                          child: Text(
                            'No comment',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        )
                      : getCommentList(commentList, context),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 5.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Comment',
                                ),
                                autocorrect: true,
                                validator: Comment.validateComment,
                                onSaved: ctrl.saveComment,
                                controller: commentTextField,
                              ),
                            ),
                            FlatButton(
                              onPressed: ctrl.submit,
                              child: Icon(Icons.send),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
}

Widget getCommentList(List<Comment> commentList, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var c in commentList)
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Card(
                color: Colors.black,
                elevation: 7.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${c.comment}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        '${c.timestamp}',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5.0),
          ],
        )
    ],
  );
}
