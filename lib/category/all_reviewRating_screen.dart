import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/intro_screen/more_details_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'add_review.dart';
import 'category_details.dart';
import 'package:http/http.dart' as http;
class ReviewAndRating extends StatefulWidget {
  const ReviewAndRating({Key? key}) : super(key: key);

  @override
  _ReviewAndRatingState createState() => _ReviewAndRatingState();
}

class _ReviewAndRatingState extends State<ReviewAndRating> {
  List<AllReviewDataList> allReviewDataList = [];
  var isDataFetched = false;
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
            height: MediaQuery.of(context).size.height - 200,
            child: Container(
              child: Column(
                children: [
                  ListView.builder(
                    //shrinkWrap: true,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 8,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) => Card(
                      elevation: 0,
                      child: GestureDetector(
                        onTap: () {
                          nextScreen();
                        },
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
                            padding: EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                Container(
                                  width: 48.00,
                                  height: 48.00,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.red,
                                    image: DecorationImage(
                                      scale: 2,
                                      image: ExactAssetImage(
                                          'assets/images/makepayment.png'),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: 15,
                                    right: 15,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Paul',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              letterSpacing: 2,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Good Service',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 14.0,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    nextScreen();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Container(
                                        child: RatingBar.builder(
                                      initialRating: 3,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: kYellowColor,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    )),
                                  ),
                                )
                              ],
                            ),
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
                      'Add Review',
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
  _callApiForAllReviewDataList() async {
    var mapBody = new Map<String, dynamic>();
    mapBody['status'] = 'ACTIVE';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getString('LOGIN_USER_TOKEN') ?? '';
    setState(() {
      allReviewDataList.clear();
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
          var mdlActiveOrder = AllReviewDataList();
          mdlActiveOrder.vendorIds = dictResult['_id'].toString();
          mdlActiveOrder.orderNumber = dictResult['orderNumber'].toString();
          mdlActiveOrder.customerId = dictResult['customerId'].toString();
          mdlActiveOrder.payableAmount = dictResult['payableAmount'].toString();
          mdlActiveOrder.referralDeduction = dictResult['referralDeduction'].toString();
        }

        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  void nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddReview()));
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CategoryDetails()));
  }

}
class AllReviewDataList {
  String vendorIds = '';
  String orderNumber = '';
  String customerId = '';
  String payableAmount = '';
  String referralDeduction = '';
}
