import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spendzz/dashboard/account_screen.dart';
import 'package:spendzz/category/all_category.dart';
import 'package:spendzz/category/category_details.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';

class HistoryScreen extends StatefulWidget {
  static const String route = '/HistoryScreen';

  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
                        previousScreen();
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
                  fitterPopup();
                },
                child: Container(
                  height: 75,
                  width: 75,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Image.asset('assets/images/fittler.png'),
                ),
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: true),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      //shrinkWrap: true,
                      itemCount: 25,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) => Card(
                        elevation: 0,
                        child: GestureDetector(
                          onTap: () {
                            nextScreen();
                          },
                          child: Container(
                            margin: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    width: 1.0, color: Color(0xff787D86)),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            child: Text(
                                          'Today, 1:56 PM',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0,
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      nextScreen();
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            '\u{20B9}${'+12'}',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            'Success',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green,
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
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
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }

  void fitterPopup() {
    List<String> _days = ['sunday', 'Monday', 'Tuesday'];
    final dateController = TextEditingController();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Container(
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                            child: Text(
                          'All',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                            child: Text(
                          'Paid',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                            child: Text(
                          'Received',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                            child: Text(
                          'Added',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Container(
                    child: ExpansionTile(
                      iconColor: kYellowColor,
                      title: Text(
                        'Monthly',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                      ),
                      children: [
                        ListTile(
                          onTap: () {},
                          title: Text(
                            'January',
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('February'),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('March'),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('April'),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('May'),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('June'),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('July'),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('August'),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('September'),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('October'),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('November'),
                        ),
                        ListTile(
                          onTap: () {},
                          title: Text('December'),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xff787D86),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Text(
                          'Request to Statement ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(
                                        'Start Date',
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
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        new LengthLimitingTextInputFormatter(4),
                                      ],
                                      decoration: new InputDecoration(
                                        hintText: 'DD/MM/YY',
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(right: 25, left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(
                                        'End Date',
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
                                    TextField(
                                      readOnly: true,
                                      controller: dateController,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                      autocorrect: true,
                                      decoration: InputDecoration(
                                        hintText: 'DD/MM/YY',
                                      ),
                                      onTap: () async {
                                        var date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100));
                                        dateController.text =
                                            date.toString().substring(0, 10);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 100.0, right: 100.0, top: 5, bottom: 20),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: kYellowColor,
                            // borderRadius: BorderRadius.horizontal()),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: FlatButton(
                          onPressed: () {
                            nextScreen();
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
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
