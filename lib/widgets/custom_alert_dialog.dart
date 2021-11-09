import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {

  final ButtonBuilder? buttonPositive;
  final ButtonBuilder? buttonNegative;
  final ButtonBuilder? buttonNeutral;
  final ButtonBuilder? buttonNeutral2;
  final String title;
  final CustomAlertType type;
  final String? customImage;
  const CustomAlertDialog(this.title,this.type,{this.buttonPositive,this.buttonNegative,this.buttonNeutral,this.buttonNeutral2,this.customImage});

  @override
  Widget build(BuildContext context) {
    return
      buttonNeutral2 == null ?
      Dialog(
        child: buildBody(),
      ) :
      Dialog(
        insetPadding: const EdgeInsets.all(4),
        child: buildBody(),
      );
  }

  Widget buildBody(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          const SizedBox(height: 20),
          Text(title,textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: buttonNeutral == null ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (buttonNeutral2 == null) ? Container() : generateButton(buttonNeutral2!),
                  (buttonNeutral == null) ? Container() : generateButton(buttonNeutral!),
                  (buttonNegative == null) ? Container() : generateButton(buttonNegative!),
                  (buttonPositive == null) ? Container() : generateButton(buttonPositive!),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
  String getType(){
    switch(type){
      case CustomAlertType.SUCCESS:
        return "assets/images/dialog/success.svg";
        break;
      case CustomAlertType.INFO:
        return "assets/images/dialog/info.svg";
        break;
      case CustomAlertType.WARNING:
        return "assets/images/dialog/warning.svg";
        break;
      case CustomAlertType.ERROR:
        return "assets/images/dialog/error.svg";
        break;
      case CustomAlertType.CUSTOM:
        return customImage!;
        break;
    }
    return "";
  }
  Widget generateButton(ButtonBuilder button){
    return Card(
      elevation: 4,
      color: button.bgColor,
      child: InkWell(
        onTap: button.onTap,
        child: Container(
          constraints: BoxConstraints(minWidth: 70),
          padding: EdgeInsets.symmetric(horizontal: 4),
          height: 38,
          child: Center(
              child: Text(button.title,
                  style: TextStyle(color: button.textColor,fontSize: 16)
              )
          ),
        ),
      ),
    );
  }
}
enum CustomAlertType{
  SUCCESS,
  INFO,
  WARNING,
  ERROR,
  CUSTOM
}
class ButtonBuilder{
  final String title;
  final Function() onTap;
  final Color bgColor;
//  AppColors.primaryColor
  final Color textColor;

  ButtonBuilder(this.title,this.onTap, {
    this.bgColor = Colors.white,
    this.textColor = Colors.black
  });

}