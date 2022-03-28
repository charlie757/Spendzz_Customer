import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/qrCode.dart';

import 'add_money_history.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({Key? key}) : super(key: key);

  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  bool isChecked = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController addNoteController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();
  int _value = 1;
  late ConfettiController controllerTopCenter;
  var isDataFetched = false;
  String gst = '';
  String amount = '';
  late int intValue;
  late int plan_id;
  late Razorpay _razorpay;
  late String name;
  late String email;
  late String mobile;
  late int promo_id;
  late String paymentIdForApi;
  late int _razorpayAmount = intValue * 100;
  late String promoCode;
  late String promo_code_type;
  late String minimum_amount;
  late String maximum_discount='';
  late int flatAndPerValue = 0;
  //late String flatAndPerValue;
  late double total_amount_withPromo = 0;
  late double promoCodeValue = 0;
  late bool promoStatus=false;
  late int promoCodeSend = 0;




  @override
  void initState() {
    super.initState();
    initController();
    _callGetProfile();
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
    intValue = int.parse(amountController.text);
    var options = {
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

  void initController() {
    controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kstatusBarColor,
    ));
    return WillPopScope(
        onWillPop: () async {
          if(Platform.isAndroid)
          {

            Navigator.push(context, MaterialPageRoute(builder: (context) =>DashboardMainScreen()));
          }
          else
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>DashboardMainScreen()));
          }
          //ShowDialog();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Text(
              "Add Money to Wallet",
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
                Navigator.push(context, MaterialPageRoute(builder: (context) =>DashboardMainScreen()));
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    buildConfettiWidget(controllerTopCenter, pi / 1),
                    buildConfettiWidget(controllerTopCenter, pi / 4),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('\u{20B9}',
                                    style: TextStyle(
                                      color: kYellowColor, // <-- Change this
                                      fontSize: 22,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 100,
                                  child: TextFormField(
                                    cursorColor: kYellowColor,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: kYellowColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 22.0,
                                    ),
                                    autocorrect: true,
                                    controller: amountController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter Amount',
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black38,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 1.0)),
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter Amount';
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    onTap: () {
                                      if (amountController.text.isEmpty) {
                                        EasyLoading.showToast('Please enter Amount');
                                        return;
                                      }
                                      if (int.parse(amountController.text) <= 0) {
                                        EasyLoading.showToast(
                                            'Please enter Valid Amount');
                                        return;
                                      } else {
                                        promoCodePopup();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Text('Apply Promo',
                                          style: TextStyle(
                                            color: kYellowColor, // <-- Change this
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          )),
                                    )
                                )
                            )

                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if(maximum_discount=='')...[

                        ]
                        else...[
                          Container(
                            child: Text(
                              'You have earned\n₹'+maximum_discount+' cashback',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.green,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),

                          )
                        ],

                      ],
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Add Note',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black38,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          TextFormField(
                            cursorColor: kYellowColor,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 8,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            autocorrect: true,
                            controller: addNoteController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff303030)),
                              ),
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter Full Name';
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    /*if(total_amount_withPromo>0)...[
                      SizedBox(height: 25),
                      Container(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                        child: Column(
                          children: [
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                'Pay from',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding:
                            EdgeInsets.only(left: 25, right: 25, top: 15),
                            child: Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Spendzz Balance  (Low Balance)',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black38,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              left: 25,
                              right: 25,
                            ),
                            child: Row(
                              children: [
                                Align(
                                  child: Text(
                                    'Available Balance ₹1000',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Radio(
                                    fillColor: MaterialStateColor.resolveWith(
                                            (states) => kYellowColor),
                                    value: 1,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value as int;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 25, right: 25),
                            child: Divider(
                              color: Colors.black38,
                              thickness: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ],*/
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            width: 200,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 25, bottom: 25),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: kYellowColor,
                    borderRadius: BorderRadius.circular(20.0)),
                child: FlatButton(
                  onPressed: () {
                    if (amountController.text.isEmpty) {
                      EasyLoading.showToast('Please enter Amount');
                      return;
                    }
                    if (int.parse(amountController.text) <= 0) {
                      EasyLoading.showToast('Please enter Valid Amount');
                      return;
                    } else {
                      openCheckout();
                    }
                  },
                  child: Text(
                    'Add Money',
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

  void promoCodePopup() {
    showModalBottomSheet(
      /*shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),*/
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding:
          EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              children: [
                Container(
                padding: MediaQuery.of(context).viewInsets,
                 /* padding:
                      EdgeInsets.only(left: 25, right: 25, bottom: 550, top: 5),*/
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              'Apply PromoCode',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                fontStyle: FontStyle.normal,
                                fontSize: 20.0,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.cancel,
                                color: Colors.black38,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Center(
                          child: Image.asset(
                        "assets/images/splash_logo.png",
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width - 100,
                      )),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                'Promo code',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.characters,

                            style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                                autocorrect: true,
                                controller: promoCodeController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Promo code',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xff787D86)),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 35, bottom: 0),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: kYellowColor,
                                borderRadius: BorderRadius.circular(20.0)),
                            child: FlatButton(
                              onPressed: () {
                                if(promoCodeController.text.toString().isEmpty)
                                  {
                                    EasyLoading.showToast('Please enter PromoCode',toastPosition:EasyLoadingToastPosition.bottom);
                                  }
                                else
                                  {


                                    _apply_PromoCode();
                                  }

                              },
                              child: Text(
                                'Apply Now',
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
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void previousScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    paymentIdForApi = response.paymentId.toString();
    Fluttertoast.showToast(
        msg: "SUCCESS: " +
            response.paymentId.toString(),
        timeInSecForIosWeb: 4,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    if(promoStatus==false)
      {
        _callSendPaymentId_Withought_PromoCode();
      }
    else
      {
        _callSendPaymentId_With_Promo();
      }



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

  _callSendPaymentId_Withought_PromoCode() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['payment_id'] = paymentIdForApi.toString();

    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.ADD_MONEY_FROM_WALLET),
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
        promoCodeSend=dataAll['promo_code'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("amount", dataAll["data"]['amount']);
        prefs.setString("transaction_id", dataAll["data"]['transaction_id']);
        prefs.setString("pay_on", dataAll["data"]['pay_on']);
        prefs.setString("mobile", mobile);

        if(promoCodeSend==1)
          {
            ShowDialog();
            controllerTopCenter.play();
          }
        else
          {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddMoneyHistory()));
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
  _callSendPaymentId_With_Promo() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    promo_code_type = prefs.getString('promo_code_type') ?? '';
    minimum_amount = prefs.getString('minimum_amount') ?? '';
    maximum_discount = prefs.getString('maximum_discount') ?? '';
    flatAndPerValue = prefs.getInt('discount')!;
    promo_id= prefs.getInt('id')!;
    // flatAndPerValue=int.parse(prefs.getString('discount') ?? '');
    mapBody['payment_id'] = paymentIdForApi.toString();
    mapBody['promo_code_id'] = promo_id.toString();
    mapBody['total_amount'] = total_amount_withPromo.toString();

    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.ADD_MONEY_FROM_WALLET),
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
        promoCodeSend=dataAll['promo_code'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("amount", dataAll["data"]['amount']);
        prefs.setString("transaction_id", dataAll["data"]['transaction_id']);
        prefs.setString("pay_on", dataAll["data"]['pay_on']);

        if(promoCodeSend==1)
        {
          ShowDialog();
          controllerTopCenter.play();
        }
        else
        {
         /* Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddMoneyHistory()));*/
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

  void ShowDialog() {
    int enterAmount=int.parse(amountController.text.toString());
    double per=flatAndPerValue/100;
    addNoteController.text=amountController.text;
    double _opacity = 0.8;
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Color(0x00ffffff),
        builder: (BuildContext context) {
          return BackdropFilter(
              child:    Container(
                color: Colors.black.withOpacity(_opacity),
                child: AlertDialog(
                  backgroundColor: klightYelloColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  title: Align(
                    alignment: FractionalOffset.center,
                    child: Container(
                      width: 55.00,
                      height: 55.00,
                      child: Container(
                        width: 68.00,
                        height: 68.00,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          image: DecorationImage(
                            scale: 2,
                            image: ExactAssetImage('assets/images/add_money.png',),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ),
                  content: Container(
                    height: 120,
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.center,
                          child: Text(
                            promoCodeController.text.toString()+" applied",
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black38,
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
                            'You have earned\n₹'+maximum_discount+' cashback',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Text(
                            ' with this code',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black38,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => AddMoneyHistory()));
                          },child: Align(
                          alignment: FractionalOffset.center,
                          child: Text(
                            'Thanks',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: kYellowColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        )

                      ],
                    ),
                  ),
                  actions: [

                  ],
                ),
              ),
              filter: ImageFilter.blur(sigmaX: 0.0,sigmaY: 0.0));

        });
  }

  _apply_PromoCode() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['promo_code'] = promoCodeController.text.toString();
    var client = http.Client();

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.APPLY_PROMO_CODE),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      promoStatus=dataAll['status'];

      if(promoStatus==false)
        {
          EasyLoading.dismiss();
          Fluttertoast.showToast(
              msg: dataAll['message'].toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      else
        {
          EasyLoading.dismiss();
          if (uriResponse.statusCode == 200) {
            int discount_value = dataAll["data"]['discount'];
            int id_value = dataAll["data"]['id'];
            Navigator.of(context).pop();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("promo_code_type", dataAll["data"]['promo_code_type']);
            prefs.setString("minimum_amount", dataAll["data"]['minimum_amount']);
            prefs.setString("maximum_discount", dataAll["data"]['maximum_discount']);
            prefs.setInt("discount", discount_value);
            prefs.setInt("id", id_value);

            promo_code_type = dataAll["data"]['promo_code_type'];
            minimum_amount = dataAll["data"]['minimum_amount'];
            maximum_discount = dataAll["data"]['maximum_discount'];
            flatAndPerValue = discount_value;
            promo_id= prefs.getInt('id')!;



            if (int.parse(amountController.text.toString()) < int.parse(dataAll["data"]['minimum_amount'])) {

              Fluttertoast.showToast(
                  msg: 'Please Enter Valid Promo Code Amount',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.orange,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
              EasyLoading.dismiss();
            }
            else
            {

              EasyLoading.dismiss();
              Fluttertoast.showToast(
                  msg: dataAll['message'],
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
              int enterAmount=int.parse(amountController.text.toString());
              double per=flatAndPerValue/100;
              addNoteController.text=amountController.text;
              if(enterAmount>=int.parse(minimum_amount))
              {
                if(promo_code_type== "2")
                {

                  promoCodeValue=(enterAmount * per).toDouble();
                  if(promoCodeValue>int.parse(maximum_discount))
                  {
                    total_amount_withPromo=(enterAmount+double.parse(maximum_discount));
                    addNoteController.text=total_amount_withPromo.toString();
                  }
                  else
                  {
                    total_amount_withPromo=(enterAmount+promoCodeValue);
                    addNoteController.text=total_amount_withPromo.toString();
                  }
                }
                else if(promo_code_type== "1")
                {
                  total_amount_withPromo=(enterAmount+flatAndPerValue).toDouble();
                  addNoteController.text=flatAndPerValue.toString();

                }
              }
             // Navigator.pop(context);
              //openCheckout();
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
        }

    } finally {
      client.close();
    }
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
