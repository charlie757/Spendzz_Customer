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
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/qrCode.dart';

import 'sendMoney_screen/contactScreen_screen.dart';

class SendPayment extends StatefulWidget {
  const SendPayment({Key? key}) : super(key: key);

  @override
  _SendPaymentState createState() => _SendPaymentState();
}

class _SendPaymentState extends State<SendPayment> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  late String BarCodeResult;
  QRViewController? controller;
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
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
           Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
         /* Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                  'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : Text('Scan a code'),
            ),
          ),*/
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
                                )))
                      ],
                    ),
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
      setState(() {
        result = scanData;
        _callScanQrCode();
      });
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
          prefs.setString("paymentType", 'scanner');

           Navigator.push(
              context, MaterialPageRoute(builder: (context) => PayMoneyScreen(dataAll["data"]["unique_key"].toString(),'')));
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

}
