import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';
import 'package:lesson3/screen/myView/myimage.dart';

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
  Profile profile;
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
    profile ??= args[Constant.ARG_ONE_PROFILE];
    photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];

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
          child: Icon(Icons.add),
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
                          : Colors.black,
                      border: Border.all(color: Colors.black),
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
                            color: con.delIndex != null && con.delIndex == index
                                ? Theme.of(context).highlightColor
                                : Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: ListTile(
                            // Each item

                            leading: MyImage.network(
                              url: photoMemoList[index].photoURL,
                              context: context,
                            ),
                            trailing: IconButton(
                              onPressed: () => con.onTap(index),
                              icon: Icon(Icons.settings),
                            ),
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
                            onTap: () => con.checkComment(index),
                            onLongPress: () => con.onLongPress(index),
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
                                  onPressed: () =>
                                      con.checkComment(index), // Check comment
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

  void checkComment(int index) async {
    state.render(() => delIndex = null);
    try {
      List<Comment> commentList = await FirebaseController.getCommentList(
          photomemoId: state.photoMemoList[index].docId);

      await Navigator.pushNamed(state.context, OnePhotoMemoDetailedScreen.routeName,
          arguments: {
            Constant.ARG_USER: state.user,
            Constant.ARG_ONE_PHOTOMEMO: state.photoMemoList[index],
            Constant.ARG_COMMENTLIST: commentList,
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
