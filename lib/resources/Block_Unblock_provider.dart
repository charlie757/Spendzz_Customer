import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:spendzz/screens/login_signup_screens/login_signup_screen.dart';

class Block_UnblockUser extends ChangeNotifier{
  callLogOutApi(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    var mapBody = new Map<String, dynamic>();

    mapBody['token'] = auth_token;

    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(Uri.parse(ApiConfig.app_base_url + ApiConfig.LOG_OUT), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      });
      var dataAll = json.decode(uriResponse.body);
      //notifyListeners();
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if(dataAll['status']==true)
          {
           /* Fluttertoast.showToast(
                msg: dataAll['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0
            );*/
          }
        else
          {
            /*SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('LOGOUT_TOKEN', dataAll['message']);
            Fluttertoast.showToast(
                msg: dataAll['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0
            );
            logoutUser(context);*/

          }
      }
    } finally {
      client.close();
    }
   // notifyListeners();
  }
  logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('ON_BOARD_VIEWS', true);
    prefs.setBool('IS_LOGIN_DATA_STATUS', false);
    prefs.clear();
   // notifyListeners();

    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp_SignIn()));
  }

}