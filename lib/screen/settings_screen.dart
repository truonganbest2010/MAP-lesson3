import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/profile.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settingsScreen';
  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
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
          title: Text('Settings', style: Theme.of(context).textTheme.headline4),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: (MediaQuery.of(context).size.width),
                child: RaisedButton(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  elevation: 10.0,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Account', style: Theme.of(context).textTheme.headline6),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Permission',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: (MediaQuery.of(context).size.width),
                child: RaisedButton(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  elevation: 10.0,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Deactivate your account',
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width),
                child: RaisedButton(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  elevation: 10.0,
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Delete account',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        )),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ));
  }
}

class _Controller {
  _SettingsState state;
  _Controller(this.state);
}
