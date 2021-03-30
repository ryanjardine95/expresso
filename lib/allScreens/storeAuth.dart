import 'package:expresso_mobile_app/allScreens/storeSignup.dart';
import 'package:flutter/material.dart';

class StoreAuth extends StatefulWidget {
  @override
  _StoreAuthState createState() => _StoreAuthState();
}

class _StoreAuthState extends State<StoreAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Navigator.pushNamed(context, 'StoreLogIn');
                      },
                      child: Text("Login"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'StoreRegister');
                      },
                      child: Text("Sign up"),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: InkWell(
                    child: Text("Click here if you're an Expresso User!"),
                    onTap: () {
                      // ignore: unnecessary_statements
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}

