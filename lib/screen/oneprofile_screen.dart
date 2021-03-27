import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

import 'addprofilephoto_screen.dart';
import 'myView/myimage.dart';

class OneProfileScreen extends StatefulWidget {
  static const routeName = '/oneProfileScreen';
  @override
  State<StatefulWidget> createState() {
    return _OneProfileState();
  }
}

class _OneProfileState extends State<OneProfileScreen> {
  _Controller ctrl;
  User user;
  Profile profile;

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
    profile ??= args[Constant.ARG_PROFILE];
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          Center(
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: profile.profilePhotoURL == null
                        ? Container(
                            margin: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 200.0,
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              child: MyImage.network(
                                url: profile.profilePhotoURL,
                                context: context,
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  right: 30.0,
                  bottom: 30.0,
                  child: Container(
                    child: PopupMenuButton<String>(
                      icon: Icon(Icons.settings),
                      onSelected: ctrl.profilePhotoSetting,
                      itemBuilder: (context) => <PopupMenuEntry<String>>[
                        (profile.profilePhotoURL == null)
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
                                    Icon(Icons.remove),
                                    Text(' Delete Profile Photo'),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.0),
        ],
      ),
    );
  }
}

class _Controller {
  _OneProfileState state;
  _Controller(this.state);

  void profilePhotoSetting(String src) async {
    try {
      if (src == Constant.SRC_SELECT_PROFILE_PHOTO) {
        await Navigator.pushNamed(state.context, AddProfilePhotoScreen.routeName,
            arguments: {
              Constant.ARG_USER: state.user,
              Constant.ARG_PROFILE: state.profile,
            });
      } else if (src == Constant.SRC_REMOVE_PROFILE_PHOTO) {
        await FirebaseController.deleteProfilePic(state.profile);
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
}
