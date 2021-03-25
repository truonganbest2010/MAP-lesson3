import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

import 'myView/myimage.dart';

class SharedWithDetailedScreen extends StatefulWidget {
  static const routeName = "/sharedWithDetailedScreen";
  @override
  State<StatefulWidget> createState() {
    return _SharedWithDetailedState();
  }
}

class _SharedWithDetailedState extends State<SharedWithDetailedScreen> {
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
        child: SingleChildScrollView(
          child: Column(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 10.0),
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
              commentList.length == 0
                  ? Text(
                      'No comment',
                      style: Theme.of(context).textTheme.headline5,
                    )
                  : getCommentList(commentList, context),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SharedWithDetailedState state;
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
    children: [
      SizedBox(height: 10.0),
      for (var c in commentList)
        Card(
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
        )
    ],
  );
}
