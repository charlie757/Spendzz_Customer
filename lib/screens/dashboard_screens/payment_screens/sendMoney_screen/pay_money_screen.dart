import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/category_details.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/addMoney_screen/add_money_history.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/pay_money_history.dart';

import '../trancations_details_screens/pasbook_history_details.dart';
import 'contactScreen_screen.dart';

class PayMoneyScreen extends StatefulWidget {
  var paymentId = '';
  var CategoryBack = '';
  var senderType = "";

  PayMoneyScreen(this.paymentId, this.CategoryBack, this.senderType);

  @override
  _PayMoneyScreenState createState() =>
      _PayMoneyScreenState(paymentId, CategoryBack, senderType);
}

class _PayMoneyScreenState extends State<PayMoneyScreen> {
  _PayMoneyScreenState(this.paymentId, this.CategoryBack, this.senderType);
  var paymentId = '';
  var CategoryBack = '';
  var senderType = "";
  //todo All Controller
  TextEditingController enterAmountController = TextEditingController();
  late ConfettiController controllerTopCenter;
  TextEditingController addNoteController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();

  //todo Razorpay Fields
  late Razorpay _razorpay;
  late double intValue;
  late double _razorpayAmount = intValue * 100.roundToDouble();
  late String paymentIdForApi;

  //todo userDetails Fields
  /*late String spendzzBalance= '';*/
  var spendzzBalance = 0.0;
  late String contactName = '';
  late String mobileNumber = '';

  //todo addMoney Fields
  var rameningBalance = 0.0;
  bool addMoneyButton = false;
  late String amountType = '';

  //todo radioButton Fields
  int _value = 1;

  //todo PromoCode Fields
  late double promoCodeValue = 0;
  late bool promoStatus = false;
  late double total_amount_withPromo = 0;
  late String promoCodeSend = "";
  late String promoCode = "";
  late String promo_code_type;
  late String minimum_amount;
  late String maximum_discount;
  late int flatAndPerValue = 0;
  late int promo_id;
  var ShowPromoCode = "";
  var promoCodeApply = '';
  var promoCodeName = '';
  var unId = '';

  //todo offers Fields
  var offer_baseUrl = '';
  List<ExcitingOffersData> listExcitingOffersData = [];
  var isDataFetched = false;

  //todo Qr_Result
  late String qrName = '';
  late String unique_key = '';
  late String paymentType = '';
  @override
  void initState() {
    super.initState();
    //initController();
    _checkToken();
    initController();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  _checkToken() async {
    if (paymentId == 'payToCategory') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('AUTH_TOKEN') != null) {
        _callPassbookBalance(prefs.getString('AUTH_TOKEN').toString());
        _callOffersCategory(prefs.getString('AUTH_TOKEN').toString());
        //_callQrCodeResult();
      }
      if (prefs.getString('shop_name') != null) {
        contactName = prefs.getString('shop_name').toString();
      }
      if (prefs.getString('CONTACT_NUMBER') != null) {
        mobileNumber = prefs.getString('CONTACT_NUMBER').toString();
      }
      if (prefs.getString('paymentType') != null) {
        paymentType = prefs.getString('paymentType').toString();
      }
      if (prefs.getString('unique_key') != null) {
        paymentId = prefs.getString('unique_key').toString();
      }

      setState(() {});
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('AUTH_TOKEN') != null) {
        _callPassbookBalance(prefs.getString('AUTH_TOKEN').toString());
        _callOffersCategory(prefs.getString('AUTH_TOKEN').toString());
        //_callQrCodeResult();
      }
      if (prefs.getString('CONTACT_NAME') != null) {
        contactName = prefs.getString('CONTACT_NAME').toString();
      }
      if (prefs.getString('CONTACT_NUMBER') != null) {
        mobileNumber = prefs.getString('CONTACT_NUMBER').toString();
      }
      if (prefs.getString('paymentType') != null) {
        paymentType = prefs.getString('paymentType').toString();
      }

