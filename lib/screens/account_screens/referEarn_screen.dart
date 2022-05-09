import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/account_screens/account_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class Refer_Earn_Screen extends StatefulWidget {
  const Refer_Earn_Screen({Key? key}) : super(key: key);

  @override
  _Refer_Earn_ScreenState createState() => _Refer_Earn_ScreenState();
}

class _Refer_Earn_ScreenState extends State<Refer_Earn_Screen> {
  String inviteCode = "";
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callReferralCode(prefs.getString('AUTH_TOKEN').toString());
    }

    setState(() {});
  }

  _callReferralCode(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.REFERRAL_CODE),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        inviteCode = dataAll['data']['referral_code'].toString();
        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  openwhatsapp() async {
    var whatsapp = "+919782485409";
    var whatsappURl_android =
        "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return WillPopScope(
      onWillPop: () async {
        BackScreen();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.white),
            elevation: 0,
            actions: [],
            leading: IconButton(
              icon: Image.asset(
                'assets/images/Icon_back.png',
                height: 20,
                width: 20,
              ),
              onPressed: () {
                BackScreen();
              },
            ),
            title: Text(
              "Refer & Earn",
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 20.0,
              ),
            ),
            automaticallyImplyLeading: true,
            centerTitle: false),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Text(
                    "Refer & Earn",
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w300,
                      color: blackTextColor,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    _launchWhatsapp();
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 25),
                    child: Row(
                      children: [
                        Container(
                          child: Icon(
                            Icons.phone_android_outlined,
                            color: kYellowColor,
                          ),
                        ),
                        Text(
                          "Refer via Whatsapp",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: kYellowColor,
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Your referral Code',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 17.0),
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          width: 190,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color: Color(0xffF1F0F8),
                              borderRadius: BorderRadius.circular(5.0),
                              border:
                                  Border.all(color: Colors.grey, width: 1.0)),
                          alignment: Alignment.center,
                          child: Text(
                            inviteCode,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18.0),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        GestureDetector(
                          onTap: () {
                            //Clipboard.setData(ClipboardData(text: inviteCode));
                            Clipboard.setData(
                                    new ClipboardData(text: inviteCode))
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(inviteCode)));
                            });
                            //only if ->
                            //ScaffoldMessenger.of(context).showSnackBar(snackBar));
                          },
                          child: Text(
                            'Tap to copy',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,
                                color: kYellowColor),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        GestureDetector(
                          onTap: () {
                            Share.share("Your Refer Code " +
                                inviteCode +
                                "\n" +
                                "https://play.google.com/store/apps/details?id=com.spendzz_customer_merchant");
                            // launch("https://play.google.com/store/apps/details?id=com.spendzz_customer_merchant" + "Your Refer Code"+inviteCode);
                          },
                          child: Container(
                            width: 190,
                            height: 46.0,
                            decoration: BoxDecoration(
                                color: kYellowColor,
                                borderRadius: BorderRadius.circular(5.0),
                                border:
                                    Border.all(color: Colors.grey, width: 1.0)),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.share_rounded,
                                    color: Colors.white, size: 18.0),
                                SizedBox(width: 10.0),
                                Text(
                                  'Refer Now',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        /*GestureDetector(
                          child: Text(
                            'Terms & Conditions Apply*',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 13.0, color: Colors.red.shade800
                            ),
                          ),
                        ),*/
                        SizedBox(height: 40.0)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchUrl() async {}
  _launchWhatsapp() async {
    String playstorelink =
        'https://play.google.com/store/apps/details?id=com.spendzz_merchant_business';
    String text =
        'Download spendzz app and earn some cashback on refer customer';
    String url =
        "https://wa.me/?text=${Uri.parse("$playstorelink\n $text\n\nYour Refer Code $inviteCode")}";
    launch("$url");

    // url = "https://wa.me/?text=";
    // if (await canLaunch("https://play.google.com/store/apps/details?id=" + "Your Refer Code"+inviteCode)) {
    //   await launch("https://play.google.com/store/apps/details?id=" + "Your Refer Code"+inviteCode);
    // } else {
    //   throw 'Could not launch "https://play.google.com/store/apps/details?id=" + appPackageName';
    // }
    // try {
    //   launch("https://play.google.com/store/apps/details?id=com.spendzz_customer_merchant" + "Your Refer Code"+inviteCode);
    // } on PlatformException catch(e) {
    //   launch("https://play.google.com/store/apps/details?id=" + "https://play.google.com/store/apps/details?id=com.spendzz_customer_merchant" + "Your Refer Code"+inviteCode);
    // } finally {
    //   launch("https://play.google.com/store/apps/details?id=" + "https://play.google.com/store/apps/details?id=com.spendzz_customer_merchant" + "Your Refer Code"+inviteCode);
    // }
  }

  void BackScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }
}
