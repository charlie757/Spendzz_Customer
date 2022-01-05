import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spendzz/dashboard/account_screen.dart';
import 'package:spendzz/account_screen/payment_card.dart';
import 'package:spendzz/category/all_category.dart';
import 'package:spendzz/category/category_details.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';

import 'input_formatters.dart';
import 'my_strings.dart';

class Kyc_screen extends StatefulWidget {
  static const String route = '/Kyc_screen';

  const Kyc_screen({Key? key}) : super(key: key);

  @override
  _Kyc_screenState createState() => _Kyc_screenState();
}

class _Kyc_screenState extends State<Kyc_screen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  late String phoneNumber;
  String currencyType = 'New';
  String country = 'India';
  String professionName = 'INR';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          key: _scaffoldKey,
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
                  previousScreen();
                },
              ),
              title: Text(
                "KYC",
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
            child: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Profession',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.7),
                                border: Border.all(
                                    color: Colors.white38, width: 2)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                /*value: value='Dog',
                  items: items.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() =>this.value =value as String?),*/
                                value: country,
                                icon: const Icon(Icons.keyboard_arrow_down,color: kYellowColor,),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black26,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    country = newValue!;
                                  });
                                },
                                items: <String>[
                                  'India',
                                  'Iran',
                                  'Afghanistan',
                                  'Bangladesh',
                                  'Canada',
                                  'Denmark',
                                  'Egypt',
                                  'France',
                                  'Germany',
                                  'Hungary',
                                  'Italy',
                                  'Mexico',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Divider(
                              color: Colors.black38,
                              thickness: 1,
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Salary',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.7),
                                border: Border.all(
                                    color: Colors.white38, width: 2)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                /*value: value='Dog',
                  items: items.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() =>this.value =value as String?),*/
                                value: country,
                                icon: const Icon(Icons.keyboard_arrow_down,color: kYellowColor,),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black26,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    country = newValue!;
                                  });
                                },
                                items: <String>[
                                  'India',
                                  'Afghanistan',
                                  'Bangladesh',
                                  'Canada',
                                  'Denmark',
                                  'Egypt',
                                  'France',
                                  'Germany',
                                  'Hungary',
                                  'Italy',
                                  'Mexico',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Divider(
                              color: Colors.black38,
                              thickness: 1,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5,right: 5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Aadhaar Number',
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
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(12),
                                    ],
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Aadhaar Number',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Color(0xff787D86)),
                                      ),
                                    ),
                                    /*validator: (String? value) {

                            phoneNumber=value!;
                            if (value.isEmpty) {
                              return 'Please enter phone number';
                            } else if (value.length < 10) {
                              return 'Please enter valid 10 digit phone number';
                            }
                          },*/
                                    validator: (String? value) {
                                      phoneNumber=value!;
                                      String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                      RegExp regExp = new RegExp(patttern);
                                      if (value.isEmpty) {
                                        return 'Please enter mobile number';
                                      } else if (!regExp.hasMatch(value)) {
                                        return 'Please enter valid mobile number';
                                      }
                                    }),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(child: Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Upload Aadhaar Front",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black38,
                                          ),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 61,
                                                  width: 133,
                                                  child: Image.asset('assets/images/Icon_back.png'),
                                                ),
                                              ],
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                                Spacer(),
                                Expanded(child: Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Upload Aadhaar Front",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black38,
                                          ),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 61,
                                                  width: 133,
                                                  child: Image.asset('assets/images/Icon_back.png'),
                                                ),
                                              ],
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Upload Aadhaar Front",
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black38,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            height:133,
                                            width: 133,
                                            child: Image.asset('assets/images/Icon_back.png'),
                                          ),
                                        ],
                                      )
                                  ),
                                )
                              ],
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
              child:  Container(
                width: MediaQuery.of(context).size.width -100,
                padding: const EdgeInsets.only(
                  left: 50.0, right: 50.0,),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 0.0, bottom: 0),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width -200,
                      decoration: BoxDecoration(
                          color: kYellowColor,
                          // borderRadius: BorderRadius.horizontal()),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: FlatButton(
                        onPressed: (){

                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )

          ),
        ));
  }

  void nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CategoryDetails()));
  }
  void previousScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AccountScreen()));
  }
}
