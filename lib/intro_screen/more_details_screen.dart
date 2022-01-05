import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/intro_screen/otp_screen.dart';
import 'package:spendzz/intro_screen/signup_mobile.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;

class MoreDetailsScreen extends StatefulWidget {
  static const String route = '/MoreDetailsScreen';

  const MoreDetailsScreen({Key? key}) : super(key: key);

  @override
  _MoreDetailsScreenState createState() => _MoreDetailsScreenState();
}

class _MoreDetailsScreenState extends State<MoreDetailsScreen> {
  bool isChecked = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final dateController = TextEditingController();

  late String emailAddress;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kstatusBarColor,
    ));
    FocusNode myFocusNode = new FocusNode();
    return new WillPopScope(
        onWillPop: () async {
          _onBackPressed();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Form(
              autovalidate: true,
              key: _formkey,
              child: Container(
                padding: EdgeInsets.only(bottom: 125),
                /*height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/splash.png"),
                    fit: BoxFit.fill,
                  ),
                ),*/
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _onBackPressed();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 75, left: 25),
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
                      padding: EdgeInsets.only(top: 20, left: 25),
                      child: Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Enter More Details',
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
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Full Name *',
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
                              LengthLimitingTextInputFormatter(25),
                            ],
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            autocorrect: true,
                            controller: fullNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter Name',
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff303030)),
                              ),
                            ),
                           /* validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter Full Name';
                              }
                            },
*/

                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Email',
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
                    SizedBox(
                      height: 1,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: TextFormField(
                       // validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                          autocorrect: true,
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff787D86)),
                            ),
                          ),
                          /*validator: (String? value) {
                            emailAddress = value!;
                            String patttern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regExp = new RegExp(patttern);
                             if (!regExp.hasMatch(value)) {
                              return 'Please enter valid Email Address';
                            }
                          }*/
                         // RegExp regExp = new RegExp(patttern);





                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Date of Birth *',
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
                            readOnly: true,
                            controller: dobController,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),


                            autocorrect: true,
                            decoration: InputDecoration(
                              hintText: 'Pick your Date of Birth',
                            ),
