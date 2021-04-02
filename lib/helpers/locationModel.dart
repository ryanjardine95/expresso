import 'package:flutter/material.dart';
class LocationModel{
  final double latitiude;
  final double longitude;
  final String address;

  const LocationModel({this.address, @required this.latitiude, @required this.longitude});
}