import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/dashboard/account_screen.dart';
import 'package:spendzz/account_screen/wallet_pin_screen.dart';
import 'package:spendzz/dashboard/notifications.dart';
import 'package:spendzz/intro_screen/signup_mobile.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.white),
            elevation: 0,
            actions: [],
            leading: IconButton(
              icon: Image.asset(
                'assets/images/Icon_back.png',
                height: 20,
                width: 20,
              ),
              onPressed: () {
                nextPreviousScreen();
              },
            ),
            title: Text(
              "Setting",
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 20.0,
              ),
            ),
            automaticallyImplyLeading: true,
            centerTitle: false),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 25,right: 25),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: ()
                  {
                    nextWalletPinScreen();
                  },child:  Container(
                  child: Row(
                    children: [
                      Container(
                          child: Text('Wallet Pin',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          )
                      ),
                      Spacer(),
                      Container(
                        width: 27.00,
                        height: 27.00,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: klightYelloColor,
                          image: DecorationImage(
                            scale: 2,
                            image: ExactAssetImage('assets/images/forward_img.png'),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: ()
                  {
                    nextNotificationsScreen();
                  },child:Container(
                  child: Row(
                    children: [
                      Container(
                          child: Text('Notifications',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          )
                      ),
                      Spacer(),
                      Container(
                        width: 27.00,
                        height: 27.00,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: klightYelloColor,
                          image: DecorationImage(
                            scale: 2,
                            image: ExactAssetImage('assets/images/forward_img.png'),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(height: 15,),
                GestureDetector(
                  onTap: ()
                  {
                    signOutScreen();
                  },child:Container(
                  child: Row(
                    children: [
                      Container(
                          child: Text('Sign Out',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          )
                      ),
                      Spacer(),
                      Container(
                        width: 27.00,
                        height: 27.00,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: klightYelloColor,
                          image: DecorationImage(
                            scale: 2,
                            image: ExactAssetImage('assets/images/forward_img.png'),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
  void nextWalletPinScreen()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WalletPinScreen()));
  }
  void nextNotificationsScreen()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
  }
  void signOutScreen()
  {
    logOut();

  }
  void nextPreviousScreen()
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen()));

  }
  Future<void> logOut() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to logout'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the Dialog
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                //logoutUser();
                _calllogOutApi();
                //Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp_SignIn()));
              },
            ),
          ],
        );
      },
    );
  }
  _calllogOutApi() async {
    //FadeInImage.assetNetwork(placeholder: cupertinoActivityIndicator, image: "assets/images/splash.png");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    var mapBody = new Map<String, dynamic>();

    mapBody['token'] = auth_token;

    var client = http.Client();
    EasyLoading.show();
    try {
      var uriResponse = await client.get(Uri.parse(ApiConfig.app_base_url + ApiConfig.LOG_OUT), headers: {
        //'token':  auth_token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      });
      var dataAll = json.decode(uriResponse.body);

      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('LOGOUT_TOKEN', dataAll['message']);

        //var dd= prefs.setString('LOGOUT_TOKEN', dataAll['error'].toString());
        // prefs.setBool('IS_LOGIN_DATA_STATUS', true);
        Fluttertoast.showToast(
            msg: dataAll['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );
        logoutUser();
        //Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp_SignIn()));
      }
      else{
        Fluttertoast.showToast(
            msg: dataAll['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }
    } finally {
      client.close();
    }
  }
  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp_SignIn()));
  }
}
