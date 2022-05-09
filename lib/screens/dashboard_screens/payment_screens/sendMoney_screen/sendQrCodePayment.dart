import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/pay_money_screen.dart';
import 'package:spendzz/screens/account_screens/qrCode.dart';

import 'contactScreen_screen.dart';

class SendPaymentWithQrCodeOld extends StatefulWidget {
  const SendPaymentWithQrCodeOld({Key? key}) : super(key: key);

  @override
  _SendPaymentWithQrCodeOldState createState() => _SendPaymentWithQrCodeOldState();
}

class _SendPaymentWithQrCodeOldState extends State<SendPaymentWithQrCodeOld> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  //late String BarCodeResult;
  QRViewController? controller;
  List<RecentContactList> recentContact = [];
  var isDataFetched = false;
  String file_url_merchant = '';
  String customer_base_url = '';
  String userImageShow = '';
  String pay_by_type = '';
  String CustomerFullUrl="";

  var merchant_id='';
  var senderType='';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callRecentContact(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {});
  }

  _callRecentContact(String tokenData) async {
    var auth_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      auth_token = prefs.getString('AUTH_TOKEN') ?? '';
      //auth_token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdGVzdGFscGhvbmljLmNvbVwvcHJvamVjdHNcL3JhbWtlc2hcL3NwZW5kenpcL2FwaVwvdXNlclwvdjJcL3NpZ24tY29tcGxldGUiLCJpYXQiOjE2NDg4Nzg5MTYsImV4cCI6MTY1MDM5MDkxNiwibmJmIjoxNjQ4ODc4OTE2LCJqdGkiOiJRWGZObVQxb3Q2cFBmWmt0Iiwic3ViIjozMiwicHJ2IjoiMjNiZDVjODk0OWY2MDBhZGIzOWU3MDFjNDAwODcyZGI3YTU5NzZmNyJ9.QbaPap9Ggp0KBHw2tCxj-Bh8hONZLkTkLdNrHUOW3sk';
    }
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.RESEND_CONTACT),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $auth_token'
          });
      var dataAll = json.decode(uriResponse.body);
      print("dataAll ${dataAll}");
      EasyLoading.dismiss();

      setState(() {
        recentContact.clear();
      });
      if (uriResponse.statusCode == 200) {
        var arrResults = dataAll['data'];
        file_url_merchant=dataAll['merchant_base_url'];
        customer_base_url=dataAll['customer_base_url'];
        userImageShow=dataAll['user_img'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];

          var mdlSubData = RecentContactList();
          pay_by_type=dictResult['pay_by_type'].toString();
          if(dictResult['pay_by_type'].toString()=="merchant")
          {
            if(dictResult['merchant_details']!=null)
            {
              mdlSubData.name = dictResult['merchant_details']['name'].toString();
              mdlSubData.image = dictResult['merchant_details']['profile'].toString();
              mdlSubData.number = dictResult['merchant_details']['mobile'].toString();
            }
            else
            {
              mdlSubData.name = '';
              mdlSubData.number ='';
            }
          }if(dictResult['pay_by_type'].toString()=="user")
          {
            if(dictResult['user_details']!=null)
            {
              mdlSubData.name = dictResult['user_details']['name'].toString();
              mdlSubData.image = dictResult['user_details']['profile'].toString();
              mdlSubData.number = dictResult['user_details']['mobile'].toString();
            }
            else
            {
              mdlSubData.name = '';
              mdlSubData.number ='';
            }
          }
          if(dictResult['pay_by_type'].toString()=="customer")
          {
            if(dictResult['customer_info']!=null)
            {
              mdlSubData.name = dictResult['customer_info']['name'].toString();
              mdlSubData.image = dictResult['customer_info']['profile'].toString();
              CustomerFullUrl=customer_base_url.toString()+"/"+mdlSubData.image.toString();
              mdlSubData.number = dictResult['customer_info']['mobile'].toString();
            }
            else
            {
              mdlSubData.name = '';
              mdlSubData.number ='';

            }
          }
          recentContact.add(mdlSubData);
        }

        setState(() {});
      }

    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
           Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Container(
                        child: Center(
                          child: (result != null)
                              ?

                          Text(
                                  'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                              : Text('Scan a code'),
                        ),
                      ),
                Expanded(
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      borderLength: 20,
                      borderRadius: 10,
                      borderWidth: 10,
                      cutOutSize: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(top: 25, left: 25, right: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                margin:
                                    new EdgeInsets.symmetric(vertical: 15.0),
                                width: 200,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.bottomToTop,
                                            child: ContactList()));
                                  },
                                  child: Text(
                                      'Enter Phone Number'), /*TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                ],

                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),

                                //controller: phoneNumberController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Phone Number',
                                  border: InputBorder.none,
                                ),
                              )*/
                                )),
                          ],
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.bottomToTop,
                                          child: ContactList()));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(right: 1),
                                  child: Icon(
                                    Icons.perm_contact_cal_sharp,
                                    color: kYellowColor,
                                  ),
                                ))),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Recent',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: ListView.builder(
                       shrinkWrap: true,
                       physics: ScrollPhysics(),
                        itemCount: recentContact.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          var mdlSubData = recentContact[index];
                          return   Card(
                            elevation: 0,
                            child: GestureDetector(
                              onTap: (){
                                _callCheckValidMobile(mdlSubData.number);
                                /* Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => PassbookTransactionHistory(mdlSubData.transaction_id,fromDashboard)));*/
                              },
                              child: Container(
                                padding: EdgeInsets.only(bottom: 15),
                                margin: EdgeInsets.all(2.0),

                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          if(pay_by_type=="customer")...[
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(100.0)),
                                              child: CachedNetworkImage(
                                                  height: 50,
                                                  width: 50,
                                                  imageUrl: customer_base_url+"/"+mdlSubData.image.toString(),
                                                  placeholder: (context, url) => Transform.scale(
                                                    scale: 0.4,
                                                    child: CircularProgressIndicator(
                                                      color: kYellowColor,
                                                      strokeWidth: 3,
                                                    ),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                      height: 40,
                                                      width: 40,
                                                      child: Image.asset(
                                                          'assets/images/account_profile.png')),
                                                  fit: BoxFit.cover),
                                            ),
                                          ]
                                          else if(pay_by_type=="merchant")...[
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(100.0)),
                                              child: CachedNetworkImage(
                                                  height: 50,
                                                  width: 50,
                                                  imageUrl: file_url_merchant+"/"+mdlSubData.image.toString(),
                                                  placeholder: (context, url) => Transform.scale(
                                                    scale: 0.4,
                                                    child: CircularProgressIndicator(
                                                      color: kYellowColor,
                                                      strokeWidth: 3,
                                                    ),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                      height: 40,
                                                      width: 40,
                                                      child: Image.asset(
                                                          'assets/images/account_profile.png')),
                                                  fit: BoxFit.cover),
                                            ),
                                          ]
                                          else...[
                                              ClipRRect(
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(100.0)),
                                                child: CachedNetworkImage(
                                                    height: 50,
                                                    width: 50,
                                                    imageUrl: customer_base_url+"/"+mdlSubData.image.toString(),
                                                    placeholder: (context, url) => Transform.scale(
                                                      scale: 0.4,
                                                      child: CircularProgressIndicator(
                                                        color: kYellowColor,
                                                        strokeWidth: 3,
                                                      ),
                                                    ),
                                                    errorWidget: (context, url, error) => Container(
                                                        height: 40,
                                                        width: 40,
                                                        child: Image.asset(
                                                            'assets/images/account_profile.png')),
                                                    fit: BoxFit.cover),
                                              ),
                                            ]


                                        ],
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 70,
                                            padding: EdgeInsets.only(right: 1),
                                            child: Text(
                                              mdlSubData.name,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )



                                    ],
                                  ),
                                ),
                              ),
                            ),

                          );
                        },
                      )
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      {
        Fluttertoast.showToast(
            msg: result.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      //_callScanQrCode();
     /* setState(() {
        result = scanData;
        _callScanQrCode();
      });*/
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }




  _callScanQrCode() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['qr_id'] = result!.code.toString();

    var client = http.Client();
    EasyLoading.show(status: 'loading...');

    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.QR_PAYMENT),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if(dataAll['status']==true)
        {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("CONTACT_NAME",dataAll["data"]['name'].toString());
          prefs.setString("unique_key", dataAll["data"]["unique_key"].toString());
        //  prefs.setString("unique_key", dataAll["data"]["type"].toString());
          prefs.setString("paymentType", 'scanner');

           Navigator.push(
              context, MaterialPageRoute(builder: (context) => PayMoneyScreen(dataAll["data"]["unique_key"].toString(),'',dataAll["type"].toString(),)));
        }
        else
        {
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }


      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: dataAll['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } finally {
      client.close();
    }
  }
  _callCheckValidMobile(String number) async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['mobile'] = number.toString();
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.CHECK_VALID_NUMBER),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      bool status=dataAll['status'];
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if (status == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('CONTACT_NAME', dataAll['data']['name'].toString());
          prefs.setString('CONTACT_NUMBER', dataAll['data']['mobile'].toString());
          merchant_id=dataAll['data']["unique_key"];
          senderType=dataAll['type'];
          /* Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);*/


          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PayMoneyScreen(merchant_id,"",senderType,)));
        }
        if(status == false)
        {
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          /*Navigator.push(
                context, MaterialPageRoute(builder: (context) => NotificationScreen()));*/
        }

      } else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: dataAll['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } finally {
      client.close();
    }
  }
}

class RecentContactList {
  String file_url_merchant = '';
  String file_url_user = '';
  String user_img = '';
  String image = '';
  String name = '';
  String number = '';

}
