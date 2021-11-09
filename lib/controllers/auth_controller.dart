import 'package:flutter/cupertino.dart';
import 'package:flutter_exam/data/model/user.dart';
import 'package:flutter_exam/data/network/user_resource.dart';
import 'package:flutter_exam/utils/shared_preference_helper.dart';


class AuthProvider extends ChangeNotifier{
  final UserResource _userResource = UserResource();
  Future<User> login(String username,String password)async{
    User user = (await _userResource.login(username, password))!;
    _userResource.sharedPreferenceHelper.saveUser(user);
    return user;
  }
}