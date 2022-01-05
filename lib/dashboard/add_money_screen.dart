import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({Key? key}) : super(key: key);

  @override
  _AddMoneyScreenState createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  bool isChecked = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController addNoteController = TextEditingController();
  int _value = 1;

  late ConfettiController controllerTopCenter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      initController();
    });

  }

  void initController() {
    controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kstatusBarColor,
    ));
    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(

          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Text(
              "Add Money to Wallet",
              style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontStyle: FontStyle.normal,
                fontSize: 20.0,
              ),
            ),
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
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    buildConfettiWidget(controllerTopCenter, pi / 1),
                    buildConfettiWidget(controllerTopCenter, pi / 4),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(25),
                            ],
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: kYellowColor,
                              fontStyle: FontStyle.normal,
                              fontSize: 26.0,
                            ),
                            autocorrect: true,
                            controller: amountController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '\u{20B9}',
                              hintStyle: TextStyle(
                                color: kYellowColor, // <-- Change this
                                fontSize: null,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter Amount';
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Add Note',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black38,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 8,
                            inputFormatters: [
                              // LengthLimitingTextInputFormatter(25),
                            ],
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            autocorrect: true,
                            controller: addNoteController,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff303030)),
                              ),
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter Full Name';
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Pay from',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                          child: Column(
                            children: [
                              Align(
                                alignment: FractionalOffset.topLeft,
                                child: Text(
                                  'Spendzz Balance  (Low Balance)',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black38,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 25,),
                          child:  Row(
                            children: [
                              Align(
                                child: Text(
                                  'Available Balance ₹1000',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Radio(
                                  fillColor: MaterialStateColor.resolveWith((states) => kYellowColor),
                                  value: 1,
                                  groupValue: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value as int;
                                    });
                                  }),


                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Divider(
                            color: Colors.black38,
                            thickness: 1.0,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                          child: Column(
                            children: [
                              Align(
                                alignment: FractionalOffset.topLeft,
                                child: Text(
                                  'Razorpay ',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black38,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 25,),
                          child:  Row(
                            children: [
                              Align(
                                child: Text(
                                  '999999999',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Radio(
                                  fillColor: MaterialStateColor.resolveWith((states) => kYellowColor),
                                  value: 2,
                                  groupValue: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value as int;
                                    });
                                  }),


                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 25),
                          child: Divider(
                            color: Colors.black38,
                            thickness: 1.0,
                          ),
                        ),



                      ],
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15,bottom: 150),
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Promo code',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                TextField(
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                    autocorrect: true,
                                    //  controller: referralCodeController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Promo code',
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Color(0xff787D86)),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 50.0, right: 50.0, top: 25, bottom: 0),
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: kYellowColor,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: FlatButton(
                                onPressed: () {
                                  ShowDialog();
                                  controllerTopCenter.play();

                                 /* if(isChecked == false)
                                  {
                                    Fluttertoast.showToast(
                                        msg: "Please Accept Privacy Policy ",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.red,
                                        timeInSecForIosWeb: 1,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                  if(_formkey.currentState!.validate() && isChecked == true)
                                  {
                                    //_callSendOtpIntoAppApiInDataListings();
                                    //NextScreen();

                                  }*/
                                },
                                child: Text(
                                  '\u{20B9}'+' Pay 50',
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
                      ),
                    )


                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void previousScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }
  void ShowDialog() {
    showDialog(
        context: context,
        barrierColor: Color(0x00ffffff),
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: klightYelloColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Align(
              alignment: FractionalOffset.center,
              child: Container(
                width: 55.00,
                height: 55.00,
                child: Container(
                  width: 68.00,
                  height: 68.00,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.red,
                    image: DecorationImage(
                      scale: 2,
                      image: ExactAssetImage(
                          'assets/images/makepayment.png'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  Align(
                    alignment: FractionalOffset.center,
                    child: Text(
                      '‘SPENDZZ11’ applied',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w300,
                        color: Colors.black38,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Align(
                    alignment: FractionalOffset.center,
                    child: Text(
                      'You have earned\n₹100 cashback',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Align(
                    alignment: FractionalOffset.center,
                    child: Text(
                      ' with this code',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w300,
                        color: Colors.black38,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Align(
                    alignment: FractionalOffset.center,
                    child: Text(
                      'Thanks',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500,
                        color: kYellowColor,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [

            ],
          );
        });
  }
  Align buildConfettiWidget(controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        /*confettiController: controllerTopCenter,
        blastDirectionality: BlastDirectionality.explosive,
        particleDrag: 0.05,
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 0.05,
        shouldLoop: true,
        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ],*/
        maximumSize: Size(30, 30),
        shouldLoop: false,
        particleDrag: 0.05,
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 0.05,
        confettiController: controller,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.explosive,
       // blastDirectionality: BlastDirectionality.directional,
        maxBlastForce: 20, // set a lower max blast force
        minBlastForce: 8, // set a lower min blast force

        colors: const [
          Colors.green,
          Colors.blue,
          Colors.pink,
          Colors.orange,
          Colors.purple
        ],
      ),
    );
  }
}