/*
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter DOB';
                              }
                            },*/
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));

                              dobController.text =
                                  date.toString().substring(0, 10);
                            },

                          ),

                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Referral Code (Optional)',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          TextField(
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                              autocorrect: true,
                              controller: referralCodeController,
                              decoration: InputDecoration(
                                hintText: 'Enter Referral Code',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff787D86)),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Align(
                                alignment: FractionalOffset.topLeft,
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: kYellowColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    value: isChecked,
                                    onChanged: (bool? b) {
                                      setState(() {
                                        isChecked = b!;
                                      });
                                    },
                                  ),
                                )),
                          ),
                          /* Container(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                'By signing you agree to our',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  color: Color(0xff303030),
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15, left: 2),
                              child: Text(
                                'T&C',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  color: kYellowColor,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                ' and',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  color: Color(0xff303030),
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15, left: 3),
                              child: Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                  color: kYellowColor,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),*/
                          Container(
                              padding: EdgeInsets.only(top: 25),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "By signing you agree to our ",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      )),
                                  TextSpan(
                                      text: "T&C",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        color: kYellowColor,
                                        decoration: TextDecoration.underline,
                                        fontSize: 14.0,
                                      )),
                                  TextSpan(
                                      text: " and\n",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      )),
                                  TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        color: kYellowColor,
                                        decoration: TextDecoration.underline,
                                        fontSize: 14.0,
                                      )),
                                ]),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                           /* if (_formkey.currentState!.validate() && isChecked == true) {
                              //_callSendOtpIntoAppApiInDataListings();
                              //  NextScreen();
                              _callSignCompleteApiInDataListings();
                            }
                            else if(isChecked == false)
                              {
                                Fluttertoast.showToast(
                                    msg: "Please Accept Privacy Policy ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }*/

                              String patttern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regExp = new RegExp(patttern);
                              if (fullNameController.text.isEmpty) {
                                EasyLoading.showToast('Please enter Full Name.');
                                return;
                              }
                              else if(emailController.text.length >=1)
                              {
                                if (!regExp.hasMatch(emailController.text)) {
                                  EasyLoading.showToast('Please enter Valid Email Address.');
                                  return;
                                }
                                else if (dobController.text.isEmpty) {
                                  EasyLoading.showToast('Please enter dob.');
                                  return;
                                }

                                else if (isChecked == false) {
                                  EasyLoading.showToast('Please Accept Privacy Policy ');
                                  return;
                                }

                                else{
                                  _callSignCompleteApiInDataListings();
                                }
                              }
                              else if (dobController.text.isEmpty) {
                                EasyLoading.showToast('Please enter dob.');
                                return;
                              }

                              else if (isChecked == false) {
                                EasyLoading.showToast('Please Accept Privacy Policy ');
                                return;
                              }

                              else{
                                _callSignCompleteApiInDataListings();
                              }

                          /*  else if(!regExp.hasMatch(emailAddress))
                            {
                              Fluttertoast.showToast(
                                  msg: "Please Accept Privacy Policy ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }*/

                          /*  if (isChecked == false) {
                              Fluttertoast.showToast(
                                  msg: "Please Accept Privacy Policy ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }*/
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          floatingActionButton: Stack(
            children: [
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    height: 170,
                    child: Image.asset(
                      "assets/images/splash_background2.png",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    )), //Your widget here,
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    height: 150,
                    child: Image.asset(
                      "assets/images/splash_background1.png",
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                    ) //Your widget here,
                ),
              ),
            ],
          ),
        ));
  }

  _callSignCompleteApiInDataListings() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var register_token = prefs.getString('REGISTER_TOKEN') ?? '';
    mapBody['name'] = fullNameController.text;
    mapBody['email'] = emailController.text;
    mapBody['dob'] = dobController.text;
    mapBody['referralCode'] = referralCodeController.text;
    mapBody['register_token'] = register_token;
    var client = http.Client();
    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.SIGNUP_COMPLETE),
          body: mapBody);
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
            fontSize: 16.0);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //prefs.setString('NAME',fullNameController.text);
        prefs.setString('AUTH_TOKEN', dataAll['auth_token'].toString());
       // prefs.setBool('IS_LOGIN_DATA_STATUS', true);
        // prefs.setBool('IS_LOGIN_DATA_STATUS', true);
        NextScreen();
        //  Navigator.of(context).pushNamed(DashboardViewController.route);
      } else {
        EasyLoading.dismiss();
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



  void NextScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }

  _onBackPressed() {
    return showDialog(
          context: context,
          barrierColor: Color(0x00ffffff),
          builder: (context) => new AlertDialog(
            backgroundColor: klightYelloColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: new Text(
              'Exit Confirmation',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                color: kYellowColor,
                fontStyle: FontStyle.normal,
                fontSize: 17.0,
              ),
            ),
            content: new Text(
              'Do you want to exit ?',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w300,
                color: kYellowColor,
                fontStyle: FontStyle.normal,
                fontSize: 14.0,
              ),
            ),
            actions: <Widget>[
              new Container(
                padding: EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Ink(
                      height: 35,
                      width: 85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ), // LinearGradientBoxDecoration
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        splashColor: kYellowColor,
                        child: Align(
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: kYellowColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      // Red will correctly spread over gradient
                    ),
                    Ink(
                      height: 35,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ), // LinearGradientBoxDecoration
                      child: InkWell(
                        onTap: () {
                          if(Platform.isAndroid)
                            {
                              SystemNavigator.pop();
                            }
                          else
                            {
                              exit(0);
                            }
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        splashColor: kYellowColor,
                        child: Align(
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: kYellowColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      // Red will correctly spread over gradient
                    ),
                  ],
                ),
              )
            ],
          ),
        ) ??
        false;
  }
}
