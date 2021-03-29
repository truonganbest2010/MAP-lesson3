import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/home_screen.dart';
import 'package:lesson3/screen/myView/myDialog.dart';
import 'package:lesson3/screen/signup_screen.dart';
import 'package:lesson3/screen/userhome_screen.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = '/signInScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignInScreen> {
  _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sign In'),
      // ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          formKey.currentState.reset();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0, left: 15.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'PhotoMemo',
                        style: TextStyle(
                          fontFamily: 'Pacifico',
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                    Text(
                      'Sign in, please!',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0, right: 20.0),
                      decoration: BoxDecoration(),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            validator: con.validateEmail,
                            onSaved: con.saveEmail,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                            ),
                            obscureText: true,
                            autocorrect: false,
                            validator: con.validatePassword,
                            onSaved: con.savePassword,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    RawMaterialButton(
                      onPressed: con.signIn,
                      elevation: 7.0,
                      fillColor: Colors.black,
                      child: Text('Sign In', style: Theme.of(context).textTheme.button),
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    RawMaterialButton(
                      onPressed: con.signUp,
                      elevation: 7.0,
                      fillColor: Colors.black,
                      child: Text(
                        'Create a new account',
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
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _SignInState state;
  _Controller(this.state);
  String email, password;
  Profile profile = Profile();

  String validateEmail(String value) {
    if (value.contains('@') && value.contains('.'))
      return null;
    else
      return 'Invalid email address';
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

  void signIn() async {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();

    User user;
    MyDialog.circularProgressStart(state.context);
    try {
      user = await FirebaseController.signIn(email: email, password: password);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);

      MyDialog.info(
        context: state.context,
        title: 'Sign In Error',
        content: e.toString(),
      );
      return;
    }

    try {
      profile = await FirebaseController.getOneProfileDatabase(email: email);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Firestore getProfileDatabase Error',
        content: '$e',
      );
    }

    try {
      List<PhotoMemo> photoMemoList =
          await FirebaseController.getPhotoMemoList(email: user.email);
      MyDialog.circularProgressStop(state.context);
      Navigator.pushNamed(state.context, HomeScreen.routeName, arguments: {
        Constant.ARG_USER: user,
        Constant.ARG_PHOTOMEMOLIST: photoMemoList,
        Constant.ARG_ONE_PROFILE: profile,
      });
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Firestore getphotoMemoList Error',
        content: '$e',
      );
    }
  }

  void signUp() {
    Navigator.pushNamed(state.context, SignUpScreen.routeName);
  }
}
