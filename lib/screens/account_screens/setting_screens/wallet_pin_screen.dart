import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/account_screens/setting_screens/reset_pin_screen.dart';

import 'setting_screen.dart';

class WalletPinScreen extends StatefulWidget {
  const WalletPinScreen({Key? key}) : super(key: key);

  @override
  _WalletPinScreenState createState() => _WalletPinScreenState();
}

class _WalletPinScreenState extends State<WalletPinScreen> {
  bool status = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool isSwitched = false;
  bool pinFoundStatus = false;
  var textValue = 'Switch is OFF';
  late int pin_Status=0;


  @override
  void initState() {
    super.initState();
    pin_Status=0;
    _checkToken();
    //_callChangePinStatus();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('AUTH_TOKEN') != null) {

       _callCheckPin(prefs.getString('AUTH_TOKEN').toString());
       _callCheckPin_Field(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {
    });
  }

  _callCheckPin(String tokenData) async {
    var client = http.Client();
     EasyLoading.show(status: 'loading...');
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
        isSwitched=dataAll['status'];
        isSwitched=dataAll['status'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
        });
      }
    } finally {
      client.close();
    }
  }

  _callCheckPin_Field(String tokenData) async {
    var client = http.Client();
     EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.CHECK_PIN_FIELD),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      pinFoundStatus=dataAll['status'];
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        pinFoundStatus=dataAll['status'];
        setState(() {
        });
      }
    } finally {
      client.close();
    }
  }

  toggleSwitch(bool value) async {
    pin_Status=0;
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        pin_Status=1;
        EasyLoading.showToast('Switch Button is ON');
        _callChangePinStatus();
        return;
      });
    } else {
      setState(() {

        isSwitched = false;
        pin_Status=0;
        EasyLoading.showToast('Switch Button is OFF');
        _callChangePinStatus();
        return;
       // textValue = 'Switch Button is OFF';
      });
     // print('Switch Button is OFF');
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingScreen()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              Container(
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/Icon_back.png',
                        height: 20,
                        width: 20,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => SettingScreen()));
                      },
                    ),
                    Text(
                      'Wallet Pin',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0,
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Switch(
                    onChanged: toggleSwitch,
                    value: isSwitched,
                    activeColor: kYellowColor,
                    activeTrackColor: Colors.black,
                    inactiveThumbColor: Colors.black38,
                    inactiveTrackColor: Colors.black,
                  )),
            ],
            automaticallyImplyLeading: false,
            centerTitle: true),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  if (isSwitched==false) ...[

                  ] else ...[
                    if (pinFoundStatus==false) ...[
                      Container(
                        padding: EdgeInsets.all(25),
                        child: Column(
                          children: [
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                'Enter 4 Digit PIN',
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
                              controller: _pass,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
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
                              decoration: InputDecoration(
                                hintText: 'Enter Pin',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff787D86)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                'Re-Enter 4 Digit PIN',
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
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                                autocorrect: true,
                                controller: _confirmPass,
                                decoration: InputDecoration(
                                  hintText: 'ReEnter Pin',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Color(0xff787D86)),
                                  ),
                                ),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter 4 Digit PIN';
                                  } else if (val.length < 4) {
                                    return 'Please enter valid PIN';
                                  } else if (val != _pass.text) {
                                    return 'PIN Not Match';
                                  }
                                })
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ] else ...[
                      Container(
                        padding: EdgeInsets.all(25),
                        child: Column(
                          children: [
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                'Enter 4 Digit PIN',
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
                              controller: _pass,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(4),
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
                              decoration: InputDecoration(
                                hintText: '****',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff787D86)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                'Re-Enter 4 Digit PIN',
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
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                obscureText: true,
                                obscuringCharacter: "*",
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                                autocorrect: true,
                                controller: _confirmPass,
                                decoration: InputDecoration(
                                  hintText: '****',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Color(0xff787D86)),
                                  ),
                                ),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter 4 Digit PIN';
                                  } else if (val.length < 4) {
                                    return 'Please enter valid PIN';
                                  } else if (val != _pass.text) {
                                    return 'PIN Not Match';
                                  }
                                })
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPin()));
                        },child: Container(
                        padding: EdgeInsets.only(right: 25),
                        child: Align(
                          alignment: FractionalOffset.topRight,
                          child: Text(
                            'Reset Pin',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: kYellowColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      ),

                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
            child: Container(
              width: MediaQuery.of(context).size.width - 100,
              padding: const EdgeInsets.only(
                left: 50.0,
                right: 50.0,
              ),
              child: Stack(
                children: [
                  if (isSwitched == true) ...[
                    if (pinFoundStatus == true) ...[

                    ] else ...[
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 25),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 200,
                            decoration: BoxDecoration(
                                color: kYellowColor,
                                // borderRadius: BorderRadius.horizontal()),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: FlatButton(
                              onPressed: () {
                                if (_pass.text.isEmpty) {
                                  EasyLoading.showToast('Please enter Pin');
                                  return;
                                } else if (_pass.text.length < 4) {
                                  EasyLoading.showToast('Please enter Valid Pin');
                                  return;
                                } else if (_confirmPass.text.isEmpty) {
                                  EasyLoading.showToast('Please enter ConfirmPin');
                                  return;
                                } else if (_confirmPass.text.length < 4) {
                                  EasyLoading.showToast('Please enter Valid ConfirmPin');
                                  return;
                                } else if (_pass.text != _confirmPass.text) {
                                  EasyLoading.showToast('Password must be same as above');
                                  return;
                                } else {
                                  _callWalletPin();
                                }
                              },
                              child: Text(
                                'Set Pin',
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
                      )
                    ],
                  ] else ...[

                  ],
                ],
              ),
            )),
      ),
    );
  }


  _callChangePinStatus() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['pin_status'] = pin_Status.toString();
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.CHANGE_PIN_STATUS),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        Fluttertoast.showToast(
            msg: dataAll['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);

      }
        else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: dataAll['message'],
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
  _callWalletPin() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['pin'] = _pass.text.toString();
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.WALLET_PIN),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (dataAll['status'] == true) {
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);


          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingScreen()));
        } else {
          Fluttertoast.showToast(
              msg: 'The pin must be at least 4 characters.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
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
