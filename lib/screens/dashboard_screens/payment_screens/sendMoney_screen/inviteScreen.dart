import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/category_details.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/addMoney_screen/add_money_history.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/pay_money_history.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contactScreen_screen.dart';

class InviteScreen extends StatefulWidget {
  var contactNumber = '';

  InviteScreen(this.contactNumber);

  @override
  _InviteScreenState createState() => _InviteScreenState(contactNumber);
}

class _InviteScreenState extends State<InviteScreen> {
  _InviteScreenState(this.contactNumber);

  var contactNumber = '';

  String inviteCode = "";
  String refferCode = "";
  @override
  void initState() {
    super.initState();
    _checkToken();
  }
  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callReferralCode(prefs.getString('AUTH_TOKEN').toString());
    }

    setState(() {});
  }
  _callReferralCode(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.REFERRAL_CODE),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      //inviteCode=
      print(dataAll);
      inviteCode=dataAll['referral_amount'].toString();
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        refferCode=dataAll['data']['referral_code'].toString();
        setState(() {
        });
      }
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (Platform.isAndroid) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactList()));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactList()));
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,),
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Text(
              contactNumber,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 20.0,
              ),
            ),
            leading: IconButton(
              icon: Image.asset(
                'assets/images/Icon_back.png',
                height: 20,
                width: 20,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactList()));
              },
            ),
          ),
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20,top: 20),
                          child: Column(
                            children: [
                              Text(contactNumber + ' has not have any Account',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                "You can still send money by invite",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20,top: 25),
                    child: Row(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "Invite Your Friends to Install Spendzz\nApplication.",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    padding: EdgeInsets.only(left: 20,top: 25),
                    child: Row(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Text(
                                "Choose an option from below",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0,
                                ),
                              )
                            ],
                          ),
                        )

                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Transform.rotate(
                          angle: -170 * math.pi / 100,
                          child: IconButton(
                            icon: Icon(
                              Icons.details,
                              color: kYellowColor,
                            ),
                            onPressed: null,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Earn upto "+'\u{20B9}${inviteCode}'+" cashback every time",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    "a friend makes their 1st payment from \nSpendzz App",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              )


                            ],
                          ),
                        )

                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 50),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 25, bottom: 5),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width/3,
                              decoration: BoxDecoration(
                                  color: kYellowColor,
                                  // borderRadius: BorderRadius.horizontal()),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: FlatButton(
                                onPressed: () {
                                  Share.share('https://play.google.com/store/apps/details?id=com.spendzz_merchant_business'+refferCode);

                                },
                                child: Text(
                                  'Invite Now',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),

                ],
              ),
            )
          ),
        ));
  }
   _launchWhatsapp() async {
     const url = "https://wa.me/?text=Hey buddy, try this super cool new app!";
     if (await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
  }
}
