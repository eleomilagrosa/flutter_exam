import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_exam/data/model/station.dart';
import 'package:flutter_exam/data/network/station_resource.dart';
import 'package:flutter_exam/widgets/custom_snackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


const CameraPosition defaultLoc = CameraPosition(
  target: LatLng(14.5839869, 120.9787417),
  zoom: 14,
);

class DashboardProvider extends ChangeNotifier{
  final StationResource stationResource = StationResource();

  Position? currentPosition;
  LatLng get currentLatLng => currentPosition == null ? defaultLoc.target :
    LatLng( currentPosition!.latitude, currentPosition!.longitude);

  Station? selectedStation;
  void setSelectedStation(Station? station)async{
    selectedStation = station;
    if(station != null){
      await controllerMap.animateCamera(CameraUpdate.newLatLng(station.getPosition));
    }
    notifyListeners();
  }

  List<Station> stations = [];
  Completer<GoogleMapController> controllerMapCompleter = Completer();
  late GoogleMapController controllerMap;
  late LatLngBounds currentLatLngBounds;
  late LatLng cameraLatLng;
  final BuildContext context;

  DashboardProvider(this.context){
    getAllStations();
  }

  void getAllStations()async{
    controllerMap = await controllerMapCompleter.future;

    stationResource.getAllStation().then((stationList){
      stations = stationList;
      notifyListeners();
    }).catchError((error,trace){
      CustomSnackBar.showError(context, "Fetching stations failed");
    });

    _determinePosition().then((position)async{
      currentPosition = position;
      notifyListeners();

      cameraLatLng = LatLng(currentPosition!.latitude, currentPosition!.longitude);
      await controllerMap.animateCamera(CameraUpdate.newLatLng(cameraLatLng));
    }).catchError((error){
      CustomSnackBar.showError(context, error);
    });
  }

  reloadMarkers()async{
    currentLatLngBounds = await controllerMap.getVisibleRegion();
    notifyListeners();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}