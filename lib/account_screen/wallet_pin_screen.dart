import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:spendzz/resources/constants.dart';
class WalletPinScreen extends StatefulWidget {
  const WalletPinScreen({Key? key}) : super(key: key);

  @override
  _WalletPinScreenState createState() => _WalletPinScreenState();
}

class _WalletPinScreenState extends State<WalletPinScreen> {
  bool status = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>true,
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
                       // nextPreviousScreen();
                      },
                    ),
                    Text('Wallet Pin',style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0,
                    ),)
                  ],
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: FlutterSwitch(
                  width: 50.0,
                  height: 20.0,
                  value: status,
                  borderRadius: 30.0,
                  padding: 2.0,
                  activeToggleColor: kYellowColor,
                  inactiveToggleColor: Colors.white,
                  activeSwitchBorder: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                  inactiveSwitchBorder: Border.all(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                  activeColor: Colors.black,
                  inactiveColor: Colors.black12,
                  onToggle: (val) {
                    setState(() {
                      status = val;
                    });
                  },
                ),
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: true),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'Enter 4 Digit PIN',
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
                            controller: _pass,
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
                              hintText: '1111',
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xff787D86)),
                              ),
                            ),

                        validator: (val){
                          if(val!.isEmpty)
                            {
                              return 'Please enter 4 Digit PIN';
                            }
                          else if (val.length <4) {
                            return 'Please enter valid PIN';
                          }
                        }),
                        SizedBox(height: 15,),
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'Enter 4 Digit PIN',
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
                              LengthLimitingTextInputFormatter(4),
                            ],
                            obscureText: true,
                            obscuringCharacter: "*",
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
                              hintText: '1111',
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xff787D86)),
                              ),
                            ),
                          validator: (val){
                            if(val!.isEmpty)
                            {
                              return 'Please enter 4 Digit PIN';
                            }
                            else if (val.length <4) {
                              return 'Please enter valid PIN';
                            }
                            else if(val != _pass.text)
                              {
                                return 'PIN Not Match';
                              }
                          })
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 100.0, right: 100.0, top: 25, bottom: 0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: kYellowColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: FlatButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {

                            return;
                          }
                        },
                        child: Text(
                          'Continue',
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

            ),
          ),
        ),
      ),

    );
  }
}
