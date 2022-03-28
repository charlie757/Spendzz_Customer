import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SubscribeScreen.dart';
import 'incoice_webView.dart';
class SubscribeScreenDetails extends StatefulWidget {
  const SubscribeScreenDetails({Key? key}) : super(key: key);

  @override
  _SubscribeScreenDetailsState createState() => _SubscribeScreenDetailsState();
}

class _SubscribeScreenDetailsState extends State<SubscribeScreenDetails> {
  String amount1='';
  String gst1='';
  String purchaseDate1 = '';
  String expiryDate1 = '';
  String remaining1 = '';
  String sss = '';
  String totalTime='';
  List<SubDataList> subData = [];
  String invoice = '';
  String invoiceFull = '';
  var isDataFetched = false;
  @override
  void initState() {
    super.initState();
    _callGetSubscribeDetails();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('GST') != null) {
      gst1=prefs.getString('GST').toString();
    }
    setState(() {
    });
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
          Uri.parse(ApiConfig.app_base_url + ApiConfig.PAYMENT_HISTORY),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $auth_token'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();

      setState(() {
        subData.clear();
      });
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = SubDataList();
          if(i==0)
            {
              purchaseDate1=mdlSubData.purchaseDate = dictResult['payment_date'].toString();
              expiryDate1=mdlSubData.expiryDate = dictResult['plan_expires'].toString();
              amount1=mdlSubData.amount = dictResult['amount'].toString();

              DateTime dt1 = DateTime.parse(expiryDate1);
              DateTime dt2 = DateTime.parse(purchaseDate1);

              Duration diff = dt1.difference(dt2);
              int date=diff.inDays+1;
              totalTime=date.toString();
            }
          mdlSubData.purchaseDate = dictResult['payment_date'].toString();
          mdlSubData.expiryDate = dictResult['plan_expires'].toString();
          mdlSubData.amount = dictResult['amount'].toString();
          mdlSubData.transactionID = dictResult['payment_id'].toString();
          mdlSubData.payment_invoice= dictResult['payment_uuid'].toString();
          invoice=  dictResult['payment_uuid'].toString();
          invoiceFull="https://testalphonic.com/projects/ramkesh/spendzz/payment-invoice/"+invoice;
          /*var purchaseDate1 = mdlSubData.purchaseDate;
          var parts = purchaseDate1.split(' ');
          purchaseDateMain = parts[0].trim();
          purchaseDate11=purchaseDateMain;*/
          //mdlSubData.purchaseDate = dictResult['payment_date'].toString();

