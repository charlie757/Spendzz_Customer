import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/account_screen/profile.dart';
import 'package:spendzz/category/single_category.dart';
import 'package:spendzz/dashboard/account_screen.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/category/all_category.dart';
import 'package:spendzz/dashboard/add_money_screen.dart';
import 'package:spendzz/dashboard/make_payment_screen.dart';
import 'package:spendzz/dashboard/passbook_screen.dart';
import 'package:spendzz/dashboard/send_money_screen.dart';
import 'package:spendzz/intro_screen/more_details_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;

import 'notifications.dart';

class DashboardMainScreen extends StatefulWidget {
  static const String route = '/DashboardMainScreen';

  const DashboardMainScreen({Key? key}) : super(key: key);

  @override
  _DashboardMainScreenState createState() => _DashboardMainScreenState();
}

class _DashboardMainScreenState extends State<DashboardMainScreen> {
  List<ExcitingOffersData> listExcitingOffersData = [];
  var isDataFetched = false;
  List<CategoryDataList> listCategoryData = [];

  // List<ExcitingOffersData> listExcitingOffersData = [];
  Color colorBackgroundMoneyImage = Color(0xffFFF9EC);
  Color colorBackgroundSendMoneyImage = Color(0xffFFF9EC);
  Color colorBackgroundMakePaymentImage = Color(0xffFFF9EC);
  Color colorBackgroundPassbookImage = Color(0xffFFF9EC);
  bool change = false;
  //late String name;
  String addMoneyImage = "assets/images/money.png";
  String sendMoneyImage = "assets/images/sendmoney.png";
  String makePaymentImage = "assets/images/sendmoney.png";
  String passbookImage = "assets/images/passbook.png";
  final list = List.generate(20, (index) => 'Item $index');

