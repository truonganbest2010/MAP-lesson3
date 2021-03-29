import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUpScreen';
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
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
      appBar: AppBar(
        title: Text('Create an account'),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
          left: 15.0,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            formKey.currentState.reset();
          },
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Text(
                  //   'Create an account',
                  //   style: Theme.of(context).textTheme.headline5,
                  // ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 5.0, top: 50.0, right: 20.0, bottom: 20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Name',
                          ),
                          keyboardType: TextInputType.name,
                          autocorrect: false,
                          validator: con.tempProfile.validateName,
                          onSaved: con.saveName,
                        ),
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
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Password confirm',
                          ),
                          obscureText: true,
                          autocorrect: false,
                          validator: con.validatePassword,
                          onSaved: con.savePasswordConfirm,
                        ),
                        con.passwordErrorMessage == null
                            ? SizedBox(height: 1.0)
                            : Text(
                                con.passwordErrorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0,
                                ),
                              ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10.0),
                  RawMaterialButton(
                    onPressed: con.createAccount,
                    elevation: 7.0,
                    fillColor: Colors.black,
                    child: Text(
                      'Create',
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
    );
  }
}

class _Controller {
  _SignUpState state;
  _Controller(this.state);
  String email, password, passwordConfirm;

  String passwordErrorMessage;
  Profile tempProfile = Profile();

  void createAccount() async {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();

    state.render(() => passwordErrorMessage = null);
    state.formKey.currentState.save();

    if (password != passwordConfirm) {
      state.render(() => passwordErrorMessage = 'passwords do not match');
      return;
    }
    MyDialog.circularProgressStart(state.context);

    try {
      await FirebaseController.createAccount(email: email, password: password);

      tempProfile.createdBy = email;
      tempProfile.admin = false;
      var docId = await FirebaseController.createProfile(tempProfile);
      tempProfile.profileID = docId;
      MyDialog.circularProgressStop(state.context);

      MyDialog.info(
          context: state.context,
          title: 'Account created!',
          content: 'Go to Sign in to use the app');
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
}
