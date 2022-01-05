import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/account_screen/MyApp.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/intro_screen/signup_mobile.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
import 'package:timer_button/timer_button.dart';
import 'more_details_screen.dart';

class OtpScreen extends StatefulWidget {
  static const String route = '/OtpScreen';

  var otp = '';
  OtpScreen(this.phoneValue, this.otp);
  var phoneValue = '';
  late ProgressDialog pr;
  TextEditingController otpController = TextEditingController();
  @override
  _OtpScreenState createState() => _OtpScreenState(phoneValue,otp);


}

class _OtpScreenState extends State<OtpScreen> {
  _OtpScreenState(this.phoneValue,this.otp,);
  var phoneValue = '';
  var otp = '';
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  late Timer _timer;
  int _start = 9;
  bool styleOBJ = true;
  bool time= false;


  changeStyle(){

    setState(() {
      styleOBJ = false ;
    });
  }
  var status = true;

  @override
  void initState() {
    super.initState();
    Fluttertoast.showToast(
        msg: "Your Otp Is "+otp,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  late ProgressDialog pr;
  @override
  Widget build(BuildContext context) {

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
        onWillPop: () async => true,

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
                    GestureDetector(
                      onTap: (){
                        BackScreen();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 0, left: 25),
                        child: Align(
                          alignment: FractionalOffset.topLeft,
                          child: Icon(
                            Icons.keyboard_backspace_outlined,
                            color: Color(0xff303030),
                            size: 25.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5, left: 25),
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
                      height: 15,
                    ),
                    Center(
                        child: Image.asset(
                          "assets/images/splash_logo.png",
                          fit: BoxFit.fitWidth,
                          width: MediaQuery.of(context).size.width - 100,
                        )),
                    SizedBox(
                      height: 15,
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
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              phoneValue,
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: Divider(
                                height: 5,
                                thickness: 1,
                                color: Color(0xff787D86)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25,right: 25),
                      child: Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'OTP',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25,right: 25),

                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                        controller: otpController,
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Please enter OTP',

                        ),

                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Please enter OTP';
                          }
                        },

                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: Align(
                              alignment: FractionalOffset.center,
                              child: Text(
                                'Did not receive OTP?' ,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  color: blackTextColor,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),

                          GestureDetector(
                            onTap: ()
                            {

                              _callResendOtp();
                            },
                            child:Container(
                              child: Align(
                                alignment: FractionalOffset.bottomRight,
                                child: Visibility(
                                    child: Text(
                                      'ResendOtp',
                                      style: styleOBJ
                                          ? TextStyle(fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          decoration: TextDecoration.underline,
                                          color: kYellowColor,
                                          fontSize: 16.0)
                                          : TextStyle(fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                          fontStyle: FontStyle.normal,
                                          decoration: TextDecoration.underline,
                                          color: blackTextColor,
                                          fontSize: 16.0),)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 100.0, right: 100.0, top: 5, bottom: 0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: kYellowColor,
                            // borderRadius: BorderRadius.horizontal()),
                            borderRadius: BorderRadius.circular(20.0)),
                      /*  child: RaisedButton(
                          onPressed: status?(){

                          }: null,
                          child: Text('Continue',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),),),*/
                        child: FlatButton(
                          onPressed: status?(){
                            if (_formkey.currentState!.validate()) {
                              //nextScreen();
                              _callVerifyOtp();
                              return;
                            }
                          }: null,
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
  _callVerifyOtp() async {
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var verifyToken = prefs.getString('VERIFY_TOKEN') ?? '';
    mapBody['verify_token'] = verifyToken;
    mapBody['otp'] = otpController.text;

    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    //EasyLoading.show();
    try {
      var uriResponse = await client.post(Uri.parse(ApiConfig.app_base_url + ApiConfig.VERIFY_OTP), body: mapBody);
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        Fluttertoast.showToast(
            msg: dataAll['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('REGISTER_TOKEN', dataAll['register token'].toString());
        var accountStatus=dataAll['account_status'].toString();
        if(dataAll['account_status'].toString() == '1')
        {
          prefs.setString('AUTH_TOKEN', dataAll['auth_token'].toString());
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));
        }
        else
        {
          nextScreen();
        }
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
  _callResendOtp() async {
    EasyLoading.show(status: 'Resending Otp...');
    var mapBody = new Map<String, dynamic>();
    mapBody['mobile'] = phoneValue;
    var client = http.Client();
   // EasyLoading.show();
    try {
      var uriResponse = await client.post(Uri.parse(ApiConfig.app_base_url + ApiConfig.SIGNUP_WITH_MOBILE), body: mapBody);
      var dataAll = json.decode(uriResponse.body);
      if (uriResponse.statusCode == 200) {
        EasyLoading.dismiss();
        otpController.clear();
        Fluttertoast.showToast(
            msg: "Your Otp Is "+dataAll['otp'].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('VERIFY_TOKEN', dataAll['verify_token'].toString());
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MoreDetailsScreen()));
  }
  void BackScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUp_SignIn()));
  }
  void onBack()
  {

  }

}
