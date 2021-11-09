import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/constants/colors.dart';
import 'package:flutter_exam/constants/font_style.dart';
import 'package:flutter_exam/widgets/logout_prompt.dart';

class DashboardDrawer extends StatelessWidget {

  const DashboardDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          Container(
            child: DrawerHeader(
              child: Center(
                child: Image.asset( "assets/images/locq_logo.png",
                  width: 200,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text("Logout", style: AppFontStyle.font16,),
            onTap: ()async{
              Navigator.pop(context);
              await showLogoutPrompt(context);
            },
          ),
        ],
      ),
    );
  }
}
