import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/follow.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';
import 'package:lesson3/screen/oneprofile_screen.dart';
import 'package:lesson3/screen/pendingrequest_screen.dart';

class DisplayFollowerScreen extends StatefulWidget {
  static const routeName = '/displayFollowerScreen';
  @override
  State<StatefulWidget> createState() {
    return _DisplayFollowerState();
  }
}

class _DisplayFollowerState extends State<DisplayFollowerScreen> {
  _Controller ctrl;
  User user;
  Profile userProfile;
  List<Profile> profileList;
  List<Follow> pendingRequestList;
  bool notification;

  String sortOption;

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
    profileList ??= args[Constant.ARG_PROFILE_LIST];
    pendingRequestList ??= args[Constant.ARG_PENDING_REQUEST_LIST];
    notification ??= args["NOTIFICATION"];
    sortOption ??= args["sortOption"];
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            icon: Icon(Icons.sort),
            onSelected: ctrl.getSortOption,
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: Constant.SRC_SORT_BY_NAME_A_Z,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: sortOption == Constant.SRC_SORT_BY_NAME_A_Z
                          ? Colors.blue
                          : Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      Constant.SRC_SORT_BY_NAME_A_Z,
                      style: TextStyle(
                        color: sortOption == Constant.SRC_SORT_BY_NAME_A_Z
                            ? Colors.blue
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: Constant.SRC_SORT_BY_NAME_Z_A,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: sortOption == Constant.SRC_SORT_BY_NAME_Z_A
                          ? Colors.blue
                          : Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      Constant.SRC_SORT_BY_NAME_Z_A,
                      style: TextStyle(
                        color: sortOption == Constant.SRC_SORT_BY_NAME_Z_A
                            ? Colors.blue
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: Constant.SRC_SORT_BY_EMAIL_A_Z,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: sortOption == Constant.SRC_SORT_BY_EMAIL_A_Z
                          ? Colors.blue
                          : Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      Constant.SRC_SORT_BY_EMAIL_A_Z,
                      style: TextStyle(
                        color: sortOption == Constant.SRC_SORT_BY_EMAIL_A_Z
                            ? Colors.blue
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: Constant.SRC_SORT_BY_EMAIL_Z_A,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: sortOption == Constant.SRC_SORT_BY_EMAIL_Z_A
                          ? Colors.blue
                          : Colors.white,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      Constant.SRC_SORT_BY_EMAIL_Z_A,
                      style: TextStyle(
                        color: sortOption == Constant.SRC_SORT_BY_EMAIL_Z_A
                            ? Colors.blue
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        title: Text(
          'Followers',
          style: TextStyle(
            fontFamily: "Pacifico",
            fontSize: 30.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: RawMaterialButton(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    'See all requests',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.notifications,
                                    color: notification == false
                                        ? Colors.white
                                        : Colors.yellow,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () =>
                              ctrl.goToPendingRequestsList(), // goto Pending Request Page
                          elevation: 7.0,
                          fillColor: Colors.black,
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: profileList.length == 0
                ? Center(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'No follower',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: profileList.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey[700],
                            ),
                            child: ListTile(
                              leading: profileList[index].profilePhotoURL != null
                                  ? Container(
                                      width: 50.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                profileList[index].profilePhotoURL)),
                                      ),
                                    )
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
                              title: Text(profileList[index].name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  )),
                              trailing: Text(profileList[index].createdBy),
                              onTap: () => ctrl.goToProfile(profileList[index].createdBy),
                            ),
                          ),
                          Divider(
                            height: 10.0,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _DisplayFollowerState state;
  _Controller(this.state);

  void goToPendingRequestsList() async {
    try {
      state.pendingRequestList = await FirebaseController.getFollowerList(
          email: state.user.email, pendingStatus: true);
      var requestProfileList = <Profile>[];
      for (var p in state.pendingRequestList) {
        requestProfileList
            .add(await FirebaseController.getOneProfileDatabase(email: p.follower));
      }
      await Navigator.pushNamed(state.context, PendingRequestScreen.routeName,
          arguments: {
            Constant.ARG_USER: state.user,
            Constant.ARG_PENDING_REQUEST_LIST: state.pendingRequestList,
            "ARG_REQUEST_LIST": requestProfileList,
          });
      var followerList = await FirebaseController.getFollowerList(
          email: state.user.email, pendingStatus: false);

      var pList = <Profile>[];
      for (var p in followerList) {
        pList.add(await FirebaseController.getOneProfileDatabase(email: p.follower));
      }
      pList.sort((a, b) => a.name.compareTo(b.name));

      state.render(() {
        state.profileList = pList;
        state.notification = false;
      });
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Oops',
        content: '$e',
      );
    }
  }

  void goToProfile(String email) async {
    try {
      var prf = await FirebaseController.getOneProfileDatabase(email: email);
      Navigator.pushNamed(state.context, OneProfileScreen.routeName, arguments: {
        Constant.ARG_USER: state.user,
        Constant.ARG_ONE_PROFILE: prf,
      });
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Oops',
        content: '$e',
      );
    }
  }

  void getSortOption(String src) async {
    try {
      if (src == Constant.SRC_SORT_BY_NAME_A_Z) {
        state.sortOption = Constant.SRC_SORT_BY_NAME_A_Z;
        state.render(() => state.profileList.sort((a, b) => a.name.compareTo(b.name)));
      }
      if (src == Constant.SRC_SORT_BY_NAME_Z_A) {
        state.sortOption = Constant.SRC_SORT_BY_NAME_Z_A;
        state.render(() => state.profileList.sort((a, b) => b.name.compareTo(a.name)));
      }
      if (src == Constant.SRC_SORT_BY_EMAIL_A_Z) {
        state.sortOption = Constant.SRC_SORT_BY_EMAIL_A_Z;
        state.render(
            () => state.profileList.sort((a, b) => a.createdBy.compareTo(b.createdBy)));
      }
      if (src == Constant.SRC_SORT_BY_EMAIL_Z_A) {
        state.sortOption = Constant.SRC_SORT_BY_EMAIL_Z_A;
        state.render(
            () => state.profileList.sort((a, b) => b.createdBy.compareTo(a.createdBy)));
      }
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Oops',
        content: '$e',
      );
    }
  }
}
