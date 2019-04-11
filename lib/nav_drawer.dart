import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;
import 'place_detail.dart';
import 'main.dart';

const kGoogleApiKey = "API KEY";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class DrawerBuilder extends StatefulWidget {


  DrawerBuilder();

  @override
  State<StatefulWidget> createState() {
    return _DrawerBuilderState();
  }
}


class _DrawerBuilderState extends State<DrawerBuilder> {

  List<PlacesSearchResult> places = [];
  GoogleMapController mapController;
  PlacesDetailsResponse place;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color:Colors.blue),
            child:
            Container(
              padding:EdgeInsets.only(left:70,right:70,top:10,bottom:10),
              child:CircleAvatar(
              radius: 25.0,
                backgroundImage: AssetImage('assets/profile.jpg')
              ),
            )
          ),
          ListTile(
            title: Text("Search for Cafe"),
            onTap: () {
              _handlePressButton();
            },
            leading: Icon(
              Icons.local_cafe,
              color: Colors.blue,
            ),
          ),

        ]
    )
    );
  }

  Future<void> _handlePressButton() async {
    try {
      final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: kGoogleApiKey,
          mode: Mode.fullscreen,
          language: "en",
          location: center == null
              ? null
              : Location(center.latitude, center.longitude),
          radius: center == null ? null : 10000);

      showDetailPlace(p.placeId);
    } catch (e) {
      print("error");
      return;
    }
  }

  Future<Null> showDetailPlace(String placeId) async {

    if (placeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceDetailWidget(placeId)),
      );
    }

  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

}
