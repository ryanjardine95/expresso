import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class StoreModel {
  String storeId;
  double latitude;
  double longitude;

  StoreModel({this.storeId, this.latitude, this.longitude});

  StoreModel.fromJson(Map<String, dynamic> parsedJSON)
      : storeId = parsedJSON['userid'], latitude = parsedJSON['latitude'], longitude = parsedJSON['longitude'];
}