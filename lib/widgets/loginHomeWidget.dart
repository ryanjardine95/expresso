import 'package:expresso_mobile_app/allScreens/storeLoginInorSignup.dart';
import 'package:flutter/material.dart';

Widget homePageLogin(BuildContext context) {
  return Center(
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
                child: Text("Click here if you're a new store!"),
                onTap: () {
                  Navigator.of(context).pushNamed(StoreLoginSignUp.routeName);
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
