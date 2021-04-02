import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expresso_mobile_app/allScreens/storeHomeScreen.dart';
import 'package:expresso_mobile_app/helpers/locationModel.dart';
import 'package:expresso_mobile_app/widgets/location_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoreRegister extends StatefulWidget {
  static const routeName = '/StoreLogin';
  @override
  _StoreRegisterState createState() => _StoreRegisterState();
}

class _StoreRegisterState extends State<StoreRegister> {
  LocationModel locationHelper;
  String yourName;
  String storeName;
  String emailAdress;
  double phoneNumber;
  String passWord;
  double _counter = 0;
  String userRole;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController emailAdressController = TextEditingController();
  final TextEditingController phoneNumberContoller = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController passWordConfirmController =
      TextEditingController();

  bool _isLoading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  CollectionReference stores = FirebaseFirestore.instance.collection("stores");

  void _selectPlace(double lat, double lng) {
    locationHelper = LocationModel(latitiude: lat, longitude: lng);
  }

  Future fireBaseRegister() async {
    setState(() {
      _isLoading = true;
    });
    try {
      UserCredential storeCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAdress,
        password: passWord,
      );

      await users.doc(storeCredential.user.uid).set({
        'userid': storeCredential.user.uid,
        'yourName': yourName,
        'storeName': storeName,
        'email': emailAdress,
        'phone': phoneNumber,
        'password': passWord,
        'latitude': locationHelper.latitiude.roundToDouble(),
        'longitude': locationHelper.longitude.roundToDouble(),
        'userRole': 'Store',
      });

      await stores.add({
        'userid': storeCredential.user.uid,
        'latitude': locationHelper.latitiude,
        'longitude': locationHelper.longitude,
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed(StoreHomeScreen.routeName);
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

  Future<void> signUpStore() async {
    if (passWordController.text == passWordConfirmController.text &&
        nameController.text.isNotEmpty &&
        storeNameController.text.isNotEmpty &&
        emailAdressController.text.isNotEmpty &&
        phoneNumberContoller.text.isNotEmpty) {
      setState(() {
        yourName = nameController.text;
        storeName = storeNameController.text;
        emailAdress = emailAdressController.text;
        phoneNumber = double.parse(phoneNumberContoller.text);
        passWord = passWordController.text;

        fireBaseRegister();
        print(yourName + passWord);
      });
    } else {
      setState(() {
        AlertDialog(
          content: Text('Double check info'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Okay'),
            )
          ],
        );
      });
    }
  }

  Widget firstSignUp() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Center(
                        child: Container(
                          child: Image.asset(
                              "assets/images/Expresso Name Transparent Background.png"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Your Name'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        controller: storeNameController,
                        decoration: InputDecoration(labelText: 'Store Name'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailAdressController,
                        decoration: InputDecoration(labelText: 'Email Adress'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: phoneNumberContoller,
                        decoration: InputDecoration(labelText: 'Phone number'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: passWordController,
                        decoration: InputDecoration(labelText: 'Password'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: TextFormField(
                        obscureText: true,
                        controller: passWordConfirmController,
                        decoration:
                            InputDecoration(labelText: 'Confrim Password'),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          print('NextBtn');
                          setState(() {
                            _counter = 1;
                          });
                          print(_counter);
                        },
                        child: Text('Next')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Back"))
                  ],
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _counter == 0
              ? firstSignUp()
              : Center(
                  child: LocationInput(
                    _selectPlace,
                    signUpStore
                  ),
                ),
    );
  }
}
