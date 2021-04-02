import 'package:expresso_mobile_app/allScreens/mapScreen.dart';
import 'package:expresso_mobile_app/helpers/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  final Function signUpStore;

  LocationInput(this.onSelectPlace, this.signUpStore);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewimageUrl;

  void _showpreview(double lat, double lng) {
    final staticMap = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    setState(() {
      _previewimageUrl = staticMap;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    _showpreview(locData.latitude, locData.longitude);
    widget.onSelectPlace(locData.latitude, locData.longitude);
  }

  Future<void> _selectONMap() async {
    final LatLng selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showpreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 50, right: 50),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            alignment: Alignment.center,
            height: 170,
            width: double.infinity,
            child: _previewimageUrl == null
                ? Text(
                    'No Location Chosen',
                    textAlign: TextAlign.center,
                  )
                : Image.network(
                    _previewimageUrl,
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
                label: Text('Current Locations'),
              ),
              TextButton.icon(
                onPressed: _selectONMap,
                icon: Icon(Icons.map),
                label: Text('Select Location'),
              )
            ],
          ),
          ElevatedButton(
            onPressed: widget.signUpStore,
            child: Text('Done'),
          )
        ],
      ),
    );
  }
}
