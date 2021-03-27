import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
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
        title: Text('Shared With Me'),
        actions: [],
      ),
      body: photoMemoList.length == 0
          ? Text(
              'No PhotoMemos shared with me',
              style: Theme.of(context).textTheme.headline5,
            )
          : ListView.builder(
              itemCount: photoMemoList.length,
              itemBuilder: (context, index) => Column(
                children: [
                  SizedBox(height: 10.0),
                  RaisedButton(
                    color: Colors.black,
                    onPressed: () async {
                      try {
                        List<Comment> commentList =
                            await FirebaseController.getCommentList(
                                photomemoId: photoMemoList[index].docId);

                        await Navigator.pushNamed(
                            context, OnePhotoMemoDetailedScreen.routeName,
                            arguments: {
                              Constant.ARG_USER: user,
                              Constant.ARG_ONE_PHOTOMEMO: photoMemoList[index],
                              Constant.ARG_COMMENTLIST: commentList,
                            });
                      } catch (e) {
                        MyDialog.info(
                          context: context,
                          title: 'Comment List Load error',
                          content: '$e',
                        );
                      }
                    },
                    elevation: 7.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: MyImage.network(
                                url: photoMemoList[index].photoURL,
                                context: context,
                              ),
                            ),
                          ),
                          Text(
                            'Title: ${photoMemoList[index].title}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            'Memo: ${photoMemoList[index].memo}',
                          ),
                          Text(
                            'Created By: ${photoMemoList[index].createdBy}',
                          ),
                          Text(
                            'Update At: ${photoMemoList[index].timestamp}',
                          ),
                          Text(
                            'SharedWith: ${photoMemoList[index].sharedWith}',
                          ),
                          Text(
                            'ID: ${photoMemoList[index].docId}',
                            style: Theme.of(context).textTheme.headline6,
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
  _SharedWithState state;
  _Controller(this.state);
}
