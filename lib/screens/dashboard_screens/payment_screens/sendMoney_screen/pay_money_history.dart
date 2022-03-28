import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/account_screens/help_screens/normal_ticket/normal_help_screen.dart';
import 'package:spendzz/screens/account_screens/help_screens/normal_ticket/raise_normal_ticket.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/passbook_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/pay_money_screen.dart';
class payMoneyHistory extends StatefulWidget {
  const payMoneyHistory({Key? key}) : super(key: key);

  @override
  _payMoneyHistoryState createState() => _payMoneyHistoryState();
}

class _payMoneyHistoryState extends State<payMoneyHistory> {
  late int total_amount=0;
  late String transaction_id='';
  late String date='';
  late String debit_from='';
  late String credit_to='';
  late String credit_mobile='';
  late String debit_mobile='';
  late ConfettiController controllerTopCenter;
  late String un_id='';
  @override
  void initState() {
    setState(() {

    });
    super.initState();
    initController();
    _checkToken();
  }
  void initController() {
    controllerTopCenter = ConfettiController(duration: const Duration(seconds: 1));
  }
  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('total_amount') != null) {
      total_amount= prefs.getInt('total_amount')!;
    }
    if (prefs.getString('transaction_id') != null) {
      transaction_id=prefs.getString('transaction_id')!;
    }
    if (prefs.getString('date') != null) {
      date=prefs.getString('date')!;
    }
    if (prefs.getString('debit_from') != null) {
      debit_from=prefs.getString('debit_from')!;
    }
    if (prefs.getString('credit_to') != null) {
      credit_to=prefs.getString('credit_to')!;
    }
    if (prefs.getString('un_id') != null) {
      un_id=prefs.getString('un_id')!;
    }

    if (prefs.getString('credit_mobile') != null) {
      credit_mobile=prefs.getString('credit_mobile')!;
    }

    if (prefs.getString('debit_mobile') != null) {
      debit_mobile=prefs.getString('debit_mobile')!;
    }
    setState(() {
      //controllerTopCenter.play();
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(Platform.isAndroid)
        {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>PayMoneyScreen("",'')));
        }
        else
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>PayMoneyScreen("",'')));
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
                      buildConfettiWidget(controllerTopCenter, pi / 1),
                      buildConfettiWidget(controllerTopCenter, pi / 4),
                      Container(
                        padding: EdgeInsets.only(top: 85),
                        child: Image.asset('assets/images/check.png',width: 90,
                            height: 90,
                            fit:BoxFit.fill  ),
                      ),
                      SizedBox(height: 20,),
                      Text('\u{20B9}'+total_amount.toString(),
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
                          date.toString(),
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
                      context, MaterialPageRoute(builder: (context) =>Raise_Ticket_Normal(un_id)));
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
