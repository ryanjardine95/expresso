import 'dart:async';

import 'package:expresso_mobile_app/helpers/locationChooser.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final LocationChooser intialLoaction;
  final bool isSelecting;

  MapScreen({
    this.isSelecting = false,
    this.intialLoaction =
        const LocationChooser(latitude: 37.422, longitude: -122.084),
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;
  LatLng _pickedLocation;
  Geolocator geoLocator = Geolocator();
  Position userPosition;

  void locateUser() async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 14.0);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _selectLocation(LatLng latLng) {
    setState(() {
      _pickedLocation = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
          markers: _pickedLocation == null
              ? {}
              : {Marker(markerId: MarkerId('m1'), position: _pickedLocation)},
          onTap: widget.isSelecting ? _selectLocation : null,
          initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.intialLoaction.latitude,
                widget.intialLoaction.longitude,
              ),
              tilt: 10,
              zoom: 16),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            newGoogleMapController = controller;
            locateUser();
          }),
    );
  }
}
