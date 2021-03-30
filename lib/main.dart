import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expresso_mobile_app/allScreens/UserLoginScreen.dart';
import 'package:expresso_mobile_app/allScreens/addMenuItem.dart';
import 'package:expresso_mobile_app/allScreens/storeAuth.dart';
import 'package:expresso_mobile_app/allScreens/storeHomeScreen.dart';
import 'package:expresso_mobile_app/allScreens/storeSignup.dart';
import 'package:expresso_mobile_app/allScreens/userSignupScreen.dart';
import 'package:expresso_mobile_app/widgets/loginHomeWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'allScreens/editMenuItem.dart';
import 'allScreens/home.dart';
import 'allScreens/storeLogin.dart';
import 'allScreens/storeMenu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SomethingWentWrong();
          }
          // Once complete, show the application
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Expresso App',
              theme: ThemeData(
                primaryColor: Colors.grey,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              //setup for named routes for Navigator
              initialRoute: '/',
              routes: {
                '/': (context) => MyHomePage(title: "Expresso App"),
                'SignUp': (context) => SignUp(),
                'LogIn': (context) => Login(),
                'Home': (context) => Home(),
                'StoreLogIn': (context) => StoreLogin(),
                'StoreRegister': (context) => StoreRegister(),
                'StoreHome': (context) => StoreHomeScreen(),
                'StoreAuth': (context) => StoreAuth(),
                'StoreMenu': (context) => StoreMenu(),
                'AddMenuItem': (context) => AddMenuItem(),
                'EditMenuItem': (context) => EditMenuItem(),
              },
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return CircularProgressIndicator();
        });
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          "Something is wrong. Please check you are connected to the internet"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.grey,
      //   title: Text(widget.title),
      // ),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapShot) {
            if (snapShot.hasData && snapShot.data != null) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapShot.data.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final user = snapshot.data.data();
                    if (user['userRole'] == 'Store') {
                      return StoreHomeScreen();
                    } else {
                      return Home();
                    }
                  }
                  return Material(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              );
            } else {
              return homePageLogin(context);
            }
          },
        ));
  }
}