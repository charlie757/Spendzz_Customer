import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/screens/account_screens/profile_screens/profile.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
class PinAccess extends StatefulWidget {
  const PinAccess({Key? key}) : super(key: key);

  @override
  _PinAccessState createState() => _PinAccessState();
}

class _PinAccessState extends State<PinAccess> {
  TextEditingController newTextEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  late String pin;


  @override
  void dispose() {
    newTextEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(height: 105),
                  Center(
                      child: Image.asset(
                    "assets/images/splash_logo.png",
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width - 100,
                  )),
                  SizedBox(height: 25),
                  Text(
                    'Enter Spendzz PIN',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    padding: EdgeInsets.only(left: 25,right: 25),
                    child:  PinCodeFields(
                      length: 4,
                      fieldBorderStyle: FieldBorderStyle.Square,
                      responsive: false,
                      fieldHeight:32.0,
                      fieldWidth: 32.0,
                      borderWidth:2.0,

                      autofocus: true,

                      borderRadius: BorderRadius.circular(25.0),
                      keyboardType: TextInputType.number,
                      autoHideKeyboard: false,
                      activeBorderColor: Colors.black26,
                      fieldBackgroundColor: Colors.white10,
                      borderColor: Colors.black,
                      textStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      animationDuration: const Duration(milliseconds: 200),
                      animationCurve: Curves.easeInOut,
                      switchInAnimationCurve: Curves.easeIn,
                      switchOutAnimationCurve: Curves.easeOut,
                      obscureText: true,
                      obscureCharacter: '✤',
                      animation: Animations.SlideInDown,
                      onComplete: (result) {
                        if(result!=null)
                          {
                            _callAccessPin(result);
                          }

                        // Your logic with code
                        print(result);
                        //pin=result;

                        print(result);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  _callAccessPin(String pin) async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['pin'] = pin;
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.ACCESS_PIN),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if(dataAll['status']==true)
          {
            Fluttertoast.showToast(
                msg: dataAll['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));
          }
        else
          {
            Fluttertoast.showToast(
                msg: dataAll['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }


      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: dataAll['error']['pin'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } finally {
      client.close();
    }
  }


}
