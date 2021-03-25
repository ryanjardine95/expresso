import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expresso_mobile_app/allScreens/loginScreen.dart';
import 'package:expresso_mobile_app/allScreens/signupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'allScreens/home.dart';

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
          if (snapshot.hasError){
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
      child: Text("Something is wrong. Please check you are connected to the internet"),
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
      body: auth.currentUser == null? Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: SizedBox(
                    child: Image.asset(
                        "assets/images/ExpressoLogoTransparentBackground.png"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "LogIn");
                      },
                      child: Text("Login"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "SignUp");
                      },
                      child: Text("Sign up"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    child: Text("click here if you're a new store!"),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ): Home(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

