import 'dart:convert';
import 'dart:ffi';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/all_category.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/category_details.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/trancations_details_screens/pasbook_history_details.dart';

class PassbookScreen extends StatefulWidget {
  static const String route = '/PassbookScreen';

  @override
  _PassbookScreenState createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  late String amount = '';
  List<PassbookHistoryList> passbookHistoryList = [];
  var isDataFetched = false;
  String Createddate = '';
  String file_url_merchant = '';
  String file_url_user = '';
  String userImageShow = '';
  String fromDashboard = "DashBoard to PassBook";
  String AllDate="";

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callPassbookBalance(prefs.getString('AUTH_TOKEN').toString());
      _callPassbookBalanceHistory(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {});
  }

  _callPassbookBalance(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.PASSBOOK_USER_BALANCE),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        amount = dataAll['data']['wallet_amount'].toString();
        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  _callPassbookBalanceHistory(String tokenData) async {
    var auth_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    }
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.TRANSACTION_HISTORY),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $auth_token'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();

      setState(() {
        passbookHistoryList.clear();
      });
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        file_url_merchant = dataAll['file_url_merchant'];
        file_url_user = dataAll['file_url_user'];
        userImageShow = dataAll['user_img'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = PassbookHistoryList();
          if (dictResult['pay_by_type'].toString() == "merchant") {
            if (dictResult['merchant_details'] != null) {
              mdlSubData.name =
                  dictResult['merchant_details']['name'].toString();
              mdlSubData.image =
                  dictResult['merchant_details']['profile'].toString();
            } else {
              mdlSubData.name = '';
            }
          }
          if (dictResult['pay_by_type'].toString() == "customer") {
            if (dictResult['customer_info'] != null) {
              mdlSubData.name = dictResult['customer_info']['name'].toString();
              mdlSubData.image =
                  dictResult['customer_info']['profile'].toString();
            } else {
              mdlSubData.name = '';
            }
          }
          if (dictResult['type'].toString() == "cashback") {
            if (dictResult['user_details'] != null) {
              mdlSubData.name = dictResult['user_details']['name'].toString();
              mdlSubData.image =
                  dictResult['user_details']['profile'].toString();
            } else {
              mdlSubData.name = '';
            }
          }
          if (dictResult['type'].toString() == "subscription") {
            if (dictResult['user_details'] != null) {
              mdlSubData.name = dictResult['user_details']['name'].toString();
              mdlSubData.image =
                  dictResult['user_details']['profile'].toString();
            } else {
              mdlSubData.name = '';
            }
          }
          if (dictResult['type'].toString() == "refferal") {
            if (dictResult['user_details'] != null) {
              mdlSubData.name = dictResult['user_details']['name'].toString();
              mdlSubData.image =
                  dictResult['user_details']['profile'].toString();
            } else {
              mdlSubData.name = '';
            }
          }
          mdlSubData.time = dictResult['pay_time'].toString();
          mdlSubData.date = dictResult['created_at'].toString();
          //Createddate=mdlSubData.date;
          /*var dateTime = dfate;
          var date = dateTime.split('T');
          var date1 = date[0].trim();
          var time = dateTime.split('T') + dateTime.split('.');
          var time1 = time[1].trim();
          var time2 = time1.split('.');
          var timeFinal = time2[0].trim();
          Createddate = date1 + ", " + timeFinal;*/
          mdlSubData.amount = dictResult['amount'].toString();
          mdlSubData.type = dictResult['type'].toString();
          mdlSubData.pay_status = dictResult['pay_status'].toString();
          mdlSubData.transaction_id = dictResult['un_id'].toString();

          passbookHistoryList.add(mdlSubData);
        }

        setState(() {});
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashboardMainScreen()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashboardMainScreen()));
        }
        //ShowDialog();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backwardsCompatibility: false,
            /*systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Color(0xffFFF9EC)),*/
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.white,
           // backgroundColor: Color(0xffFFF9EC),
            actions: [],
            leading: IconButton(
              icon: Image.asset(
                'assets/images/Icon_back.png',
                height: 20,
                width: 20,
              ),
              onPressed: () {
                previousScreen();
              },
            ),

            title: Text(
              "Passbook",
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
        body:  Wrap(
          children: [
            Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(left: 15, right: 45, bottom: 15),
                child: Row(
                  children: [
                    Text(
                      "Current Wallet Balance",
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '\u{20B9}${amount.toString()}',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: MediaQuery.of(context).size.height,
                  child: Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemCount: passbookHistoryList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (ctx, index) {
                          var mdlSubData = passbookHistoryList[index];
                          return Card(
                            elevation: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PassbookTransactionHistory(
                                                mdlSubData.transaction_id,
                                                fromDashboard)));
                              },
                              child: Container(
                                padding: EdgeInsets.only(bottom: 15),
                                margin: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 1.0, color: Color(0xff787D86)),
                                  ),
                                ),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (mdlSubData.type == "Paid") ...[
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0)),
                                              child: CachedNetworkImage(
                                                  height: 50,
                                                  width: 50,
                                                  imageUrl: file_url_merchant +
                                                      "/" +
                                                      mdlSubData.image.toString(),
                                                  placeholder: (context, url) =>
                                                      Transform.scale(
                                                        scale: 0.4,
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: kYellowColor,
                                                          strokeWidth: 3,
                                                        ),
                                                      ),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      Container(
                                                          height: 40,
                                                          width: 40,
                                                          child: Image.asset(
                                                              'assets/images/account_profile.png')),
                                                  fit: BoxFit.cover),
                                            ),
                                          ],
                                        ),
                                      ] else if (mdlSubData.type == "Received") ...[
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0)),
                                              child: CachedNetworkImage(
                                                  height: 50,
                                                  width: 50,
                                                  imageUrl: file_url_merchant +
                                                      "/" +
                                                      mdlSubData.image.toString(),
                                                  placeholder: (context, url) =>
                                                      Transform.scale(
                                                        scale: 0.4,
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: kYellowColor,
                                                          strokeWidth: 3,
                                                        ),
                                                      ),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      Container(
                                                          height: 40,
                                                          width: 40,
                                                          child: Image.asset(
                                                              'assets/images/account_profile.png')),
                                                  fit: BoxFit.cover),
                                            ),
                                          ],
                                        ),
                                      ] else ...[
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100.0)),
                                              child: CachedNetworkImage(
                                                  height: 50,
                                                  width: 50,
                                                  imageUrl: file_url_user +
                                                      "/" +
                                                      userImageShow,
                                                  placeholder: (context, url) =>
                                                      Transform.scale(
                                                        scale: 0.4,
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: kYellowColor,
                                                          strokeWidth: 3,
                                                        ),
                                                      ),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      Container(
                                                          height: 40,
                                                          width: 40,
                                                          child: Image.asset(
                                                              'assets/images/account_profile.png')),
                                                  fit: BoxFit.cover),
                                            ),
                                          ],
                                        ),
                                      ],
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            if (mdlSubData.type == "Paid") ...[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    2,
                                                child: Text(
                                                  mdlSubData.type +
                                                      "  to" +
                                                      "\n" +
                                                      mdlSubData.name,
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ] else if (mdlSubData.type ==
                                                "Received") ...[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    2,
                                                child: Text(
                                                  mdlSubData.type +
                                                      "  from" +
                                                      "\n" +
                                                      mdlSubData.name,
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ] else if (mdlSubData.type ==
                                                "cashback") ...[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    2,
                                                child: Text(
                                                  mdlSubData.type,
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ] else if (mdlSubData.type ==
                                                "added") ...[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    2,
                                                child: Text(
                                                  mdlSubData.type +
                                                      " to Spendzz Wallet",
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ] else if (mdlSubData.type ==
                                                "subscription") ...[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    2,
                                                child: Text(
                                                  mdlSubData.type +
                                                      "  Plan Purchase from" +
                                                      "\n" +
                                                      mdlSubData.name,
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ] else ...[
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                    2,
                                                child: Text(
                                                  mdlSubData.type +
                                                      "\n" +
                                                      mdlSubData.name,
                                                  style: TextStyle(
                                                    overflow: TextOverflow.ellipsis,
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                                child: Text(
                                                  mdlSubData.date.substring(0,10)+" "+mdlSubData.time,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                //nextScreen();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(right: 15),
                                                child: Text(
                                                  '\u{20B9}${mdlSubData.amount}',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (mdlSubData.pay_status ==
                                                "success") ...[
                                              GestureDetector(
                                                onTap: () {
                                                  //nextScreen();
                                                },
                                                child: Container(
                                                  padding:
                                                  EdgeInsets.only(right: 15),
                                                  child: Text(
                                                    mdlSubData.pay_status,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.green,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ] else if (mdlSubData.pay_status ==
                                                "failed") ...[
                                              GestureDetector(
                                                onTap: () {
                                                  //nextScreen();
                                                },
                                                child: Container(
                                                  padding:
                                                  EdgeInsets.only(right: 15),
                                                  child: Text(
                                                    mdlSubData.pay_status,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.red,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ] else ...[
                                              GestureDetector(
                                                onTap: () {
                                                  //nextScreen();
                                                },
                                                child: Container(
                                                  padding:
                                                  EdgeInsets.only(right: 15),
                                                  child: Text(
                                                    mdlSubData.pay_status,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.orangeAccent,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ))
              ),
            )
          ],
        ),
      ),
    );
  }

  void nextScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CategoryDetails('', '', '')));
  }

  void previousScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }
}

class PassbookHistoryList {
  String file_url_merchant = '';
  String file_url_user = '';
  String user_img = '';
  String name = '';
  String amount = '';
  String date = '';
  String time = '';
  String transaction_id = '';
  String type = '';
  String image = '';
  String pay_status = '';
}
