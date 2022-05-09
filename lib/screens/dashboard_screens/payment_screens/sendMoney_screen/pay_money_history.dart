import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
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
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/trancations_details_screens/passbook_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/pay_money_screen.dart';
import 'package:http/http.dart' as http;
class payMoneyHistory extends StatefulWidget {
  var Un_Id='';
  payMoneyHistory(this.Un_Id);

  @override
  _payMoneyHistoryState createState() => _payMoneyHistoryState(Un_Id);
}

class _payMoneyHistoryState extends State<payMoneyHistory> {
  _payMoneyHistoryState(this.Un_Id);
  var transaction_ID='';
  var Un_Id='';
  //late int total_amount=0;
  late String total_amount='';
  late String transaction_id='';
  late String date='';
  late String debit_from='';
  late String debit_mobile='';
  late String credit_to='';
  late String credit_mobile='';
  late String raisedOn='';
  @override
  void initState() {
    setState(() {

    });
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    _callTicketHistory();
    setState(() {
      //controllerTopCenter.play();
    });
  }

  _callTicketHistory() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['tid'] = Un_Id.toString();


    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.TRANSACTION_HISTORY_DETAILS),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if(dataAll['status']==true)
        {

          total_amount=dataAll["data"]['amount'].toString();
         // total_amount=dataAll["data"]['un_id'].toString();
         // date=dataAll["data"]['created_at'].toString();
          var dateCreated=dataAll["data"]['created_at'].toString();
          var payTime=dataAll["data"]["pay_time"];
          var dateTime = dateCreated;
          var date = dateTime.split('T');
          var date1 = date[0].trim();
          var time = dateTime.split('T') + dateTime.split('.');
          var time1 = time[1].trim();
          var time2 = time1.split('.');
          var timeFinal = time2[0].trim();
          raisedOn = date1 + ", " + payTime;

          if(dataAll["data"]['type']=='Paid')
          {
            if(dataAll["data"]['pay_by_type']=='customer')
              {
                debit_from=dataAll["data"]['user_details']['name'].toString();
                debit_mobile=dataAll["data"]['user_details']['mobile'].toString();

                credit_to=dataAll["data"]['customer_info']['name'].toString();
                credit_mobile=dataAll["data"]['customer_info']['mobile'].toString();
              }
            else {
              debit_from=dataAll["data"]['user_details']['name'].toString();
              debit_mobile=dataAll["data"]['user_details']['mobile'].toString();

              credit_to=dataAll["data"]['merchant_details']['name'].toString();
              credit_mobile=dataAll["data"]['merchant_details']['mobile'].toString();
            }

          }
          else
          {
            credit_to=dataAll["data"]['user_details']['name'].toString();
            credit_mobile=dataAll["data"]['user_details']['mobile'].toString();

            debit_from=dataAll["data"]['merchant_details']['name'].toString();
            debit_mobile=dataAll["data"]['merchant_details']['mobile'].toString();
          }


          setState(() {

          });
        }
        else
        {
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
        if(Platform.isAndroid)
        {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>PassbookScreen()));
        }
        else
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>PassbookScreen()));
        }
        //ShowDialog();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(

          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: 370,
                  decoration: BoxDecoration(
                    color: klightYelloColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
                  ),

                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 85),
                        child: Image.asset('assets/images/check.png',width: 90,
                            height: 90,
                            fit:BoxFit.fill  ),
                      ),
                      SizedBox(height: 20,),
                      Text('\u{20B9}'+total_amount,
                          style: TextStyle(
                            color: kYellowColor, // <-- Change this
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
                            fontSize:20.0,
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
                            fontSize:20.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Text(
                          raisedOn.toString(),
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black87,
                            fontStyle: FontStyle.normal,
                            fontSize:18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      if(transaction_id=="")...[

                      ]
                      else...[
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            "Transaction ID",
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black38,
                              fontStyle: FontStyle.normal,
                              fontSize:18.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            transaction_id.toString(),
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize:18.0,
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: 25,),
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          "Debit from ",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black38,
                            fontStyle: FontStyle.normal,
                            fontSize:18.0,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Expanded(
                              flex:0,
                              child:  Container(
                                width: 55.00,
                                height: 55.00,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.red,
                                  image: DecorationImage(
                                    scale: 2,
                                    image: ExactAssetImage(
                                        'assets/images/makepayment.png'),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),),
                            SizedBox(width: 10,),
                            Expanded(
                              flex:2,
                              child: Container(padding: EdgeInsets.only(top: 1, right: 15,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                              ),),

                          ],
                        ),
                      ),

                      SizedBox(height: 25,),
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          "Credit to ",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black38,
                            fontStyle: FontStyle.normal,
                            fontSize:18.0,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Expanded(
                              flex:0,
                              child:  Container(
                                width: 55.00,
                                height: 55.00,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.red,
                                  image: DecorationImage(
                                    scale: 2,
                                    image: ExactAssetImage(
                                        'assets/images/makepayment.png'),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),),
                            SizedBox(width: 10,),
                            Expanded(
                              flex:2,
                              child: Container(padding: EdgeInsets.only(top: 1, right: 15,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                              ),),

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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          width: 200,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 0, right: 0, top: 25, bottom: 20),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: kYellowColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>Raise_Ticket_Normal(Un_Id)));
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));
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
