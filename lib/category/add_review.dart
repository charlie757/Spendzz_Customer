import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/category/all_reviewRating_screen.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
class AddReview extends StatefulWidget {
  const AddReview({Key? key}) : super(key: key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  TextEditingController reviewController = TextEditingController();
  late String rating;
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
            "Review & Rating",
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
          child: Container(
            padding: EdgeInsets.only(left: 25, right: 25, top: 10),
            height: MediaQuery.of(context).size.height - 200,
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15,),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'Review',
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
                      ],
                    ),
                  ),
                  SizedBox(height: 25,),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 25, top: 0),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'Review',
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
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                          autocorrect: true,
                          controller: reviewController,
                          decoration: InputDecoration(
                            hintText: 'Good Service',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff787D86)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: const EdgeInsets.only(
                  left: 50.0, right: 50.0, bottom: 20),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 0.0, bottom: 0),
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                    onPressed: () {
                      nextScreen();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: kYellowColor,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  _callAddReviewDataListings() async {
    var mapBody = new Map<String, dynamic>();
    mapBody['review'] = reviewController;
    mapBody['rating'] = rating;

    var client = http.Client();
    EasyLoading.show();
    try {
      var uriResponse = await client.post(Uri.parse(ApiConfig.app_base_url + ApiConfig.SIGNUP_WITH_MOBILE), body: mapBody);
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var dictData = dataAll['data'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('VENDOR_ID', dictData['_id'].toString());
        prefs.setString('STORE_NAME', dictData['storeName'].toString());
        prefs.setString('STORE_TYPE', dictData['storeType'].toString());
        prefs.setString('STORE_EMAIL', dictData['email'].toString());
        prefs.setString('STORE_PHONE', dictData['phone'].toString());
        prefs.setString('STORE_CODE', dictData['code'].toString());
        prefs.setString('LOGIN_USER_TOKEN', dictData['token'].toString());
        prefs.setBool('IS_LOGIN_DATA_STATUS', true);
        //Navigator.of(context).pushNamed(DashboardViewController.route);
      }
    } finally {
      client.close();
    }
  }

  void nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }
  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ReviewAndRating()));
  }
}


