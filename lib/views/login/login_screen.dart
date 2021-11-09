import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/constants/colors.dart';
import 'package:flutter_exam/constants/error_codes.dart';
import 'package:flutter_exam/constants/font_style.dart';
import 'package:flutter_exam/constants/routes.dart';
import 'package:flutter_exam/controllers/auth_controller.dart';
import 'package:flutter_exam/controllers/dashboard_controller.dart';
import 'package:flutter_exam/widgets/custom_fields.dart';
import 'package:flutter_exam/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _etControllerUsername = TextEditingController();
  final TextEditingController _etControllerPassword = TextEditingController();
  final StreamController<bool> _loadingLogin = StreamController();
  bool isAutoValidate = false;

  final _formKey = GlobalKey<FormState>();
  bool _isCreatePasswordHidden = true;
  final _cpFocus = FocusNode();

  late AuthProvider authProvider;
  @override
  void initState() {
    authProvider = AuthProvider();
    _etControllerUsername.text = "09021234567";
    _etControllerPassword.text = "123456";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => authProvider),
      ],
      builder: (context, _) =>
        Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Image.asset(
                            "assets/images/locq_logo.png",
                            width: 200,
                          ),
                          const SizedBox(height: 30,),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Username",
                              labelStyle: AppFontStyle.font18,
                            ),
                            autovalidateMode: isAutoValidate
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            validator: (text){
                              if(text?.isEmpty ?? true) return "Required field";
                            },
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).requestFocus(_cpFocus);
                            },
                            textInputAction: TextInputAction.next,
                            controller: _etControllerUsername,
                            style: AppFontStyle.font20,
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            focusNode: _cpFocus,
                            decoration: InputDecoration(
                              labelText: "Password",
                              labelStyle: AppFontStyle.font18,
                              errorStyle: AppFontStyle.errorTextStyle,
                              suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isCreatePasswordHidden =
                                      !_isCreatePasswordHidden;
                                    });
                                  },
                                  child: Icon(
                                    _isCreatePasswordHidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColors.warmGrey,
                                  )),
                            ),
                            autovalidateMode: isAutoValidate
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            validator: (text){
                              if(text?.isEmpty ?? true) return "Required field";
                            },
                            onFieldSubmitted: (String password) async {
                              attemptLogin();
                            },
                            obscureText: _isCreatePasswordHidden,
                            controller: _etControllerPassword,
                            style: AppFontStyle.font20,
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<bool>(
                            stream: _loadingLogin.stream,
                            builder: (context, snapshot) {
                              bool isLoading = snapshot.hasData ? (snapshot.data!) : false;
                              return Container(
                                height: 45,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 30,bottom: 30,),
                                child: CustomFields.buildLoadingButton(
                                  label: "Login",
                                  isLoading: isLoading,
                                  onPressed: () async {
                                    attemptLogin();
                                  },
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  void attemptLogin(){
    isAutoValidate = true;
    if(_formKey.currentState?.validate() ?? false){
      var username = _etControllerUsername.text;
      var password = _etControllerPassword.text;
      _loadingLogin.add(true);

      authProvider.login(username, password)

        .then((user){
          Navigator.pushReplacementNamed(context, Routes.DASHBOARD_PAGE, arguments: user);
        })

        .catchError((error,trace){
          print([error,trace]);
          if(error == ErrorCodes.no_user_found){
            CustomSnackBar.showError(context, "Username and password not found");
          }else{
            // Generic Error
            CustomSnackBar.showError(context, "An error occurred, Please try again");
          }
        })

        .whenComplete((){
          _loadingLogin.add(false);
        });
    }else{
      CustomSnackBar.showError(context, "Fields should not be empty");
    }
  }

}
