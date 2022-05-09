import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:spendzz/screens/account_screens/qrCode.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/addMoney_screen/promo_screen.dart';

import '../trancations_details_screens/passbook_screen.dart';
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
  late String maximum_discount = '';
  late int flatAndPerValue = 0;
  //late String flatAndPerValue;
  late double total_amount_withPromo = 0;
  late double promoCodeValue = 0;
  late bool promoStatus = false;
  late int promoCodeSend = 0;
  bool status = false;
  //todo offers Fields
  var offer_baseUrl = '';
  List<ExcitingOffersData> listExcitingOffersData = [];

  var promoCodeApply = '';
  var ShowPromoCode = "";
  bool offersStatus = false;
  var kyc_limit_status = '';
  Block_UnblockUser _block_unblockUser = Block_UnblockUser();
  @override
  void initState() {
    super.initState();
    initController();
    _callGetProfile();
    _checkToken();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callOffersCategory(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {
      bool status = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    intValue = int.parse(amountController.text);
    var options = {
      //'key': 'rzp_live_GGUyTkH97ZWQTx',
      'key': 'rzp_test_XzDju6P1EB5RkQ',
      'amount': _razorpayAmount.toString(),
      /*'amount': double.parse(_razorpayAmount.toStringAsFixed(2)),*/

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

  _callOffersCategory(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(
              ApiConfig.app_base_url + ApiConfig.PROMO_CODE_LIST_ADD_MONEY),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      offer_baseUrl = dataAll['icon_url'].toString();
      offersStatus = dataAll['status'];
      EasyLoading.dismiss();

      if (uriResponse.statusCode == 200) {
        if (offersStatus == true) {
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
            setState(() {});
          }
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashboardMainScreen()));
              },
            ),
          ),
          body: SafeArea(
            child: Form(
              key: _formkey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
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
                                      readOnly:
                                          ShowPromoCode == '' ? false : true,
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
                              if (offersStatus == true) ...[
                                GestureDetector(
                                    onTap: () async {
                                      await ShowPromoCode == ''
                                          ? _checkToken()
                                          : null;
                                      if (amountController.text.isEmpty) {
                                        EasyLoading.showToast(
                                            'Please enter Amount');
                                        return;
                                      }
                                      if (int.parse(amountController.text) <=
                                          0) {
                                        EasyLoading.showToast(
                                            'Please enter Valid Amount');
                                        return;
                                      } else {
                                        ShowPromoCode == ''
                                            ? promoCodePopup()
                                            : null;
                                        // FocusManager.instance.primaryFocus?.unfocus();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(right: 8),
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
                                    ))
                              ] else if (offersStatus == true)
                                ...[]
                            ],
                          ),
                        ),
                      ),
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
                    ],
                  ),
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
                  const EdgeInsets.only(left: 0, right: 0, top: 25, bottom: 5),
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
                      // _callCheckKycLimit_AddMoney_Withought_Promo();

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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
            height: MediaQuery.of(context).size.height - 100,
            padding: MediaQuery.of(context).viewInsets,
            margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
            child: StatefulBuilder(
              builder: (context, state) {
                return Container(
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
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
                                textCapitalization:
                                    TextCapitalization.characters,
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
                                      padding: const EdgeInsets.only(
                                          top: 8, right: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (promoCodeController.text
                                              .toString()
                                              .isEmpty) {
                                            EasyLoading.showToast(
                                                'Please enter PromoCode',
                                                toastPosition:
                                                    EasyLoadingToastPosition
                                                        .bottom);
                                          } else {
                                            promoCodeApply =
                                                promoCodeController.text;
                                            //promoCodeController.text=promoCodeApply;

                                            _apply_PromoCode(promoCodeApply);
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1.0))),
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
                                      trailing: GestureDetector(
                                        onTap: () {
                                          _apply_PromoCode(
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
                                    )),
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
                );
              },
            ));
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
        msg: "SUCCESS: " + response.paymentId.toString(),
        timeInSecForIosWeb: 4,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    if (promoStatus == false) {
      //_callCheckKycLimit_AddMoney_Withought_Promo();
      _callAddMoney_Withought_PromoCode();
      setState(() {});
    } else {
      //_callCheckKycLimit_AddMoney_With_Promo();
      _callAddMoney_With_Promo();
      setState(() {});
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

  _callCheckKycLimit_AddMoney_Withought_Promo() async {
    var tokenData = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      tokenData = prefs.getString('AUTH_TOKEN') ?? '';
    }
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.KYC_LIMIT),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        kyc_limit_status = dataAll['status'];
        if (dataAll['status'] == false) {
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          if (dataAll['check_status'] == 0) {
            Fluttertoast.showToast(
                msg: dataAll['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            // _block_unblockUser.callLogOutApi(context);
          }

          ///_callAddMoney_With_Promo();
        } else {
          openCheckout();
        }
        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  _callCheckKycLimit_AddMoney_With_Promo() async {
    var tokenData = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      tokenData = prefs.getString('AUTH_TOKEN') ?? '';
    }
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.KYC_LIMIT),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        kyc_limit_status = dataAll['status'];
        if (dataAll['status'] == false) {
          if (dataAll['check_status'] == 0) {
            Fluttertoast.showToast(
                msg: dataAll['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            //_block_unblockUser.callLogOutApi(context);
          }

          //_callAddMoney_Withought_PromoCode();
          ///_callAddMoney_With_Promo();
        } else {
          _callAddMoney_With_Promo();
        }
        setState(() {});
      }
    } finally {
      client.close();
    }
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

  _callAddMoney_Withought_PromoCode() async {
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
        promoCodeSend = dataAll['promo_code'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("amount", dataAll["data"]['amount']);
        prefs.setString("transaction_id", dataAll["data"]['transaction_id']);
        prefs.setString("pay_on", dataAll["data"]['pay_on']);
        prefs.setString("mobile", mobile);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddMoneyHistory()));
        /* if(promoCodeSend==1)
          {
            //ShowDialog();
           // controllerTopCenter.play();
          }
        else
          {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddMoneyHistory()));
          }*/

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

  _callAddMoney_With_Promo() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    promo_code_type = prefs.getString('promo_code_type') ?? '';
    minimum_amount = prefs.getString('minimum_amount') ?? '';
    maximum_discount = prefs.getString('maximum_discount') ?? '';
    flatAndPerValue = prefs.getInt('discount')!;
    promo_id = prefs.getInt('id')!;
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
        promoCodeSend = dataAll['promo_code'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("amount", dataAll["data"]['amount']);
        prefs.setString("transaction_id", dataAll["data"]['transaction_id']);
        prefs.setString("pay_on", dataAll["data"]['pay_on']);

        if (promoCodeSend == 1) {
          ShowDialog();
          controllerTopCenter.play();
        } else {
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
    addNoteController.text = amountController.text;
    double _opacity = 0.8;
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Color(0x00ffffff),
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PassbookScreen()));
              return true;
            },
            child: BackdropFilter(
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
                                  promoCodeValue.toString() +
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
                                      builder: (context) => AddMoneyHistory()));
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
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7)),
          );
        });
  }

  _apply_PromoCode(String PromoCode) async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['promo_code'] = PromoCode;
    mapBody['type'] = "add";
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
          if (int.parse(amountController.text.toString()) <
              int.parse(dataAll["data"]['minimum_amount'])) {
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
            int enterAmount = int.parse(amountController.text.toString());
            double per = flatAndPerValue / 100;
            //addNoteController.text=amountController.text;
            if (enterAmount >= int.parse(minimum_amount)) {
              if (promo_code_type == "2") {
                promoCodeValue = (enterAmount * per).toDouble();
                if (promoCodeValue > int.parse(maximum_discount)) {
                  total_amount_withPromo =
                      (enterAmount + double.parse(maximum_discount));
                  promoCodeValue = double.parse(maximum_discount.toString());
                  // addNoteController.text=total_amount_withPromo.toString();
                } else {
                  total_amount_withPromo = (enterAmount + promoCodeValue);
                  //total_amount_withPromo=(enterAmount+promoCodeValue);
                  // addNoteController.text=total_amount_withPromo.toString();
                }
              } else if (promo_code_type == "1") {
                total_amount_withPromo =
                    (enterAmount + flatAndPerValue).toDouble();
                promoCodeValue = double.parse(flatAndPerValue.toString());
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

class ExcitingOffersData {
  String promocode = '';
  String promocode_type = '';
  String minimum_amount = '';
  String maximum_discount = '';
  String one_time_use = '';
  String promo_code_expriration_date = '';
  String no_of_uses = '';
  String icon = '';
  String title = '';
  String description = '';
  String promo_code_id = '';
}