      setState(() {});
    }
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
        spendzzBalance =
            double.parse(dataAll['data']['wallet_amount'].toString());
        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  _callOffersCategory(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(
              ApiConfig.app_base_url + ApiConfig.PROMO_CODE_LIST_PAY_MONEY),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      offer_baseUrl = dataAll['icon_url'].toString();
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = ExcitingOffersData();
          mdlSubData.promocode = dictResult['promocode'].toString();
          mdlSubData.icon = dictResult['icon'].toString();
          mdlSubData.title = dictResult['title'].toString();
          mdlSubData.description = dictResult['description'].toString();
          mdlSubData.promo_code_id = dictResult['promo_code_id'].toString();
          listExcitingOffersData.add(mdlSubData);
        }
        setState(() {});
      }
    } finally {
      client.close();
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
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Text(
              "Paying to " + contactName,
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
                if (CategoryBack == "CategoryBack") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryDetails("", '', '')));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContactList()));
                }
              },
            ),
          ),
          body: SafeArea(
            child: Form(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    buildConfettiWidget(controllerTopCenter, pi / 1),
                    buildConfettiWidget(controllerTopCenter, pi / 4),
                    SizedBox(
                      height: 25,
                    ),
                    if (ShowPromoCode == '') ...[
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
                                    width: 150,
                                    child: TextFormField(
                                      onChanged: (text) {
                                        setState(() {});
                                        if (double.parse(
                                                enterAmountController.text) >
                                            spendzzBalance) {
                                          rameningBalance = double.parse(
                                                  enterAmountController.text) -
                                              spendzzBalance;
                                          addMoneyButton = true;
                                          setState(() {});
                                        } else {
                                          addMoneyButton = false;
                                          setState(() {});
                                        }
                                      },
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
                                      controller: enterAmountController,
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
                              if (senderType == "user")
                                ...[]
                              else ...[
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: () {
                                          if (enterAmountController
                                              .text.isEmpty) {
                                            EasyLoading.showToast(
                                                'Please enter Amount');
                                            return;
                                          }
                                          if (int.parse(
                                                  enterAmountController.text) <=
                                              0) {
                                            EasyLoading.showToast(
                                                'Please enter Valid Amount');
                                            return;
                                          } else {
                                            ShowPromoCode == ''
                                                ? promoCodePopup()
                                                : null;
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Text('Apply Promo',
                                              style: TextStyle(
                                                color: ShowPromoCode == ''
                                                    ? kYellowColor
                                                    : Colors
                                                        .orange, // <-- Change this
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              )),
                                        )))
                              ]
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: ShowPromoCode == ''
                                ? Colors.black
                                : Colors.orange,
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
                                    width: 150,
                                    child: TextFormField(
                                      // focusNode: FocusScope.of(context).unfocus(),
                                      autofocus:
                                          ShowPromoCode == '' ? true : false,
                                      // enabled: false,
                                      readOnly:
                                          ShowPromoCode == '' ? false : true,
                                      onChanged: (text) {
                                        setState(() {});
                                        if (double.parse(
                                                enterAmountController.text) >
                                            spendzzBalance) {
                                          rameningBalance = double.parse(
                                                  enterAmountController.text) -
                                              spendzzBalance;
                                          addMoneyButton = true;
                                          setState(() {});
                                        } else {
                                          addMoneyButton = false;
                                          setState(() {});
                                        }
                                      },
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
                                      controller: enterAmountController,
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
                              if (senderType == "user")
                                ...[]
                              else ...[
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: () {
                                          if (enterAmountController
                                              .text.isEmpty) {
                                            EasyLoading.showToast(
                                                'Please enter Amount');
                                            return;
                                          }
                                          if (int.parse(
                                                  enterAmountController.text) <=
                                              0) {
                                            EasyLoading.showToast(
                                                'Please enter Valid Amount');
                                            return;
                                          } else {
                                            // promoCodePopup();
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Text('Apply Promo',
                                              style: TextStyle(
                                                color:
                                                    kYellowColor, // <-- Change this
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.normal,
                                              )),
                                        )))
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                    ShowPromoCode == ''
                        ? Container()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 25),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 1,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  ShowPromoCode.toString(),
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    ShowPromoCode = "";
                                    promoStatus = false;
                                    setState(() {
                                      promoStatus = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.black26,
                                    size: 22,
                                  ),
                                )
                              ],
                            ),
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
                          GestureDetector(
                            onTap: () {},
                            child: TextField(
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
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 15),
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
                                padding: EdgeInsets.only(top: 15),
                                child: Column(
                                  children: [
                                    if (addMoneyButton == true) ...[
                                      Align(
                                        alignment: FractionalOffset.topLeft,
                                        child: Text(
                                          'Spendzz Balance (Low Balance)',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.orangeAccent,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (addMoneyButton == false) ...[
                                      Align(
                                        alignment: FractionalOffset.topLeft,
                                        child: Text(
                                          'Spendzz Balance',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black38,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                              Container(
                                //padding: EdgeInsets.only(left: 25, right: 25,),
                                child: Row(
                                  children: [
                                    Align(
                                      child: Text(
                                        'Available Balance ₹' +
                                            spendzzBalance.toStringAsFixed(2),
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
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => kYellowColor),
                                        value: 1,
                                        groupValue: _value,
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value as int;
                                            setState(() {});
                                          });
                                        }),
                                  ],
                                ),
                              ),
                              Container(
                                //padding: EdgeInsets.only(left: 25, right: 25),
                                child: Divider(
                                  color: Colors.black38,
                                  thickness: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
              child: Container(
            width: MediaQuery.of(context).size.width - 0,
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Stack(
              children: [
                if (addMoneyButton == true) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 25, bottom: 5),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: kYellowColor,
                            // borderRadius: BorderRadius.horizontal()),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: FlatButton(
                          onPressed: () {
                            if (enterAmountController.text.isEmpty) {
                              EasyLoading.showToast('Please enter Amount');
                              return;
                            }
                            if (int.parse(enterAmountController.text) <= 0) {
                              EasyLoading.showToast(
                                  'Please enter Valid Amount');
                              return;
                            } else {
                              openCheckout();
                            }
                          },
                          child: Text(
                            'Add ' +
                                '\u{20B9}' +
                                rameningBalance.toStringAsFixed(2) +
                                ' &' +
                                ' Pay',
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
                if (addMoneyButton == false) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 25, bottom: 5),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: kYellowColor,
                            // borderRadius: BorderRadius.horizontal()),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: FlatButton(
                          onPressed: () {
                            if (enterAmountController.text.isEmpty) {
                              EasyLoading.showToast('Please enter Amount');
                              return;
                            }
                            if (int.parse(enterAmountController.text) <= 0) {
                              EasyLoading.showToast(
                                  'Please enter Valid Amount');
                              return;
                            } else {
                              if (senderType == 'user') {
                                _callPayCustomer_WithoughtAddMoney();
                              } else {
                                if (promoStatus == false) {
                                  _callPayMerchant_WithoughtAddMoney();
                                  setState(() {});
                                } else {
                                  _callPayMerchant_WithoughtAddMoney_WithPromoCode();
                                  setState(() {});
                                }
                              }
                            }
                          },
                          child: Text(
                            'Pay Now' /* + '\u{20B9}' + enterAmountController.text*/,
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
                ]
              ],
            ),
          )),
        ));
  }

  void promoCodePopup() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 100,
          padding: MediaQuery.of(context).viewInsets,
          margin: EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 0),
          child: Container(
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
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
                          promoCodeController.clear();
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colors.black54,
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
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
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
                              /*hintText: 'Enter Promocode',*/
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff787D86)),
                              ),
                              suffixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    if (promoCodeController.text
                                        .toString()
                                        .isEmpty) {
                                      EasyLoading.showToast(
                                          'Please enter PromoCode',
                                          toastPosition:
                                              EasyLoadingToastPosition.bottom);
                                    } else {
                                      promoCodeApply = promoCodeController.text;
                                      //promoCodeController.text=promoCodeApply;

                                      _apply_PromoCodeMerchant(promoCodeApply);
                                    }
                                  },
                                  child: Text(
                                    'Apply Now',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: kYellowColor,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              )))
                    ],
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: listExcitingOffersData.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, index) {
                      var mdlSubData = listExcitingOffersData[index];
                      return GestureDetector(
                        child: Card(
                          elevation: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1.0))),
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100.0)),
                                    child: CachedNetworkImage(
                                        height: 50,
                                        width: 50,
                                        imageUrl: offer_baseUrl +
                                            "/" +
                                            mdlSubData.icon,
                                        placeholder: (context, url) =>
                                            Transform.scale(
                                              scale: 0.4,
                                              child: CircularProgressIndicator(
                                                color: kYellowColor,
                                                strokeWidth: 3,
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                height: 40,
                                                width: 40,
                                                child: Image.asset(
                                                    'assets/images/account_profile.png')),
                                        fit: BoxFit.cover),
                                  ),
                                  title: Text(
                                    mdlSubData.title,
                                    maxLines: 2,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    mdlSubData.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _apply_PromoCodeMerchant(
                                            mdlSubData.promocode);
                                        ShowPromoCode = promoCodeApply;
                                      },
                                      child: Text(
                                        'Apply Now',
                                        textAlign: TextAlign.center,
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
                                )),
                          ),
                        ),
                        onTap: () {
                          /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OffersDetails(mdlSubData.promo_code_id)));*/
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void openCheckout() async {
    intValue = double.parse(rameningBalance.toString());
    amountType = '2';
    var options = {
      //'key': 'rzp_live_GGUyTkH97ZWQTx',
      'key': 'rzp_test_XzDju6P1EB5RkQ',
      //'amount': _razorpayAmount.toString(),
      'amount': double.parse(_razorpayAmount.toStringAsFixed(2)),
      'name': contactName,
      'description': 'Payment',
      'prefill': {'contact': mobileNumber, 'email': ''},
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

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    paymentIdForApi = response.paymentId.toString();
    if (senderType == 'user') {
      _callPayCustomer_WithAddMoney(paymentIdForApi);
    } else {
      if (promoStatus == false) {
        _callPayMerchant_WithAddMoney(paymentIdForApi);
        setState(() {});
      } else {
        _callPayMerchant_WithAddMoney_WithPromoCode(paymentIdForApi);
        setState(() {});
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " +
            response.code.toString() +
            " - " +
            response.message.toString(),
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName.toString(),
        timeInSecForIosWeb: 4);
  }

  //todo Customer Payment
  _callPayCustomer_WithoughtAddMoney() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['amount'] = enterAmountController.text.toString();
    mapBody['note'] = addNoteController.text.toString();
    mapBody['mobile'] = mobileNumber.toString();
    if (paymentType == "scanner") {
      mapBody['payment_type'] = 'scanner';
    } else {
      mapBody['payment_type'] = 'mobile';
    }
    mapBody['amount_type'] = '1';

    mapBody['particulars'] = 'debit';
    mapBody['merchant_id'] = paymentId.toString();

    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.SEND_MONEY_TO_CUSTOMER),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if (dataAll['status'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt(
              "total_amount", int.parse(dataAll["data"]['amount'].toString()));
          var unId = dataAll["data"]['un_id'].toString();
          // prefs.setString("transaction_id", dataAll["data"]['transaction_id']);
          prefs.setString("date", dataAll["data"]['date_time'].toString());
          prefs.setString("un_id", dataAll["data"]['un_id'].toString());
          prefs.setString(
              "debit_from", dataAll["data"]["debit_from"].toString());
          prefs.setString("credit_to", dataAll["data"]["credit_to"].toString());
          prefs.setString(
              "debit_mobile", dataAll["data"]["debit_mobile"].toString());
          prefs.setString(
              "credit_mobile", dataAll["data"]["credit_mobile"].toString());
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          //  controllerTopCenter.play();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => payMoneyHistory(unId)));
        } else {
          Fluttertoast.showToast(
              msg: dataAll['message'],
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

  _callPayCustomer_WithAddMoney(String paymentIdForApi) async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    var amount = int.parse(enterAmountController.text) - rameningBalance;
    mapBody['amount'] = amount.toString();
    mapBody['note'] = addNoteController.text.toString();
    mapBody['mobile'] = mobileNumber.toString();
    mapBody['amount_type'] = amountType;
    if (paymentType == "scanner") {
      mapBody['payment_type'] = 'scanner';
    } else {
      mapBody['payment_type'] = 'mobile';
    }
    mapBody['particulars'] = 'debit';
    mapBody['merchant_id'] = paymentId.toString();
    mapBody['payment_id'] = paymentIdForApi.toString();

    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.SEND_MONEY_TO_CUSTOMER),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if (dataAll['status'] == true) {
          var unId = dataAll["data"]['un_id'].toString();
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          // controllerTopCenter.play();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => payMoneyHistory(unId)));
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

  //todo Merchant Payment Withought PromoCode
  _callPayMerchant_WithoughtAddMoney() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['amount'] = enterAmountController.text.toString();
    mapBody['note'] = addNoteController.text.toString();
    mapBody['mobile'] = mobileNumber.toString();
    if (paymentType == "scanner") {
      mapBody['payment_type'] = 'scanner';
    } else {
      mapBody['payment_type'] = 'mobile';
    }
    mapBody['amount_type'] = '1';

    mapBody['particulars'] = 'debit';
    mapBody['merchant_id'] = paymentId.toString();
    //mapBody['promo_code_id'] = promo_id.toString();

    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.SEND_MONEY_TO_MERCHANT),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if (dataAll['status'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt(
              "total_amount", int.parse(dataAll["data"]['amount'].toString()));
          // prefs.setString("transaction_id", dataAll["data"]['transaction_id']);
          prefs.setString("date", dataAll["data"]['date_time'].toString());
          prefs.setString("un_id", dataAll["data"]['un_id'].toString());
          prefs.setString(
              "debit_from", dataAll["data"]["debit_from"].toString());
          prefs.setString("credit_to", dataAll["data"]["credit_to"].toString());
          prefs.setString(
              "debit_mobile", dataAll["data"]["debit_mobile"].toString());
          prefs.setString(
              "credit_mobile", dataAll["data"]["credit_mobile"].toString());
          var unId = dataAll["data"]['un_id'].toString();
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          //  controllerTopCenter.play();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => payMoneyHistory(unId)));
        } else {
          Fluttertoast.showToast(
              msg: dataAll['message'],
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

  _callPayMerchant_WithAddMoney(String paymentIdForApi) async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    var amount = int.parse(enterAmountController.text) - rameningBalance;
    mapBody['amount'] = amount.toString();
    mapBody['note'] = addNoteController.text.toString();
    mapBody['mobile'] = mobileNumber.toString();
    mapBody['amount_type'] = amountType;
    if (paymentType == "scanner") {
      mapBody['payment_type'] = 'scanner';
    } else {
      mapBody['payment_type'] = 'mobile';
    }
    mapBody['particulars'] = 'debit';
    mapBody['merchant_id'] = paymentId.toString();
    mapBody['payment_id'] = paymentIdForApi.toString();

    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.SEND_MONEY_TO_MERCHANT),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      var unId = dataAll["data"]['un_id'].toString();
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if (dataAll['status'] == true) {
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          // controllerTopCenter.play();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => payMoneyHistory(unId)));
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

  //todo  PromoCode Apply Api
  _apply_PromoCodeMerchant(String PromoCode) async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['promo_code'] = PromoCode;
    mapBody['merchant_id'] = paymentId.toString();
    mapBody['type'] = "sent";

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
      promoStatus = dataAll['status'];

      if (promoStatus == false) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: dataAll['message'].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        EasyLoading.dismiss();
        if (uriResponse.statusCode == 200) {
          promoCodeController.clear();
          int discount_value = dataAll["data"]['discount'];
          int id_value = dataAll["data"]['id'];
          // promoCodeName=promoCode;
          Navigator.of(context).pop();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(
              "promo_code_type", dataAll["data"]['promo_code_type']);
          prefs.setString("minimum_amount", dataAll["data"]['minimum_amount']);
          prefs.setString(
              "maximum_discount", dataAll["data"]['maximum_discount']);
          prefs.setInt("discount", discount_value);
          prefs.setInt("id", id_value);
          promo_code_type = dataAll["data"]['promo_code_type'];
          minimum_amount = dataAll["data"]['minimum_amount'];
          maximum_discount = dataAll["data"]['maximum_discount'];
          flatAndPerValue = discount_value;
          promo_id = prefs.getInt('id')!;
          if (int.parse(enterAmountController.text.toString()) <
              int.parse(dataAll["data"]['minimum_amount'])) {
            /*Fluttertoast.showToast(
                msg: 'Please Enter Minimum Amount '+dataAll["data"]['minimum_amount']+ "for this Promo Code",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.orange,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);*/
            _validProm_codeDialog(dataAll["data"]['minimum_amount']);
            EasyLoading.dismiss();
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

            ShowPromoCode = PromoCode;
            int enterAmount = int.parse(enterAmountController.text.toString());
            double per = flatAndPerValue / 100;
            //addNoteController.text=enterAmountController.text;
            if (enterAmount >= int.parse(minimum_amount)) {
              if (promo_code_type == "2") {
                promoCodeValue = (enterAmount * per).toDouble();
                if (promoCodeValue > int.parse(maximum_discount)) {
                  total_amount_withPromo =
                      (enterAmount + double.parse(maximum_discount));
                  // addNoteController.text=total_amount_withPromo.toString();
                } else {
                  total_amount_withPromo = (enterAmount + promoCodeValue);
                  // addNoteController.text=total_amount_withPromo.toString();
                }
              } else if (promo_code_type == "1") {
                total_amount_withPromo =
                    (enterAmount + flatAndPerValue).toDouble();
                promoCodeValue = flatAndPerValue.toDouble();
                //  addNoteController.text=flatAndPerValue.toString();

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

  //todo Merchant Payment With PromoCode
  _callPayMerchant_WithoughtAddMoney_WithPromoCode() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    // mapBody['amount'] = enterAmountController.text.toString();
    mapBody['note'] = addNoteController.text.toString();
    mapBody['mobile'] = mobileNumber.toString();
    if (paymentType == "scanner") {
      mapBody['payment_type'] = 'scanner';
    } else {
      mapBody['payment_type'] = 'mobile';
    }
    mapBody['amount_type'] = '1';

    mapBody['particulars'] = 'debit';
    mapBody['merchant_id'] = paymentId.toString();
    mapBody['promo_code_id'] = promo_id.toString();
    mapBody['amount'] = enterAmountController.text.toString();

    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.SEND_MONEY_TO_MERCHANT),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if (dataAll['status'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt(
              "total_amount", int.parse(dataAll["data"]['amount'].toString()));
          // prefs.setString("transaction_id", dataAll["data"]['transaction_id']);
          prefs.setString("date", dataAll["data"]['date_time'].toString());
          prefs.setString("un_id", dataAll["data"]['un_id'].toString());
          prefs.setString(
              "debit_from", dataAll["data"]["debit_from"].toString());
          prefs.setString("credit_to", dataAll["data"]["credit_to"].toString());
          prefs.setString(
              "debit_mobile", dataAll["data"]["debit_mobile"].toString());
          prefs.setString(
              "credit_mobile", dataAll["data"]["credit_mobile"].toString());
          var unId = dataAll["data"]['un_id'].toString();
          unId = dataAll["data"]['un_id'].toString();
          promoCodeSend = dataAll['promo_code'];
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          //  controllerTopCenter.play();
          if (promoCodeSend != "") {
            ShowCashBackDialog(unId);
            controllerTopCenter.play();
          } else {}
        } else {
          Fluttertoast.showToast(
              msg: dataAll['message'],
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

  _callPayMerchant_WithAddMoney_WithPromoCode(String paymentIdForApi) async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    var amount = int.parse(enterAmountController.text) - rameningBalance;
    mapBody['amount'] = amount.toString();
    mapBody['note'] = addNoteController.text.toString();
    mapBody['mobile'] = mobileNumber.toString();
    mapBody['amount_type'] = amountType;
    if (paymentType == "scanner") {
      mapBody['payment_type'] = 'scanner';
    } else {
      mapBody['payment_type'] = 'mobile';
    }
    mapBody['particulars'] = 'debit';
    mapBody['merchant_id'] = paymentId.toString();
    mapBody['payment_id'] = paymentIdForApi.toString();
    mapBody['promo_code_id'] = promo_id.toString();
    //mapBody['amount'] = total_amount_withPromo.toString();

    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.SEND_MONEY_TO_MERCHANT),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      var unId = dataAll["data"]['un_id'].toString();
      promoCodeSend = dataAll['promo_code'];
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if (dataAll['status'] == true) {
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          // controllerTopCenter.play();
          /*if(promoCodeSend==1)
          {
            ShowDialog(unId);
            controllerTopCenter.play();
          }*/
          if (promoCodeSend != "") {
            ShowCashBackDialog(unId);
            controllerTopCenter.play();
          } else {
            /* Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddMoneyHistory()));*/
          }
          /*Navigator.push(
              context, MaterialPageRoute(builder: (context) => payMoneyHistory(unId)));*/
        } else {
          EasyLoading.dismiss();
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

  void ShowCashBackDialog(String unId) {
    double _opacity = 0.8;
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Color(0x00ffffff),
        builder: (BuildContext context) {
          return BackdropFilter(
              child: Container(
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
                            image: ExactAssetImage(
                              'assets/images/add_money.png',
                            ),
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
                            ShowPromoCode + " applied",
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
                            'You have earned\n₹' +
                                promoCodeValue.toStringAsFixed(2) +
                                ' cashback',
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        payMoneyHistory(unId)));
                          },
                          child: Align(
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
                  actions: [],
                ),
              ),
              filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0));
        });
  }

  _validProm_codeDialog(String amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return showDialog(
      context: context,
      barrierColor: Color(0x00ffffff),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: new AlertDialog(
          title: new Text(
            'Error',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              fontStyle: FontStyle.normal,
              fontSize: 17.0,
            ),
          ),
          content: new Text(
            "Please Enter Minimum Amount " + amount + " for this Promo Code",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontStyle: FontStyle.normal,
              fontSize: 16.0,
            ),
          ),
          actions: <Widget>[
            new Container(
              padding: EdgeInsets.all(1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Ink(
                    height: 35,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ), // LinearGradientBoxDecoration
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      splashColor: kYellowColor,
                      child: Align(
                        child: Container(
                          decoration: BoxDecoration(
                              color: kYellowColor,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text(
                              'Ok',
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
                    // Red will correctly spread over gradient
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    false;
  }
}
