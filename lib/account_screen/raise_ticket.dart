import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
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

class Raise_Ticket extends StatefulWidget {
  static const String route = '/Raise_Ticket';

  const Raise_Ticket({Key? key}) : super(key: key);

  @override
  _Raise_TicketState createState() => _Raise_TicketState();
}

class _Raise_TicketState extends State<Raise_Ticket> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  late String phoneNumber;
  final List<String> list = ['Developer', 'Designer', 'Consultant', 'Student'];
  final jobRoleFormCtrl = TextEditingController();

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
                "Raise Ticket",
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
                          Container(
                            padding: EdgeInsets.only(left: 0,right: 5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Transaction ID',
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
                                      hintText: '444654161',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Color(0xff787D86)),
                                      ),
                                    ),
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
                            height: 10,
                          ),


                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Issue',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: CustomDropdown(
                        hintText: 'Issue',
                        items: list,
                        controller: jobRoleFormCtrl,
                        excludeSelected: false,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                     child: Divider(
                       color: Colors.black,
                     ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 0,right: 5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Message',
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
                                      hintText: '444654161',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Color(0xff787D86)),
                                      ),
                                    ),
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
                            height: 10,
                          ),


                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 0,right: 5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Upload Image',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Expanded(child: Container(
                                        child: TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(4),
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
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText: 'ABC.jpge',
                                          ),
                                        ),
                                      ),),
                                      Expanded(child: Container(
                                        padding: EdgeInsets.only(right: 25, top: 5),
                                        child: Align(
                                          alignment: FractionalOffset.bottomRight,
                                          child: Icon(Icons.drive_folder_upload,
                                          color: kYellowColor,)
                                        ),
                                      ),)

                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 0.7,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                width: MediaQuery.of(context).size.width - 100,
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
                          'Submit Ticket',
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
