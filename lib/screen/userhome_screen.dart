import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/myView/myimage.dart';

import 'addphotomemo_screen.dart';
import 'detailedview_screen.dart';

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
    return WillPopScope(
      onWillPop: () => Future.value(false), // Android 's back button disabled
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Home'),
          actions: [],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  accountName: Text(user.displayName ?? 'N/A'),
                  accountEmail: Text(user.email)),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: con.signOut,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: con.addButton,
        ),
        body: photoMemoList.length == 0
            ? Text(
                'No PhotoMemos Found!',
                style: Theme.of(context).textTheme.headline5,
              )
            : ListView.builder(
                itemCount: photoMemoList.length,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  leading: MyImage.network(
                    url: photoMemoList[index].photoURL,
                    context: context,
                  ),
                  title: Text(photoMemoList[index].title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(photoMemoList[index].memo.length >= 20
                          ? photoMemoList[index].memo.substring(0, 20) + '...'
                          : photoMemoList[index].memo),
                      Text('Created By: ${photoMemoList[index].createdBy}'),
                      Text('Created By: ${photoMemoList[index].sharedWith}'),
                      Text('Created By: ${photoMemoList[index].timestamp}'),
                    ],
                  ),
                  onTap: () => con.onTap(index),
                ),
              ),
      ),
    );
  }
}

class _Controller {
  _UserHomeState state;
  _Controller(this.state);

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
    await Navigator.pushNamed(
      state.context,
      DetailedViewScreen.routeName,
      arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_ONE_PHOTOMEMO: state.photoMemoList[index]
      },
    );
  }
}