 /* Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('NAME') ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    name = "";
    getSharedPrefs();
  }*/

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.only(top: 10, left: 3),
                  child: Align(
                    child: Container(
                      padding: EdgeInsets.only(top: 5, left: 20),
                      child: Row(
                        children: [
                          Container(
                            child: Container(
                              width: 35.00,
                              height: 35.00,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                  scale: 4,
                                  image: ExactAssetImage(
                                      'assets/images/account_profile.png'),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
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
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'name',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
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
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.only(right: 15),
                child: IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      notifications();
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
                Container(
                  height: 180,
                  width: MediaQuery.of(context).size.height - 10,
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: ListView(
                    children: [
                      CarouselSlider(
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
                              padding: EdgeInsets.all(24),
                              child: Row(
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
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Column(
                                      children: [
                                        Container(
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
                                            padding: EdgeInsets.only(left: 15),
                                            child: Align(
                                              child: Text(
                                                'Earn Instant Cashbacks\n'
                                                'Zero Transaction Fees for Adding\n'
                                                'amount to wallet ',
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontStyle: FontStyle.normal,
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
                          height: 150.0,
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
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Ink(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ), // LinearGradientBoxDecoration
                          child: InkWell(
                            onTap: () {
                              addMoneyScreen();
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            splashColor: kYellowColor,
                            child: Expanded(
                                child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 35.00,
                                    height: 35.00,
                                    child: Image.asset(
                                      addMoneyImage,
                                      scale: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 50,
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
                                  ),
                                ],
                              ),
                            )),
                          ),
                          // Red will correctly spread over gradient
                        ),
                      ),

                      /* validator: (String? value) {
                        emailAddress = value!;
                        String patttern ='!@#<>?":_``~;[]\|=-+)(*&^%1234567890';
                        RegExp regExp = new RegExp(patttern);
                        if (value.isEmpty) {
                          return 'Please enter Full Name';
                        } else if (!regExp.hasMatch(value)) {
                          return 'Please enter valid Name';
                        }
                      }
*/

                      Expanded(
                        child: Ink(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ), // LinearGradientBoxDecoration
                          child: InkWell(
                            onTap: () {
                              sendMoneyScreen();
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            splashColor: kYellowColor,
                            child: Expanded(
                                child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 35.00,
                                    height: 35.00,
                                    child: Image.asset(
                                      addMoneyImage,
                                      scale: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 50,
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
                                  ),
                                ],
                              ),
                            )),
                          ),
                          // Red will correctly spread over gradient
                        ),
                      ),
                      Expanded(
                        child: Ink(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ), // LinearGradientBoxDecoration
                          child: InkWell(
                            onTap: () {
                              makeMoneyScreen();
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            splashColor: kYellowColor,
                            child: Expanded(
                                child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 35.00,
                                    height: 35.00,
                                    child: Image.asset(
                                      addMoneyImage,
                                      scale: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 80,
                                    child: Text(
                                      'Make Payment',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                          // Red will correctly spread over gradient
                        ),
                      ),
                      Expanded(
                        child: Ink(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ), // LinearGradientBoxDecoration
                          child: InkWell(
                            onTap: () {
                              passbookScreen();
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            splashColor: kYellowColor,
                            child: Expanded(
                                child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 35.00,
                                    height: 35.00,
                                    child: Image.asset(
                                      addMoneyImage,
                                      scale: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 60,
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
                                  ),
                                ],
                              ),
                            )),
                          ),
                          // Red will correctly spread over gradient
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
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
                  child: ListView.builder(
                      //shrinkWrap: true,
                      //itemCount: 5,
                      itemCount: list.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) =>
                          GestureDetector(
                            child: Card(
                              elevation: 0,
                              child: Container(
                                margin: EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                  color: Color(0xffFFFCF6),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0),
                                    topLeft: Radius.circular(30.0),
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(top: 2, left: 25),
                                  child: Column(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(top: 2),
                                          width: 178.00,
                                          height: 118.00,
                                          decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                              image: ExactAssetImage(
                                                  'assets/images/intro_c.png'),
                                              fit: BoxFit.fill,
                                            ),
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.only(top: 15, right: 15),
                                        child: Column(
                                          children: [
                                            Text(
                                              'Bonus Cashback',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                letterSpacing: 2,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: 160,
                                              child: Text(
                                                'Get 10% Cashback for all transaction with Wallie',
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  letterSpacing: 2,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0,
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
                              //addMoneyScreen();
                              //  Navigator.push(context, MaterialPageRoute(builder: (context) => PassbookScreen(item :list[index])));
                            },
                          )),
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
                  itemCount: 8,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (BuildContext context, int index) {
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
                                height: 35,
                                width: 35,
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
                      return Container(
                        child: Ink(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ), // LinearGradientBoxDecoration
                          child: InkWell(
                            onTap: () {
                              addMoneyScreen();
                              //SingleCategory();
                              //AllCategory();
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            splashColor: kYellowColor,
                            child: Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 35.00,
                                        height: 35.00,
                                        child: Image.asset(
                                          'assets/images/category.png',
                                          scale: 2,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          width: 70,
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              'Category One',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontWeight:
                                                FontWeight.w500,
                                                color: Colors.black,
                                                fontStyle:
                                                FontStyle.normal,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                )),
                          ),
                          // Red will correctly spread over gradient
                        ),
                      );
                      return Container(
                        child: Container(
                            child: Column(
                          children: [
                            Ink(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                              ), // LinearGradientBoxDecoration
                              child: InkWell(
                                onTap: () {
                                  SingleCategory();
                                },
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                ),
                                splashColor: kYellowColor,
                                child: Expanded(
                                  child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                image: DecorationImage(
                                                  scale: 2,
                                                  image: ExactAssetImage(
                                                      'assets/images/category.png'),
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                width: 70,
                                                child: Container(
                                                  width: 100,
                                                  child: Text(
                                                    'Category One',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                ),
                              ),
                              // Red will correctly spread over gradient
                            ),
                          ],
                        )),
                      );
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
          width: MediaQuery.of(context).size.width - 100,
          padding: const EdgeInsets.only(
            left: 50.0,
            right: 50.0,
          ),
          child: Padding(
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
        )),
      ),
    );
  }

  _callApiForExcitingOffersOnDashboard() async {
    var mapBody = new Map<String, dynamic>();
    mapBody['status'] = 'ACTIVE';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getString('LOGIN_USER_TOKEN') ?? '';
    setState(() {
      listExcitingOffersData.clear();
    });
    var client = http.Client();
    //  EasyLoading.show();
    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.EXCITING_OFFERS),
          body: mapBody,
          headers: {'x-access-token': tokenData});
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      // EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['result'];

        isDataFetched = true;

        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlActiveOrder = ExcitingOffersData();
          mdlActiveOrder.vendorIds = dictResult['_id'].toString();
          mdlActiveOrder.orderNumber = dictResult['orderNumber'].toString();
          mdlActiveOrder.customerId = dictResult['customerId'].toString();
          mdlActiveOrder.payableAmount = dictResult['payableAmount'].toString();
          mdlActiveOrder.referralDeduction =
              dictResult['referralDeduction'].toString();
          mdlActiveOrder.couponDeduction =
              dictResult['couponDeduction'].toString();
          mdlActiveOrder.serviceFee = dictResult['serviceFee'].toString();
          mdlActiveOrder.deliveryAmount =
              dictResult['deliveryAmount'].toString();
          mdlActiveOrder.grandTotal = dictResult['grandTotal'].toString();
          mdlActiveOrder.status = dictResult['status'].toString();
          listExcitingOffersData.add(mdlActiveOrder);
        }

        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  _callApiForCategoryDataOnDashboard() async {
    var mapBody = new Map<String, dynamic>();
    mapBody['status'] = 'ACTIVE';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getString('LOGIN_USER_TOKEN') ?? '';
    setState(() {
      listCategoryData.clear();
    });
    var client = http.Client();
    //  EasyLoading.show();
    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.EXCITING_OFFERS),
          body: mapBody,
          headers: {'x-access-token': tokenData});
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      // EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['result'];

        isDataFetched = true;

        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlActiveOrder = CategoryDataList();
          mdlActiveOrder.vendorIds = dictResult['_id'].toString();
          mdlActiveOrder.orderNumber = dictResult['orderNumber'].toString();
          mdlActiveOrder.customerId = dictResult['customerId'].toString();
          mdlActiveOrder.payableAmount = dictResult['payableAmount'].toString();
          mdlActiveOrder.referralDeduction =
              dictResult['referralDeduction'].toString();
          mdlActiveOrder.couponDeduction =
              dictResult['couponDeduction'].toString();
          mdlActiveOrder.serviceFee = dictResult['serviceFee'].toString();
          mdlActiveOrder.deliveryAmount =
              dictResult['deliveryAmount'].toString();
          mdlActiveOrder.grandTotal = dictResult['grandTotal'].toString();
          mdlActiveOrder.status = dictResult['status'].toString();
          listCategoryData.add(mdlActiveOrder);
        }

        setState(() {});
      }
    } finally {
      client.close();
    }
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SendMoney()));
  }

  void makeMoneyScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MakeMoney()));
  }

