import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/screens/account_screens/subscribtion_screens/SubscribeScreen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/delet.dart';
import 'package:spendzz/screens/dashboard_screens/recive_payment_qr_code_screen.dart';
import 'package:spendzz/screens/account_screens/profile_screens/profile.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/single_category.dart';
import 'package:spendzz/screens/account_screens/account_screen.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/all_category.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/addMoney_screen/add_money_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/trancations_details_screens/passbook_screen.dart';
import 'package:spendzz/screens/login_signup_screens/signup_details_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;

import '../account_screens/setting_screens/notifications.dart';
import 'offers_details.dart';

class DashboardMainScreen extends StatefulWidget {
  static const String route = '/DashboardMainScreen';

  const DashboardMainScreen({Key? key}) : super(key: key);

  @override
  _DashboardMainScreenState createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  Color colorBackgroundMoneyImage = Color(0xffFFF9EC);
  Color colorBackgroundSendMoneyImage = Color(0xffFFF9EC);
  Color colorBackgroundMakePaymentImage = Color(0xffFFF9EC);
  Color colorBackgroundPassbookImage = Color(0xffFFF9EC);
  bool change = false;
  String addMoneyImage = "assets/images/add_money.png";
  String sendMoneyImage = "assets/images/sendmoney.png";
  String makePaymentImage = "assets/images/sendmoney.png";
  String passbookImage = "assets/images/passbook.png";
  final list = List.generate(20, (index) => 'Item $index');
  late String name = '';
  var imgValueUser = '';
  bool is_login_status = false;
  bool pinStatus = false;

  //todo Category Fields
  var category_baseUrl = '';
  bool isDataFetched = false;
  List<CategoryDataList> listCategoryData = [];
  Block_UnblockUser _block_unblockUser = Block_UnblockUser();

  //todo offers Fields
  var offer_baseUrl = '';
  List<ExcitingOffersData> listExcitingOffersData = [];
  String type = 'dashboard';
  late bool subscriptions_status = false;
  String subscriptionsNextScreen = 'dashboardScreen';
  var device_id = "";
  //FirebaseMessaging messaging = FirebaseMessaging.instance;

  /*var status= "Online";
  var internetConnection;*/
  @override
  void initState() {
    super.initState();
    _checkToken();
    setState(() {});
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      is_login_status = true;
      _callGetProfile(prefs.getString('AUTH_TOKEN').toString());
      _callFeaturedCategory(prefs.getString('AUTH_TOKEN').toString());
      _callOffersCategory(prefs.getString('AUTH_TOKEN').toString());
      _callCheckSubscriptionStatus(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {});
  }

