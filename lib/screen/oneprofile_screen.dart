import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

import 'addprofilephoto_screen.dart';

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
    profile ??= args[Constant.ARG_ONE_PROFILE];
    return Scaffold(
      // appBar: AppBar(
      //   actions: [],
      //   title: Text('Profile'),
      // ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 50.0),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            elevation: 7.0,
                            fillColor: Colors.black,
                            child: Icon(Icons.arrow_back), // Back
                            padding: EdgeInsets.all(10.0),
                            shape: CircleBorder(),
                          ),
                          profile.createdBy == user.email
                              ? Positioned(
                                  right: 0.0,
                                  top: 0.0,
                                  child: RawMaterialButton(
                                    onPressed: () async {
                                      ctrl.toggleEdit();
                                    },
                                    elevation: 7.0,
                                    fillColor:
                                        editToggle == true ? Colors.green : Colors.black,
                                    child: editToggle == true
                                        ? Icon(Icons.check)
                                        : Icon(Icons.edit), // Save/Edit
                                    padding: EdgeInsets.all(10.0),
                                    shape: CircleBorder(),
                                  ),
                                )
                              : SizedBox(
                                  width: 1.0,
                                ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10.0),
                                  Text(
                                    'Profile',
                                    style: TextStyle(
                                      fontFamily: "Pacifico",
                                      fontSize: 30.0,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  profile.profilePhotoURL != null
                                      ? Container(
                                          width: 190.0,
                                          height: 190.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    profile.profilePhotoURL)),
                                          ))
                                      : Container(
                                          width: 190.0,
                                          height: 190.0,
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
                                  Text(
                                    profile.name,
                                    style: TextStyle(
                                      fontFamily: "Pacifico",
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                          ),
                          profile.createdBy == user.email
                              ? Positioned(
                                  right: MediaQuery.of(context).size.width * 0.2,
                                  bottom: 50.0,
                                  child: Container(
                                    child: PopupMenuButton<String>(
                                      color: Colors.grey[800],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(30.0))),
                                      icon: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[700],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.settings,
                                            size: 30.0,
                                          ),
                                        ),
                                      ),
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
                                                    Icon(Icons.delete),
                                                    Text(' Remove Photo'),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 1.0,
                                ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      profile.createdBy == user.email
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RawMaterialButton(
                                      onPressed: () {},
                                      elevation: 7.0,
                                      fillColor: Colors.black,
                                      child: Text('Follower'), // Follower
                                      padding:
                                          EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
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
                                      child: Text('Following'), // Following
                                      padding:
                                          EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(width: 1.0),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 20.0,
                color: Colors.black,
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: editToggle == true
                        ? TextFormField(
                            initialValue: profile.bioDescription == null
                                ? ''
                                : profile.bioDescription,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height * 0.1,
                                left: 20.0,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),

                              hintText: profile.bioDescription == null
                                  ? 'Insert Bio'
                                  : profile.bioDescription,
                              fillColor:
                                  Colors.grey[900], // Theme.of(context).backgroundColor,
                              filled: true,
                            ),
                            autocorrect: true,
                            enabled: editToggle,
                            onSaved: ctrl.saveBio,
                          )
                        : Container(
                            margin: EdgeInsets.all(8.0),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.4,
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
                            child: profile.bioDescription == null
                                ? Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      'No Bio Description',
                                      style: TextStyle(
                                        fontFamily: "Pacifico",
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      profile.bioDescription,
                                      style: TextStyle(
                                        fontFamily: "Pacifico",
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  )),
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
  _OneProfileState state;
  _Controller(this.state);

  void profilePhotoSetting(String src) async {
    try {
      if (src == Constant.SRC_SELECT_PROFILE_PHOTO) {
        await Navigator.pushNamed(state.context, AddProfilePhotoScreen.routeName,
            arguments: {
              Constant.ARG_USER: state.user,
              Constant.ARG_ONE_PROFILE: state.profile,
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
        await FirebaseController.deleteProfilePic(state.profile);
        Navigator.pop(context);
        state.render(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Remove Profile Photo?"),
      // content: Text("Would you like to continue learning how to use Flutter alerts?"),
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

  void saveBio(String value) {
    if (value.length == 0)
      state.profile.bioDescription = null;
    else
      state.profile.bioDescription = value;
  }

  void toggleEdit() async {
    state.formKey.currentState.save();
    if (state.editToggle == true) {
      await FirebaseController.updateProfile(state.profile);
    }
    state.editToggle = !state.editToggle;
    state.render(() {});
  }
}
