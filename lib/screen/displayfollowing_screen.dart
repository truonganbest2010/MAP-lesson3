import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/follow.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';
import 'package:lesson3/screen/oneprofile_screen.dart';

class DisplayFollowingScreen extends StatefulWidget {
  static const routeName = '/displayFollowingScreen';
  @override
  State<StatefulWidget> createState() {
    return _DisplayFollowingState();
  }
}

class _DisplayFollowingState extends State<DisplayFollowingScreen> {
  _Controller ctrl;
  User user;
  Profile userProfile;
  List<Profile> profileList;

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

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
        title: Text(
          'Following',
          style: TextStyle(
            fontFamily: "Pacifico",
            fontSize: 30.0,
          ),
        ),
      ),
      body: Column(
        children: [
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
                          'No following',
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
  _DisplayFollowingState state;
  _Controller(this.state);

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
}
