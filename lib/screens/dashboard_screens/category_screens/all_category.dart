import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/single_category.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:spendzz/resources/constants.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
class AllCategory extends StatefulWidget {
  static const String route = '/AllCategory';

  const AllCategory({Key? key}) : super(key: key);

  @override
  _AllCategoryState createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  //todo Category Fields
  var category_baseUrl = '';
  List<AllCategoryDataList> allCategoryData = [];
  var isDataFetched = false;
  String type='AllCategory';
  ConnectivityResult? _connectivityResult;
  @override
  void initState() {
    super.initState();
    _checkToken();
  }
  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callFeaturedCategory(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {
    });
  }

  /*_checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      bool isConnected = await checkInternet();
      if (isConnected) {
        _callFeaturedCategory(prefs.getString('AUTH_TOKEN').toString());
        setState(() {
          _callFeaturedCategory(prefs.getString('AUTH_TOKEN').toString());
        });
      } else {
        showErrorSnackBar(context, noInternet);
      }
      setState(() {

      });
    }
    setState(() {

    });
  }*/

  _callFeaturedCategory(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(
        dismissOnTap: false
    );
    try {
      var uriResponse = await client.get(
          Uri.parse(
              ApiConfig.app_base_url + ApiConfig.FEATURED_MERCHANT_CATEGORY),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      category_baseUrl = dataAll['icon_url'].toString();
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = AllCategoryDataList();
          mdlSubData.categoryName = dictResult['name'].toString();
          mdlSubData.icon = dictResult['icon'].toString();
          mdlSubData.id = dictResult['id'].toString();
          allCategoryData.add(mdlSubData);
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
      onWillPop: () async {
        if(Platform.isAndroid)
        {

            Navigator.push(context, MaterialPageRoute(builder: (context) =>DashboardMainScreen()));



        }
        else
        {

            Navigator.push(context, MaterialPageRoute(builder: (context) =>DashboardMainScreen()));

        }
        //ShowDialog();
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
            "Merchants",
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
              Navigator.push(context, MaterialPageRoute(builder: (context) =>DashboardMainScreen()));
            },
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                itemCount:allCategoryData.length,
                //  itemCount: 23,
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, index) {
                  var mdlSubData = allCategoryData[index];
                return Card(
                 // color: klightYelloColor,
                  elevation: 0,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SingleCategory(mdlSubData.id,mdlSubData.categoryName,type)));
                    },
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.only(right: 0),
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          margin: EdgeInsets.all(0.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 3,top: 2),
                            child:  Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(2.0),
                                    child: Container(
                                      padding: EdgeInsets.only(top: 2, left: 25,right: 25),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 68.00,
                                            height: 68.00,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(30.0),
                                              //color: Colors.red,
                                              image: DecorationImage(
                                                scale: 2,
                                                image: NetworkImage(
                                                    category_baseUrl + "/" + mdlSubData.icon),
                                                colorFilter: ColorFilter.mode(Colors.white10, BlendMode.color),
                                                fit: BoxFit.scaleDown,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 45,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context).size.width/2,
                                                  alignment: Alignment.topLeft,
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child:Text(
                                                      mdlSubData.categoryName,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        overflow: TextOverflow.ellipsis,
                                                        fontFamily: 'Rubik',
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black,
                                                        fontStyle: FontStyle.normal,
                                                        fontSize: 16.0,
                                                      ),
                                                    ) ,
                                                  )),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(

                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    'Featured Merchants',
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.grey,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ))
                                            ],
                                          )
                                        ],
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
                  ),

                );
                },

              ),
            ),
          ),
        ),
      ),
    );
  }

  void nextScreen() {
    /*Navigator.push(
        context, MaterialPageRoute(builder: (context) => SingleCategory()));*/
  }

  void previousScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }
}

class AllCategoryDataList {
  String categoryName = '';
  String icon = '';
  String amount_limit = '';
  String id = '';
}
