import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/constants/colors.dart';
import 'package:flutter_exam/constants/font_style.dart';
import 'package:flutter_exam/controllers/dashboard_controller.dart';
import 'package:flutter_exam/utils/map_utils.dart';
import 'package:flutter_exam/views/dashboard/widgets/item_station.dart';

class SearchStationScreen extends StatefulWidget {
  final DashboardProvider dashboardProvider;
  const SearchStationScreen(this.dashboardProvider,{Key? key}) : super(key: key);

  @override
  _SearchStationScreenState createState() => _SearchStationScreenState();
}

class _SearchStationScreenState extends State<SearchStationScreen> {

  StreamController<String> streamSearch = StreamController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorPrimary,
        elevation: 0,
        title: const Text( "Search Station",
          style: AppFontStyle.font20,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.colorPrimary,
              padding: const EdgeInsets.only(left: 32,right: 32,bottom: 24),
              child: TextFormField(
                onChanged: (text){
                  streamSearch.add(text);
                },
                decoration: const InputDecoration(
                  labelText: "Search...",
                  labelStyle: AppFontStyle.font18,
                  errorStyle: AppFontStyle.errorTextStyle,
                  prefix: Icon(  Icons.search),
                ),
                textInputAction: TextInputAction.done,
                style: AppFontStyle.font20,
                maxLines: 1,
              ),
            ),
            Expanded(
              child: StreamBuilder<String>(
                stream: streamSearch.stream,
                builder: (context, snapshot) {
                    String searchText = snapshot.data ?? "";

                    var filtered = widget.dashboardProvider.stations
                        .where((station) => searchText.isEmpty ? true : station.name.toLowerCase().contains(searchText.toLowerCase())).toList();

                    filtered.sort((a,b) => MapUtils.calculateDistanceInKm(widget.dashboardProvider.currentLatLng, a.getPosition)
                        .compareTo(MapUtils.calculateDistanceInKm(widget.dashboardProvider.currentLatLng, b.getPosition)));

                    return ListView(
                      children: filtered
                          .map((station) => ItemStationWidget(
                              station: station,
                              currentLocation: widget.dashboardProvider.currentLatLng,
                              onTap: (station){
                                Navigator.pop(context,station);
                              },
                            )
                          ).toList(),
                    );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
