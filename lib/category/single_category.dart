import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;

import 'all_category.dart';
import 'category_details.dart';
class SingleCategory extends StatefulWidget {
  static const String route = '/SingleCategory';
  const SingleCategory({Key? key}) : super(key: key);

  @override
  _SingleCategoryState createState() => _SingleCategoryState();
}

class _SingleCategoryState extends State<SingleCategory> {
  List<SingleCategoryDataList> singleCategoryData = [];
  var isDataFetched = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,));
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text("Category One",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontStyle: FontStyle.normal,
              fontSize: 20.0,
            ),),
          leading: IconButton(
            icon: Image.asset('assets/images/Icon_back.png',height: 20,width: 20,),
            onPressed: () {
              previousScreen();
            },
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              height: 250,
              child: ListView.builder(
                //shrinkWrap: true,
                itemCount: 25,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) =>
                    Card(
                      elevation: 0,
                      child: Ink(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),

                        ), // LinearGradientBoxDecoration
                        child: InkWell(
                          onTap: () {
                            nextScreen();
                          },

                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                          splashColor: kYellowColor,
                          child: Container(
                            margin: EdgeInsets.all(2.0),
                            /*decoration: BoxDecoration(
                              color: Color(0xffFFFCF6),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                                topLeft: Radius.circular(30.0),
                              ),
                            ),*/
                            child: Container(
                              padding: EdgeInsets.only(left: 25),
                              child: Row(
                                children: [
                                  Container(
                                    width: 68.00,
                                    height: 68.00,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
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
                                        top: 15, right: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Category A',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,

                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        Container(
                                            padding: EdgeInsets.only(right: 25),
                                            alignment: Alignment.topLeft,
                                            child: Text('Tagline',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                                letterSpacing: 2,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14.0,
                                              ),
                                            )
                                        )

                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: ()
                                    {
                                      nextScreen();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(right: 15),
                                      child: Text(
                                        'View',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                          color: kYellowColor,

                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ),
                        ),
                        // Red will correctly spread over gradient
                      ),

                    ),
              ),
            ),
          ),
        ),
      ),

    );
  }

  _callApiForSingleCategoryList() async {
    var mapBody = new Map<String, dynamic>();
    mapBody['status'] = 'ACTIVE';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getString('LOGIN_USER_TOKEN') ?? '';
    setState(() {
      singleCategoryData.clear();
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
          var mdlActiveOrder = SingleCategoryDataList();
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
  void nextScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetails()));
  }
  void previousScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AllCategory()));
  }
}
class SingleCategoryDataList {
  String vendorIds = '';
  String orderNumber = '';
  String customerId = '';
  String payableAmount = '';
  String referralDeduction = '';
}