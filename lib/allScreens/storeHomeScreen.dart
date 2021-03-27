import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoreHomeScreen extends StatefulWidget {
  static const routeName = '/StoreHomeScreen';
  @override
  _StoreHomeScreenState createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Image.asset('assets/images/Expresso Name Transparent Background.png'),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("stores").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final docs = snapshot.data.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    var location = docs[i]['latLang'].toString();
                    String lat = location.toString().substring(17, 29);
                    String long = location.toString().substring(36, 46);

                    return ListTile(
                      title: Column(
                        children: [
                          Text('lat: $lat'),
                          Text('long: $long'),
                        ],
                      ),
                    );
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('logout'),
        onPressed: () => FirebaseAuth.instance.signOut(),
      ),
    );
  }
}
