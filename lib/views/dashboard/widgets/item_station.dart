import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/data/model/station.dart';
import 'package:flutter_exam/utils/map_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItemStationWidget extends StatelessWidget {
  final Station station;
  final Function(Station station) onTap;
  final LatLng currentLocation;
  final bool showAddress;
  const ItemStationWidget({Key? key,
    required this.station,
    required this.currentLocation,
    required this.onTap,
    this.showAddress = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        onTap(station);
      },
      title: Row(
          children: [
            Flexible(child: Text(station.name))
          ]
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(showAddress) Row(
            children: [
              const Icon(Icons.pin_drop_outlined, size: 18,),
              Flexible(child: Text(station.address)),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.car_repair, size: 18),
              Text("${MapUtils.calculateDistanceInKm(currentLocation, station.getPosition).toStringAsFixed(2)} km from you")
            ],
          ),
        ],
      ),
      trailing: (showAddress) ? null : IgnorePointer(
        child: Radio(
          onChanged:(value){},
          groupValue: 2,
          value: 1,
        ),
      ),
    );
  }
}
