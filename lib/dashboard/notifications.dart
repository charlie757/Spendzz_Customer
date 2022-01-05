import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
class NotificationScreen extends StatefulWidget {
  static const String route = '/NotificationScreen';
  const NotificationScreen({Key? key}) : super(key: key);
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}
class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationDataList> notificationCategoryData = [];
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
          title: Text("Notification",
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
                itemCount: 23,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) =>
                    Card(
                      elevation: 0,
                      child: GestureDetector(
                        onTap: (){
                        },
                        child: Container(
                          margin: EdgeInsets.all(2.0),

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
                                        'Alice Park',
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

                                          alignment: Alignment.topLeft,
                                          child: Text('₹300 sent',
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

                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 15),
                                    child: Text(
                                      'Success',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green,

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

                    ),
              ),
            ),
          ),
        ),
      ),

    );
  }
  void previousScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }
  _callApiForNotificationOnDashboard() async {
    var mapBody = new Map<String, dynamic>();
    mapBody['status'] = 'ACTIVE';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenData = prefs.getString('LOGIN_USER_TOKEN') ?? '';
    setState(() {
      notificationCategoryData.clear();
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
          var mdlActiveOrder = NotificationDataList();
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
}

class NotificationDataList {
  String vendorIds = '';
  String orderNumber = '';
  String customerId = '';
  String payableAmount = '';
  String referralDeduction = '';
}
