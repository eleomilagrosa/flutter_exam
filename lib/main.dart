import 'package:flutter/material.dart';
import 'package:flutter_exam/constants/apptheme.dart';
import 'package:flutter_exam/constants/routes.dart';
import 'package:flutter_exam/controllers/auth_controller.dart';
import 'package:flutter_exam/controllers/dashboard_controller.dart';
import 'package:flutter_exam/data/model/user.dart';
import 'package:flutter_exam/utils/shared_preference_helper.dart';
import 'package:flutter_exam/views/dashboard/dashboard_screen.dart';
import 'package:flutter_exam/views/dashboard/search_station/search_station_page.dart';
import 'package:flutter_exam/views/login/login_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(user: await hasCurrentUser()));
}

Future<User?> hasCurrentUser()async{
  SharedPreferenceHelper sharedPreferenceHelper = SharedPreferenceHelper();
  await sharedPreferenceHelper.init();
  return sharedPreferenceHelper.getUser;
}

class MyApp extends StatelessWidget {
  late User? user;
  MyApp({Key? key,required this.user}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ],
      builder: (context, _) =>  MaterialApp(
          title: 'Sample App',
          debugShowCheckedModeBanner: false,
          initialRoute: user == null ? Routes.LOGIN_PAGE : Routes.DASHBOARD_PAGE,
          theme: themeDataDark,
          onGenerateRoute: (RouteSettings settings) {
            final arg = settings.arguments;
            switch (settings.name) {
              case Routes.DASHBOARD_PAGE:
                final User? argUser = (arg as User?) ?? user;
                user = null;
                return MaterialPageRoute(builder: (_) => DashboardScreen(user: argUser!));
              case Routes.SEARCH_STATION_PAGE:
                return MaterialPageRoute(builder: (_) => SearchStationScreen(arg as DashboardProvider));
              case Routes.LOGIN_PAGE:
              default:
                return MaterialPageRoute(builder: (_) => LoginScreen());
            }
          }
      ),
    );
  }
}