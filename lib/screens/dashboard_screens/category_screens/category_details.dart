import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/account_screens/subscribtion_screens/SubscribeScreen.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/slider_component/slide_dots.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/pay_money_screen.dart';
import 'package:spendzz/screens/dashboard_screens/rating_review_screens/review_rating_list_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'all_category.dart';
import 'package:http/http.dart' as http;

class CategoryDetails extends StatefulWidget {
  //todo SingleCategory Data
  var shopId = '';
  var merchantId = '';
  var shopNameSingleCategory = '';

  CategoryDetails(this.shopId, this.merchantId, this.shopNameSingleCategory);

  @override
  _CategoryDetailsState createState() =>
      _CategoryDetailsState(shopId, merchantId, shopNameSingleCategory);
}

class _CategoryDetailsState extends State<CategoryDetails> {
  _CategoryDetailsState(
    this.shopId,
    this.merchantId,
    this.shopNameSingleCategory,
  );
  var shopId = '';
  var merchantId = '';
  var shopNameSingleCategory = '';
  var CategoryPay = "payToCategory";
  List<CategoryDetailsDataList> categorydetailsData = [];
  List<RatingDataList> ratingList = [];
  List<SliderImageDataList> sliderImageList = [];
  var isDataFetched = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String phoneNumber;
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  late bool Status = true;
  var singleCategory_baseUrl = '';
  var singleCategory_imageUrl = '';

  //todo Details Field
  var shopName = '';
  var shopMobileNo = '';
  var shopAddress = '';
  var establishtime = '';
  var lat = '';
  var long = '';
  var shopbio = '';
  var rating = 0.0;
  var unique_key = '';
  var imageUrl = '';

