import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/screens/intro_screens/pin_access_screen.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/screens/login_signup_screens/login_signup_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'onboarding_screen.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Block_UnblockUser _block_unblockUser = Block_UnblockUser();
  bool pinStatus = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    this._callIntroScreen();
  }

  _callIntroScreen() {
    var duration = Duration(seconds: 1);
    timer = Timer(duration, () {
      _navigateToFirstAppScreen();
    });
  }

  _callCheckPin(String tokenData) async {
    var client = http.Client();

    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.CHECK_PIN_STATUS),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        pinStatus = dataAll['status'];
        if (pinStatus == true) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PinAccess()));
        } else if (dataAll['status'] == false) {
          if (dataAll['check_status'] == 0) {
            Fluttertoast.showToast(
                msg: dataAll['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            _block_unblockUser.callLogOutApi(context);
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardMainScreen()));
          }
        }
        /*  else{
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));
          }*/
        setState(() {});
      } else {
        EasyLoading.dismiss();
      }
    } finally {
      EasyLoading.dismiss();
      client.close();
    }
  }

  _navigateToFirstAppScreen() async {
    timer.cancel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('ON_BOARD_VIEWS') == true) {
      if (prefs.getBool('IS_LOGIN_DATA_STATUS') == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('AUTH_TOKEN') != null) {
          _callCheckPin(prefs.getString('AUTH_TOKEN').toString());
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignUp_SignIn()));
        }
        //  Get.to(DashboardMainScreen());
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp_SignIn()));
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
    }
  }

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
