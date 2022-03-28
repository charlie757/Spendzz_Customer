import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/login_signup_screens/signup_details_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'add_review_rating.dart';
import '../category_screens/category_details.dart';
import 'package:http/http.dart' as http;
class ReviewAndRating extends StatefulWidget {
  var unique_key='';
  ReviewAndRating(this.unique_key,);

  @override
  _ReviewAndRatingState createState() => _ReviewAndRatingState(/*unique_key*/);
}

class _ReviewAndRatingState extends State<ReviewAndRating> {
  //_ReviewAndRatingState(this.unique_key);
  var unique_key='';

  List<AllReviewDataList> allReviewDataList = [];
  var isDataFetched = false;
  String name='';
  String review='';
  double rating = 0.0;


  @override
  void initState() {
    super.initState();
    _callApiForAllReviewDataList();
  }
  _callApiForAllReviewDataList() async {
    var auth_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      auth_token = prefs.getString('AUTH_TOKEN') ?? '';

    }
    if (prefs.getString('unique_key') != null) {
      unique_key = prefs.getString('unique_key') ?? '';

    }
    var client = http.Client();
     EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.GET_REVIEW_RATING+unique_key),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $auth_token'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();

      setState(() {
        allReviewDataList.clear();
      });
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = AllReviewDataList();
          mdlSubData.review = dictResult['review'].toString();
          double.parse(mdlSubData.rating = dictResult['rating'].toString());
          mdlSubData.get_user_d_t_l = dictResult['get_user_d_t_l']['name'].toString();
          allReviewDataList.add(mdlSubData);
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
                    itemCount: allReviewDataList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, index) {
                      var mdlSubData = allReviewDataList[index];
                      return Card(
                        color: klightYelloColor,
                        elevation: 0,
                        child:  GestureDetector(
                          onTap: () {
                           // nextScreen();
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
                              padding: EdgeInsets.only(left: 5),
                              child: Row(
                                children: [
                                  Expanded(

                                    child:  Container(
                                      padding: EdgeInsets.only(left: 15,right: 15),
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
                                  ),),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    flex:2,
                                    child: Container(
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
                                              mdlSubData.get_user_d_t_l,
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
                                            width: 120,
                                            alignment: Alignment.topLeft,
                                            child: Text(

                                              mdlSubData.review,
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
                                  ),),
                                  Expanded(
                                      flex:2,
                                      child: GestureDetector(
                                    onTap: () {
                                     // nextScreen();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: Container(
                                          child: RatingBar.builder(
                                            initialRating: double.parse(mdlSubData.rating),
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
                                  ))

                                ],
                              ),
                            ),
                          ),
                        ),

                      );
                    },
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


  void nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddReview(unique_key)));
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CategoryDetails('','','')));
  }

}
class AllReviewDataList {
  String id = '';
  String user_id = '';
  String merchant_id = '';
  String review = '';
  String rating = '';
  String status = '';
  String reason = '';
  String name = '';
  String get_user_d_t_l = '';

}
