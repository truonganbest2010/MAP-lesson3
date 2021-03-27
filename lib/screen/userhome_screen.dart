import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';
import 'package:lesson3/screen/myView/myimage.dart';
import 'package:lesson3/screen/settings_screen.dart';
import 'package:lesson3/screen/sharedwith_screen.dart';

import 'addphotomemo_screen.dart';
import 'detailedview_screen.dart';
import 'onephotomemodetailed_screen.dart';
import 'oneprofile_screen.dart';

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
    profile ??= args[Constant.ARG_PROFILE];
    photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];

    return WillPopScope(
      onWillPop: () => Future.value(false), // Android 's back button disabled
      child: Scaffold(
        appBar: AppBar(
          // title: Text('User Home'),
          actions: [
            con.delIndex != null
                ? IconButton(icon: Icon(Icons.cancel), onPressed: con.cancelDelete)
                : Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            fillColor: Theme.of(context).backgroundColor,
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
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: con.search,
                  ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture: FlatButton(
                    minWidth: 200.0,
                    child: profile.profilePhotoURL == null
                        ? Icon(Icons.person, size: 40.0)
                        : MyImage.network(
                            url: profile.profilePhotoURL,
                            context: context,
                          ),
                    onPressed: () async {
                      await Navigator.pushNamed(context, OneProfileScreen.routeName,
                          arguments: {
                            Constant.ARG_USER: user,
                            Constant.ARG_PROFILE: profile,
                          });
                      render(() {});
                    },
                  ),
                  accountName: Text('Hi, ' + profile.name),
                  accountEmail: Text(user.email)),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Shared With Me'),
                onTap: con.sharedWithMe,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.pushNamed(context, SettingsScreen.routeName, arguments: {
                    Constant.ARG_USER: user,
                    Constant.ARG_PROFILE: profile,
                  });
                }, // con.settings,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: con.signOut,
              ),
            ],
          ),
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
                itemBuilder: (BuildContext context, int index) => Card(
                  elevation: 7.0,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        color: con.delIndex != null && con.delIndex == index
                            ? Theme.of(context).highlightColor
                            : Theme.of(context).scaffoldBackgroundColor,
                        child: ListTile(
                          leading: MyImage.network(
                            url: photoMemoList[index].photoURL,
                            context: context,
                          ),
                          trailing: Icon(Icons.keyboard_arrow_right),
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
                                Text('ID: ${photoMemoList[index].docId}'),
                              ],
                            ),
                          ),
                          onTap: () => con.onTap(index),
                          onLongPress: () => con.onLongPress(index),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                              onPressed: () {},
                              child: Icon(Icons.thumb_up),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FlatButton(
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
                              child: Icon(Icons.message),
                            ),
                          ),
                        ],
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
  _UserHomeState state;
  _Controller(this.state);
  int delIndex;
  String keyString;

  void signOut() async {
    try {
      await FirebaseController.signOut();
    } catch (e) {
      // do nothing
    }

    Navigator.of(state.context).pop(); // pop the drawer
    Navigator.of(state.context).pop(); // pop user home screen
  }

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
      var commentList = await FirebaseController.getCommentList(photomemoId: p.docId);
      for (var c in commentList) await FirebaseController.deleteComment(c);

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

  void sharedWithMe() async {
    try {
      List<PhotoMemo> photoMemoList =
          await FirebaseController.getPhotoMemoSharedWithMe(email: state.user.email);
      // for (var i in photoMemoList) {
      //   print(i.docId);
      // }

      await Navigator.pushNamed(state.context, SharedWithScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_PHOTOMEMOLIST: photoMemoList,
      });
      Navigator.pop(state.context);
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'get Shared PhotoMemo error',
        content: '$e',
      );
    }
  }

  void saveSearchKeyString(String value) {
    keyString = value;
  }

  void search() async {
    state.formKey.currentState.save();
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
}
