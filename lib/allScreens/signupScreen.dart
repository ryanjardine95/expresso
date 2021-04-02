import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmController = new TextEditingController();


  String username = "";
  String email = "";
  String password = "";
  double number = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Register!"),
      // ),
      body: _isLoading? Center(child: CircularProgressIndicator(),):Center(
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
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                    ),
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
                    controller: numberController,
                    decoration: InputDecoration(
                      labelText: "Phone number",
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
                  child: TextFormField(
                    controller: passwordConfirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    child: Text("Register Now!"),
                    onPressed: () async {
                      if(passwordController.text == passwordConfirmController.text
                          && emailController.text.isNotEmpty
                          && nameController.text.isNotEmpty){
                        setState((){
                          username = nameController.text;
                          number = double.parse(numberController.text);
                          password = passwordConfirmController.text;
                          print(username + number.toString() + password + email);
                          registerUser();
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future registerUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      try{
        users.add({
          "UserId": userCredential.user.uid,
          "Email" : emailController.text,
          "Name"  : nameController.text,
          "Number": numberController.text
        });
      }catch(e){
        throw(e);
      }
      print(users.toString());
      setState(() {
        _isLoading = false;
      });
      //add navigation to main screen on succesful sign up
      Navigator.pushNamed(context, "Home");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

