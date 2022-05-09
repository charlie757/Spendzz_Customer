import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/account_screens/account_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SubscribeScreenDetails.dart';

class SubscribeScreen extends StatefulWidget {
  var dashboard = '';
  SubscribeScreen(this.dashboard);
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState(dashboard);
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  var dashboard = '';
  _SubscribeScreenState(this.dashboard);
  List<SubDataList> subData = [];
  var isDataFetched = false;
  String gst = '';
  String amount = '';
  late int intValue;
  late int plan_id;
  late Razorpay _razorpay;
  late String name;
  late String email;
  late String mobile;
  late String paymentIdForApi;
  late int _razorpayAmount = intValue * 100;
  @override
  void initState() {
    super.initState();
    _callGetProfile();
    _callGetSubscribeDetails();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      //'key': 'rzp_live_GGUyTkH97ZWQTx',
      'key': 'rzp_test_XzDju6P1EB5RkQ',
      'amount': _razorpayAmount.toString(),
      'name': name,
      'description': 'Payment',
      'prefill': {'contact': mobile, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (dashboard == "dashboardScreen") {
            homeScreen();
          } else {
            accountScreen();
          }

          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: 65),
              child: Stack(
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: klightYelloColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          child: Center(
                              child: Image.asset(
                            "assets/images/splash_logo.png",
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.of(context).size.width - 100,
                          )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 190),
                    alignment: FractionalOffset.bottomRight,
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.all(20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 35, top: 25),
                        child: Container(
                          padding: EdgeInsets.all(1.0),
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: FractionalOffset.center,
                                        child: Text(
                                          'Subscribe Now',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: FractionalOffset.center,
                                        child: Text(
                                          'Become our User & Get access To Wallet',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: FractionalOffset.center,
                                        child: Text(
                                          'Yearly',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: FractionalOffset.center,
                                        child: Text(
                                          '\u{20B9}$amount',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w500,
                                            color: kYellowColor,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 26.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: FractionalOffset.center,
                                        child: Text(
                                          'Including GST (\u{20B9}$gst)',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 1),
                                      Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: subData.length,
                                          //  itemCount: 23,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (ctx, index) {
                                            var mdlSubData = subData[index];
                                            return Container(
                                              padding: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                              ),
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Align(
                                                  alignment:
                                                      FractionalOffset.topLeft,
                                                  child: Text(
                                                    '> ' + mdlSubData.title,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black54,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      /* Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Align(

                                          alignment: FractionalOffset.topLeft,
                                          child: Text(
                                            '1. Lorem ipsum dolor sit amet',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Align(

                                          alignment: FractionalOffset.topLeft,
                                          child: Text(
                                            '2. Lorem ipsum dolor sit amet',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Align(

                                          alignment: FractionalOffset.topLeft,
                                          child: Text(
                                            '3. Lorem ipsum dolor sit amet',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Align(

                                          alignment: FractionalOffset.topLeft,
                                          child: Text(
                                            '4. Lorem ipsum dolor sit amet',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),*/
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            width: 200,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 25, bottom: 0),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: kYellowColor,
                    borderRadius: BorderRadius.circular(20.0)),
                child: FlatButton(
                  onPressed: () {
                    openCheckout();
                    /*Navigator.push(
                        context, MaterialPageRoute(builder: (context) => SubscribeScreenDetails()));*/
                    /*Navigator.push(
                        context, MaterialPageRoute(builder: (context) => SubscribeScreenDetails()));*/
                    /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SubscribeScreenDetails()));*/
                    //openwhatsapp();
                  },
                  child: Text(
                    'Subscribe Now',
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
          ),
        ));
  }

  void accountScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }

  void homeScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }

  _callGetSubscribeDetails() async {
    var auth_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    }
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.GET_SUBSCRIBE_DETAILS),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $auth_token'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      amount = dataAll['amount'];
      intValue = int.parse(dataAll['amount']);
      plan_id = (dataAll['plan_id']);
      String intToStr = "$plan_id";
      gst = dataAll['gst'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('GST', dataAll['gst'].toString());
      setState(() {
        subData.clear();
      });
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['features'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = SubDataList();
          mdlSubData.title = dictResult['title'].toString();
          subData.add(mdlSubData);
        }

        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  _callGetProfile() async {
    var register_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      register_token = prefs.getString('AUTH_TOKEN') ?? '';
    }
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.GET_PROFILE),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $register_token'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        name = dataAll['data']['name'].toString();
        email = dataAll['data']['email'].toString();
        mobile = dataAll['data']['mobile'].toString();
      }
    } finally {
      client.close();
    }
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    paymentIdForApi = response.paymentId.toString();
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId.toString()
        /*+ response.orderId.toString()
            + response.signature.toString()*/
        ,
        timeInSecForIosWeb: 4,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    _callSendPaymentId();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " +
            response.code.toString() +
            " - " +
            response.message.toString(),
        timeInSecForIosWeb: 4);
    Fluttertoast.showToast(
        msg: "SUCCESS: " +
            response.code.toString() +
            " - " +
            response.message.toString(),
        timeInSecForIosWeb: 4,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName.toString(),
        timeInSecForIosWeb: 4);

    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.walletName.toString(),
        timeInSecForIosWeb: 4,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _callSendPaymentId() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['payment_id'] = paymentIdForApi.toString();
    mapBody['plan_id'] = plan_id.toString();
    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.PAYMENT_UPDATE),
        headers: headers,
        body: mapBody,
      );
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SubscribeScreenDetails()));
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
}

class SubDataList {
  String title = '';
}
