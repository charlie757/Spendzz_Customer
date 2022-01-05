import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendzz/category/category_details.dart';
import 'package:spendzz/resources/constants.dart';

import '../dashboard/account_screen.dart';

class CloseHelpDetail extends StatefulWidget {
  const CloseHelpDetail({Key? key}) : super(key: key);

  @override
  _CloseHelpDetailState createState() => _CloseHelpDetailState();
}

class _CloseHelpDetailState extends State<CloseHelpDetail> {
  late String phoneNumber;
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
                        onPressed: () {},
                      ),
                      Text(
                        '#2121151151',
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
                Container(
                  padding: EdgeInsets.only(right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Active',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: kYellowColor,
                            fontStyle: FontStyle.normal,
                            decoration: TextDecoration.underline,
                            fontSize: 16.0,
                          )),
                    ],
                  ),
                )
              ],
              automaticallyImplyLeading: false,
              centerTitle: true),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 25,right: 95),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Ticket Number",
                                style: TextStyle(fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff303030),
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,),
                              ),),
                            Container(
                                child: Expanded(child:  Text(
                                  "1111",
                                  style: TextStyle(fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff303030),
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,),
                                ))
                            )


                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Raised On",
                                style: TextStyle(fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff303030),
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,),
                              ),),
                            Container(
                                child: Expanded(child:  Text(
                                  "13 Oct,2021",
                                  style: TextStyle(fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff303030),
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,),
                                ))
                            )


                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Issue",
                                style: TextStyle(fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff303030),
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,),
                              ),),
                            Container(
                                child: Expanded(child:  Text(
                                  "Payment Failed",
                                  style: TextStyle(fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff303030),
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,),
                                ))
                            )


                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25,right: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15,),
                        Text(
                          "Message",
                          style: TextStyle(fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: kYellowColor,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ullamcorper ipsum, felis quis velit egestas maecenas aliquet amet odio. Massa sed pellentesque id purus vulputate ornare tristique elementum.",
                          style: TextStyle(fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Color(0xff303030),
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,),
                        ),

                      ],
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
                                  'Write Comment',
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
                                    hintText: 'Enter Comment',
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
              child: Container(
            width: MediaQuery.of(context).size.width - 100,
            padding: const EdgeInsets.only(
              left: 50.0,
              right: 50.0,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0),
              child: Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 200,
                  decoration: BoxDecoration(
                      color: kYellowColor,
                      // borderRadius: BorderRadius.horizontal()),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Send',
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
          )),
        ));
  }

  void nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CategoryDetails()));
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }
}
