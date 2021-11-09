import 'dart:convert';

import 'package:flutter_exam/constants/preference.dart';
import 'package:flutter_exam/data/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  late SharedPreferences _sharedPreference;

  Future<SharedPreferenceHelper> init() async {
    _sharedPreference = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> clearStorage() async {
    return _sharedPreference.clear();
  }

  Future<bool> saveUser(User user) async {
    return await _sharedPreference.setString(Preferences.USER_DATA, jsonEncode(user.toJson()));
  }

  User? get getUser {
    String config = _sharedPreference.getString(Preferences.USER_DATA) ?? "";
    if(config.isEmpty){
      return null;
    }
    return User.fromJson(jsonDecode(config));
  }
}