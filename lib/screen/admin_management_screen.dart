import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/model/report.dart';

import 'myView/myDialog.dart';

class AdminManagementScreen extends StatefulWidget {
  static const routeName = 'adminManagementScreen';
  @override
  State<StatefulWidget> createState() {
    return _AdminManagementState();
  }
}

class _AdminManagementState extends State<AdminManagementScreen> {
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
        title: Text('Admin Management'),
        actions: [],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5.0,
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    userProfile.profilePhotoURL != null
                        ? Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(userProfile.profilePhotoURL)),
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
                    Container(
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(userProfile.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.red[400]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Admin',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RawMaterialButton(
                      onPressed: () => ctrl.addAdminUser(),
                      elevation: 7.0,
                      fillColor: Colors.black,
                      child: Icon(Icons.add_box),
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    SizedBox(width: 5.0),
                    RawMaterialButton(
                      onPressed: () => ctrl.showReport(),
                      elevation: 7.0,
                      fillColor: Colors.black,
                      child: Icon(Icons.flag),
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 10.0,
            color: Colors.black,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var p in profileList)
                    Column(
                      children: [
                        profileList.length == 0
                            ? Center(
                                child: Text('No user found!'),
                              )
                            : p.createdBy == user.email
                                ? SizedBox(width: 1.0)
                                : Container(
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
                                                      image: NetworkImage(
                                                          p.profilePhotoURL)),
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
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.name,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text(
                                              p.createdBy,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: p.admin == true
                                                ? Colors.red[400]
                                                : Colors.blue[500],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: p.admin == true
                                                ? Text(
                                                    'Admin',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15.0,
                                                    ),
                                                  )
                                                : Text('User',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0,
                                                    )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Controller {
  _AdminManagementState state;
  _Controller(this.state);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email, password, passwordConfirm;
  String passwordErrorMessage;
  Profile tempProfile = Profile();
  List<Report> reportList;

  void addAdminUser() async {
    showDialog(
      context: state.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Admin Account'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 5.0, top: 50.0, right: 20.0, bottom: 20.0),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Name',
                              ),
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              validator: tempProfile.validateName,
                              onSaved: saveName,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              validator: validateEmail,
                              onSaved: saveEmail,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Password',
                              ),
                              obscureText: true,
                              autocorrect: false,
                              validator: validatePassword,
                              onSaved: savePassword,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Password confirm',
                              ),
                              obscureText: true,
                              autocorrect: false,
                              validator: validatePassword,
                              onSaved: savePasswordConfirm,
                            ),
                            passwordErrorMessage == null
                                ? SizedBox(height: 1.0)
                                : Text(
                                    passwordErrorMessage,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.0,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  elevation: 7.0,
                  fillColor: Colors.black,
                  child: Icon(Icons.arrow_back),
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                ),
                RawMaterialButton(
                  onPressed: () {
                    createAccount(setState);
                  },
                  elevation: 7.0,
                  fillColor: Colors.black,
                  child: Icon(Icons.check),
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void createAccount(setState) async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();

    setState(() => passwordErrorMessage = null);
    formKey.currentState.save();

    if (password != passwordConfirm) {
      state.render(() => passwordErrorMessage = 'passwords do not match');
      return;
    }
    MyDialog.circularProgressStart(state.context);

    try {
      Map<String, dynamic> updateCInfo = {};
      var commentList =
          await FirebaseController.getAllCommentList(email: state.user.email);
      for (var c in commentList) {
        var tempC = c.grantedPermission;
        tempC.add(email);
        updateCInfo[Comment.GRANTED_PERMISSION] = tempC;
        await FirebaseController.updateComment(c.commentId, updateCInfo);
      }

      Map<String, dynamic> updatePInfo = {};
      var photoMemoList =
          await FirebaseController.getAllPhotoMemoList(email: state.user.email);
      for (var p in photoMemoList) {
        var tempP = p.grantedPermission;
        tempP.add(email);
        updatePInfo[PhotoMemo.GRANTED_PERMISSION] = tempP;
        await FirebaseController.updatePhotoMemos(p.docId, updatePInfo);
      }

      await FirebaseController.createAccount(email: email, password: password);
      tempProfile.createdBy = email;
      tempProfile.admin = true;
      await FirebaseController.createProfile(tempProfile);

      MyDialog.circularProgressStop(state.context);
      showDialog(
        context: state.context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Admin User Added'),
          content: Text(''),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.button,
                ))
          ],
        ),
      );
      formKey.currentState.reset();
      state.profileList =
          await FirebaseController.getProfileList(email: state.user.email);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);

      MyDialog.info(context: state.context, title: 'Cannot create', content: '$e');
    }
  }

  void saveName(String value) {
    tempProfile.name = value;
  }

  String validateEmail(String value) {
    if (value.contains('@') && value.contains('.'))
      return null;
    else
      return 'Invalid email';
  }

  void saveEmail(String value) {
    email = value;
  }

  String validatePassword(String value) {
    if (value.length < 6)
      return 'Too short';
    else
      return null;
  }

  void savePassword(String value) {
    password = value;
  }

  void savePasswordConfirm(String value) {
    passwordConfirm = value;
  }

  void showReport() async {
    try {
      reportList = await FirebaseController.getReport();
      // print(reportList.length);
      showDialog(
        context: state.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Report Review'),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: reportList.length == 0
                        ? Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                  color: Colors.black),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'No report found',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 15.0,
                              ),
                              for (var r in reportList)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(30.0)),
                                        shape: BoxShape.rectangle,
                                        color: Colors.black,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ListTile(
                                          title: Text(
                                            r.report.length > 15
                                                ? r.report.substring(0, 15) + '...'
                                                : r.report,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'ID: ${r.photoMemoId}',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              Text('Time: ${r.timestamp}',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                  )),
                                            ],
                                          ),
                                          onTap: () => showPhotoMemoReport(r),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                  ),
                ),
                actions: [
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 7.0,
                    fillColor: Colors.black,
                    child: Icon(Icons.arrow_back),
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Failed',
        content: '$e',
      );
    }
  }

  void showPhotoMemoReport(Report r) async {
    try {
      PhotoMemo p = await FirebaseController.getPhotoMemoByDocId(r.photoMemoId);
      // print(p.photoURL);
      showDialog(
        context: state.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text(
                      'ID: ${p.docId}',
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Created by: ${p.createdBy}',
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[500],
                          ),
                          child: Container(
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: Image.network(
                                  p.photoURL,
                                  fit: BoxFit.fitWidth,
                                )),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.grey[700],
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.all(
                                      10.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Title: ${p.title}',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '${p.memo}',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[500],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.grey[700],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Report Feedback:',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(r.report,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                actions: [
                  RawMaterialButton(
                    onPressed: () async {
                      try {
                        await FirebaseController.discardReport(r);
                      } catch (e) {
                        MyDialog.info(
                          context: state.context,
                          title: 'Failed',
                          content: '$e',
                        );
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                      showReport();
                    },
                    elevation: 7.0,
                    fillColor: Colors.blue,
                    child: Text(
                      'Discard',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.0),
                    ),
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      Map<String, dynamic> updateInfo = {};
                      updateInfo[PhotoMemo.SUSPENDED_STATUS] = true;
                      updateInfo[PhotoMemo.SHARED_WITH] = [];
                      updateInfo[PhotoMemo.SHARED_WITH_ALL_FOLLOWERS] = false;
                      await FirebaseController.updatePhotoMemos(
                          r.photoMemoId, updateInfo);
                      await FirebaseController.removeAllReportOfAPhotoMemo(p);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      showReport();
                    },
                    elevation: 7.0,
                    fillColor: Colors.yellow,
                    child: Icon(
                      Icons.warning,
                      color: Colors.red,
                    ),
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 7.0,
                    fillColor: Colors.black,
                    child: Icon(Icons.subdirectory_arrow_left),
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    shape: CircleBorder(),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Failed',
        content: '$e',
      );
    }
  }
}
