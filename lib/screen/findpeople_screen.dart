import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/follow.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

class FindPeopleScreen extends StatefulWidget {
  static const routeName = '/findPeopleScreen';
  @override
  State<StatefulWidget> createState() {
    return _FindPeopleState();
  }
}

class _FindPeopleState extends State<FindPeopleScreen> {
  _Controller ctrl;
  User user;
  List<Profile> profileList;
  List<Follow> followerList;
  List<Follow> followingList;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ctrl = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    profileList ??= args[Constant.ARG_PROFILE_LIST];
    followerList ??= args[Constant.ARG_FOLLOWER_LIST];
    followingList ??= args[Constant.ARG_FOLLOWING_LIST];
    // print(followingList.length);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // appBar: AppBar(
        //   actions: [],
        // ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            bottom: 10.0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: RawMaterialButton(
                        onPressed: () => Navigator.pop(context),
                        elevation: 7.0,
                        fillColor: Colors.black,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text(
                        'Find People',
                        style: TextStyle(
                          fontFamily: "Pacifico",
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.0),
                                color: Colors.black,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0,
                                  right: 15.0,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'Search Email . . .',
                                        ),
                                        autocorrect: true,
                                        onSaved: ctrl.saveEmail,
                                        validator: ctrl.validateEmail,
                                        maxLines: 1,
                                        keyboardType: TextInputType.multiline,
                                      ),
                                    ),
                                    if (FocusScope.of(context).hasFocus == true)
                                      Expanded(
                                        flex: 1,
                                        child: RawMaterialButton(
                                          onPressed: ctrl.cancel,
                                          elevation: 7.0,
                                          child: Icon(
                                            Icons.highlight_off,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                          shape: CircleBorder(),
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
                            child: RawMaterialButton(
                              onPressed: ctrl.searchEmail,
                              elevation: 7.0,
                              fillColor: Colors.black,
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              padding: EdgeInsets.all(10.0),
                              shape: CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        profileList.length == 0
                            ? Center(
                                child: Text('No user found!'),
                              )
                            : getProfileList(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getProfileList(BuildContext context) {
    var tempFollowingList = {};
    followingList.forEach((f) {
      tempFollowingList[f.following] = f.pendingStatus;
    });
    return Column(
      children: [
        for (var p in profileList)
          Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.grey[700],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                    leading: p.profilePhotoURL != null
                        ? Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(p.profilePhotoURL)),
                            ))
                        : Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: Icon(
                              Icons.person,
                              size: 50,
                            ),
                          ),
                    title: Text(
                      p.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    trailing: p.createdBy == user.email
                        ? SizedBox(width: 1.0)
                        : tempFollowingList[p.createdBy] == null
                            ? RawMaterialButton(
                                onPressed: () async {
                                  ctrl.follow(p.createdBy);
                                },
                                elevation: 7.0,
                                fillColor: Colors.black,
                                child: Text('Follow'),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              )
                            : tempFollowingList[p.createdBy] == false
                                ? RawMaterialButton(
                                    onPressed: () async {
                                      ctrl.showUnfollowAlertDialog(context, p);
                                    },
                                    elevation: 7.0,
                                    fillColor: Colors.blue[300],
                                    child: Text(
                                      'Following',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)),
                                  )
                                : RawMaterialButton(
                                    onPressed: () => ctrl.unfollow(p.createdBy),
                                    elevation: 7.0,
                                    fillColor: Colors.green[500],
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
                                      child: Text('Request Pending'),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)),
                                  )),
              ))
      ],
    );
  }
}

class _Controller {
  _FindPeopleState state;
  _Controller(this.state);
  String searchKey;

  void follow(String followingEmail) async {
    try {
      var tempFollow = Follow();
      tempFollow.follower = state.user.email;
      tempFollow.following = followingEmail;
      tempFollow.pendingStatus = true;
      var id = await FirebaseController.follow(tempFollow);
      tempFollow.docId = id;
      state.followingList.insert(0, tempFollow);
      state.render(() {});
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Follow failed',
        content: '$e',
      );
    }
  }

  void unfollow(String followingEmail) async {
    try {
      await FirebaseController.unfollow(state.user.email, followingEmail);

      // state.followingList.removeWhere((f) => f == follow);
      state.followingList =
          await FirebaseController.getFollowingList(email: state.user.email);
      var photoMemoSharedWithMe =
          await FirebaseController.getPhotoMemoSharedWithMe(email: state.user.email);
      for (var p in photoMemoSharedWithMe) {
        if (p.sharedWith.contains(state.user.email)) {
          state.render(() => p.sharedWith.remove(state.user.email));
          Map<String, dynamic> updateInfo = {};
          updateInfo[PhotoMemo.SHARED_WITH] = p.sharedWith;
          await FirebaseController.updatePhotoMemos(p.docId, updateInfo);
        }
      }

      state.render(() {});
      print(state.followingList.length);
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Unfollow failed',
        content: '$e',
      );
    }
  }

  void cancel() async {
    state.formKey.currentState.reset();
    state.profileList =
        await FirebaseController.getProfileListForSearch(email: state.user.email);

    state.render(() {
      FocusScope.of(state.context).unfocus();
    });
  }

  void searchEmail() async {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();
    try {
      var result = <Profile>[];
      if (searchKey != "") {
        for (var p in state.profileList) {
          if (p.createdBy == searchKey) {
            result.add(p);
          }
        }
      } else {
        result =
            await FirebaseController.getProfileListForSearch(email: state.user.email);
      }

      state.render(() => state.profileList = result);
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Search error',
        content: '$e',
      );
    }
    state.render(() {});
  }

  void saveEmail(String value) {
    searchKey = value;
  }

  String validateEmail(String value) {
    if (value == null || value.trim().length == 0) return null;
    if (value.contains('@') && value.contains('.'))
      return null;
    else
      return '';
  }

  showUnfollowAlertDialog(BuildContext context, Profile p) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        unfollow(p.createdBy);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Unfollow ${p.name}?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
