import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expresso_mobile_app/models/storeModel.dart';
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

  List<StoreModel> stores = [];

  Set<Marker> _markers = {};

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
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Future<void> getStoreList() async {
      try {
        await FirebaseFirestore.instance
            .collection("stores")
            .get()
            .then((value) {
          value.docs.forEach((element) {
            print(element.data());
            setState(() {
              stores.add(StoreModel(
                  storeId: element['userid'],
                  latitude: element['latitude'],
                  longitude: element['longitude']));
              print(stores);
            });
          });
        });
        stores.forEach((element) {
          _markers.add(Marker(
            markerId: MarkerId(element.storeId),
            position: LatLng(element.latitude, element.longitude),
            onTap: () {
              
              print(Text("you clicked ${element.storeId} store"));
            },
          ));
        });
        print(_markers);
      } catch (e) {
        throw (e);
      }
    }

   
   
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
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
              getStoreList();
              locateUser();
              print(stores);
            },
            markers: _markers,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 0, 60.0, 0),
        child: FloatingActionButton.extended(
            onPressed: () {
              auth.signOut();
              Navigator.pushNamed(context, '/');
            },
            label: Text("Logout")),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Text('logout'),
      //   onPressed: () => FirebaseAuth.instance.signOut(),
      // ),
    );
  }
}
