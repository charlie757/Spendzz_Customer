import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'all_category.dart';
import 'category_details.dart';

class SingleCategory extends StatefulWidget {
  static const String route = '/SingleCategory';
  var id = '';
  var categoryName = '';
  var type = '';

  SingleCategory(this.id, this.categoryName, this.type);

  @override
  _SingleCategoryState createState() =>
      _SingleCategoryState(id, categoryName, type);
}

class _SingleCategoryState extends State<SingleCategory> {
  _SingleCategoryState(
    this.id,
    this.categoryName,
    this.type,
  );

  var id = '';
  var categoryName = '';
  var type = '';
  List<SingleCategoryDataList> singleCategoryData = [];
  var isDataFetched = false;
  var singleCategory_baseUrl = '';
  var singleCategory_imageUrl = '';
  bool is_login_status = false;
  /* late bool Status;*/

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _singleCategoryList(prefs.getString('AUTH_TOKEN').toString());
      is_login_status = true;
    }
    setState(() {});
  }

  _singleCategoryList(String tokenData) async {
    var mapBody = new Map<String, dynamic>();
    mapBody['category_id'] = id;
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $tokenData',
      };
      var uriResponse = await client.post(
          Uri.parse(
              ApiConfig.app_base_url + ApiConfig.SINGLE_MERCHANT_CATEGORY_LIST),
          headers: headers,
          body: mapBody);
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();

      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var status = dataAll['status'];
        setState(() {});
        if (status == true) {
          singleCategory_baseUrl = dataAll['image_url'].toString();
          var arrResults = dataAll['data'];
          isDataFetched = true;
          for (var i = 0; i < arrResults.length; i++) {
            var dictResult = arrResults[i];
            var mdlSubData = SingleCategoryDataList();
            mdlSubData.shop_name =
                dictResult['get_merchat_info']['shop_name'].toString();
            mdlSubData.shop_id =
                dictResult['get_merchat_info']['shop_id'].toString();
            mdlSubData.merchant_id =
                dictResult['get_merchat_info']['merchant_id'].toString();
            mdlSubData.address =
                dictResult['get_merchat_info']['address'].toString();

            if (dictResult['merchant_gallerys_one'] != null) {
              mdlSubData.image =
                  dictResult['merchant_gallerys_one']['image'].toString();
            }

            singleCategoryData.add(mdlSubData);

            setState(() {});
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          if (type == 'AllCategory') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllCategory()));
          }
          if (type == 'dashboard') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardMainScreen()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllCategory()));
          }
        } else {
          if (type == 'AllCategory') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllCategory()));
          }
          if (type == 'dashboard') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardMainScreen()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AllCategory()));
          }
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
              categoryName,
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
                if (type == 'AllCategory') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AllCategory()));
                }
                if (type == 'dashboard') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardMainScreen()));
                }
              },
            ),
          ),
          body: ListView.builder(
              itemCount: singleCategoryData.length,
              itemBuilder: (context, index) {
                var mdlSubData = singleCategoryData[index];
                return Card(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryDetails(
                                  mdlSubData.shop_id,
                                  mdlSubData.merchant_id,
                                  mdlSubData.shop_name)));
                    },
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: CachedNetworkImage(
                            height: 75,
                            width: 75,
                            imageUrl: singleCategory_baseUrl +
                                "/" +
                                mdlSubData.image.toString(),
                            placeholder: (context, url) => Transform.scale(
                                  scale: 0.4,
                                  child: CircularProgressIndicator(
                                    color: kYellowColor,
                                    //strokeWidth: 3,
                                  ),
                                ),
                            errorWidget: (context, url, error) => Container(
                                height: 75,
                                width: 75,
                                child: Image.asset(
                                    'assets/images/account_profile.png')),
                            fit: BoxFit.cover),
                      ),
                      title: Text(
                        mdlSubData.shop_name,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Text(
                        mdlSubData.address,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                        maxLines: 4,
                      ),
                    ),
                  ),
                );
              })

          // SingleChildScrollView(
          //   scrollDirection: Axis.vertical,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: singleCategoryData.length,
          //     physics: NeverScrollableScrollPhysics(),
          //     scrollDirection: Axis.vertical,
          //     itemBuilder: (ctx, index) {
          //       var mdlSubData = singleCategoryData[index];
          //       return Card(
          //         // color: klightYelloColor,
          //         elevation: 0,
          //         child: GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => CategoryDetails(
          //                         mdlSubData.shop_id,
          //                         mdlSubData.merchant_id,
          //                         mdlSubData.shop_name)));
          //           },
          //           child: Container(
          //             padding: EdgeInsets.only(right: 0),
          //             child: Card(
          //               color: Colors.white,
          //               elevation: 3,
          //               margin: EdgeInsets.all(0.0),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(0.0),
          //               ),
          //               child: Container(
          //                 margin: EdgeInsets.only(bottom: 3, top: 2),
          //                 child: Container(
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         margin: EdgeInsets.all(2.0),
          //                         child: Container(
          //                           padding: EdgeInsets.only(
          //                               top: 2, left: 15, right: 25),
          //                           child: Row(
          //                             children: [
          //                               Container(
          //                                 padding: EdgeInsets.only(
          //                                     left: 2, top: 2, bottom: 3),
          //                                 child: ClipRRect(
          //                                   borderRadius: BorderRadius.all(
          //                                       Radius.circular(8.0)),
          //                                   child: CachedNetworkImage(
          //                                       height: 75,
          //                                       width: 75,
          //                                       imageUrl:
          //                                           singleCategory_baseUrl +
          //                                               "/" +
          //                                               mdlSubData.image
          //                                                   .toString(),
          //                                       placeholder: (context, url) =>
          //                                           Transform.scale(
          //                                             scale: 0.4,
          //                                             child:
          //                                                 CircularProgressIndicator(
          //                                               color: kYellowColor,
          //                                               //strokeWidth: 3,
          //                                             ),
          //                                           ),
          //                                       errorWidget: (context, url,
          //                                               error) =>
          //                                           Container(
          //                                               height: 75,
          //                                               width: 75,
          //                                               child: Image.asset(
          //                                                   'assets/images/account_profile.png')),
          //                                       fit: BoxFit.cover),
          //                                 ),
          //                               ),
          //                               SizedBox(
          //                                 width: 25,
          //                               ),
          //                               Column(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.start,
          //                                 crossAxisAlignment:
          //                                     CrossAxisAlignment.start,
          //                                 mainAxisSize: MainAxisSize.max,
          //                                 children: [
          //                                   Container(
          //                                       alignment: Alignment.topLeft,
          //                                       child: Align(
          //                                         alignment:
          //                                             Alignment.centerLeft,
          //                                         child: Text(
          //                                           mdlSubData.shop_name,
          //                                           style: TextStyle(
          //                                             fontFamily: 'Rubik',
          //                                             fontWeight:
          //                                                 FontWeight.w500,
          //                                             color: Colors.black,
          //                                             fontStyle:
          //                                                 FontStyle.normal,
          //                                             fontSize: 16.0,
          //                                           ),
          //                                         ),
          //                                       )),
          //                                   SizedBox(
          //                                     height: 5,
          //                                   ),
          //                                   Container(
          //                                       width: MediaQuery.of(context)
          //                                               .size
          //                                               .width *
          //                                           0.6,
          //                                       height: 55,
          //                                       child: Text(
          //                                         mdlSubData.address,
          //                                         style: TextStyle(
          //                                           fontFamily: 'Rubik',
          //                                           fontWeight: FontWeight.w300,
          //                                           color: Colors.grey,
          //                                           fontStyle: FontStyle.normal,
          //                                           fontSize: 16.0,
          //                                         ),
          //                                         maxLines: 4,
          //                                       ))
          //                                 ],
          //                               )
          //                             ],
          //                           ),
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          ),
    );
  }

  void nextScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CategoryDetails('', "", '')));
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AllCategory()));
  }
}

class SingleCategoryDataList {
  String id = '';
  String category = '';
  String get_merchat_info = '';
  String shop_id = '';
  String merchant_id = '';
  String shop_name = '';
  String shop_phone = '';
  String address = '';
  String bio = '';
  String merchant_gallerys_one = '';
  String image = '';
}
