import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/account_screens/account_screen.dart';
import 'package:spendzz/screens/account_screens/help_screens/normal_ticket/all_help_ticket_screen.dart';
import 'package:spendzz/screens/account_screens/history_details/transaction_history_details.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/all_category.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/category_details.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';

import '../../dashboard_screens/payment_screens/trancations_details_screens/pasbook_history_details.dart';
import '../help_screens/raise_ticket/raise_normal_ticket.dart';

class HistoryScreen extends StatefulWidget {
  static const String route = '/HistoryScreen';

  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<TrancationHistoryList> trancationHistoryList = [];
  var isDataFetched = false;
  String Monthly = '';
  String type = '';
  String Createddate = '';
  String file_url_merchant = '';
  String file_url_user = '';
  String userImageShow = '';
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callTransactionHistory(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {});
  }

  _callTransactionHistory(String tokenData) async {
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
        trancationHistoryList.clear();
      });
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        file_url_merchant = dataAll['file_url_merchant'];
        file_url_user = dataAll['file_url_user'];
        userImageShow = dataAll['user_img'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = TrancationHistoryList();
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
          mdlSubData.time = dictResult['pay_time'].toString();
          mdlSubData.date = dictResult['created_at'].toString();
          mdlSubData.amount = dictResult['amount'].toString();
          mdlSubData.type = dictResult['type'].toString();
          mdlSubData.pay_status = dictResult['pay_status'].toString();
          mdlSubData.transaction_id = dictResult['un_id'].toString();

          trancationHistoryList.add(mdlSubData);
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
        previousScreen();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Color(0xffFFF9EC)),
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
                        previousScreen();
                      },
                    ),
                    Text(
                      'History',
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
              GestureDetector(
                onTap: () {
                  fitterPopup();
                },
                child: Container(
                  height: 75,
                  width: 75,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Image.asset('assets/images/fittler.png'),
                ),
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: true),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(left: 0, right: 0),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 15),
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      //shrinkWrap: true,
                      itemCount: trancationHistoryList.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (ctx, index) {
                        var mdlSubData = trancationHistoryList[index];
                        return Card(
                          elevation: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TransactionHistoryDetails(
                                              mdlSubData.transaction_id, "")));
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
                                    ] else if (mdlSubData.type ==
                                        "Received") ...[
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                mdlSubData.type +
                                                    "  from" +
                                                    "\n" +
                                                    mdlSubData.name,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                    "  from" +
                                                    "\n" +
                                                    mdlSubData.name,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                            mdlSubData.date.substring(0, 10) +
                                                " " +
                                                mdlSubData.time,
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
                                              padding:
                                                  EdgeInsets.only(right: 15),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }

  void fitterPopup() {
    final dateController = TextEditingController();
    DateTime dateToday = DateTime(DateTime.now().year);
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Container(
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                GestureDetector(
                  onTap: () {
                    type = 'all';
                    _callHistoryFitter();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                            child: Text(
                          'All',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    type = 'paid';
                    _callHistoryFitter();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                            child: Text(
                          'Paid',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    type = 'received';
                    _callHistoryFitter();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                            child: Text(
                          'Received',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    type = 'added';
                    _callHistoryFitter();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                            child: Text(
                          'Added',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    //type='monthly';
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Container(
                      child: ExpansionTile(
                        iconColor: kYellowColor,
                        title: Container(
                          child: GestureDetector(
                            onTap: () {
                              //type='monthly';
                            },
                            child: Text(
                              'Monthly',
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
                        children: [
                          ListTile(
                            title: Text(
                              'January',
                            ),
                            onTap: () {
                              Monthly = '1';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '2';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('February'),
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '3';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('March'),
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '4';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('April'),
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '5';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('May'),
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '6';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('June'),
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '7';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('July'),
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '8';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('August'),
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '9';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('September'),
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '10';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('October'),
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '11';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('November'),
                          ),
                          ListTile(
                            onTap: () {
                              Monthly = '12';
                              type = 'monthly';
                              _callHistoryFitter();
                              Navigator.pop(context);
                            },
                            title: Text('December'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(
                  height: 10,
                ),
                /*  GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Text(
                          'Request to Statement ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(
                                        'Start Date',
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
                                      height: 1,
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        new LengthLimitingTextInputFormatter(4),
                                      ],
                                      decoration: new InputDecoration(
                                        hintText: 'DD/MM/YY',
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(right: 25, left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(
                                        'End Date',
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
                                      height: 1,
                                    ),
                                    TextField(
                                      readOnly: true,
                                      controller: dateController,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                      autocorrect: true,
                                      decoration: InputDecoration(
                                        hintText: 'DD/MM/YY',
                                      ),
                                      onTap: () async {
                                        var date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100));
                                        dateController.text =
                                            date.toString().substring(0, 10);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 100.0, right: 100.0, top: 5, bottom: 20),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: kYellowColor,
                            // borderRadius: BorderRadius.horizontal()),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: FlatButton(
                          onPressed: () {

                          //  _callHistoryFitter();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Submit',
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
                )*/
              ],
            ),
          ),
        );
      },
    );
  }

  _callHistoryFitter() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['type'] = type.toString();
    mapBody['value'] = type.toString();
    if (Monthly == '') {
      mapBody['value'] = '2022' + '-' + '1';
    } else {
      mapBody['value'] = '2022' + '-' + Monthly.toString();
    }

    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.FILTER_HISTORY),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      print("dataAll ${dataAll}");
      EasyLoading.dismiss();
      setState(() {
        trancationHistoryList.clear();
      });
      if (dataAll['status'] == true) {
        if (uriResponse.statusCode == 200) {
          var arrResults = dataAll['data'];
          print("arrResults ${arrResults}");
          isDataFetched = true;
          for (var i = 0; i < arrResults.length; i++) {
            var dictResult = arrResults[i];
            var mdlSubData = TrancationHistoryList();
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
                mdlSubData.name =
                    dictResult['customer_info']['name'].toString();
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
            mdlSubData.time = dictResult['pay_time'].toString();
            mdlSubData.date = dictResult['created_at'].toString();
            mdlSubData.amount = dictResult['amount'].toString();
            mdlSubData.type = dictResult['type'].toString();
            mdlSubData.pay_status = dictResult['pay_status'].toString();
            print("mdlSubData.pay_status ${mdlSubData.pay_status}");
            mdlSubData.transaction_id = dictResult['un_id'].toString();

            trancationHistoryList.add(mdlSubData);
            /*if(dictResult['merchant_details']!=null)
              {
                mdlSubData.name = dictResult['merchant_details']['name'].toString();
              }
              else
              {
                mdlSubData.name = '';
              }
              mdlSubData.time = dictResult['pay_time'].toString();
              mdlSubData.date = dictResult['created_at'].toString();
              mdlSubData.amount = dictResult['amount'].toString();
              mdlSubData.type = dictResult['type'].toString();
              mdlSubData.transaction_id = dictResult['un_id'].toString();

              trancationHistoryList.add(mdlSubData);*/
          }

          setState(() {});
        }
      } else {
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
}

class TrancationHistoryList {
  String name = '';
  String amount = '';
  String date = '';
  String transaction_id = '';
  String type = '';
  String file_url_merchant = '';
  String file_url_user = '';
  String user_img = '';
  String image = '';
  String time = '';
  String pay_status = '';
}
