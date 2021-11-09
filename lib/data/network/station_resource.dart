import 'package:dio/dio.dart';
import 'package:flutter_exam/constants/end_points.dart';
import 'package:flutter_exam/constants/error_codes.dart';
import 'package:flutter_exam/data/model/station.dart';
import 'package:flutter_exam/data/network/base_resource.dart';

class StationResource extends BaseResource{
  Future<List<Station>> getAllStation()async{
    await isInitialized.future;
    Response response = await dio.get(Endpoints.getAllStation);
    if((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300){
      List data = response.data["data"];
      return data.map<Station>((station) => Station.fromJson(station)).toList();
    }else{
      throw ErrorCodes.no_stations;
    }
  }
}