          subData.add(mdlSubData);
        }

        setState(() {});
      }

    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    String purchaseDateMain='';
    String expiryDateMain='';
    String subPurchaseDate='';
    String subExpiryDate='';
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child:  Stack(
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
                            )),),



                    ],
                  ),
                ),
                SizedBox(height: 35,),
                Container(
                  padding: EdgeInsets.only(top: 190),
                  alignment:
                  FractionalOffset.bottomRight,
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 35,top: 25),
                      child: Container(
                        padding: EdgeInsets.all(1.0),
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Text(
                                        'Subscribe Status - Active',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Text(
                                        'Get Access of Your Wallet',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black54,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
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
                                    SizedBox(height: 10,),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Text(
                                        '\u{20B9}'+amount1.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                          color: kYellowColor,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 26.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Text(
                                        'Including GST \u{20B9}'+" {"+gst1+"}",
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black54,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10, top: 8, bottom: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Purchase Date',
                                                        style: TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontWeight: FontWeight.w300,
                                                          color: Colors.black54,
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Expiry Date',
                                                        style: TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontWeight: FontWeight.w300,
                                                          color: Colors.black54,
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Remaining Days',
                                                        style: TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontWeight: FontWeight.w300,
                                                          color: Colors.black54,
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),

                                                      SizedBox(
                                                        height: 10,
                                                      ),



                                                      Text(
                                                        'Auto Renew',
                                                        style: TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontWeight: FontWeight.w300,
                                                          color: Colors.black54,
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 15,),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10, top: 5, bottom: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 1,
                                                      ),
                                                      Text(
                                                      purchaseDateMain = purchaseDate1.split(' ').first,
                                                        style: TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black,
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        expiryDateMain = expiryDate1.split(' ').first,
                                                        style: TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black,
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                          width: 205,
                                                          child: Text(
                                                            totalTime+' Days',
                                                            maxLines: 2,
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              fontFamily: 'Rubik',
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              color: Colors.black,
                                                              fontStyle:
                                                              FontStyle.normal,
                                                              fontSize: 14.0,
                                                            ),
                                                          )),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        'Auto Renew',
                                                        style: TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontWeight: FontWeight.w300,
                                                          color: Colors.black54,
                                                          fontStyle: FontStyle.normal,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),



                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: ()
                                      {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => SubscribeScreen()));
                                      },child: Container(
                                      padding: EdgeInsets.only(right: 15,top:5),
                                      child:  Align(
                                        alignment: FractionalOffset.topRight,
                                        child: Text(
                                          'View Plan',
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
                                    )



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
                Container(
                  padding: EdgeInsets.only(top: 590,left: 20,right: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 5,left: 5),
                        child: Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'Subscribe History',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: subData.length,
                          //  itemCount: 23,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (ctx, index) {var mdlSubData = subData[index];
                            return Card(
                              color: klightYelloColor,
                              elevation: 0,
                              child: GestureDetector(
                                onTap: (){

                                },
                                child: Container(
                                  margin: EdgeInsets.all(0.0),

                                  child: Container(
                                    padding: EdgeInsets.only(right: 0),
                                    child: Card(
                                      color: klightYelloColor,
                                      elevation: 3,
                                      margin: EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 35,top: 25),
                                        child:  Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(
                                                                left: 10, top: 8, bottom: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Purchase Date',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Rubik',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: Colors.black,
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Expiry Date',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Rubik',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: Colors.black,
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Amount',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Rubik',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: Colors.black,
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Transaction ID',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Rubik',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: Colors.black,
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Gst',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Rubik',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: Colors.black,
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: ()
                                                                  {
                                                                    //webViewScreen();
                                                                    _launchUrlpdf();
                                                                  },
                                                                  child:   Text(
                                                                    'Invoice',
                                                                    style: TextStyle(
                                                                      decoration: TextDecoration.underline,
                                                                      fontFamily: 'Rubik',
                                                                      fontWeight: FontWeight.w500,
                                                                      color: kYellowColor,
                                                                      fontStyle: FontStyle.normal,
                                                                      fontSize: 14.0,
                                                                    ),
                                                                  ),
                                                                )

                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Container(
                                                            padding: EdgeInsets.only(
                                                                left: 10, top: 5, bottom: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 1,
                                                                ),
                                                                Text(
                                                                  //purchaseDateMain.toString(),
                                                                  subPurchaseDate = mdlSubData.purchaseDate.split(' ').first,
                                                                 /* mdlSubData.purchaseDate,*/
                                                                  //purchaseDate11.toString(),
                                                                  style: TextStyle(
                                                                    fontFamily: 'Rubik',
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black,
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  subPurchaseDate = mdlSubData.expiryDate.split(' ').first,
                                                                  //mdlSubData.expiryDate,
                                                                  style: TextStyle(
                                                                    fontFamily: 'Rubik',
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black,
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                    width: 205,
                                                                    child: Text(
                                                                      '\u{20B9}'+mdlSubData.amount,
                                                                      maxLines: 2,
                                                                      overflow:
                                                                      TextOverflow.ellipsis,
                                                                      style: TextStyle(
                                                                        fontFamily: 'Rubik',
                                                                        fontWeight:
                                                                        FontWeight.w500,
                                                                        color: Colors.black,
                                                                        fontStyle:
                                                                        FontStyle.normal,
                                                                        fontSize: 14.0,
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width/2,
                                                                  child: Text(
                                                                    mdlSubData.transactionID,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                      overflow: TextOverflow.ellipsis,
                                                                      fontFamily: 'Rubik',
                                                                      fontWeight: FontWeight.w500,
                                                                      color: Colors.black,
                                                                      fontStyle: FontStyle.normal,
                                                                      fontSize: 14.0,
                                                                    ),

                                                                  ),
                                                                ),

                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  '\u{20B9}'+gst1,
                                                                  style: TextStyle(
                                                                    fontFamily: 'Rubik',
                                                                    fontWeight: FontWeight.w500,
                                                                    color: Colors.black,
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 14.0,
                                                                  ),

                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  '',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Rubik',
                                                                    fontWeight: FontWeight.w300,
                                                                    color: Colors.black54,
                                                                    fontStyle: FontStyle.normal,
                                                                    fontSize: 14.0,
                                                                  ),

                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                              )

                                            ],

                                          ),

                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            );
                          },

                        ),
                      ),
                    ],
                  ),
                )


              ],
            ),
          ),
        ),

      ),
    );
  }


  void webViewScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Invoice(invoiceFull)));
  }

  _launchUrlpdf() async {
    if (await canLaunch(invoiceFull)) {
      await launch(invoiceFull,/*forceSafariVC: true, forceWebView: true*/);
    } else {
      throw 'Could not launch';
    }
  }
}
    class SubDataList {
  String purchaseDate = '';
  String expiryDate = '';
  String amount = '';
  String transactionID = '';
  String payment_invoice = '';
}
