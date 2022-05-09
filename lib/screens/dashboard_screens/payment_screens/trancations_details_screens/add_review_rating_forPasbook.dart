import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/trancations_details_screens/passbook_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/trancations_details_screens/pasbook_history_details.dart';
import 'package:spendzz/screens/dashboard_screens/rating_review_screens/review_rating_list_screen.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
class Add_Review_For_Pasbook extends StatefulWidget {
  var unique_key='';
  Add_Review_For_Pasbook(this.unique_key,);

  @override
  _Add_Review_For_PasbookState createState() => _Add_Review_For_PasbookState(unique_key);
}

class _Add_Review_For_PasbookState extends State<Add_Review_For_Pasbook> {
  _Add_Review_For_PasbookState(this.unique_key);
  var unique_key='';

  TextEditingController reviewController = TextEditingController();
  late String addRating='';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PassbookScreen()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PassbookScreen()));
        }
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PassbookScreen()));
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
                            'Rating',
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
                              initialRating: 0,
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
                                addRating=rating.toString();
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

                      if(addRating=='')
                        {
                          EasyLoading.showToast('Please Add Rating');
                          return;
                        }
                      else if (reviewController.text.isEmpty) {
                        EasyLoading.showToast('Enter Add Review');
                        return;
                      }
                      else
                        {
                          _callAdd_Review_For_PasbookDataListings();
                        }

                      /*if(rating.isEmpty)
                        {
                          EasyLoading.showToast('Please Add Rating');
                          return;
                        }

                      else{
                        _callAdd_Review_For_PasbookDataListings();
                      }*/
                      //nextScreen();
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
  _callAdd_Review_For_PasbookDataListings() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['reviews'] = reviewController.text;
    mapBody['ratings'] = addRating;
    mapBody['merchant_id'] = unique_key;
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(Uri.parse(ApiConfig.app_base_url + ApiConfig.POST_REVIEW_RATING), headers: headers, body: mapBody,);
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if(dataAll['status']==true)
          {
            Fluttertoast.showToast(
                msg: dataAll['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.green,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            nextScreen();
          }
        else{
          EasyLoading.dismiss();
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }



        }
      else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: dataAll['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
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
        context, MaterialPageRoute(builder: (context) => ReviewAndRating('')));
  }
}


