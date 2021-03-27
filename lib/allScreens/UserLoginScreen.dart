import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();


  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Register!"),
      // ),
      body: _isLoading? Center(child: CircularProgressIndicator()):Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Image.asset("assets/images/Expresso Name Transparent Background.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email address",
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    child: Text("Login!"),
                    onPressed: (){
                      if(emailController.text.isNotEmpty){
                        setState((){
                          email = emailController.text;
                          password = passwordController.text;
                          signIn();
                        });
                      }else{
                        setState(() {
                          AlertDialog(
                            content: Text("double check all info"),
                          );
                        });
                      }
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text("Go Back"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      //add navigation to main screen on succesful login
      Navigator.pushNamed(context, "Home");
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        setState(() {
          _isLoading = false;
        });
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
