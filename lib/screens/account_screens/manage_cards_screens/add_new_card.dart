import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spendzz/screens/account_screens/manage_cards_screens/payment_card.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/all_category.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/category_details.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';

import 'input_formatters.dart';

class AddNewCardScreen extends StatefulWidget {
  static const String route = '/AddNewCardScreen';

  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  _AddNewCardScreenState createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidateMode = AutovalidateMode.disabled;
  var _card = new PaymentCard();

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
  }

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
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: Container(
                height: 400,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Card Number',
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
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              new LengthLimitingTextInputFormatter(19),
                              new CardNumberInputFormatter()
                            ],
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            controller: numberController,
                            decoration: new InputDecoration(
                              hintText: '**** **** **** 0567',

                            ),
                            onSaved: (String? value) {
                              print('onSaved = $value');
                              print(
                                  'Num controller has = ${numberController.text}');
                              _paymentCard.number =
                                  CardUtils.getCleanedNumber(value!);
                            },
                            validator: CardUtils.validateCardNum,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(child: Container(
                          padding: EdgeInsets.only(left: 25,right: 10),
                          child: Column(
                            children: [
                              Align(
                                alignment: FractionalOffset.topLeft,
                                child: Text(
                                  'Card Expiry Date',
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
                                height: 10,
                              ),
                              TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  new LengthLimitingTextInputFormatter(4),
                                  new CardMonthInputFormatter()
                                ],
                                decoration: new InputDecoration(
                                  hintText: 'MM/YY',
                                ),
                                validator: CardUtils.validateDate,
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  List<int> expiryDate = CardUtils.getExpiryDate(value!);
                                  _paymentCard.month = expiryDate[0];
                                  _paymentCard.year = expiryDate[1];
                                },
                              )
                            ],
                          ),
                        ),),
                        Expanded(child: Container(
                          padding: EdgeInsets.only(right: 25,left: 10),
                          child: Column(
                            children: [
                              Align(
                                alignment: FractionalOffset.topLeft,
                                child: Text(
                                  'CVV',
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
                                height: 10,
                              ),
                              TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  new LengthLimitingTextInputFormatter(4),
                                ],
                                decoration: new InputDecoration(
                                  hintText: 'Number behind the card',
                                ),
                                validator: CardUtils.validateCVV,
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  _paymentCard.cvv = int.parse(value!);
                                },
                              ),
                            ],
                          ),
                        ),)
                      ],
                    ),
                    Spacer(),
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
                        onPressed: _validateInputs,
                        child: Text(
                          'Save',
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
        context, MaterialPageRoute(builder: (context) => CategoryDetails('','','')));
  }

  void previousScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      this._paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      _showInSnackBar('Payment card is valid');
    }
  }

  void _showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      duration: new Duration(seconds: 3),
    ));
  }
}
