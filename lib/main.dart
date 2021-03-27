import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/screen/addphotomemo_screen.dart';
import 'package:lesson3/screen/addprofilephoto_screen.dart';
import 'package:lesson3/screen/detailedview_screen.dart';
import 'package:lesson3/screen/onephotomemodetailed_screen.dart';
import 'package:lesson3/screen/oneprofile_screen.dart';
import 'package:lesson3/screen/settings_screen.dart';
import 'package:lesson3/screen/sharedwith_screen.dart';
import 'package:lesson3/screen/signIn_screen.dart';
import 'package:lesson3/screen/signup_screen.dart';
import 'package:lesson3/screen/userhome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PhotoMemoApp());
}

class PhotoMemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.DEV,
      initialRoute: SignInScreen.routeName,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
      ),
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        UserHomeScreen.routeName: (context) => UserHomeScreen(),
        AddPhotoMemoScreen.routeName: (context) => AddPhotoMemoScreen(),
        DetailedViewScreen.routeName: (context) => DetailedViewScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        SharedWithScreen.routeName: (context) => SharedWithScreen(),
        OnePhotoMemoDetailedScreen.routeName: (context) => OnePhotoMemoDetailedScreen(),
        SettingsScreen.routeName: (context) => SettingsScreen(),
        OneProfileScreen.routeName: (context) => OneProfileScreen(),
        AddProfilePhotoScreen.routeName: (context) => AddProfilePhotoScreen(),
      },
    );
  }
}