  //todo Details shop time Field
  var sundayOpenTime = '';
  var sundayCloseTime = '';
  var mondayOpenTime = '';
  var mondayCloseTime = '';
  var tuesdayOpenTime = '';
  var tuesdayCloseTime = '';
  var wednesdayOpenTime = '';
  var wednesdayCloseTime = '';
  var thursdayOpenTime = '';
  var thursdayCloseTime = '';
  var fridayOpenTime = '';
  var fridayCloseTime = '';
  var saturdayOpenTime = '';
  var saturdayCloseTime = '';
  bool subscriptions_status = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
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
    setState(() {});
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

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _categoryDetails(prefs.getString('AUTH_TOKEN').toString());
      _callCheckSubscriptionStatus(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {});
  }

  _categoryDetails(String tokenData) async {
    var mapBody = new Map<String, dynamic>();
    mapBody['shop_id'] = shopId;
    mapBody['merchant_id'] = merchantId;
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokenData',
      };
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.CATEGORY_DETAIL),
          headers: headers,
          body: mapBody);
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();

      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        Status = dataAll['status'];
        setState(() {});
        if (Status == true) {
          singleCategory_baseUrl = dataAll['image_url'].toString();
          var arrResults = dataAll['data'];
          print("arrResults ${arrResults}");
          shopName = arrResults['get_merchat_info']['shop_name'].toString();
          shopMobileNo = arrResults['get_merchat_info']['shop_phone'];
          shopAddress = arrResults['get_merchat_info']['address'].toString();
          lat = arrResults['get_merchat_info']['lat'].toString();
          long = arrResults['get_merchat_info']['long'].toString();
          establishtime = arrResults['established'].toString();
          shopbio = arrResults['get_merchat_info']['bio'].toString();
          unique_key = arrResults['unique_key'].toString();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("unique_key", unique_key);
          prefs.setString("shop_name", shopName);
          prefs.setString("mobile", shopMobileNo);
          prefs.setString("paymentType", 'mobile');
          //   prefs.setString("unique_key", unique_key);
          var ratingArray = arrResults['merchant_avg_rating'];
          /*//  var ratingArray = arrResults['merchant_avg_rating'];
          var ratingArray = arrResults['merchant_avg_rating'];
          rating = ratingArray[0]['aggregate'];
          rating = ratingArray[0]['aggregate'];
          //message=arrResult2[0]['message'].toString();*/

          /* isDataFetched = true;
          for (var i = 0; i < ratingArray.length; i++) {
            var dictResult = ratingArray[i];
            var mdlSubData = RatingDataList();
            rating=dictResult[0]['aggregate'];
            timeListdetailsData.add(mdlSubData);
            setState(() {});
          }*/
          var sliderImage = dataAll['data']['merchant_gallerys'];
          isDataFetched = true;
          for (var i = 0; i < sliderImage.length; i++) {
            var dictResult = sliderImage[i];
            var mdlSubData = SliderImageDataList();
            mdlSubData.image =
                singleCategory_baseUrl + '/' + dictResult['image'].toString();
            mdlSubData.image =
                singleCategory_baseUrl + '/' + dictResult['image'].toString();

            sliderImageList.add(mdlSubData);

            setState(() {});
          }
          var ratingArdray = dataAll['data']['merchant_avg_rating'];
          isDataFetched = true;
          for (var i = 0; i < ratingArdray.length; i++) {
            var dictResult = ratingArdray[i];
            var mdlSubData = RatingDataList();
            mdlSubData.aggregate = dictResult['aggregate'].toString();
            rating = double.parse(mdlSubData.aggregate);
            print("rating $rating");
            ratingList.add(mdlSubData);

            setState(() {});
          }
          if (dataAll['shop_time'] != null) {
            if (dataAll['shop_time']['monday'] != null) {
              var MondayTime = dataAll['shop_time']['monday'].toString();
              var MondayTimeArr = MondayTime;
              mondayOpenTime = MondayTimeArr[0].toString();
              mondayCloseTime = MondayTimeArr[1].toString();
            } else {
              mondayOpenTime = "8:00AM";
              mondayOpenTime = "8:00PM";
            }
            if (dataAll['shop_time']['tuesday'] != null) {
              var TuesdayTime = dataAll['shop_time']['tuesday'];
              var TuesdayTimeArr = TuesdayTime;
              tuesdayOpenTime = TuesdayTimeArr[0].toString();
              tuesdayCloseTime = TuesdayTimeArr[1].toString();
            } else {
              tuesdayOpenTime = "8:00AM";
              tuesdayCloseTime = "8:00PM";
            }
            if (dataAll['shop_time']['wednesday'] != null) {
              var WednesdayTime = dataAll['shop_time']['wednesday'];
              var WednesdayTimeTimeArr = WednesdayTime;
              wednesdayOpenTime = WednesdayTimeTimeArr[0].toString();
              wednesdayCloseTime = WednesdayTimeTimeArr[1].toString();
            } else {
              wednesdayOpenTime = "8:00AM";
              wednesdayCloseTime = "8:00PM";
            }

            if (dataAll['shop_time']['thursday'] != null) {
              var ThursdayTime = dataAll['shop_time']['thursday'];
              var ThursdayTimeArr = ThursdayTime;
              thursdayOpenTime = ThursdayTimeArr[0].toString();
              thursdayCloseTime = ThursdayTimeArr[1].toString();
            } else {
              thursdayOpenTime = "8:00AM";
              thursdayCloseTime = "8:00PM";
            }

            if (dataAll['shop_time']['friday'] != null) {
              var FridayTime = dataAll['shop_time']['friday'];
              var FridayTimeArr = FridayTime;
              fridayOpenTime = FridayTimeArr[0].toString();
              fridayCloseTime = FridayTimeArr[1].toString();
            } else {
              fridayOpenTime = "8:00AM";
              fridayCloseTime = "8:00PM";
            }

            if (dataAll['shop_time']['saturday'] != null) {
              var SaturdayTime = dataAll['shop_time']['saturday'];
              var SaturdayTimeArr = SaturdayTime;
              saturdayOpenTime = SaturdayTimeArr[0].toString();
              saturdayCloseTime = SaturdayTimeArr[1].toString();
            } else {
              saturdayOpenTime = "8:00AM";
              saturdayCloseTime = "8:00PM";
            }

            if (dataAll['shop_time']['sunday'] != null) {
              var SundayTime = dataAll['shop_time']['sunday'];
              var SundayTimeArr = SundayTime;
              sundayOpenTime = SundayTimeArr[0].toString();
              sundayCloseTime = SundayTimeArr[1].toString();
            } else {
              sundayOpenTime = "8:00AM";
              sundayCloseTime = "8:00PM";
            }
          }
        } else {
          setState(() {});
          Fluttertoast.showToast(
              msg: dataAll['message'],
              //msg: 'successfully',
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
            //msg: 'successfully',
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

        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AllCategory()));
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
              shopNameSingleCategory.toString(),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AllCategory()));
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: sliderImageList.length,
                      itemBuilder: (context, index) {
                        var mdlSubData = sliderImageList[index];
                        return Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(mdlSubData.image.toString()),
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < sliderImageList.length; i++)
                        if (i == _currentPage)
                          SlideDots(true)
                        else
                          SlideDots(false)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shop Name',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
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
                          hintText: shopName,
                          hintStyle: TextStyle(color: Colors.black),
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Shop Phone Number',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
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
                          hintText: shopMobileNo,
                          hintStyle: TextStyle(color: Colors.black),
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Address',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
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
                          hintText: shopAddress,
                          hintStyle: TextStyle(color: Colors.black),
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Established Since',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
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
                          hintText: establishtime,
                          hintStyle: TextStyle(color: Colors.black),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff787D86)),
                          ),
                        ),
                        validator: (String? value) {
                          phoneNumber = value!;
                          if (value.isEmpty) {
                            return 'Please enter your Established Since';
                          }
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    'Shop Timing',
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
                                Text(
                                  'Monday',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  'Tuesday',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  'Wednesday',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  'Thursday',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  'Friday',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  'Saturday',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  // padding: EdgeInsets.only(left: 0, right: 85),
                                  child: Text(
                                    'Open',
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
                                Text(
                                  sundayOpenTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  tuesdayOpenTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  wednesdayOpenTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  thursdayOpenTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  fridayOpenTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  saturdayOpenTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Close',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  sundayCloseTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  tuesdayCloseTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  wednesdayCloseTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  thursdayCloseTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  fridayCloseTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  saturdayCloseTime,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        // padding: EdgeInsets.all(25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                      'About Merchant-',
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
                                    height: 10,
                                  ),
                                  Container(
                                    height: 255,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      //.horizontal
                                      child: /*new Text(

                                    shopbio,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),*/
                                          Align(
                                        alignment: FractionalOffset.topLeft,
                                        child: Text(
                                          shopbio,
                                          textAlign: TextAlign.left,
                                          style: new TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
                                          ),
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
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          openMapsSheet(
                            context,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "View Location",
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w500,
                                color: kYellowColor,
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                              ),
                            ),
                            Icon(
                              Icons.location_on_outlined,
                              color: kYellowColor,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Review & Rating',
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
                      Row(
                        children: [
                          Container(
                              child: RatingBar.builder(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30,
                            ignoreGestures: true,
                            updateOnDrag: false,
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
                              /*if(subscriptions_status==true)
                          {
                            nextScreen();
                          }
                          else{

                          }*/

                              if (subscriptions_status == true) {
                                nextScreen();
                              } else {
                                SubscribetionScreen();
                                /*Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => Kyc_screen()));*/
                              }
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          )

          //  SingleChildScrollView(
          //   scrollDirection: Axis.vertical,
          //   child: Form(
          //     key: _formkey,
          //     child: Column(
          //       children: [
          //         Container(
          //           padding: EdgeInsets.only(left: 10, right: 10),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.only(
          //               topRight: Radius.circular(10.0),
          //               bottomLeft: Radius.circular(10.0),
          //               bottomRight: Radius.circular(10.0),
          //               topLeft: Radius.circular(10.0),
          //             ),
          //           ),
          //           height: 200,
          //           child: Column(
          //             children: <Widget>[
          //               /*Expanded(
          //                 child: Stack(
          //                   alignment: AlignmentDirectional.bottomCenter,
          //                   children: <Widget>[
          //                     PageView.builder(
          //                       scrollDirection: Axis.horizontal,
          //                       controller: _pageController,
          //                       onPageChanged: _onPageChanged,
          //                       itemCount: sliderImageList.length,
          //                       itemBuilder: (ctx, i) => SlideItem(i),
          //                     ),
          //                     Stack(
          //                       alignment: AlignmentDirectional.centerEnd,
          //                       children: <Widget>[
          //                         Container(
          //                           margin: const EdgeInsets.only(bottom: 10),
          //                           child: Row(
          //                             mainAxisSize: MainAxisSize.min,
          //                             mainAxisAlignment: MainAxisAlignment.center,
          //                             children: <Widget>[
          //                               for (int i = 0; i < sliderImageList.length; i++)
          //                                 if (i == _currentPage)
          //                                   SlideDots(true)
          //                                 else
          //                                   SlideDots(false)
          //                             ],
          //                           ),
          //                         )
          //                       ],
          //                     )
          //                   ],
          //                 ),
          //               ),*/
          //               Expanded(
          //                 child: Stack(
          //                   alignment: AlignmentDirectional.bottomCenter,
          //                   children: <Widget>[
          //                     PageView.builder(
          //                         scrollDirection: Axis.horizontal,
          //                         controller: _pageController,
          //                         onPageChanged: _onPageChanged,
          //                         itemCount: sliderImageList.length,
          //                         itemBuilder: (ctx, i) {
          //                           var mdlSubData = sliderImageList[i];
          //                           return Stack(
          //                             alignment:
          //                                 AlignmentDirectional.bottomCenter,
          //                             children: <Widget>[
          //                               Container(
          //                                 padding: EdgeInsets.only(
          //                                     left: 10, right: 10),
          //                                 width:
          //                                     MediaQuery.of(context).size.width,
          //                                 height: 200,
          //                                 decoration: BoxDecoration(
          //                                   borderRadius: BorderRadius.only(
          //                                     topRight: Radius.circular(10.0),
          //                                     bottomLeft: Radius.circular(10.0),
          //                                     bottomRight: Radius.circular(10.0),
          //                                     topLeft: Radius.circular(10.0),
          //                                   ),
          //                                   image: DecorationImage(
          //                                     image: NetworkImage(
          //                                         mdlSubData.image.toString()),
          //                                     fit: BoxFit.fill,
          //                                   ),
          //                                 ),
          //                               ),
          //                               Container(
          //                                 alignment:
          //                                     AlignmentDirectional.bottomCenter,
          //                                 margin:
          //                                     const EdgeInsets.only(bottom: 10),
          //                                 child:
          // Row(
          //                                   mainAxisSize: MainAxisSize.max,
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.center,
          //                                   children: <Widget>[
          //                                     for (int i = 0;
          //                                         i < sliderImageList.length;
          //                                         i++)
          //                                       if (i == _currentPage)
          //                                         SlideDots(true)
          //                                       else
          //                                         SlideDots(false)
          //                                   ],
          //                                 ),
          //                               ),
          //                             ],
          //                           );
          //                         }),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         Container(
          //           padding: EdgeInsets.all(25),
          //           child: Column(
          //             children: [
          //               Align(
          //                 alignment: FractionalOffset.topLeft,
          //                 child: Text(
          //                   'Shop Name',
          //                   style: TextStyle(
          //                     fontFamily: 'Rubik',
          //                     fontWeight: FontWeight.w300,
          //                     color: Colors.black,
          //                     fontStyle: FontStyle.normal,
          //                     fontSize: 14.0,
          //                   ),
          //                 ),
          //               ),
          //               TextFormField(
          //                 enabled: false,
          //                 style: TextStyle(
          //                   fontFamily: 'Rubik',
          //                   fontWeight: FontWeight.w300,
          //                   color: Colors.black,
          //                   fontStyle: FontStyle.normal,
          //                   fontSize: 16.0,
          //                 ),
          //                 autocorrect: true,
          //                 decoration: InputDecoration(
          //                   hintText: shopName,
          //                   hintStyle: TextStyle(color: Colors.black),
          //                   focusedBorder: UnderlineInputBorder(
          //                     borderSide: BorderSide(color: Color(0xff787D86)),
          //                   ),
          //                 ),
          //                 validator: (String? value) {
          //                   phoneNumber = value!;
          //                   if (value.isEmpty) {
          //                     return 'Please enter Shop Name';
          //                   }
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          //         Container(
          //           padding: EdgeInsets.only(left: 25, right: 25),
          //           child: Column(
          //             children: [
          //               Align(
          //                 alignment: FractionalOffset.topLeft,
          //                 child: Text(
          //                   'Shop Phone Number',
          //                   style: TextStyle(
          //                     fontFamily: 'Rubik',
          //                     fontWeight: FontWeight.w300,
          //                     color: Colors.black,
          //                     fontStyle: FontStyle.normal,
          //                     fontSize: 14.0,
          //                   ),
          //                 ),
          //               ),
          //               TextFormField(
          //                 enabled: false,
          //                 inputFormatters: [
          //                   LengthLimitingTextInputFormatter(10),
          //                 ],
          //                 keyboardType: TextInputType.number,
          //                 style: TextStyle(
          //                   fontFamily: 'Rubik',
          //                   fontWeight: FontWeight.w300,
          //                   color: Colors.black,
          //                   fontStyle: FontStyle.normal,
          //                   fontSize: 16.0,
          //                 ),
          //                 autocorrect: true,
          //                 decoration: InputDecoration(
          //                   hintText: shopMobileNo,
          //                   hintStyle: TextStyle(color: Colors.black),
          //                   focusedBorder: UnderlineInputBorder(
          //                     borderSide: BorderSide(color: Color(0xff787D86)),
          //                   ),
          //                 ),
          //                 validator: (String? value) {
          //                   phoneNumber = value!;
          //                   if (value.isEmpty) {
          //                     return 'Please enter phone number';
          //                   } else if (value.length < 10) {
          //                     return 'Please enter valid 10 digit phone number';
          //                   }
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          //         SizedBox(
          //           height: 25,
          //         ),
          //         Container(
          //           padding: EdgeInsets.only(left: 25, right: 25),
          //           child: Column(
          //             children: [
          //               Align(
          //                 alignment: FractionalOffset.topLeft,
          //                 child: Text(
          //                   'Address',
          //                   style: TextStyle(
          //                     fontFamily: 'Rubik',
          //                     fontWeight: FontWeight.w300,
          //                     color: Colors.black,
          //                     fontStyle: FontStyle.normal,
          //                     fontSize: 14.0,
          //                   ),
          //                 ),
          //               ),
          //               TextFormField(
          //                 enabled: false,
          //                 style: TextStyle(
          //                   fontFamily: 'Rubik',
          //                   fontWeight: FontWeight.w300,
          //                   color: Colors.black,
          //                   fontStyle: FontStyle.normal,
          //                   fontSize: 16.0,
          //                 ),
          //                 autocorrect: true,
          //                 decoration: InputDecoration(
          //                   hintText: shopAddress,
          //                   hintStyle: TextStyle(color: Colors.black),
          //                   focusedBorder: UnderlineInputBorder(
          //                     borderSide: BorderSide(color: Color(0xff787D86)),
          //                   ),
          //                 ),
          //                 validator: (String? value) {
          //                   phoneNumber = value!;
          //                   if (value.isEmpty) {
          //                     return 'Please enter your Address';
          //                   }
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),

          //         SizedBox(
          //           height: 15,
          //         ),
          //         Container(
          //           padding: EdgeInsets.only(left: 25, right: 25),
          //           child: Column(
          //             children: [
          //               Align(
          //                 alignment: FractionalOffset.topLeft,
          //                 child: Text(
          //                   'Established Since',
          //                   style: TextStyle(
          //                     fontFamily: 'Rubik',
          //                     fontWeight: FontWeight.w300,
          //                     color: Colors.black,
          //                     fontStyle: FontStyle.normal,
          //                     fontSize: 14.0,
          //                   ),
          //                 ),
          //               ),
          //               TextFormField(
          //                 enabled: false,
          //                 style: TextStyle(
          //                   fontFamily: 'Rubik',
          //                   fontWeight: FontWeight.w300,
          //                   color: Colors.black,
          //                   fontStyle: FontStyle.normal,
          //                   fontSize: 16.0,
          //                 ),
          //                 autocorrect: true,
          //                 decoration: InputDecoration(
          //                   hintText: shopAddress,
          //                   hintStyle: TextStyle(color: Colors.black),
          //                   focusedBorder: UnderlineInputBorder(
          //                     borderSide: BorderSide(color: Color(0xff787D86)),
          //                   ),
          //                 ),
          //                 validator: (String? value) {
          //                   phoneNumber = value!;
          //                   if (value.isEmpty) {
          //                     return 'Please enter your Established Since';
          //                   }
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          //         SizedBox(
          //           height: 15,
          //         ),
          //         Container(
          //             padding: EdgeInsets.only(left: 35, right: 25),
          //             child: Container(
          //                 padding: EdgeInsets.only(left: 0, right: 35),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   // use whichever suits your need
          //                   children: <Widget>[
          //                     Container(
          //                       padding: EdgeInsets.only(right: 25),
          //                       child: Text(
          //                         'Shop Timing',
          //                         style: TextStyle(
          //                           fontFamily: 'Rubik',
          //                           fontWeight: FontWeight.w300,
          //                           color: Colors.black,
          //                           fontStyle: FontStyle.normal,
          //                           fontSize: 14.0,
          //                         ),
          //                       ),
          //                     ),
          //                     Container(
          //                       padding: EdgeInsets.only(left: 0, right: 85),
          //                       child: Text(
          //                         'Open',
          //                         style: TextStyle(
          //                           fontFamily: 'Rubik',
          //                           fontWeight: FontWeight.w300,
          //                           color: Colors.black,
          //                           fontStyle: FontStyle.normal,
          //                           fontSize: 14.0,
          //                         ),
          //                       ),
          //                     ),
          //                     Text(
          //                       'Close',
          //                       style: TextStyle(
          //                         fontFamily: 'Rubik',
          //                         fontWeight: FontWeight.w300,
          //                         color: Colors.black,
          //                         fontStyle: FontStyle.normal,
          //                         fontSize: 14.0,
          //                       ),
          //                     ),
          //                   ],
          //                 ))),

          //         SizedBox(
          //           height: 5,
          //         ),
          //         //TODO Timer
          //         Container(
          //             padding: EdgeInsets.only(
          //               left: 35,
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: <Widget>[
          //                 Expanded(
          //                   child: Text(
          //                     'Monday',
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w500,
          //                       color: Colors.black,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     sundayOpenTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 25,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     sundayCloseTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             )),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Container(
          //             padding: EdgeInsets.only(
          //               left: 35,
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: <Widget>[
          //                 Expanded(
          //                   child: Text(
          //                     'Tuesday',
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w500,
          //                       color: Colors.black,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     tuesdayOpenTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 25,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     tuesdayCloseTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             )),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Container(
          //             padding: EdgeInsets.only(
          //               left: 35,
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: <Widget>[
          //                 Expanded(
          //                   child: Text(
          //                     'Wednesday',
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w500,
          //                       color: Colors.black,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     wednesdayOpenTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 25,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     wednesdayCloseTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             )),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Container(
          //             padding: EdgeInsets.only(
          //               left: 35,
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: <Widget>[
          //                 Expanded(
          //                   child: Text(
          //                     'Thursday',
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w500,
          //                       color: Colors.black,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     thursdayOpenTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 25,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     thursdayCloseTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             )),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Container(
          //             padding: EdgeInsets.only(
          //               left: 35,
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: <Widget>[
          //                 Expanded(
          //                   child: Text(
          //                     'Friday',
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w500,
          //                       color: Colors.black,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     fridayOpenTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 25,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     fridayCloseTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             )),
          //         SizedBox(
          //           height: 5,
          //         ),
          //         Container(
          //             padding: EdgeInsets.only(
          //               left: 35,
          //             ),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: <Widget>[
          //                 Expanded(
          //                   child: Text(
          //                     'Saturday',
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w500,
          //                       color: Colors.black,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     saturdayOpenTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 25,
          //                 ),
          //                 Expanded(
          //                   flex: 1,
          //                   child: Text(
          //                     saturdayCloseTime,
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w400,
          //                       color: Colors.grey,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             )),
          //         Container(
          //           padding: EdgeInsets.all(25),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Container(
          //                 padding: EdgeInsets.only(
          //                     left: 15, right: 15, top: 5, bottom: 15),
          //                 decoration: BoxDecoration(
          //                   border: Border.all(
          //                     color: Colors.black38,
          //                   ),
          //                   borderRadius: BorderRadius.circular(10.0),
          //                 ),
          //                 child: Container(
          //                     child: Column(
          //                   children: [
          //                     Align(
          //                       alignment: FractionalOffset.topLeft,
          //                       child: Text(
          //                         'Bio',
          //                         style: TextStyle(
          //                           fontFamily: 'Rubik',
          //                           fontWeight: FontWeight.w300,
          //                           color: Colors.black,
          //                           fontStyle: FontStyle.normal,
          //                           fontSize: 14.0,
          //                         ),
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       height: 10,
          //                     ),
          //                     Container(
          //                       height: 255,
          //                       child: SingleChildScrollView(
          //                         scrollDirection: Axis.vertical,
          //                         //.horizontal
          //                         child: /*new Text(

          //                           shopbio,
          //                           textAlign: TextAlign.left,
          //                           style: new TextStyle(
          //                             fontFamily: 'Rubik',
          //                             fontWeight: FontWeight.w500,
          //                             color: Colors.black,
          //                             fontStyle: FontStyle.normal,
          //                             fontSize: 16.0,
          //                           ),
          //                         ),*/
          //                             Align(
          //                           alignment: FractionalOffset.topLeft,
          //                           child: Text(
          //                             shopbio,
          //                             textAlign: TextAlign.left,
          //                             style: new TextStyle(
          //                               fontFamily: 'Rubik',
          //                               fontWeight: FontWeight.w500,
          //                               color: Colors.black,
          //                               fontStyle: FontStyle.normal,
          //                               fontSize: 16.0,
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 )),
          //               )
          //             ],
          //           ),
          //         ),

          //         Padding(
          //           padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.end,
          //             children: [
          //               TextButton(
          //                   onPressed: () {},
          //                   child: Text(
          //                     "View Location",
          //                     style: TextStyle(
          //                       fontFamily: 'Rubik',
          //                       fontWeight: FontWeight.w500,
          //                       color: kYellowColor,
          //                       fontStyle: FontStyle.normal,
          //                       fontSize: 14.0,
          //                     ),
          //                   )),
          //               Icon(
          //                 Icons.location_on_outlined,
          //                 color: kYellowColor,
          //                 size: 40,
          //               ),
          //             ],
          //           ),
          //         ),

          //         SizedBox(
          //           height: 25,
          //         ),
          //         Container(
          //           padding: EdgeInsets.only(left: 25, right: 25, top: 10),
          //           child: Column(
          //             children: [
          //               Align(
          //                 alignment: FractionalOffset.topLeft,
          //                 child: Text(
          //                   'Review & Rating',
          //                   style: TextStyle(
          //                     fontFamily: 'Rubik',
          //                     fontWeight: FontWeight.w300,
          //                     color: Colors.black,
          //                     fontStyle: FontStyle.normal,
          //                     fontSize: 14.0,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         Container(
          //           padding: EdgeInsets.only(left: 15, right: 25, top: 1),
          //           child: Row(
          //             children: [
          //               Container(
          //                   child: RatingBar.builder(
          //                 initialRating: rating,
          //                 minRating: 1,
          //                 direction: Axis.horizontal,
          //                 allowHalfRating: true,
          //                 itemCount: 5,
          //                 itemSize: 30,
          //                 ignoreGestures: true,
          //                 updateOnDrag: false,
          //                 glowColor: kYellowColor,
          //                 itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          //                 itemBuilder: (context, _) => Icon(
          //                   Icons.star,
          //                   color: kYellowColor,
          //                 ),
          //                 onRatingUpdate: (rating) {
          //                   print(rating);
          //                 },
          //               )),
          //               Spacer(),
          //               GestureDetector(
          //                 onTap: () {
          //                   viewRatingScreenScreen();
          //                 },
          //                 child: Text(
          //                   'View',
          //                   style: TextStyle(
          //                     fontFamily: 'Rubik',
          //                     fontWeight: FontWeight.w500,
          //                     color: kYellowColor,
          //                     fontStyle: FontStyle.normal,
          //                     fontSize: 14.0,
          //                   ),
          //                 ),
          //               )
          //             ],
          //           ),
          //         ),
          //         SizedBox(
          //           height: 25,
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.only(
          //               left: 100.0, right: 100.0, top: 5, bottom: 55),
          //           child: Container(
          //             height: 50,
          //             width: MediaQuery.of(context).size.width,
          //             decoration: BoxDecoration(
          //                 color: kYellowColor,
          //                 borderRadius: BorderRadius.circular(20.0)),
          //             child: FlatButton(
          //               onPressed: () {
          //                 /*if(subscriptions_status==true)
          //                 {
          //                   nextScreen();
          //                 }
          //                 else{

          //                 }*/

          //                 if (subscriptions_status == true) {
          //                   nextScreen();
          //                 } else {
          //                   SubscribetionScreen();
          //                   /*Navigator.push(
          //                                 context, MaterialPageRoute(builder: (context) => Kyc_screen()));*/
          //                 }
          //               },
          //               child: Text(
          //                 'Pay Now',
          //                 style: TextStyle(
          //                   fontFamily: 'Rubik',
          //                   fontWeight: FontWeight.w500,
          //                   color: Colors.white,
          //                   fontStyle: FontStyle.normal,
          //                   fontSize: 16.0,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          ),
    );
  }

  openMapsSheet(context) async {
    double latitude = double.parse(lat);
    double longtitude = double.parse(long);
    try {
      final coords = Coords(latitude, longtitude);
      final title = shopAddress;
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                          onTap: () => map.showMarker(
                                coords: coords,
                                title: title,
                              ),
                          title: Text(map.mapName),
                          leading: Icon(
                            Icons.map,
                            size: 30,
                          )),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void previousScreen() {
    /*Navigator.push(
        context, MaterialPageRoute(builder: (context) => SingleCategory()));*/
  }
  void nextScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PayMoneyScreen(CategoryPay, "CategoryBack", "")));
  }

  void viewRatingScreenScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReviewAndRating(unique_key)));
  }

  void SubscribetionScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SubscribeScreen("")));
  }
}

class RatingDataList {
  String aggregate = '';
}

/*class SliderImageDataList {
  String gallery_id = '';
  String merchant_id = '';
  String image = '';
}*/
class CategoryDetailsDataList {
  String image_url = '';
  String get_merchat_info = '';
  String shop_id = '';
  String merchant_id = '';
  String shop_name = '';
  String shop_phone = '';
  String address = '';
  String bio = '';
  String merchant_gallerys_one = '';
  String gallery_id = '';
  String image = '';
  String shop_time = '';
  String sunday = '';
  String monday = '';
  String tuesday = '';
  String wednesday = '';
  String thursday = '';
  String friday = '';
  String saturday = '';
}

class SliderImageDataList {
  late String image;
}
