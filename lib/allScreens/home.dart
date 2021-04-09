import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expresso_mobile_app/models/menuItem.dart';
import 'package:expresso_mobile_app/models/orderModel.dart';
import 'package:expresso_mobile_app/models/storeModel.dart';
import 'package:flutter/cupertino.dart';
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

  List<OrderModel> order = [];

  List<MenuItem> storeMenu = [];
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

  bool _showMenu = false;
  bool _placingOrder = false;

  void locateUser() async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 14.0);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    storeMenu.clear();
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
              stores.add(
                StoreModel(
                    storeId: element['userid'],
                    latitude: element['latitude'],
                    longitude: element['longitude']),
              );
              print(stores);
            });
          });
        });
        stores.forEach((element) {
          _markers.add(Marker(
            markerId: MarkerId(element.storeId),
            position: LatLng(element.latitude, element.longitude),
            onTap: () async {
              await getMenu(element.storeId);
              print(Text("you clicked ${element.storeId} store"));
              showBottomSheetMenu(context, element.storeId);
            },
          ));
        });
        print(_markers);
      } catch (e) {
        throw (e);
      }
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(''),
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
              getStoreList();
              locateUser();
              print(stores);
            },
            markers: _markers,
          ),
          Positioned(
              bottom: 150.0,
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

  Future getMenu(String storeId) async {
    try {
      storeMenu.clear();
      _showMenu = !_showMenu;
      print(_showMenu);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(storeId)
          .collection('menu')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          setState(() {
            storeMenu.add(MenuItem(
              name: element.data()['name'],
              description: element.data()['description'],
              price: element.data()['price'],
              numberOrdered: 0,
            ));
            print(storeMenu);
          });
        });
      });
    } catch (e) {
      throw (e);
    }
  }

  void showBottomSheetMenu(BuildContext context, String storeId) async {
    final data =
        await FirebaseFirestore.instance.collection('users').doc(storeId).get();
    final storeName = data.data()['storeName'];
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        enableDrag: true,
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state){
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Wrap(
                children: [
                  Column(children: [
                    Center(
                      child: Text(
                        storeName,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Select your favourite items!"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: InkWell(
                          child: Text(
                            "back",
                            style: TextStyle(fontSize: 15),
                          ),
                          onTap: () {
                            setState(() {
                              Navigator.of(context).pop();
                              storeMenu.clear();
                              _showMenu = false;
                            });
                          },
                        ),
                      ),
                    ]),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: storeMenu.length,
                        itemBuilder: (context, i) {
                          return Card(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Text('${storeMenu[i].name}'),
                                      ],
                                    ),
                                    subtitle: Text('${storeMenu[i].description}'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("${storeMenu[i].numberOrdered}"),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Price: ${storeMenu[i].price}'),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    left: 0,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                    ),
                                    onPressed: () {
                                      updated(state, i, 1);
                                      setState(() {
                                        print(
                                            '${storeMenu[i].numberOrdered} you clicked plus');
                                        storeMenu[i].numberOrdered++;
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, bottom: 8, left: 8, right: 2),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.remove,
                                    ),
                                    onPressed: () {
                                      updated(state, i, -1);
                                      setState(() {
                                        print(
                                            '${storeMenu[i].numberOrdered} you clicked minus');
                                        storeMenu[i].numberOrdered--;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _placingOrder ? CircularProgressIndicator():
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        updatedOrder(state, true);
                        print("Order");
                        storeMenu.forEach((element) {
                          if(element.numberOrdered != 0){
                            order.add(OrderModel(
                                element.name,
                               element.numberOrdered));
                            placeOrder(storeId, order, auth.currentUser.email);
                            print(element.name); print(element.numberOrdered);
                          }
                        });
                      },
                    ),
                  ]),
                ],
              ),
            );
          });
        });
  }
  Future<void> updated (StateSetter updateState, int i, int value) async {
    updateState((){
      storeMenu[i].numberOrdered + value;
    });
  }

  Future<void> updatedOrder (StateSetter updateState, bool value) async {
    updateState((){
      _placingOrder = value;
    });
  }

  Future placeOrder(String storeId, List<OrderModel> order, String user) async {
    setState(() {
      _placingOrder = true;
    });
    var i = 0;
    try{
      order.forEach((element) async {
        i++;
        await FirebaseFirestore.instance.collection('users').doc(storeId).collection("orders").add({
          'customer': user,
          'orderItem': i.toString(),
          'itemOrdered':element.itemOrdered,
          'numberOrdered': element.numberOrdered,
        });
      });
      setState(() {
        _placingOrder = false;
      });

    }catch(e){
      setState(() {
        _placingOrder = false;
      });
      throw(e);

    }
}
}
