import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/account_screens/account_screen.dart';
import 'package:spendzz/screens/account_screens/help_screens/formal_ticket/formal_raise_ticket_screen.dart';
import 'package:spendzz/screens/account_screens/help_screens/normal_ticket/raise_normal_ticket.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:http/http.dart' as http;
import 'help_ticket_details.dart';
class NormalHelpScreen extends StatefulWidget {
  var transaction_id = '';

  NormalHelpScreen(this.transaction_id);

  @override
  _NormalHelpScreenState createState() => _NormalHelpScreenState();
}

class _NormalHelpScreenState extends State<NormalHelpScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var isDataFetched = false;

  //todo active normal_ticket
  List<ActiveTicketDataList> activeTicketDataList = [];
  List<CloseTicketDataList> closeTicketDataList = [];
  late String helpStatus = '';
  late String message = '';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    _callActiveTicket();
    _callCloseTicket();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('accountHelp') != null) {
      helpStatus = prefs.getString('accountHelp')!;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  _callActiveTicket() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['type'] = '0';
    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.ALL_TICKETS_LIST),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = ActiveTicketDataList();
          if (dictResult['u_type'].toString() == 'transaction') {
            var arrResult2 = dictResult['get_user_admin_chat'];
            isDataFetched = true;
            for (var j = 0; j < arrResult2.length; j++) {
              var dictResult1 = arrResult2[j];
              var mdlSubData = ActiveTicketDataList();
              mdlSubData.tid = dictResult1['ticket_id'].toString();
              mdlSubData.message = dictResult1['message'].toString();
              message=dictResult1['message'].toString();
            }

            mdlSubData.transaction_id = dictResult['transaction_id'].toString();
            mdlSubData.issue_type = dictResult['issue_type'].toString();
            mdlSubData.tid = dictResult['tid'].toString();

            activeTicketDataList.add(mdlSubData);
          }
          if (dictResult['u_type'].toString() == 'formal') {
            var arrResult2 = dictResult['get_user_admin_chat'];
            mdlSubData.message = arrResult2[0]['message'].toString();
            message=arrResult2[0]['message'].toString();
            isDataFetched = true;
            /* for(var j=0;j<arrResult2.length; j++)
            {
              var dictResult1 = arrResult2[j];
              var mdlSubData = ActiveTicketDataList();
              mdlSubData.tid = dictResult1['ticket_id'].toString();
              mdlSubData.message = dictResult1['message'].toString();
            }*/
            mdlSubData.transaction_id = dictResult['transaction_id'].toString();
            mdlSubData.issue_type = dictResult['issue_type'].toString();
            mdlSubData.tid = dictResult['tid'].toString();
            activeTicketDataList.add(mdlSubData);
          }
        }

        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  _callCloseTicket() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['type'] = '0';
    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.ALL_TICKETS_LIST),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = CloseTicketDataList();
          mdlSubData.message = dictResult['message'].toString();
          mdlSubData.transaction_id = dictResult['transaction_id'].toString();
          mdlSubData.issue_type = dictResult['issue_type'].toString();
          mdlSubData.issue_type = dictResult['tid'].toString();

          closeTicketDataList.add(mdlSubData);
        }

        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AccountScreen()));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 70,
              elevation: 0,
              backgroundColor: Colors.white,
              actions: [
                Container(
                  child: Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/images/Icon_back.png',
                          height: 20,
                          width: 20,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AccountScreen()));
                        },
                      ),
                      Text(
                        'History',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Fromal_Raise_Ticket()));
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('Raise Ticket',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: kYellowColor,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          )),
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
              centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // give the tab bar a height [can change hheight to preferred height]
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kYellowColor,
                      width: 1,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ),
                      color: kYellowColor,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: kYellowColor,
                    tabs: [
                      // first tab [you can add an icon using the icon property]
                      Tab(
                        child: Container(
                          child: Text(
                            'Active',
                          ),
                        ),
                      ),

                      // second tab [you can add an icon using the icon property]
                      Tab(
                        child: Container(
                          child: Text(
                            'Close',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // tab bar view here
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // first tab bar view widget
                      Container(
                        height: 250,
                        child: ListView.builder(
                          //shrinkWrap: true,
                          itemCount: activeTicketDataList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (ctx, index) {
                            var mdlSubData = activeTicketDataList[index];
                            return Card(
                              elevation: 0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: EdgeInsets.only(right: 0),
                                    child: Card(
                                      color: klightYelloColor,
                                      elevation: 3,
                                      margin: EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 15, top: 25),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    top: 8,
                                                                    bottom: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Ticket Number',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Issue',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Message',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    top: 5,
                                                                    bottom: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 1,
                                                                ),
                                                                Container(
                                                                    width: 205,
                                                                    child: Text(
                                                                      mdlSubData
                                                                          .tid,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Rubik',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .black,
                                                                        fontStyle:
                                                                            FontStyle.normal,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  mdlSubData
                                                                      .issue_type,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                    width: 205,
                                                                    child: Text(
                                                                      mdlSubData
                                                                          .message,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Rubik',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .black,
                                                                        fontStyle:
                                                                            FontStyle.normal,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                Raise_Ticket_Normal_Detail(mdlSubData.tid,mdlSubData.message)));
                                                                  },
                                                                  child:
                                                                  Container(
                                                                      width:
                                                                      205,
                                                                      child:
                                                                      Text(
                                                                        'Reply',
                                                                        maxLines:
                                                                        2,
                                                                        overflow:
                                                                        TextOverflow.ellipsis,
                                                                        style:
                                                                        TextStyle(
                                                                          fontFamily: 'Rubik',
                                                                          fontWeight: FontWeight.w500,
                                                                          color: kYellowColor,
                                                                          fontStyle: FontStyle.normal,
                                                                          fontSize: 14.0,
                                                                        ),
                                                                      )),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
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
                      // second tab bar view widget
                      Container(
                        height: 250,
                        child: ListView.builder(
                          //shrinkWrap: true,
                          itemCount: activeTicketDataList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (ctx, index) {
                            var mdlSubData = activeTicketDataList[index];
                            return Card(
                              elevation: 0,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.all(10.0),
                                  child: Container(
                                    padding: EdgeInsets.only(right: 0),
                                    child: Card(
                                      color: klightYelloColor,
                                      elevation: 3,
                                      margin: EdgeInsets.all(0.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: 15, top: 25),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    top: 8,
                                                                    bottom: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Ticket Number',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Issue',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  'Message',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  '',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    top: 5,
                                                                    bottom: 10),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 1,
                                                                ),
                                                                Container(
                                                                    width: 205,
                                                                    child: Text(
                                                                      mdlSubData
                                                                          .tid,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Rubik',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .black,
                                                                        fontStyle:
                                                                            FontStyle.normal,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Text(
                                                                  mdlSubData
                                                                      .issue_type,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                    width: 205,
                                                                    child: Text(
                                                                      mdlSubData
                                                                          .message,
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Rubik',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        color: Colors
                                                                            .black,
                                                                        fontStyle:
                                                                            FontStyle.normal,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                Raise_Ticket_Normal_Detail(mdlSubData.tid,message)));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                          width:
                                                                              205,
                                                                          child:
                                                                              Text(
                                                                            'Reply',
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Rubik',
                                                                              fontWeight: FontWeight.w500,
                                                                              color: kYellowColor,
                                                                              fontStyle: FontStyle.normal,
                                                                              fontSize: 14.0,
                                                                            ),
                                                                          )),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class ActiveTicketDataList {
  String message = '';
  String issue_type = '';
  String tid = '';
  String transaction_id = '';
}

class CloseTicketDataList {
  String message = '';
  String issue_type = '';
  String transaction_id = '';
}