  void passbookScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PassbookScreen()));
  }

  _onBackPressed() {
    return showDialog(
          context: context,
          barrierColor: Color(0x00ffffff),
          builder: (context) => new AlertDialog(
            backgroundColor: klightYelloColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: new Text(
              'Exit Confirmation',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                color: kYellowColor,
                fontStyle: FontStyle.normal,
                fontSize: 17.0,
              ),
            ),
            content: new Text(
              'Do you want to exit ?',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w300,
                color: kYellowColor,
                fontStyle: FontStyle.normal,
                fontSize: 14.0,
              ),
            ),
            actions: <Widget>[
              new Container(
                padding: EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Ink(
                      height: 35,
                      width: 85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ), // LinearGradientBoxDecoration
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        splashColor: kYellowColor,
                        child: Align(
                          child: Text(
                            'CANCEL',
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
                      // Red will correctly spread over gradient
                    ),
                    Ink(
                      height: 35,
                      width: 55,
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
                          child: Text(
                            'OK',
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
                      // Red will correctly spread over gradient
                    ),
                  ],
                ),
              )
            ],
          ),
        ) ??
        false;
  }
}

class ExcitingOffersData {
  String vendorIds = '';
  String orderNumber = '';
  String customerId = '';
  String payableAmount = '';
  String referralDeduction = '';
  String couponDeduction = '';
  String serviceFee = '';
  String deliveryAmount = '';
  String grandTotal = '';
  String status = '';
}

class CategoryDataList {
  String vendorIds = '';
  String orderNumber = '';
  String customerId = '';
  String payableAmount = '';
  String referralDeduction = '';
  String couponDeduction = '';
  String serviceFee = '';
  String deliveryAmount = '';
  String grandTotal = '';
  String status = '';
}
