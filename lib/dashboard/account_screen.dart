import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendzz/account_screen/profile.dart';
import 'package:spendzz/account_screen/setting_screen.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';

import '../account_screen/history_screen.dart';
import '../account_screen/kyc_screen.dart';
import '../account_screen/manage_card_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: klightYelloColor,
    ));
    return WillPopScope(
      onWillPop: () async => true,
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
                              padding: EdgeInsets.only(left: 25, top: 25),
                              height: 100,
                              width: 100,
                              child: Image.asset(
                                  'assets/images/account_profile.png'),
                            ),
                            Align(
                                alignment: FractionalOffset.bottomRight,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  child: Image.asset('assets/images/star.png'),
                                ))
                          ],
                        )),
                    SizedBox(width: 10,),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Alice Park',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              '+1-98989898989',
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
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'alicepark@spendzz.in',
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
                    )
                  ],
                ),
                Card(
                  elevation: 3,
                  margin: EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    /*decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      ),
                    ),*/
                    child: Container(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                              height: 78.00,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: ExactAssetImage(
                                      'assets/images/splash_logo.png'),
                                  fit: BoxFit.fill,
                                ),
                              )),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 178.00,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: ExactAssetImage(
                                      'assets/images/qr_code.png'),
                                  fit: BoxFit.fitHeight,
                                ),
                              )),
                          SizedBox(height: 10,),
                          Center(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 24,
                                      height: 24.00,
                                      decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                          image: ExactAssetImage(
                                              'assets/images/share.png'),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )),
                                  SizedBox(width: 15,),
                                  Align(
                                    alignment: FractionalOffset.topLeft,
                                    child: Text(
                                      'Share',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: kYellowColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),

                                ],

                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
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
                          GestureDetector(
                            onTap: ()
                            {

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
                          SizedBox(height: 15,),
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
