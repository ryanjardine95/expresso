import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expresso_mobile_app/allScreens/storeHomeScreen.dart';
import 'package:expresso_mobile_app/helpers/location_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class StoreRegister extends StatefulWidget {
  static const routeName = '/StoreLogin';
  @override
  _StoreRegisterState createState() => _StoreRegisterState();
}

class _StoreRegisterState extends State<StoreRegister> {
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
        'latitude': latitude,
        'longitude': longitude,
        'userRole': 'Store',
      });

      await stores.add({
        'userid': storeCredential.user.uid,
        'latitude': latitude,
        'longitude': longitude,
      });
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context)
          .pushReplacementNamed(StoreHomeScreen.routeName);
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
                        child: Text('Next')
                    ),
                    ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Back"))
                  ],
                ),
              ),
            ),
        );
  }

  String _previewImageUrl;
  bool _isGettingLocal = false;
  double latitude;
  double longitude;
  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    final staticMap = LocationHelper.generateLocationPreviewImage(
        latitude: locData.latitude, longitude: locData.longitude);
    setState(() {
      _previewImageUrl = staticMap;
      _isGettingLocal = true;
      latitude = locData.latitude;
      longitude = locData.longitude;
    });
    print(locData.latitude + locData.longitude);
  }

  Widget getLocation() {
    if (_previewImageUrl != null) {
      _isGettingLocal = false;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Choose you current Location'),
          SizedBox(
            height: 10,
          ),
          _isGettingLocal
              ? CircularProgressIndicator()
              : Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  alignment: Alignment.center,
                  height: 170,
                  width: double.infinity,
                  child: _previewImageUrl == null
                      ? Text(
                          'No Location Chosen',
                          textAlign: TextAlign.center,
                        )
                      : Image.network(
                          _previewImageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: _getCurrentUserLocation,
                icon: Icon(Icons.location_on),
                label: Text('Current Location'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              await signUpStore();
            },
            child: Text("Done"),
          )
        ],
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
              : Center(child: getLocation()),
    );
  }
}
