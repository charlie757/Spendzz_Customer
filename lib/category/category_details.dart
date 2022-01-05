import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/category/slider_component/slide.dart';
import 'package:spendzz/category/slider_component/slide_dots.dart';
import 'package:spendzz/category/slider_component/slide_item.dart';
import 'package:spendzz/dashboard/account_screen.dart';
import 'package:spendzz/category/all_reviewRating_screen.dart';
import 'package:spendzz/category/single_category.dart';
import 'package:spendzz/resources/constants.dart';
import 'all_category.dart';
import 'package:http/http.dart' as http;


class CategoryDetails extends StatefulWidget {
  const CategoryDetails({Key? key}) : super(key: key);

  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}
class _CategoryDetailsState extends State<CategoryDetails> {
  List<CategoryDetailsDataList> categorydetailsData = [];
  List<TimeListDataList> timeListdetailsData = [];
  var isDataFetched = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String phoneNumber;
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 5) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "Store A",
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
              previousScreen();
            },
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0),
                    ),
                  ),
                  height: 200,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            PageView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: _pageController,
                              onPageChanged: _onPageChanged,
                              itemCount: slideList.length,
                              itemBuilder: (ctx, i) => SlideItem(i),
                            ),
                            Stack(
                              alignment: AlignmentDirectional.centerEnd,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      for (int i = 0; i < slideList.length; i++)
                                        if (i == _currentPage)
                                          SlideDots(true)
                                        else
                                          SlideDots(false)
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Shop Name',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      TextFormField(
                        enabled: false,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Shop Name',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff787D86)),
                          ),
                        ),
                        validator: (String? value) {
                          phoneNumber = value!;
                          if (value.isEmpty) {
                            return 'Please enter Shop Name';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: [
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Shop Phone Number',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      TextFormField(
                        enabled: false,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Enter Phone Number',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff787D86)),
                          ),
                        ),
                        validator: (String? value) {
                          phoneNumber = value!;
                          if (value.isEmpty) {
                            return 'Please enter phone number';
                          } else if (value.length < 10) {
                            return 'Please enter valid 10 digit phone number';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: [
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Address',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      TextFormField(
                        enabled: false,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: ' 132, My Street, Kingston...',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff787D86)),
                          ),
                        ),
                        validator: (String? value) {
                          phoneNumber = value!;
                          if (value.isEmpty) {
                            return 'Please enter your Address';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // MapUtils.openMap(-3.823216,-38.481700);
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 25, top: 5),
                    child: Align(
                      alignment: FractionalOffset.bottomRight,
                      child: Text(
                        'View Map',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: kYellowColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 0, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        child: Text(
                          'Shop Timing',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Align(
                        child: Text(
                          'Open',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Align(
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //shrinkWrap: true,
                  itemCount: 8,
                  itemBuilder: (BuildContext context, int index) => Card(
                    elevation: 0,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Sending Message"),
                        ));
                      },
                      child: Container(
                        child: Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Align(
                                child: Text(
                                  'Monday',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Align(
                                child: Text(
                                  '09:00AM',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Align(
                                child: Text(
                                  '09:00AM',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black38,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                            child: Column(
                          children: [
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                'Bio',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 255,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                //.horizontal
                                child: new Text(
                                  "1 Description that is too long in text format(Here Data is coming from API) jdlksaf j klkjjflkdsjfkddfdfsdfds " +
                                      "2 Description that is too long in text format(Here Data is coming from API) d fsdfdsfsdfd dfdsfdsf sdfdsfsd d " +
                                      "3 Description that is too long in text format(Here Data is coming from API)  adfsfdsfdfsdfdsf   dsf dfd fds fs" +
                                      "4 Description that is too long in text format(Here Data is coming from API) dsaf dsafdfdfsd dfdsfsda fdas dsad" +
                                      "5 Description that is too long in text format(Here Data is coming from API) dsfdsfd fdsfds fds fdsf dsfds fds " +
                                      "6 Description that is too long in text format(Here Data is coming from API) asdfsdfdsf fsdf sdfsdfdsf sd dfdsf" +
                                      "7 Description that is too long in text format(Here Data is coming from API) df dsfdsfdsfdsfds df dsfds fds fsd" +
                                      "8 Description that is too long in text format(Here Data is coming from API)" +
                                      "9 Description that is too long in text format(Here Data is coming from API)" +
                                      "10 Description that is too long in text format(Here Data is coming from API)",
                                  style: new TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 0),
                  child: Column(
                    children: [
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Payment Method',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      TextFormField(
                        enabled: false,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: 'Payment Method',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff787D86)),
                          ),
                        ),
                        validator: (String? value) {
                          phoneNumber = value!;
                          if (value.isEmpty) {
                            return 'Payment Method';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                  child: Column(
                    children: [
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Review & Rating',
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
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 25, top: 1),
                  child: Row(
                    children: [
                      Container(
                          child: RatingBar.builder(
                        initialRating: 3,
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
                          print(rating);
                        },
                      )),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          viewRatingScreenScreen();
                        },
                        child: Text(
                          'View',
                          style: TextStyle(
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
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 100.0, right: 100.0, top: 5, bottom: 55),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: kYellowColor,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: FlatButton(
                      onPressed: () {
                        nextScreen();
                        /*  if (_formkey.currentState!.validate()) {

                          return;
                        }*/
                      },
                      child: Text(
                        'Pay Now',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
  _callApiForCategoryDetailsDataList() async {
    var mapBody = new Map<String, dynamic>();
    mapBody['status'] = 'ACTIVE';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getString('LOGIN_USER_TOKEN') ?? '';
    setState(() {
      categorydetailsData.clear();
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
          var mdlActiveOrder = CategoryDetailsDataList();
          mdlActiveOrder.vendorIds = dictResult['_id'].toString();
          mdlActiveOrder.orderNumber = dictResult['orderNumber'].toString();
          mdlActiveOrder.customerId = dictResult['customerId'].toString();
          mdlActiveOrder.payableAmount = dictResult['payableAmount'].toString();
          mdlActiveOrder.referralDeduction =
              dictResult['referralDeduction'].toString();
        }

        setState(() {});
      }
    } finally {
      client.close();
    }
  }
  _callApiForTimeListDataList() async {
    var mapBody = new Map<String, dynamic>();
    mapBody['status'] = 'ACTIVE';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getString('LOGIN_USER_TOKEN') ?? '';
    setState(() {
      timeListdetailsData.clear();
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
          var mdlActiveOrder = TimeListDataList();
          mdlActiveOrder.vendorIds = dictResult['_id'].toString();
          mdlActiveOrder.orderNumber = dictResult['orderNumber'].toString();
          mdlActiveOrder.customerId = dictResult['customerId'].toString();
          mdlActiveOrder.payableAmount = dictResult['payableAmount'].toString();
          mdlActiveOrder.referralDeduction =
              dictResult['referralDeduction'].toString();
        }

        setState(() {});
      }
    } finally {
      client.close();
    }
  }
  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SingleCategory()));
  }
  void nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }
  void viewRatingScreenScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ReviewAndRating()));
  }
}
class TimeListDataList {
  String vendorIds = '';
  String orderNumber = '';
  String customerId = '';
  String payableAmount = '';
  String referralDeduction = '';
}
class CategoryDetailsDataList {
  String vendorIds = '';
  String orderNumber = '';
  String customerId = '';
  String payableAmount = '';
  String referralDeduction = '';
}
