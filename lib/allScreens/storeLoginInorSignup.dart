import 'package:expresso_mobile_app/allScreens/storeLogin.dart';
import 'package:expresso_mobile_app/allScreens/storeSignup.dart';
import 'package:flutter/material.dart';

class StoreLoginSignUp extends StatelessWidget {
  static const routeName = '/StoreloginSignUp';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store Page'),
      ),
      body: Center(
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
                        Navigator.of(context).pushNamed(StoreLoginScreen.routeName);
                      },
                      child: Text("Login"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(StoreSignUp.routeName);
                        
                      },
                      child: Text("Sign up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
