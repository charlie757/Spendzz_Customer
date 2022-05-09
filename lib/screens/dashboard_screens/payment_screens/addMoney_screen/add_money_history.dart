import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/account_screens/help_screens/normal_ticket/all_help_ticket_screen.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/trancations_details_screens/passbook_screen.dart';
class AddMoneyHistory extends StatefulWidget {
  const AddMoneyHistory({Key? key}) : super(key: key);

  @override
  _AddMoneyHistoryState createState() => _AddMoneyHistoryState();
}

class _AddMoneyHistoryState extends State<AddMoneyHistory> {
  late int amount;
  late String transaction_id;
  late String pay_on;
  late String mobile='';

  /*@override
  initState()  {
    super.initState();

    amount = prefs.getString('amount') ?? '';
    transaction_id = prefs.getString('transaction_id') ?? '';
    pay_on = prefs.getString('pay_on') ?? '';
  }*/

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('amount') != null) {
      amount= prefs.getInt('amount')!;
    }
    if (prefs.getString('transaction_id') != null) {
      transaction_id=prefs.getString('transaction_id')!;
    }
    if (prefs.getString('pay_on') != null) {
      pay_on=prefs.getString('pay_on')!;
    }
    if (prefs.getString('mobile') != null) {
      mobile=prefs.getString('mobile')!;
    }
    setState(() {});
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
                        child: Image.asset('assets/images/add_money.png',width: 90,
                            height: 90,
                            fit:BoxFit.fill  ),
                      ),
                      SizedBox(height: 20,),
                      Text('\u{20B9}'+amount.toString(),
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
                          pay_on.toString(),
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
                     /* SizedBox(height: 20,),
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
                          *//*transaction_id.toString()*//*"",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize:18.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),*/
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
                      SizedBox(height: 6,),
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          "Razarpay/Wallet",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black38,
                            fontStyle: FontStyle.normal,
                            fontSize:18.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          mobile.toString(),
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
                      context, MaterialPageRoute(builder: (context) =>AllHelpTicket('')));
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
}
