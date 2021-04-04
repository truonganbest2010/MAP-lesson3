import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/follow.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/displayfollowers_screen.dart';
import 'package:lesson3/screen/findpeople_screen.dart';
import 'package:lesson3/screen/settings_screen.dart';
import 'package:lesson3/screen/sharedwith_screen.dart';
import 'package:lesson3/screen/userhome_screen.dart';

import 'addprofilephoto_screen.dart';
import 'myView/myDialog.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScreen> {
  _Controller ctrl;
  User user;
  Profile userProfile;
  List<Follow> followingList;
  List<Follow> followerList;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool editToggle = false;
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
    userProfile ??= args[Constant.ARG_ONE_PROFILE];
    followingList ??= args[Constant.ARG_FOLLOWING_LIST];
    followerList ??= args[Constant.ARG_FOLLOWER_LIST];
    return WillPopScope(
      onWillPop: () => Future.value(false), // Android 's back button disabled
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                fontFamily: "Pacifico",
                fontSize: 30.0,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => ctrl.toggleEdit(),
              icon:
                  editToggle == true ? Icon(Icons.check) : Icon(Icons.edit), // Save/Edit
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture: userProfile.profilePhotoURL == null
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                              border: Border.all(color: Colors.white)),
                          child: Icon(Icons.person, size: 40.0))
                      : Container(
                          width: 200.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(userProfile.profilePhotoURL),
                            ),
                          ),
                        ),
                  accountName: Text(
                    'Hi, ' + userProfile.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  accountEmail: Text(user.email)),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () => ctrl.goToSetting(), // con.settings,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: ctrl.signOut,
              ),
            ],
          ),
        ),
        //=============// Main Body
        body: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 10.0),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          if (userProfile.admin == true)
                            Positioned(
                              right: 10.0,
                              top: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.black,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Admin',
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10.0),
                                userProfile.profilePhotoURL != null
                                    ? Container(
                                        width: 200.0,
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  userProfile.profilePhotoURL)),
                                        ))
                                    : Container(
                                        width: 200.0,
                                        height: 200.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 100,
                                        ),
                                      ),
                                SizedBox(height: 20.0),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 5.0,
                                    bottom: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[900],
                                  ),
                                  child: editToggle == true
                                      ? TextFormField(
                                          initialValue: userProfile.name,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(10.0),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                            filled: true,
                                          ),
                                          style: Theme.of(context).textTheme.headline5,
                                          keyboardType: TextInputType.name,
                                          maxLines: 1,
                                          enabled: editToggle,
                                          validator: userProfile.validateName,
                                          onSaved: ctrl.saveName,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            userProfile.name,
                                            style: Theme.of(context).textTheme.headline5,
                                          ),
                                        ),
                                ),
                                SizedBox(height: 10.0),
                              ],
                            ),
                          ),
                          Positioned(
                            right: MediaQuery.of(context).size.width * 0.3,
                            bottom: 90.0,
                            child: Container(
                              child: PopupMenuButton<String>(
                                color: Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0))),
                                icon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.settings,
                                    size: 30.0,
                                  ),
                                ),
                                onSelected: ctrl.profilePhotoSetting,
                                itemBuilder: (context) => <PopupMenuEntry<String>>[
                                  (userProfile.profilePhotoURL == null)
                                      ? PopupMenuItem(
                                          value: Constant.SRC_SELECT_PROFILE_PHOTO,
                                          child: Row(
                                            children: [
                                              Icon(Icons.add),
                                              Text(' Select Photo'),
                                            ],
                                          ),
                                        )
                                      : PopupMenuItem(
                                          value: Constant.SRC_REMOVE_PROFILE_PHOTO,
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete),
                                              Text(' Remove Photo'),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () => ctrl.goToDisplayFollower(),
                                elevation: 7.0,
                                fillColor: Colors.black,
                                child: Text('Follower  ${followerList.length}',
                                    style:
                                        Theme.of(context).textTheme.button), // Follower
                                padding: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: RawMaterialButton(
                                onPressed: () {},
                                elevation: 7.0,
                                fillColor: Colors.black,
                                child: Text('Following  ${followingList.length}',
                                    style:
                                        Theme.of(context).textTheme.button), // Following
                                padding: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 20.0,
                        color: Colors.black,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RawMaterialButton(
                              onPressed: ctrl.goToSharedWithMe,
                              elevation: 7.0,
                              fillColor: Colors.black,
                              child: Icon(Icons.public),
                              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            SizedBox(width: 5.0),
                            RawMaterialButton(
                              onPressed: ctrl.goToUserHome,
                              elevation: 7.0,
                              fillColor: Colors.black,
                              child: Icon(Icons.home),
                              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            SizedBox(width: 5.0),
                            RawMaterialButton(
                              onPressed: () async {
                                ctrl.goToFindPeople();
                              },
                              elevation: 7.0,
                              fillColor: Colors.black,
                              child: Icon(Icons.search),
                              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            if (userProfile.admin == true)
                              Row(
                                children: [
                                  SizedBox(width: 5.0),
                                  RawMaterialButton(
                                    onPressed: () {},
                                    elevation: 7.0,
                                    fillColor: Colors.black,
                                    child: Icon(Icons.insert_chart),
                                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Divider(
                        height: 1.0,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: editToggle == true
                            ? TextFormField(
                                initialValue: userProfile.bioDescription == null
                                    ? ''
                                    : userProfile.bioDescription,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(20.0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                  ),

                                  hintText: userProfile.bioDescription == null
                                      ? 'Insert Bio'
                                      : userProfile.bioDescription,
                                  fillColor: Colors
                                      .grey[900], // Theme.of(context).backgroundColor,
                                  filled: true,
                                ),
                                style: TextStyle(
                                  fontFamily: "Pacifico",
                                  fontSize: 20.0,
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 4,
                                autocorrect: true,
                                enabled: editToggle,
                                onSaved: ctrl.saveBio,
                              )
                            : Container(
                                margin: EdgeInsets.all(8.0),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.2,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: userProfile.bioDescription == null
                                    ? Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Center(
                                          child: Text(
                                            'No Bio Description',
                                            style: TextStyle(
                                              fontFamily: "Pacifico",
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          userProfile.bioDescription,
                                          style: TextStyle(
                                            fontFamily: "Pacifico",
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _HomeState state;
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

  void profilePhotoSetting(String src) async {
    try {
      if (src == Constant.SRC_SELECT_PROFILE_PHOTO) {
        await Navigator.pushNamed(state.context, AddProfilePhotoScreen.routeName,
            arguments: {
              Constant.ARG_USER: state.user,
              Constant.ARG_ONE_PROFILE: state.userProfile,
            });
      } else if (src == Constant.SRC_REMOVE_PROFILE_PHOTO) {
        await showDeleteAlertDialog(state.context);
      }
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Oops!',
        content: '$e',
      );
    }
    state.render(() {});
  }

  showDeleteAlertDialog(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () async {
        await FirebaseController.deleteProfilePic(state.userProfile);
        Navigator.pop(context);
        state.render(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove Profile Photo?"),
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

  void goToDisplayFollower() async {
    try {
      // get Pending Followers
      var followerList = await FirebaseController.getFollowerList(
          email: state.user.email, pendingStatus: true);
      var pendingRequestList = <Follow>[];
      for (var f in followerList) {
        {
          pendingRequestList.add(f);
        }
      }
      // get Followers
      followerList = await FirebaseController.getFollowerList(
          email: state.user.email, pendingStatus: false);
      var profileList = <Profile>[];
      for (var f in followerList) {
        profileList
            .add(await FirebaseController.getOneProfileDatabase(email: f.follower));
      }
      await Navigator.pushNamed(state.context, DisplayFollowerScreen.routeName,
          arguments: {
            Constant.ARG_USER: state.user,
            Constant.ARG_ONE_PROFILE: state.userProfile,
            Constant.ARG_PROFILE_LIST: profileList,
            Constant.ARG_PENDING_REQUEST_LIST: pendingRequestList,
          });
      state.followerList = await FirebaseController.getFollowerList(
          email: state.user.email, pendingStatus: false);
      state.render(() {});
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Oops',
        content: '$e',
      );
    }
  }

  void goToSharedWithMe() async {
    try {
      List<PhotoMemo> photoMemoList =
          await FirebaseController.getPhotoMemoSharedWithMe(email: state.user.email);

      await Navigator.pushNamed(state.context, SharedWithScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_PHOTOMEMOLIST: photoMemoList,
      });
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'get Shared PhotoMemo error',
        content: '$e',
      );
    }
    state.render(() {});
  }

  void goToUserHome() async {
    MyDialog.circularProgressStart(state.context);
    try {
      List<PhotoMemo> photoMemoList =
          await FirebaseController.getPhotoMemoList(email: state.user.email);
      var photoMemoIdList = <String>[];
      photoMemoList.forEach((p) {
        photoMemoIdList.add(p.docId);
      });
      Map<dynamic, dynamic> commentCounts =
          await FirebaseController.retriveCommentsCountOfPhotoMemoList(photoMemoIdList);

      await Navigator.pushNamed(state.context, UserHomeScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_PHOTOMEMOLIST: photoMemoList,
        Constant.ARG_ONE_PROFILE: state.userProfile,
        Constant.ARG_COMMENTS_COUNT: commentCounts,
      });
      MyDialog.circularProgressStop(state.context);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'get PhotoMemoList error',
        content: '$e',
      );
    }
    state.userProfile =
        await FirebaseController.getOneProfileDatabase(email: state.user.email);
    state.render(() {});
  }

  void goToFindPeople() async {
    MyDialog.circularProgressStart(state.context);
    try {
      List<Profile> profileList =
          await FirebaseController.getProfileListForSearch(email: state.user.email);

      await Navigator.pushNamed(state.context, FindPeopleScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_PROFILE_LIST: profileList,
        Constant.ARG_FOLLOWING_LIST: state.followingList,
        Constant.ARG_FOLLOWER_LIST: state.followerList,
      });
      MyDialog.circularProgressStop(state.context);
      state.followingList =
          await FirebaseController.getFollowingList(email: state.user.email);
      state.render(() {});
    } catch (e) {
      MyDialog.circularProgressStop(state.context);

      MyDialog.info(
        context: state.context,
        title: 'Failed',
        content: '$e',
      );
    }
  }

  void goToSetting() async {
    try {
      await Navigator.pushNamed(state.context, SettingsScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_ONE_PROFILE: state.userProfile,
      });
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Failed',
        content: '$e',
      );
    }
    state.render(() {});
  }

  void saveBio(String value) {
    if (value.length == 0)
      state.userProfile.bioDescription = null;
    else
      state.userProfile.bioDescription = value;
  }

  void saveName(String value) {
    state.userProfile.name = value;
  }

  void toggleEdit() async {
    if (!state.formKey.currentState.validate()) return;

    state.formKey.currentState.save();
    if (state.editToggle == true) {
      await FirebaseController.updateProfile(state.userProfile);
    }
    state.editToggle = !state.editToggle;
    state.render(() {});
  }
}
