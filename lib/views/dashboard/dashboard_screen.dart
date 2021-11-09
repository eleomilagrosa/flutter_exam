import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/constants/colors.dart';
import 'package:flutter_exam/constants/font_style.dart';
import 'package:flutter_exam/constants/routes.dart';
import 'package:flutter_exam/controllers/dashboard_controller.dart';
import 'package:flutter_exam/data/model/station.dart';
import 'package:flutter_exam/data/model/user.dart';
import 'package:flutter_exam/utils/map_utils.dart';
import 'package:flutter_exam/views/dashboard/drawer/dashboard_drawer.dart';
import 'package:flutter_exam/views/dashboard/widgets/item_station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DashboardScreen extends StatefulWidget {

  final User user;
  const DashboardScreen({Key? key,required this.user}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  late DashboardProvider dashboardProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DashboardProvider>(create: (_) => DashboardProvider(context)),
      ],
      child: Scaffold(
        appBar: loadAppBar(),
        drawer: const DashboardDrawer(),
        // body: loadMap(),
        body: loadBody(),
      ),
    );
  }

  AppBar loadAppBar(){
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.colorPrimary,
      title: const Text( "Search Station",
        style: AppFontStyle.font20,
      ),
      actions: [
        IconButton(
            onPressed: ()async{
              popUpSearchStation();
            },
            icon: const Icon(Icons.search)
        )
      ],
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  Widget loadBody(){
    return Consumer<DashboardProvider>(
        builder: (key,dashboardProvider,child){
          this.dashboardProvider = dashboardProvider;
          List<Station> filtered = dashboardProvider.stations.isEmpty ? [] : dashboardProvider.stations
              .where((station) => dashboardProvider.currentLatLngBounds.contains(station.getPosition))
              .toList();

          filtered.sort((a,b) => MapUtils.calculateDistanceInKm(dashboardProvider.currentLatLng, a.getPosition)
              .compareTo(MapUtils.calculateDistanceInKm(dashboardProvider.currentLatLng, b.getPosition)));

          return SlidingUpPanel(
            parallaxOffset: .5,
            parallaxEnabled: true,
            minHeight: 150,
            maxHeight: MediaQuery.of(context).size.height * .6,
            panel: loadBottomSheet(filtered),
            body: loadMap(filtered),
          );
      }
    );
  }
  Widget loadMap(List<Station> filteredStations){
    return Container(
      padding: const EdgeInsets.only(bottom: 220),
      child: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) async{
          dashboardProvider.controllerMapCompleter.complete(controller);
        },
        initialCameraPosition: defaultLoc,
        onCameraIdle: ()async{
          dashboardProvider.reloadMarkers();
        },
        onCameraMove: (loc){
          dashboardProvider.cameraLatLng = loc.target;
        },
        markers: filteredStations.map((station) => Marker(
          markerId: MarkerId(station.id.toString()),
          position: station.getPosition,
          onTap: (){
            dashboardProvider.setSelectedStation(station);
          }
        )).toSet(),
      ),
    );
  }

  Widget loadBottomSheet(List<Station> filteredStations){
    return Container(
      color: AppColors.backgroundDark,
      child: Column(
        children: [
          const SizedBox(height: 12,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dashboardProvider.selectedStation != null ? "Back to List" : "Nearby Stations"),
                if(dashboardProvider.selectedStation != null) TextButton(
                    onPressed: (){
                      dashboardProvider.setSelectedStation(null);
                    },
                    child: const Text("Done")
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child:
              dashboardProvider.selectedStation != null ?
              ItemStationWidget(
                station: dashboardProvider.selectedStation!,
                currentLocation: dashboardProvider.currentLatLng,
                showAddress: true,
                onTap: (station){
                  dashboardProvider.setSelectedStation(station);
                },
              ) :
              Column(
                children: filteredStations
                    .map((station) => ItemStationWidget(
                      station: station,
                      currentLocation: dashboardProvider.currentLatLng,
                      onTap: (station){
                        dashboardProvider.setSelectedStation(station);
                      },
                    )
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void popUpSearchStation()async{
    var station = await Navigator.pushNamed(context, Routes.SEARCH_STATION_PAGE, arguments: dashboardProvider);
    if(station is Station){
      dashboardProvider.setSelectedStation(station);
    }
  }
}
