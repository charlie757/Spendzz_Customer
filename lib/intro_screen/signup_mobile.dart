import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/intro_screen/otp_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class SignUp_SignIn extends StatefulWidget {
  static const String route = '/SignUp_SignIn';
  @override
  _SignUp_SignInState createState() => _SignUp_SignInState();
}
class _SignUp_SignInState extends State<SignUp_SignIn> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String phoneNumber;
  late String otp;
  TextEditingController phoneNumberController = TextEditingController();
  late ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    SpinKitRotatingCircle(color: Colors.green);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kstatusBarColor,
    ));
    pr = new ProgressDialog(context, type: ProgressDialogType.normal,);
    pr.style(
        child:  SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),

        elevation: 10.0,
        insetAnimCurve: Curves.ease,
        progress: 0.0,
    );

    FocusNode myFocusNode = new FocusNode();
    return WillPopScope(
        onWillPop: () async {
          // Navigator.push(context, MaterialPageRoute(builder: (context) =>SignUp_SignIn()));
          if(Platform.isAndroid)
          {
            SystemNavigator.pop();
          }
          else
          {
            exit(0);
          }
          //ShowDialog();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/splash.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   // SpinKitRotatingCircle(color: Colors.green,SpinKitWaveType.start),
                    Container(
                      padding: EdgeInsets.only(top: 0, left: 25),
                      child: Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Sign Up / Sign in',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Center(
                        child: Image.asset(
                          "assets/images/splash_logo.png",
                          fit: BoxFit.fitWidth,
                          width: MediaQuery.of(context).size.width - 100,
                        )),
                    SizedBox(
                      height: 45,
                    ),
                    Container(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Phone Number',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                              autocorrect: true,
                              controller: phoneNumberController,
                              decoration: InputDecoration(
                                hintText: 'Enter Phone Number',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff787D86)),
                                ),
                              ),
                              /*validator: (String? value) {

                            phoneNumber=value!;
                            if (value.isEmpty) {
                              return 'Please enter phone number';
                            } else if (value.length < 10) {
                              return 'Please enter valid 10 digit phone number';
                            }
                          },*/
                              validator: (String? value) {

                                phoneNumber=value!;
                                String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                RegExp regExp = new RegExp(patttern);
                                if (value.isEmpty) {
                                  return 'Please enter mobile number';
                                } else if (!regExp.hasMatch(value)) {
                                  return 'Please enter valid mobile number';
                                }
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 100.0, right: 100.0, top: 25, bottom: 0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: kYellowColor,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: FlatButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                             // nextScreen();
                              _callLoginIntoAppApiInDataListings();
                              return;
                            }
                          },
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ),
          ),
        ));
  }

  _callLoginIntoAppApiInDataListings() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    mapBody['mobile'] = phoneNumber;
    var client = http.Client();
    try {
      var uriResponse = await client.post(Uri.parse(ApiConfig.app_base_url + ApiConfig.SIGNUP_WITH_MOBILE), body: mapBody);
      var dataAll = json.decode(uriResponse.body);
      if (uriResponse.statusCode == 200) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: dataAll['message'],
            //msg: 'successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );
        otp=dataAll['otp'].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('VERIFY_TOKEN', dataAll['verify_token'].toString());
        prefs.setString('MOBILE_NUMBER', phoneNumber);
        nextScreen();
      }
      else{
        EasyLoading.dismiss();
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
  void nextScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber,otp)));
  }
  void loading()
  {
    new Container(
      width: 500.0,
      padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
      color: Colors.green,
      child: new Column(
          children: [
            SpinKitWave(color: Colors.indigo, type: SpinKitWaveType.start),
            SpinKitFadingFour(color: Colors.indigo, shape: BoxShape.rectangle),
          ]
      ),
    );

  }


}



