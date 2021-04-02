import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/signIn_screen.dart';

import 'myView/myDialog.dart';

class DeleteAccountScreen extends StatefulWidget {
  static const routeName = '/deleteAccountScreen';
  @override
  State<StatefulWidget> createState() {
    return _DeleteAccountState();
  }
}

class _DeleteAccountState extends State<DeleteAccountScreen> {
  _Controller ctrl;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  User user;
  Profile userProfile;
  List<PhotoMemo> photoMemoList;
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
    photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('Delete account'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Enter your password'),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
                autocorrect: false,
                validator: ctrl.validatePassword,
                onSaved: ctrl.savePassword,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password confirm',
                ),
                obscureText: true,
                autocorrect: false,
                validator: ctrl.validatePassword,
                onSaved: ctrl.savePasswordConfirm,
              ),
              ctrl.passwordErrorMessage == null
                  ? SizedBox(height: 1.0)
                  : Text(
                      ctrl.passwordErrorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                      ),
                    ),
              SizedBox(height: 10.0),
              RawMaterialButton(
                onPressed: ctrl.deleteAccount,
                elevation: 7.0,
                fillColor: Colors.black,
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.button,
                ),
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
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
  _DeleteAccountState state;
  _Controller(this.state);
  String password, passwordConfirm;

  String passwordErrorMessage;

  void deleteAccount() async {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();

    state.render(() => passwordErrorMessage = null);
    state.formKey.currentState.save();

    if (password != passwordConfirm) {
      state.render(() => passwordErrorMessage = 'passwords do not match');
      return;
    }
    showDialog(
      context: state.context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Bye!'),
        content: Text('See you soon.'),
        actions: [
          FlatButton(
              onPressed: () async {
                Navigator.pushNamed(state.context, SignInScreen.routeName);
                try {
                  await FirebaseController.deleteAnAccount(
                      email: state.user.email,
                      password: password,
                      p: state.userProfile,
                      photoMemoList: state.photoMemoList);
                } catch (e) {
                  MyDialog.info(
                    context: state.context,
                    title: 'Cannot delete',
                    content: '$e',
                  );
                }
              },
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.button,
              ))
        ],
      ),
    );
  }

  String validatePassword(String value) {
    if (value.length < 6)
      return '';
    else
      return null;
  }

  void savePassword(String value) {
    password = value;
  }

  void savePasswordConfirm(String value) {
    passwordConfirm = value;
  }
}
