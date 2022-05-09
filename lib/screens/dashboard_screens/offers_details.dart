import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/dashboard_screens/rating_review_screens/review_rating_list_screen.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;

class OffersDetails extends StatefulWidget {
  var promo_code_id = '';

  OffersDetails(
    this.promo_code_id,
  );

  @override
  _OffersDetailsState createState() => _OffersDetailsState(promo_code_id);
}

class _OffersDetailsState extends State<OffersDetails> {
  _OffersDetailsState(this.promo_code_id);

  var promo_code_id = '';

  TextEditingController reviewController = TextEditingController();
  late String addRating = '';

  //todo offers Fields
  var offer_baseUrl = '';
  var isDataFetched = false;
  var promocode = '';
  var title = '';
  var description = '';
  var promo_code_expriration_date = '';
  var icon = '';

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callOffersDetails(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {});
  }

  _callOffersDetails(String tokenData) async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['promo_code_id'] = promo_code_id.toString();
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.PROMO_CODE_DETAILS),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        offer_baseUrl = dataAll['icon_url'];
        isDataFetched = true;
        if (dataAll['status'] == true) {
          promocode = arrResults['promocode'];
          title = arrResults['title'];
          description = arrResults['description'];
          promo_code_expriration_date =
              arrResults['promo_code_expriration_date'];
          icon = arrResults['icon'];
          icon = arrResults['icon'];

          setState(() {});
        } else {
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white30,
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "Promo Code Details",
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
            child: Container(
              child: Column(
                children: [
                  Card(
                   shadowColor: Colors.black,
                    margin: new EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                    elevation: 5,
                    child:  Container(
                      width: MediaQuery.of(context).size.width,
                      height:250,
                      child: Column(
                        children: [
                          Align(
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                    image:
                                    NetworkImage(offer_baseUrl + "/" + icon),
                                    fit: BoxFit.fill,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 25,),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                    child: Column(
                      children: [
                        Align(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: Container(

                              margin: EdgeInsets.symmetric(horizontal: 50.0),
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xff5369AE),
                                        Color(0xFFEE4B23),
                                      ]
                                  ),

                              ),
                            child: Container(
                              padding: EdgeInsets.only(left: 25,right: 25),
                              child: Row(
                                children: [
                                  Text (
                                      promocode,
                                      style: new TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          color: Colors.white,
                                      )
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: ()
                                    {
                                      Clipboard.setData(new ClipboardData(text: promocode+" Copied")).then((_){
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(promocode+" Copied")));
                                      });
                                    },child:  Text (
                                      "Copy",
                                      style:  new TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.white,
                                      )
                                  ),
                                  )

                                ],
                              ),
                            ),
                            /*  child: Text("Login",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18.0))*/
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: Container(
                            child: Align(
                              child: Text(
                                description +' Expiry Date is ' + promo_code_expriration_date +".",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
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
            ),
          ),
        ),
      ),
    );
  }



  void nextScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ReviewAndRating('')));
  }
}
