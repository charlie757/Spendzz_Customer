import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendzz/resources/constants.dart';
class Refer_Earn_Screen extends StatefulWidget {
  const Refer_Earn_Screen({Key? key}) : super(key: key);

  @override
  _Refer_Earn_ScreenState createState() => _Refer_Earn_ScreenState();
}

class _Refer_Earn_ScreenState extends State<Refer_Earn_Screen> {
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
              onPressed: () {},
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
                Container(
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
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {

                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Text(
                      "Choose from friends list below!",
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w300,
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
  }
}
