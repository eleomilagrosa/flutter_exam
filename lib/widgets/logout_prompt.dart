import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/constants/colors.dart';
import 'package:flutter_exam/constants/routes.dart';
import 'package:flutter_exam/utils/shared_preference_helper.dart';
import 'package:flutter_exam/widgets/custom_alert_dialog.dart';

Future<void> showLogoutPrompt(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return CustomAlertDialog(
        "Are you sure you want to logout?",
        CustomAlertType.WARNING,
        buttonNeutral: ButtonBuilder("No",
          () {
            Navigator.pop(context);
          },
        ),
        buttonPositive: ButtonBuilder("Yes",
          () async {
            SharedPreferenceHelper().init().then((pref) => pref.clearStorage());
            Navigator.pushReplacementNamed(context, Routes.LOGIN_PAGE);
          },
          bgColor: AppColors.colorPrimary,
          textColor: Colors.white,
        ),
      );
    },
  );
}
