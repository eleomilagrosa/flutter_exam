import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_exam/constants/end_points.dart';
import 'package:flutter_exam/data/model/user.dart';
import 'package:flutter_exam/utils/shared_preference_helper.dart';

class BaseResource{
  late Dio dio;
  late SharedPreferenceHelper sharedPreferenceHelper;
  final Completer<bool> isInitialized = Completer();

  BaseResource(){
    init();
  }
  void init() async {
    sharedPreferenceHelper = SharedPreferenceHelper();
    await sharedPreferenceHelper.init();
    dio = Dio();
    dio..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.sendTimeout = Endpoints.receiveTimeout
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options,RequestInterceptorHandler handler){
            var token = sharedPreferenceHelper.getUser?.accessToken;
            if (token != null) {
              options.headers.putIfAbsent('Authorization', () => token);
            }else{
              print("No Token");
            }
            handler.next(options);
          },
        ),
      );
    isInitialized.complete(true);
  }

}