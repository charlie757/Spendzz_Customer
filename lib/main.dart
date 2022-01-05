import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:spendzz/account_screen/profile.dart';
import 'account_screen/animation_file.dart';
import 'dashboard/account_screen.dart';
import 'account_screen/help_screen.dart';
import 'account_screen/help_screen.dart';
import 'account_screen/history_screen.dart';
import 'account_screen/referEarn_screen.dart';
import 'account_screen/setting_screen.dart';
import 'category/add_review.dart';
import 'category/all_category.dart';
import 'category/category_details.dart';
import 'dashboard/add_money_screen.dart';
import 'dashboard/dashboard_main_screen.dart';
import 'intro_screen/more_details_screen.dart';
import 'intro_screen/onboarding_screen.dart';
import 'intro_screen/otp_screen.dart';
import 'intro_screen/signup_mobile.dart';
import 'intro_screen/splash_screen.dart';

void main()
{
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
  configLoading();
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) =>SplashScreen()/*MoreDetailsScreen()*//*DashboardMainScreen()*/,

        SignUp_SignIn.route: (context) => SignUp_SignIn(),
        OnboardingScreen.route: (context) => OnboardingScreen(),
        DashboardMainScreen.route: (context) => DashboardMainScreen(),
        MoreDetailsScreen.route: (context) => MoreDetailsScreen(),
      },
    );
  }
}