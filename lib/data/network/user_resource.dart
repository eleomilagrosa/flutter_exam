import 'package:dio/dio.dart';
import 'package:flutter_exam/constants/end_points.dart';
import 'package:flutter_exam/constants/error_codes.dart';
import 'package:flutter_exam/data/model/user.dart';
import 'package:flutter_exam/data/network/base_resource.dart';

class UserResource extends BaseResource{
  Future<User?> login(String username, String password)async{
     Response response = await dio.post(Endpoints.login,
       data:{
         "mobile": username,
         "password": password
       }
     );
     if((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300){
       print("data:" + response.data["data"].toString());
       if(response.data["data"]["code"] == "InvalidLoginError"){
         throw ErrorCodes.no_user_found;
       }
       return User.fromJson(response.data["data"]);
     }else{
       throw ErrorCodes.no_user_found;
     }
  }
}