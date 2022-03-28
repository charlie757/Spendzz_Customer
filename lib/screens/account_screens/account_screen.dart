import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/screens/account_screens/profile_screens/profile.dart';
import 'package:spendzz/screens/account_screens/referEarn_screen.dart';
import 'package:spendzz/screens/account_screens/setting_screens/setting_screen.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/account_screens/subscribtion_screens/SubscribeScreen.dart';
import 'package:spendzz/screens/account_screens/subscribtion_screens/SubscribeScreenDetails.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'help_screens/normal_ticket/normal_help_screen.dart';
import 'history_screen.dart';
import 'kyc_screen.dart';
import 'manage_cards_screens/manage_card_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();


}

class _AccountScreenState extends State<AccountScreen> {

  late String name='' ;
  late String email='' ;
  late String mobile='' ;
  var imgValueUser = '';
  bool is_login_status = false;
  var kyc_status = 0;
  late String statusText='' ;
  late String massageText = '';
  bool subscriptions_status=false;
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      is_login_status = true;
      _callGetProfile(prefs.getString('AUTH_TOKEN').toString());
      _callGetKysStatus(prefs.getString('AUTH_TOKEN').toString());
      _callCheckSubscriptionStatus(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {
    });
  }
  _callGetProfile(String tokenData) async {
    var client = http.Client();
     EasyLoading.show(status: 'loading...');
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
        name = dataAll['data']['name'].toString();
        email = dataAll['data']['email'].toString();
        mobile = dataAll['data']['mobile'].toString();
        imgValueUser=dataAll['file_path'].toString()+ "/" +dataAll['data']['profile'].toString();
        setState(() {
        });
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

        setState(() {
        });
      }
    } finally {
      client.close();
    }
  }
  _callGetKysStatus(String tokenData) async {
    var client = http.Client();
     EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.GET_KYC_STATUS),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        kyc_status = dataAll['kyc_is_submitted'];
        massageText = dataAll['message'];
        if (kyc_status == 0) {
          statusText = "Reject";
        } else {
          statusText = 'Approved';
        }
        setState(() {});
      }
    } finally {
      client.close();
    }
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: klightYelloColor,
    ));
    return WillPopScope(
      onWillPop: () async
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>DashboardMainScreen()));
        return true;
      },
      child: Scaffold(
        backgroundColor: klightYelloColor,
        appBar: AppBar(
          systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Color(0xffFFF9EC)),
          elevation: 0,
          foregroundColor: klightYelloColor,
          backgroundColor: klightYelloColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        height: 110,
                        width: 110,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 25,top: 25),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                child: CachedNetworkImage(
                                    height: 75,
                                    width: 75,
                                    imageUrl: imgValueUser.toString(),
                                    placeholder: (context, url) =>Transform.scale(
                                      scale: 0.4,
                                      child: CircularProgressIndicator(
                                        color: kYellowColor,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                        height: 75,
                                        width: 75,
                                        child: Image.asset('assets/images/account_profile.png')
                                    ),
                                    fit: BoxFit.cover
                                ),
                              ),
                            ),

                            Align(
                                alignment: FractionalOffset.bottomRight,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  child: Image.asset('assets/images/star_icon.png'),
                                ))
                          ],
                        )),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: ()
                      {

                      },child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width/2,
                              alignment: FractionalOffset.topLeft,

                              child: Text('$name',
                                maxLines: 1,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),)
                          ),
                          Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text('$mobile',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),)
                          ),
                          Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text('$email',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),)
                          ),
                        ],
                      ),
                    ),
                    ),

                  ],
                ),
                SizedBox(height: 15,),
                Card(
                  elevation: 3,
                  margin: EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 15,right: 15,bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          if(subscriptions_status==true)...[
                            GestureDetector(
                              onTap: ()
                              {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => SubscribeScreenDetails()));
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48.00,
                                      height: 48.00,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: Colors.red,
                                        image: DecorationImage(
                                          scale: 2.5,
                                          image: ExactAssetImage(
                                              'assets/images/sub.png'),
                                          fit: BoxFit.scaleDown,

                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    Text(
                                      'Subscriptions',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 38.00,
                                      height: 38.00,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: klightYelloColor,
                                        image: DecorationImage(
                                          scale: 2,
                                          image: ExactAssetImage(
                                              'assets/images/dropdown.png'),
                                          fit: BoxFit.scaleDown,

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]
                          else ...[
                            GestureDetector(
                              onTap: ()
                              {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => SubscribeScreen()));
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48.00,
                                      height: 48.00,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: Colors.red,
                                        image: DecorationImage(
                                          scale: 2.5,
                                          image: ExactAssetImage(
                                              'assets/images/sub.png'),
                                          fit: BoxFit.scaleDown,

                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    Text(
                                      'Subscriptions',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 38.00,
                                      height: 38.00,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                        color: klightYelloColor,
                                        image: DecorationImage(
                                          scale: 2,
                                          image: ExactAssetImage(
                                              'assets/images/dropdown.png'),
                                          fit: BoxFit.scaleDown,

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          SizedBox(height: 15,),
                          if (kyc_status == 0)
                            ...[
                              GestureDetector(
                                onTap: ()
                                {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => Kyc_screen()));
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48.00,
                                        height: 48.00,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          color: Colors.red,
                                          image: DecorationImage(
                                            scale: 2.5,
                                            image: ExactAssetImage(
                                                'assets/images/sub.png'),
                                            fit: BoxFit.scaleDown,

                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (context) => Kyc_screen()));
                                        },
                                        child: Align(
                                          child: Text(
                                            'KYC',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Align(
                                            child: Text(
                                              statusText,
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            width: 38.00,
                                            height: 38.00,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              color: klightYelloColor,
                                              image: DecorationImage(
                                                scale: 2,
                                                image: ExactAssetImage(
                                                    'assets/images/dropdown.png'),
                                                fit: BoxFit.scaleDown,

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ]
                          else ...[
                            if (massageText == 'Your KYC has been Accepted') ...[
                              GestureDetector(
                                onTap: ()
                                {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => Kyc_screen()));
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48.00,
                                        height: 48.00,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          color: Colors.red,
                                          image: DecorationImage(
                                            scale: 2.5,
                                            image: ExactAssetImage(
                                                'assets/images/sub.png'),
                                            fit: BoxFit.scaleDown,

                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (context) => Kyc_screen()));
                                        },
                                        child: Align(
                                          child:GestureDetector(
                                            onTap: ()
                                            {
                                              Navigator.push(
                                                  context, MaterialPageRoute(builder: (context) => Kyc_screen()));
                                            },child:  Text(
                                            'KYC',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          )
                                        ),
                                      ),

                                      Spacer(),
                                      Row(
                                        children: [
                                          Align(
                                            child: Text(
                                              statusText,
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.green,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            width: 38.00,
                                            height: 38.00,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              color: klightYelloColor,
                                              image: DecorationImage(
                                                scale: 2,
                                                image: ExactAssetImage(
                                                    'assets/images/dropdown.png'),
                                                fit: BoxFit.scaleDown,

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (massageText == 'KYC is under Process') ...[
                              GestureDetector(
                                onTap: ()
                                {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => Kyc_screen()));
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48.00,
                                        height: 48.00,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          color: Colors.red,
                                          image: DecorationImage(
                                            scale: 2.5,
                                            image: ExactAssetImage(
                                                'assets/images/sub.png'),
                                            fit: BoxFit.scaleDown,

                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      GestureDetector(
                                        onTap: () {

                                        },
                                        child: Align(
                                          child: Text(
                                            'KYC',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),

                                      Spacer(),
                                      Row(
                                        children: [
                                          Align(
                                            child: Text(
                                              'Pending',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.orange,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            width: 38.00,
                                            height: 38.00,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              color: klightYelloColor,
                                              image: DecorationImage(
                                                scale: 2,
                                                image: ExactAssetImage(
                                                    'assets/images/dropdown.png'),
                                                fit: BoxFit.scaleDown,

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (massageText == 'KYC is rejected') ...[
                              GestureDetector(
                                onTap: ()
                                {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => Kyc_screen()));
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48.00,
                                        height: 48.00,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15.0),
                                          color: Colors.red,
                                          image: DecorationImage(
                                            scale: 2.5,
                                            image: ExactAssetImage(
                                                'assets/images/sub.png'),
                                            fit: BoxFit.scaleDown,

                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15,),
                                      GestureDetector(
                                        onTap: () {

                                        },
                                        child: Align(
                                          child: Text(
                                            'KYC',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Align(
                                            child: Text(
                                              statusText,
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          Container(
                                            width: 38.00,
                                            height: 38.00,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              color: klightYelloColor,
                                              image: DecorationImage(
                                                scale: 2,
                                                image: ExactAssetImage(
                                                    'assets/images/dropdown.png'),
                                                fit: BoxFit.scaleDown,

                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ]
                          ],

                          SizedBox(height: 15,),
                          GestureDetector(
                            onTap: ()
                            {
                              nextScreen();
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 48.00,
                                    height: 48.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.red,
                                      image: DecorationImage(
                                        scale: 2.5,
                                        image: ExactAssetImage(
                                            'assets/images/card.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text(
                                    'Profile',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 38.00,
                                    height: 38.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: klightYelloColor,
                                      image: DecorationImage(
                                        scale: 2,
                                        image: ExactAssetImage(
                                            'assets/images/dropdown.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          GestureDetector(
                            onTap: ()
                            {
                              /* Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));*/
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ManageCard() ));
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 48.00,
                                    height: 48.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.red,
                                      image: DecorationImage(
                                        scale: 2.5,
                                        image: ExactAssetImage(
                                            'assets/images/card.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text(
                                    'Manage Cards',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 38.00,
                                    height: 38.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: klightYelloColor,
                                      image: DecorationImage(
                                        scale: 2,
                                        image: ExactAssetImage(
                                            'assets/images/dropdown.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          GestureDetector(
                            onTap: ()
                            {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => SettingScreen()));
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 48.00,
                                    height: 48.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.red,
                                      image: DecorationImage(
                                        scale: 2.5,
                                        image: ExactAssetImage(
                                            'assets/images/setting.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text(
                                    'Setting',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 38.00,
                                    height: 38.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: klightYelloColor,
                                      image: DecorationImage(
                                        scale: 2,
                                        image: ExactAssetImage(
                                            'assets/images/dropdown.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          GestureDetector(
                            onTap: ()
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 48.00,
                                    height: 48.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.red,
                                      image: DecorationImage(
                                        scale: 2.5,
                                        image: ExactAssetImage(
                                            'assets/images/history.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text(
                                    'History',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 38.00,
                                    height: 38.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: klightYelloColor,
                                      image: DecorationImage(
                                        scale: 2,
                                        image: ExactAssetImage(
                                            'assets/images/dropdown.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          GestureDetector(
                            onTap: ()
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Refer_Earn_Screen()));

                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 48.00,
                                    height: 48.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.red,
                                      image: DecorationImage(
                                        scale: 2,
                                        image: ExactAssetImage(
                                            'assets/images/earn.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text(
                                    'Refer & Earn',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 38.00,
                                    height: 38.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: klightYelloColor,
                                      image: DecorationImage(
                                        scale: 2,
                                        image: ExactAssetImage(
                                            'assets/images/dropdown.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          GestureDetector(
                            onTap: ()
                             {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => NormalHelpScreen('')));


                             },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    width: 48.00,
                                    height: 48.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Colors.red,
                                      image: DecorationImage(
                                        scale: 2,
                                        image: ExactAssetImage(
                                            'assets/images/help.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text(
                                    'Help',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 38.00,
                                    height: 38.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: klightYelloColor,
                                      image: DecorationImage(
                                        scale: 2,
                                        image: ExactAssetImage(
                                            'assets/images/dropdown.png'),
                                        fit: BoxFit.scaleDown,

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
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

  void nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Profile()));
  }
  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }


}