  _callCheckSubscriptionStatus(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.SUBSCRIBE_SCREEN_STATUS),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        subscriptions_status = dataAll['status'];
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
            _block_unblockUser.callLogOutApi(context);
            setState(() {});
          }
        } else {}
        /*setState(() {});*/
      }
    } finally {
      client.close();
    }
  }

  _callGetProfile(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(status: "Loading...");
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.GET_PROFILE),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
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
            setState(() {});
            _block_unblockUser.callLogOutApi(context);
          }
        } else {
          name = dataAll['data']['name'].toString();
          print(name);
          imgValueUser = dataAll['file_path'].toString() +
              "/" +
              dataAll['data']['profile'].toString();
        }
        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  _callFeaturedCategory(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(
              ApiConfig.app_base_url + ApiConfig.FEATURED_MERCHANT_CATEGORY),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      category_baseUrl = dataAll['icon_url'].toString();
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        print(arrResults);
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = CategoryDataList();
          mdlSubData.categoryName = dictResult['name'].toString();
          mdlSubData.icon = dictResult['icon'].toString();
          mdlSubData.id = dictResult['id'].toString();
          listCategoryData.add(mdlSubData);
        }
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
          Uri.parse(ApiConfig.app_base_url + ApiConfig.PROMO_CODE_LIST_BOTH),
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
        print(arrResults);
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
      }
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    // _checkToken();
    // Block_UnblockUser block_unblockUser =
    //     Provider.of<Block_UnblockUser>(context);
    // block_unblockUser.callLogOutApi(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return WillPopScope(
      onWillPop: () async {
        _onBackPressed();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.white,
            actions: [
              GestureDetector(
                onTap: () {
                  paymentScreen();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: Align(
                    child: Container(
                      padding: EdgeInsets.only(top: 5, left: 20),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                            child: CachedNetworkImage(
                                height: 50,
                                width: 50,
                                imageUrl: imgValueUser.toString(),
                                placeholder: (context, url) => Transform.scale(
                                      scale: 0.4,
                                      child: CircularProgressIndicator(
                                        color: kYellowColor,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Container(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                        'assets/images/account_profile.png')),
                                fit: BoxFit.cover),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Hello!',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    alignment: FractionalOffset.topLeft,
                                    child: Text(
                                      name.toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0,
                                      ),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(right: 15),
                child: IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: kYellowColor,
                    ),
                    onPressed: () {
                      if (subscriptions_status == true) {
                        notifications();
                      } else {
                        SubscribetionScreen();
                      }
                    }),
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: true),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100),
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              children: [
                if (subscriptions_status == true)
                  ...[]
                else ...[
                  Container(
                    height: 180,
                    width: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: ListView(
                      children: [
                        GestureDetector(
                          onTap: () {
                            SubscribetionScreen();
                          },
                          child: CarouselSlider(
                            items: [
                              //1st Image of Slider
                              Container(
                                margin: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      Color(0xff5390D9),
                                      Color(0xff4BB2E0),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                    topLeft: Radius.circular(30.0),
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(24),
                                          width: 78.00,
                                          height: 78.00,
                                          decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                              image: ExactAssetImage(
                                                  'assets/images/banner.png'),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          )),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        padding: EdgeInsets.only(top: 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Align(
                                                child: Text(
                                                  'Subscribe Now',
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 20.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Align(
                                                  child: Text(
                                                    'Earn Instant Cashbacks\n'
                                                    'Zero Transaction Fees for Adding\n'
                                                    'amount to wallet ',
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 10.0,
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            //Slider Container properties
                            options: CarouselOptions(
                              height: 155.0,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              viewportFraction: 1,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (subscriptions_status == true) {
                              addMoneyScreen();
                            } else {
                              SubscribetionScreen();
                            }
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 68.00,
                                  height: 68.00,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: klightYelloColor,
                                    image: DecorationImage(
                                      scale: 2,
                                      image: ExactAssetImage(
                                          'assets/images/add_money.png'),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (subscriptions_status == true) {
                              sendMoneyScreen();
                            } else {
                              SubscribetionScreen();
                            }
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 68.00,
                                  height: 68.00,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: klightYelloColor,
                                    image: DecorationImage(
                                      scale: 2,
                                      image: ExactAssetImage(
                                          'assets/images/sendmoney.png'),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (subscriptions_status == true) {
                              QRCodeScreenMake();
                            } else {
                              SubscribetionScreen();
                            }
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 68.00,
                                  height: 68.00,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: klightYelloColor,
                                    image: DecorationImage(
                                      scale: 2,
                                      image: ExactAssetImage(
                                          'assets/images/sendmoney.png'),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (subscriptions_status == true) {
                              passbookScreen();
                            } else {
                              SubscribetionScreen();
                            }
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  width: 68.00,
                                  height: 68.00,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: klightYelloColor,
                                    image: DecorationImage(
                                      scale: 2,
                                      image: ExactAssetImage(
                                          'assets/images/passbook.png'),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (subscriptions_status == true) {
                              addMoneyScreen();
                            } else {
                              SubscribetionScreen();
                            }
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                    width: 68.00,
                                    height: 68.00,
                                    child: Center(
                                      child: Text(
                                        'Add Money',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ) /*Text(
                                'Add Money',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),*/
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (subscriptions_status == true) {
                              sendMoneyScreen();
                            } else {
                              SubscribetionScreen();
                            }
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                    width: 68.00,
                                    height: 68.00,
                                    child: Center(
                                      child: Text(
                                        'Send Money',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ) /*Text(
                                'Add Money',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),*/
                                    ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (subscriptions_status == true) {
                              QRCodeScreenMake();
                            } else {
                              SubscribetionScreen();
                            }
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                    width: 68.00,
                                    height: 68.00,
                                    child: Center(
                                      child: Text(
                                        'Received Payment',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (subscriptions_status == true) {
                              passbookScreen();
                            } else {}
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                    width: 68.00,
                                    height: 68.00,
                                    child: Center(
                                      child: Text(
                                        'Passbook',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 5, left: 25),
                    child: Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(
                        'Exciting Offers for You',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listExcitingOffersData.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      var mdlSubData = listExcitingOffersData[index];
                      return GestureDetector(
                        child: Card(
                          elevation: 0,
                          child: Container(
                            margin: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                                topLeft: Radius.circular(30.0),
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(top: 2),
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height: 118.00,
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: NetworkImage(offer_baseUrl +
                                              "/" +
                                              mdlSubData.icon),
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 0, top: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      //mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Text(
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
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          child: Text(
                                            mdlSubData.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
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
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OffersDetails(mdlSubData.promo_code_id)));
                        },
                      );
                    },
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 15, left: 25),
                    child: Align(
                      alignment: FractionalOffset.topLeft,
                      child: Text(
                        'Featured Merchants',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                Container(
                    child: GridView.builder(
                  itemCount: listCategoryData.length > 6 ? 8 : 0,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    var mdlSubData = listCategoryData[index];
                    if (index == 7) {
                      return Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                            child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                viewAllCategory();
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color(0xffEE4B23),
                                  image: DecorationImage(
                                    scale: 3,
                                    image: ExactAssetImage(
                                        'assets/images/arrow_backward.png'),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 100,
                              child: Text(
                                'View More',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0,
                                ),
                              ),
                            )
                          ],
                        )),
                      );
                    } else {
                      return GestureDetector(
                          onTap: () {},
                          child: Container(
                              child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SingleCategory(
                                              mdlSubData.id,
                                              mdlSubData.categoryName,
                                              type)));
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: klightYelloColor,
                                    image: DecorationImage(
                                      scale: 2,
                                      image: NetworkImage(category_baseUrl +
                                          "/" +
                                          mdlSubData.icon),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 90,
                                child: Text(
                                  mdlSubData.categoryName,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12.0,
                                  ),
                                ),
                              )
                            ],
                          )));
                    }
                  },
                )),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
            child: Container(
          width: MediaQuery.of(context).size.width - 50,
          padding: const EdgeInsets.only(
            left: 50.0,
            right: 50.0,
          ),
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                        color: kYellowColor,
                        // borderRadius: BorderRadius.horizontal()),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: FlatButton(
                      onPressed: () {
                        if (subscriptions_status == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SendPaymentWithQrCode()));
                        } else {
                          SubscribetionScreen();
                        }
                      },
                      child: Text(
                        'New Payment',
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
              /*if (status=='Online') ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 200,
                          decoration: BoxDecoration(
                              color: kYellowColor,
                              // borderRadius: BorderRadius.horizontal()),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: FlatButton(
                            onPressed: () {
                              //nextScreen();
                              // paymentScreen();
                            },
                            child: Text(
                              'New Payment',
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


                  ] else ...[

                  ],*/
            ],
          ),
        )),
      ),
    );
  }

  void viewAllCategory() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AllCategory()));
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MoreDetailsScreen()));
  }

  void profileScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
  }

  void paymentScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }

  void notifications() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotificationScreen()));
  }

  void addMoneyScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddMoneyScreen()));
  }

  void sendMoneyScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SendPaymentWithQrCode()));
  }

  void makeMoneyScreen() {
    /*Navigator.push(
        context, MaterialPageRoute(builder: (context) => SendMoney()));*/
  }

  void passbookScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PassbookScreen()));
  }

  void SubscribetionScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubscribeScreen(subscriptionsNextScreen)));
  }

  void QRCodeScreenMake() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => QRCodeScreenMakePayment()));
  }

  _onBackPressed() async {
    //SharedPreferences prefs =  SharedPreferences.getInstance() as SharedPreferences;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return showDialog(
      context: context,
      barrierColor: Color(0x00ffffff),
      builder: (context) => new AlertDialog(
        title: new Text(
          'Exit Confirmation',
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontStyle: FontStyle.normal,
            fontSize: 17.0,
          ),
        ),
        content: new Text(
          'Do you want to exit ?',
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w400,
            color: Colors.black87,
            fontStyle: FontStyle.normal,
            fontSize: 14.0,
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
                      Navigator.of(context).pop(true);
                      prefs.setBool('IS_LOGIN_DATA_STATUS', false);
                    },
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    splashColor: kYellowColor,
                    child: Container(
                      decoration: BoxDecoration(
                          color: kYellowColor,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          'No',
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
                  // Red will correctly spread over gradient
                ),
                SizedBox(
                  width: 10,
                ),
                Ink(
                  height: 35,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ), // LinearGradientBoxDecoration
                  child: InkWell(
                    onTap: () {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else {
                        exit(0);
                      }
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
                            if (Platform.isAndroid) {
                              SystemNavigator.pop();
                            } else {
                              exit(0);
                            }
                          },
                          child: Text(
                            'Yes',
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

class CategoryDataList {
  String categoryName = '';
  String icon = '';
  String amount_limit = '';
  String id = '';
}
