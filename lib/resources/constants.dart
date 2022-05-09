import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/login_signup_screens/login_signup_screen.dart';

const kContentColorLightTheme = Colors.black;
const kContentColorDarkTheme = Colors.white;
const kYellowColor = Color(0xFFEE4B23);
const kstatusBarColor = /*Color(0xff5369AE)*/ Colors.white;
const klightYelloColor = Color(0xffFFF9EC);
const blackTextColor = Color(0xff303030);
/*String get noInternet => 'No Internet connection';*/
String get ok => "Dismiss";

class Block_UnblockUser {
  callLogOutApi(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    var mapBody = new Map<String, dynamic>();

    mapBody['token'] = auth_token;

    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client
          .get(Uri.parse(ApiConfig.app_base_url + ApiConfig.LOG_OUT), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      });
      var dataAll = json.decode(uriResponse.body);

      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('LOGOUT_TOKEN', dataAll['message']);
        Fluttertoast.showToast(
            msg: dataAll['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        logoutUser(context);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp_SignIn()));
      } else {
        Fluttertoast.showToast(
            msg: dataAll['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } finally {
      client.close();
    }
  }

  logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('ON_BOARD_VIEWS', true);
    prefs.setBool('IS_LOGIN_DATA_STATUS', false);
    // prefs.clear();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUp_SignIn()));
  }
}

showErrorSnackBar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      backgroundColor: Colors.red.shade500,
      content: Text(message),
      action: SnackBarAction(
        label: ok,
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
}

showSuccessSnackBar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      backgroundColor: Colors.green.shade500,
      content: Text(message),
      action: SnackBarAction(
        label: ok,
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
}
