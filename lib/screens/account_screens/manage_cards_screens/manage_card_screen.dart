import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendzz/screens/account_screens/account_screen.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'add_new_card.dart';
class ManageCard extends StatefulWidget {
  static const String route = '/ManageCard';

  const ManageCard({Key? key}) : super(key: key);

  @override
  _ManageCardState createState() => _ManageCardState();
}
class _ManageCardState extends State<ManageCard> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,));
    return WillPopScope(
      onWillPop: () async {
        previousScreen();
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
                previousScreen();
              },
            ),
            title: Text(
              "Manage Cards",
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
                    padding: EdgeInsets.only(left: 15,right: 15,bottom: 15),
                    height: MediaQuery.of(context).size.height - 150,
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
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Container(
                                       child: Text(
                                         'CITI Bank',
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
                                           Container(
                                               child: Text('**** **** **** 0355',
                                                 textAlign: TextAlign.start,
                                                 style: TextStyle(
                                                   fontFamily: 'Rubik',
                                                   fontWeight: FontWeight.w500,
                                                   color: Colors.black,
                                                   fontStyle: FontStyle.normal,
                                                   fontSize: 16.0,
                                                 ),
                                               )
                                           ),
                                           Spacer(),
                                           Container(
                                             padding: EdgeInsets.only(bottom: 10),
                                             width: 38.00,
                                             height: 38.00,
                                             child: Image.asset('assets/images/delete.png'),
                                           ),
                                         ],
                                       ),
                                     ),
                                     Divider(
                                       color: Colors.black,
                                     ),



                                   ],
                                 ),
                               ),

                            ),

                          ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 0.0, bottom: 0),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width -200,
                      decoration: BoxDecoration(
                          color: kYellowColor,
                          // borderRadius: BorderRadius.horizontal()),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: FlatButton(
                        onPressed: () {
                          nextScreen();
                        },
                        child: Text(
                          'Add New',
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
              ],
            ),
          ),
        ),
        /*floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(

            child:  Container(
              width: MediaQuery.of(context).size.width -100,
              padding: const EdgeInsets.only(
                left: 50.0, right: 50.0,),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 0.0, right: 0.0, bottom: 0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width -200,
                    decoration: BoxDecoration(
                        color: kYellowColor,
                        // borderRadius: BorderRadius.horizontal()),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: FlatButton(
                      onPressed: () {

                      },
                      child: Text(
                        'Add New',
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

        ),*/
      ),
    );
  }

  void nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddNewCardScreen()));
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }
}
