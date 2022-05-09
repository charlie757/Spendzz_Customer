import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/trancations_details_screens/pasbook_history_details.dart';

class NotificationScreen extends StatefulWidget {
  static const String route = '/NotificationScreen';
  const NotificationScreen({Key? key}) : super(key: key);
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}
class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationDataList> notificationCategoryData = [];
  var isDataFetched = false;
  var userProfileBaseUrl="";
  var NotificationsBack="FromNotifications";
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callApiForNotificationOnDashboard();
    }
    setState(() {});
  }

  _callApiForNotificationOnDashboard() async {
    var auth_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    }
    EasyLoading.show(status: 'loading...');
    setState(() {
      notificationCategoryData.clear();
    });
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.NOTIFICATIONS),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $auth_token'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        userProfileBaseUrl = dataAll['base_url'];
        isDataFetched = true;

        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlActiveOrder = NotificationDataList();
          mdlActiveOrder.tid = dictResult['tid'].toString();
          mdlActiveOrder.name = dictResult["get_notification_transaction"]["user_prof_info"]['name'].toString();
          if(dictResult["get_notification_transaction"]["user_prof_info"]['profile']!=null)
            {
              mdlActiveOrder.profile = dictResult["get_notification_transaction"]["user_prof_info"]['profile'].toString();
            }

          mdlActiveOrder.type = dictResult["get_notification_transaction"]['type'].toString();
          mdlActiveOrder.pay_status = dictResult["get_notification_transaction"]['pay_status'].toString();
          mdlActiveOrder.amount = double.parse(dictResult["get_notification_transaction"]['amount'].toString()).toString();

          notificationCategoryData.add(mdlActiveOrder);

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
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: notificationCategoryData.length,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, index) {
                  var mdlSubData = notificationCategoryData[index];
                  return Card(
                    elevation: 0,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => PassbookTransactionHistory(mdlSubData.tid,NotificationsBack)));
                      },
                      child: Container(
                        margin: EdgeInsets.all(2.0),

                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                    child: CachedNetworkImage(
                                        height: 50,
                                        width: 50,
                                        imageUrl: userProfileBaseUrl+"/"+mdlSubData.profile.toString(),
                                        placeholder: (context, url) => Transform.scale(
                                          scale: 0.4,
                                          child: CircularProgressIndicator(
                                            color: kYellowColor,
                                            strokeWidth: 3,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                                'assets/images/account_profile.png')),
                                        fit: BoxFit.cover),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 15, right: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        mdlSubData.name,
                                        maxLines: 2,
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
                                      height: 5,
                                    ),

                                    Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          '\u{20B9}${mdlSubData.amount+" "+mdlSubData.type}',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            letterSpacing: 1,
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
                                    mdlSubData.pay_status,
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

                  );
                },
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

}

class NotificationDataList {
  String id = '';
  String tid = '';
  String amount = '';
  String type = '';
  String pay_status = '';
  String name = '';
  String profile = '';
  String base_url="";
}