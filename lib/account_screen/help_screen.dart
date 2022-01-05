import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendzz/account_screen/raise_ticket.dart';
import 'package:spendzz/resources/constants.dart';

import 'close_help_detail.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed: () {},
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Raise_Ticket()));
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
                      itemCount: 8,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) =>
                          GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => CloseHelpDetail()));

                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: klightYelloColor,
                            ),
                            padding: EdgeInsets.only(left: 25),
                            child: Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10, top: 10, bottom: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Ticket Number',
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Issue',
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Message',
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 10, top: 15, bottom: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                '111',
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Payment Failed',
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                  width: 205,
                                                  child: Text(
                                                    'Lorem ipsum dolor sit amet,consectetur...',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Reply',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: kYellowColor,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
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

                  // second tab bar view widget
                  Container(
                    height: 250,
                    child: ListView.builder(
                      //shrinkWrap: true,
                      itemCount: 8,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) =>
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: klightYelloColor,
                                ),
                                padding: EdgeInsets.only(left: 25),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, top: 10, bottom: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Ticket Number',
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.black,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Issue',
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.black,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Message',
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.black,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, top: 15, bottom: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    '111',
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Payment Failed',
                                                    style: TextStyle(
                                                      fontFamily: 'Rubik',
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                      fontStyle: FontStyle.normal,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                      width: 205,
                                                      child: Text(
                                                        'Lorem ipsum dolor sit amet,consectetur...',
                                                        maxLines: 2,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: 'Rubik',
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: Colors.black,
                                                          fontStyle:
                                                          FontStyle.normal,
                                                          fontSize: 16.0,
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          'Reply',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w500,
                                            color: kYellowColor,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16.0,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
