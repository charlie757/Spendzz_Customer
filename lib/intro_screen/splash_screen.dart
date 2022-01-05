import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/intro_screen/signup_mobile.dart';
import 'package:spendzz/resources/constants.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;
  @override
  void initState() {
    super.initState();
    this._callIntroScreen();
  }
  _callIntroScreen()
  {
   var duration = Duration(seconds: 3);
   timer =Timer(duration,()
   {
     _navigateToFirstAppScreen();
   });
  }

  _navigateToFirstAppScreen() async {
    timer.cancel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('IS_LOGIN_DATA_STATUS') != null) {
      Navigator.of(context).pushNamed(DashboardMainScreen.route);
    }
    else{
      Navigator.of(context).pushNamed(OnboardingScreen.route);
    }
  }
/*  _navigateToIntroScreen()
  {

    timer.cancel();
 //   Navigator.of(context).pushNamed(OnboardingScreen.route);
    var route = new MaterialPageRoute(builder: (BuildContext context) => new OnboardingScreen());
    Navigator.of(context).push(route);
  }*/
  /*_navigateToFirstAppScreen() async {
    timer.cancel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('LOGOUT_TOKEN') == "Logout successful") {
      Navigator.of(context).pushNamed(SignUp_SignIn.route);
    }
    else{
      Navigator.of(context).pushNamed(DashboardMainScreen.route);
    }
  }*/
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kstatusBarColor,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
              child: Image.asset(
            "assets/images/splash_logo.png",
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width - 100,
          )),

      ),

    );
  }
}
