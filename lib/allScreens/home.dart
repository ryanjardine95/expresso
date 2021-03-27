import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //firebase documents
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  //google maps
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;
  Geolocator geoLocator = Geolocator();
  Position userPosition;
  //example position for when maps start without a location
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void locateUser() async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 14.0);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("${auth.currentUser.email}"),
      //   actions: [
      //     IconButton(onPressed: (){
      //       auth.signOut();
      //       Navigator.pushNamed(context, "/");
      //     }, icon: Icon(Icons.exit_to_app))
      //   ],
      // ),
      body: Stack(
        children: [
          GoogleMap(
            //padding: EdgeInsets.only(top: 100.0, bottom: 200.0),
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;
              locateUser();
            },
          ),
          Positioned(
              top: 100.0,
              left: 10.0,
              right: 10.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text("Begin by selecting your nearest store!",
                          style: TextStyle(fontSize: 20.0),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('logout'),
        onPressed: () => FirebaseAuth.instance.signOut(),
      ),
    );
  }
}
