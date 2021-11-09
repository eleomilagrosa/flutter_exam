import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';

class CustomSnackBar{
  static String showError(BuildContext context, String message){
    FlushbarHelper.createError(message: message).show(context);
    return message;
  }
  static String showSuccessMessage(BuildContext context, String message, [String? title]){
    FlushbarHelper.createSuccess(title: title,message: message).show(context);
    return message;
  }
}