import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/follow.dart';
import 'package:lesson3/model/profile.dart';
import 'package:lesson3/screen/myView/myDialog.dart';

class PendingRequestScreen extends StatefulWidget {
  static const routeName = '/pendingRequestScreen';
  @override
  State<StatefulWidget> createState() {
    return _PendingRequestState();
  }
}

class _PendingRequestState extends State<PendingRequestScreen> {
  _Controller ctrl;
  User user;
  List<Profile> requestProfileList;
  List<Follow> pendingRequestList;

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
    requestProfileList ??= args["ARG_REQUEST_LIST"];
    pendingRequestList ??= args[Constant.ARG_PENDING_REQUEST_LIST];
    return Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text('Requests'),
        ),
        body: requestProfileList.length == 0
            ? Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'No request',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: requestProfileList.length,
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
                          leading: requestProfileList[index].profilePhotoURL != null
                              ? Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fitWidth,
                                        image: NetworkImage(
                                            requestProfileList[index].profilePhotoURL)),
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
                          title: Text(requestProfileList[index].name,
                              style: Theme.of(context).textTheme.headline4),
                          trailing: RawMaterialButton(
                            child: Text('Accept'),
                            onPressed: () => ctrl.accept(
                                pendingRequestList[index], index), // Accept func
                            elevation: 7.0,
                            fillColor: Colors.blue,
                            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Divider(
                        height: 10.0,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ));
  }
}

class _Controller {
  _PendingRequestState state;
  _Controller(this.state);

  void accept(Follow f, int index) async {
    try {
      await FirebaseController.acceptPendingRequest(f: f);
      state.pendingRequestList = await FirebaseController.getFollowerList(
          email: state.user.email, pendingStatus: true);
      state.requestProfileList.removeAt(index);
      state.render(() {});
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Oops',
        content: '$e',
      );
    }
  }
}
