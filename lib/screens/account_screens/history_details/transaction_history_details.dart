import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/account_screens/help_screens/normal_ticket/all_help_ticket_screen.dart';
import 'package:spendzz/screens/account_screens/help_screens/raise_ticket/raise_normal_ticket.dart';
import 'package:spendzz/screens/account_screens/history_details/review_rating_for_history.dart';
import 'package:spendzz/screens/account_screens/setting_screens/notifications.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/trancations_details_screens/add_review_rating_forPasbook.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/trancations_details_screens/passbook_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/pay_money_screen.dart';
import 'package:spendzz/screens/dashboard_screens/rating_review_screens/add_review_rating.dart';

import 'history_screen.dart';
class TransactionHistoryDetails extends StatefulWidget {
  var transaction_ID = '';
  var fromHomeScreen = "";

  TransactionHistoryDetails(this.transaction_ID, this.fromHomeScreen);

  @override
  _TransactionHistoryDetailsState createState() =>
      _TransactionHistoryDetailsState(transaction_ID, fromHomeScreen);
}

class _TransactionHistoryDetailsState
    extends State<TransactionHistoryDetails> {
  _TransactionHistoryDetailsState(this.transaction_ID, this.fromHomeScreen);

  var transaction_ID = '';
  var fromHomeScreen = "";

  //late int total_amount=0;
  late String total_amount = '';
  late String transaction_id = '';
  late String date = '';
  late String debit_from = '';
  late String debit_mobile = '';
  late String credit_to = '';
  late String credit_mobile = '';
  late String Createddate = '';
  String dfate = '';
  String type = 'noType';
  String time = '';
  String pay_by_type = '';
  String unique_key="";

  @override
  void initState() {
    setState(() {});
    super.initState();
    _callPassbookHistory();
  }

  _callPassbookHistory() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['tid'] = transaction_ID.toString();
    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(
            ApiConfig.app_base_url + ApiConfig.TRANSACTION_HISTORY_DETAILS),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if (dataAll['status'] == true) {
          total_amount = dataAll["data"]['amount'].toString();
          // date=dataAll["data"]['created_at'].toString();
          //var dateTime = dataAll["data"]['created_at'].toString();
          // dfate = dataAll["data"]['created_at'].toString();
          //to covert in date format
          var  dfated = dataAll["data"]['created_at'].toString();
          var date = DateTime.parse(dfated);
          var formattedDate = "${date.day}-${date.month}-${date.year}";
          print (formattedDate);
          dfate=formattedDate;

          time = dataAll["data"]['pay_time'].toString();
          type = dataAll["data"]['type'].toString();
          pay_by_type = dataAll["data"]['pay_by_type'].toString();
          if (dataAll["data"]['type'] == 'Paid') {
            if(pay_by_type=='customer')
              {
                debit_from = dataAll["data"]['user_details']['name'].toString();
                debit_mobile = dataAll["data"]['user_details']['mobile'].toString();
                credit_to = dataAll["data"]['customer_info']['name'].toString();
                credit_mobile = dataAll["data"]['customer_info']['mobile'].toString();
              }
            else{
              debit_from = dataAll["data"]['user_details']['name'].toString();
              debit_mobile = dataAll["data"]['user_details']['mobile'].toString();
              credit_to = dataAll["data"]['merchant_details']['name'].toString();
              unique_key= dataAll["data"]['merchant_details']['unique_key'].toString();
              credit_mobile = dataAll["data"]['merchant_details']['mobile'].toString();

            }

          } else if (dataAll["data"]['type'] == 'Received') {
            credit_to = dataAll["data"]['customer_info']['name'].toString();
            credit_mobile = dataAll["data"]['customer_info']['mobile'].toString();
            debit_from = dataAll["data"]['user_details']['name'].toString();
            debit_mobile = dataAll["data"]['user_details']['mobile'].toString();
          }
          else if (dataAll["data"]['type'] == 'refferal') {

          }

          setState(() {});
        } else {
          Fluttertoast.showToast(
              msg: 'error',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HistoryScreen()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HistoryScreen()));
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xffDFDCE5),
        appBar:  PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (type == "refferal") ...[
                    AppBar(
                        backwardsCompatibility: false,
                        systemOverlayStyle: SystemUiOverlayStyle(
                            statusBarColor: klightYelloColor),
                        toolbarHeight: 60,
                        elevation: 0,
                        backgroundColor: klightYelloColor,
                        actions: [],
                        leading: IconButton(
                          icon: Image.asset(
                            'assets/images/Icon_back.png',
                            height: 20,
                            color: Colors.black,
                            width: 20,
                          ),
                          onPressed: () {
                            previousScreen();
                          },
                        ),
                        title: Text(
                          "Referral Successful",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        automaticallyImplyLeading: true,
                        centerTitle: false)
                  ] else if (type == "subscription") ...[
                    AppBar(
                        backwardsCompatibility: false,
                        systemOverlayStyle: SystemUiOverlayStyle(
                            statusBarColor: klightYelloColor),
                        toolbarHeight: 60,
                        elevation: 0,
                        backgroundColor: klightYelloColor,
                        actions: [],
                        leading: IconButton(
                          icon: Image.asset(
                            'assets/images/Icon_back.png',
                            height: 20,
                            color: Colors.black,
                            width: 20,
                          ),
                          onPressed: () {
                            previousScreen();
                          },
                        ),
                        title: Text(
                          "Subscription Successful",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        automaticallyImplyLeading: true,
                        centerTitle: false)
                  ] else if (type == "cashback") ...[
                    AppBar(
                        backwardsCompatibility: false,
                        systemOverlayStyle: SystemUiOverlayStyle(
                            statusBarColor: klightYelloColor),
                        toolbarHeight: 60,
                        elevation: 0,
                        backgroundColor: klightYelloColor,
                        actions: [],
                        leading: IconButton(
                          icon: Image.asset(
                            'assets/images/Icon_back.png',
                            height: 20,
                            color: Colors.black,
                            width: 20,
                          ),
                          onPressed: () {
                            previousScreen();
                          },
                        ),
                        title: Text(
                          "Cashback Successful",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        automaticallyImplyLeading: true,
                        centerTitle: false)
                  ] else if (type == "Paid") ...[
                    AppBar(
                        backwardsCompatibility: false,
                        systemOverlayStyle:
                        SystemUiOverlayStyle(statusBarColor: Color(0xff2ba658)),
                        toolbarHeight: 60,
                        //toolbarHeight: MediaQuery.of(context).size.height,
                        elevation: 0,
                        backgroundColor: Color(0xff269e56),
                        actions: [],
                        leading: IconButton(
                          icon: Image.asset(
                            'assets/images/Icon_back.png',
                            height: 20,
                            color: Colors.white,
                            width: 20,
                          ),
                          onPressed: () {
                            previousScreen();
                          },
                        ),
                        title: Text(
                          "Transaction Successful",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        automaticallyImplyLeading: true,
                        centerTitle: false)
                  ] else if (type == "added") ...[
                    AppBar(
                        backwardsCompatibility: false,
                        systemOverlayStyle: SystemUiOverlayStyle(
                            statusBarColor: klightYelloColor),
                        toolbarHeight: 60,
                        elevation: 0,
                        backgroundColor: klightYelloColor,
                        actions: [],
                        leading: IconButton(
                          icon: Image.asset(
                            'assets/images/Icon_back.png',
                            height: 20,
                            color: Colors.black,
                            width: 20,
                          ),
                          onPressed: () {
                            previousScreen();
                          },
                        ),
                        title: Text(
                          "Added Successful",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        automaticallyImplyLeading: true,
                        centerTitle: false)
                  ] else if (type == "Received") ...[
                    AppBar(
                        backwardsCompatibility: false,
                        systemOverlayStyle:
                        SystemUiOverlayStyle(statusBarColor: Color(0xff2ba658)),
                        toolbarHeight: 60,
                       // toolbarHeight: MediaQuery.of(context).size.height,
                        elevation: 0,
                        backgroundColor: Color(0xff269e56),
                        actions: [],
                        leading: IconButton(
                          icon: Image.asset(
                            'assets/images/Icon_back.png',
                            height: 20,
                            color: Colors.white,
                            width: 20,
                          ),
                          onPressed: () {
                            previousScreen();
                          },
                        ),
                        title: Text(
                          "Transaction Successful",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        automaticallyImplyLeading: true,
                        centerTitle: false)
                  ]
                ],
              ),
            )),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.only(top: 1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Column(
                  children: [
                    if (type == "cashback") ...[
                      Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.0),
                              ),
                              child: Container(
                                color: klightYelloColor,
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Image.asset('assets/images/check.png',
                                      height: 90, fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('\u{20B9}' + total_amount,
                                style: TextStyle(
                                  color: kYellowColor, // <-- Change this
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                            if (type == "cashback") ...[
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  "Cashback From",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  "Spendzz",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Text(
                              dfate+" "+time,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black87,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (type == "added") ...[
                      Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.0),
                              ),
                              child: Container(
                                color: klightYelloColor,
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Image.asset('assets/images/check.png',
                                      height: 90, fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('\u{20B9}' + total_amount,
                                style: TextStyle(
                                  color: kYellowColor, // <-- Change this
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                            if (type == "added") ...[
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  "Money Added",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  " To Your Spendzz Wallet",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Text(
                                Createddate.toString(),
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black87,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (type == "refferal") ...[
                      Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.0),
                              ),
                              child: Container(
                                color: klightYelloColor,
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Image.asset('assets/images/check.png',
                                      height: 90, fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('\u{20B9}' + total_amount,
                                style: TextStyle(
                                  color: kYellowColor, // <-- Change this
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Text(
                                "Referral",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  color: kYellowColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Text(
                                "Amount from"+credit_to,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  color: kYellowColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Text(
                                Createddate.toString(),
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black87,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (type == "subscription") ...[
                      Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.0),
                              ),
                              child: Container(
                                color: klightYelloColor,
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Image.asset('assets/images/check.png',
                                      height: 90, fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('\u{20B9}' + total_amount,
                                style: TextStyle(
                                  color: kYellowColor, // <-- Change this
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Text(
                                "Money Added",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  color: kYellowColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Text(
                                " To Your Spendzz Wallet",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  color: kYellowColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Text(
                                Createddate.toString(),
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black87,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (type == "Paid") ...[
                      if(pay_by_type=="merchant")...[
                        Visibility(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(
                                        2.0, 2.0), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100.0),
                                    ),
                                    child: Container(
                                      color: klightYelloColor,
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: Image.asset('assets/images/check.png',
                                            height: 90, fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text('\u{20B9}' + total_amount,
                                      style: TextStyle(
                                        color: kYellowColor,
                                        // <-- Change this
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      )),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Text(
                                      "Money Transfer",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: kYellowColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Text(
                                      " Successfully",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: kYellowColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Text(
                                      dfate.substring(0,10)+" "+time,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: ()
                                        {
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (context) => Review_Rating_For_History(unique_key)));

                                        },child: Container(
                                          child: RatingBar.builder(
                                            initialRating: 0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 30,
                                            glowColor: kYellowColor,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: kYellowColor,
                                            ),
                                            onRatingUpdate: (rating) {
                                              Navigator.push(
                                                  context, MaterialPageRoute(builder: (context) => Review_Rating_For_History(unique_key)));

                                              // addRating=rating.toString();
                                              print(rating);
                                            },
                                          )),
                                      )

                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Visibility(
                            child: Container(
                              padding: EdgeInsets.only(left: 25),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    alignment: FractionalOffset.topLeft,
                                    child: Text(
                                      "Debit from ",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black38,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 0,
                                          child: Container(
                                            width: 55.00,
                                            height: 55.00,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                              color: Colors.red,
                                              image: DecorationImage(
                                                scale: 2,
                                                image: ExactAssetImage(
                                                    'assets/images/makepayment.png'),
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 1,
                                              right: 15,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      debit_from,
                                                      style: TextStyle(
                                                        fontFamily: 'Rubik',
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        letterSpacing: 2,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: 16.0,
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                    width: 120,
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      debit_mobile,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Align(
                                    alignment: FractionalOffset.topLeft,
                                    child: Text(
                                      "Credit to ",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black38,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 0,
                                          child: Container(
                                            width: 55.00,
                                            height: 55.00,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                              color: Colors.red,
                                              image: DecorationImage(
                                                scale: 2,
                                                image: ExactAssetImage(
                                                    'assets/images/makepayment.png'),
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 1,
                                              right: 15,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      credit_to,
                                                      style: TextStyle(
                                                        fontFamily: 'Rubik',
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        letterSpacing: 2,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: 16.0,
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                    width: 120,
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      credit_mobile,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ]
                      else if(pay_by_type=="customer")...[
                        Visibility(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    blurRadius: 2.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(
                                        2.0, 2.0), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100.0),
                                    ),
                                    child: Container(
                                      color: klightYelloColor,
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: Image.asset('assets/images/check.png',
                                            height: 90, fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text('\u{20B9}' + total_amount,
                                      style: TextStyle(
                                        color: kYellowColor,
                                        // <-- Change this
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      )),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Text(
                                      "Money Transfer",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: kYellowColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Text(
                                      " Successfully",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: kYellowColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Text(
                                      dfate.substring(0,10)+" "+time,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black87,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          child: RatingBar.builder(
                                            initialRating: 0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 30,
                                            glowColor: kYellowColor,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: kYellowColor,
                                            ),
                                            onRatingUpdate: (rating) {

                                              // addRating=rating.toString();
                                              print(rating);
                                            },
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Visibility(
                            child: Container(
                              padding: EdgeInsets.only(left: 25),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    alignment: FractionalOffset.topLeft,
                                    child: Text(
                                      "Debit from ",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black38,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 0,
                                          child: Container(
                                            width: 55.00,
                                            height: 55.00,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                              color: Colors.red,
                                              image: DecorationImage(
                                                scale: 2,
                                                image: ExactAssetImage(
                                                    'assets/images/makepayment.png'),
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 1,
                                              right: 15,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      debit_from,
                                                      style: TextStyle(
                                                        fontFamily: 'Rubik',
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        letterSpacing: 2,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: 16.0,
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                    width: 120,
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      debit_mobile,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Align(
                                    alignment: FractionalOffset.topLeft,
                                    child: Text(
                                      "Credit to ",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black38,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 0,
                                          child: Container(
                                            width: 55.00,
                                            height: 55.00,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20.0),
                                              color: Colors.red,
                                              image: DecorationImage(
                                                scale: 2,
                                                image: ExactAssetImage(
                                                    'assets/images/makepayment.png'),
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 1,
                                              right: 15,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      credit_to,
                                                      style: TextStyle(
                                                        fontFamily: 'Rubik',
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        letterSpacing: 2,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: 16.0,
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                    width: 120,
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      credit_mobile,
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ]

                    ] else if (type == "Received") ...[
                      Visibility(
                          child: Container(
                        padding: EdgeInsets.all(15),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 2.0,
                              spreadRadius: 0.0,
                              offset: Offset(
                                  2.0, 2.0), // shadow direction: bottom right
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100.0),
                              ),
                              child: Container(
                                color: klightYelloColor,
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: Image.asset('assets/images/check.png',
                                      height: 90, fit: BoxFit.fill),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('\u{20B9}' + total_amount,
                                style: TextStyle(
                                  color: kYellowColor,
                                  // <-- Change this
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                            if (type == "Received") ...[
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  "Money Received",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  " Successfully",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ] else if (type == "cashback") ...[
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  "Cashback From",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  "Spendzz",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ] else if (type == "Paid") ...[
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  "Money Transfer",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  " Successfully",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ] else if (type == "added") ...[
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  "Money Added",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: FractionalOffset.center,
                                child: Text(
                                  " Successfully",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: kYellowColor,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Text(
                                Createddate.toString(),
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black87,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      Visibility(
                          child: Container(
                        padding: EdgeInsets.only(left: 25),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            if (transaction_id == "")
                              ...[]
                            else ...[
                              Align(
                                alignment: FractionalOffset.topLeft,
                                child: Text(
                                  "Transaction ID",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black38,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: FractionalOffset.topLeft,
                                child: Text(
                                  transaction_id.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(
                              height: 25,
                            ),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                "Debit from ",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black38,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Container(
                                      width: 55.00,
                                      height: 55.00,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.red,
                                        image: DecorationImage(
                                          scale: 2,
                                          image: ExactAssetImage(
                                              'assets/images/makepayment.png'),
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 1,
                                        right: 15,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                debit_from,
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  letterSpacing: 2,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0,
                                                ),
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                              width: 120,
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                debit_mobile,
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
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                "Credit to ",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black38,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 0,
                                    child: Container(
                                      width: 55.00,
                                      height: 55.00,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.red,
                                        image: DecorationImage(
                                          scale: 2,
                                          image: ExactAssetImage(
                                              'assets/images/makepayment.png'),
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 1,
                                        right: 15,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                credit_to,
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  letterSpacing: 2,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0,
                                                ),
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                              width: 120,
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                credit_mobile,
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                    ]
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          width: 200,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 25, bottom: 20),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: kYellowColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Raise_Ticket_Normal(transaction_ID)));
                },
                child: Text(
                  'Need Help?',
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
      ),
    );
  }

  void previousScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HistoryScreen()));
  }

  Align buildConfettiWidget(controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        maximumSize: Size(30, 30),
        shouldLoop: false,
        particleDrag: 0.05,
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 0.05,
        confettiController: controller,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.explosive,
        // blastDirectionality: BlastDirectionality.directional,
        maxBlastForce: 20,
        // set a lower max blast force
        minBlastForce: 8,
        // set a lower min blast force

        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ],
      ),
    );
  }
}
