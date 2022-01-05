import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spendzz/category/all_category.dart';
import 'package:spendzz/category/category_details.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';

class PassbookScreen extends StatefulWidget {
  static const String route = '/PassbookScreen';

  const PassbookScreen({Key? key}) : super(key: key);

  @override
  _PassbookScreenState createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Color(0xffFFF9EC)),
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Color(0xffFFF9EC),
            actions: [],
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
            title: Text(
              "Passbook",
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
          scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xffFFF9EC),

                      ),
                    padding: EdgeInsets.only(left: 15,right: 15,bottom: 15),
                    child: Row(
                      children: [
                        Text(
                          "Current Wallet Balance",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '\u{20B9}${'+3500'}',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 20,),
                  Container(

                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        //shrinkWrap: true,
                        itemCount: 25,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) =>
                            Card(
                              elevation: 0,
                              child: GestureDetector(
                                onTap: (){
                                  nextScreen();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(2.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 1.0, color: Color(0xff787D86)),
                                    ),
                                  ),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 68.00,
                                          height: 68.00,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            color: Color(0xffFFF9EC),
                                            image: DecorationImage(
                                              scale: 2,
                                              image: ExactAssetImage(
                                                  'assets/images/promo_a.png'),
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 25,
                                        ),
                                        Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Receive from Mr Abhay',
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
                                                  child: Text('Today, 1:56 PM',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.black,
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
                                              '\u{20B9}${'+12'}',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,

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
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }

  void nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CategoryDetails()));
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }
}
