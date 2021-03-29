import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/profile.dart';

class FindPeopleScreen extends StatefulWidget {
  static const routeName = '/findPeopleScreen';
  @override
  State<StatefulWidget> createState() {
    return _FindPeopleState();
  }
}

class _FindPeopleState extends State<FindPeopleScreen> {
  _Controller ctrl;
  User user;
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
    profileList ??= args[Constant.ARG_PROFILE_LIST];
    // print(profileList.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Find People',
          style: TextStyle(
            fontFamily: "Pacifico",
            fontSize: 25.0,
          ),
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profileList.length == 0
                ? Center(
                    child: Text('No user found!'),
                  )
                : ctrl.getProfileList(),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _FindPeopleState state;
  _Controller(this.state);

  Widget getProfileList() {
    return Column(
      children: [
        for (var p in state.profileList)
          Container(
              width: MediaQuery.of(state.context).size.width,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.black,
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
                                fit: BoxFit.fill, image: NetworkImage(p.profilePhotoURL)),
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
                ),
              ))
      ],
    );
  }
}
