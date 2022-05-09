import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';

class QRCodeScreenMakePayment extends StatefulWidget {
  const QRCodeScreenMakePayment({Key? key}) : super(key: key);
  static const String route = '/QRCodeScreenMakePayment';

  @override
  _QRCodeScreenMakePaymentState createState() =>
      _QRCodeScreenMakePaymentState();
}

class _QRCodeScreenMakePaymentState extends State<QRCodeScreenMakePayment> {
  late String name = '';

  late String email = '';

  late String mobile = '';

  var imgValueUser = '';
  var imgqrCode = '';
  var message = '';
  bool is_login_status = false;
  late String notApproved = '';

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callGetQRCode(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {});
  }

  _callGetQRCode(String tokenData) async {
    var client = http.Client();
    EasyLoading.show();
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.GET_CUSTOMER_QR_CODE),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if (dataAll['status'] == true) {
          imgqrCode = dataAll['img_url'].toString();
          imgqrCode = imgqrCode = dataAll['img_url'].toString() +
              "/" +
              dataAll['message'].toString();
          print("imgqrCode${imgqrCode}");

          /* if(message!=null)
            {
              imgqrCode = dataAll['img_url'].toString();
              imgqrCode =  imgqrCode = dataAll['img_url'].toString() + "/" + dataAll['message'].toString();
            }
          else
            {

            }*/
          /*if (notApproved == 'Merchant ID is not approved') {
              Fluttertoast.showToast(
                  msg: 'Your Profile is Under Review',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.orange,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }*/
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
        // _onBackPressed();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DashboardMainScreen()));
        return false;
      },
      child: Scaffold(
        backgroundColor: klightYelloColor,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 55),
            child: Column(
              children: [
                // Container(
                //     height: 55.00,
                //     width: 55,
                //     decoration: new BoxDecoration(
                //       image: new DecorationImage(
                //         image: ExactAssetImage(
                //             'assets/images/banner.png'),
                //         fit: BoxFit.fill,
                //       ),
                //     )),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Congratulation',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w500,
                      color: kYellowColor,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    ' Your QR is ready',
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w500,
                      color: kYellowColor,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                  ),
                ),

                Card(
                  elevation: 3,
                  margin: EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                              height: 78.00,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: ExactAssetImage(
                                      'assets/images/splash_logo.png'),
                                  fit: BoxFit.fill,
                                ),
                              )),
                          SizedBox(
                            height: 25,
                          ),
                          /*if(message!=null)...[
                            Align(
                              alignment: Alignment.center,
                              child:   Text(
                                'Congratulation',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w500,
                                  color: kYellowColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ]
                          else...[
                            Container(
                              margin: EdgeInsets.only(left: 15,right: 15,top: 1),
                              padding: EdgeInsets.only(top: 5),
                              child: ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                child: CachedNetworkImage(
                                    imageUrl: imgqrCode.toString(),
                                    placeholder: (context, url) =>
                                        Transform.scale(
                                          scale: 0.4,
                                          child: CircularProgressIndicator(
                                            color: kYellowColor,
                                            strokeWidth: 3,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) => Container(
                                        height: 75,
                                        width: MediaQuery.of(context).size.width,
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                notApproved,
                                                style: TextStyle(
                                                  fontFamily: 'Rubik',
                                                  fontWeight: FontWeight.w500,
                                                  color: kYellowColor,
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],*/
                          Container(
                            margin:
                                EdgeInsets.only(left: 15, right: 15, top: 1),
                            padding: EdgeInsets.only(top: 5),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              child: CachedNetworkImage(
                                  imageUrl: imgqrCode.toString(),
                                  placeholder: (context, url) =>
                                      Transform.scale(
                                        scale: 0.4,
                                        child: CircularProgressIndicator(
                                          color: kYellowColor,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                          height: 75,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Text(
                                                  notApproved,
                                                  style: TextStyle(
                                                    fontFamily: 'Rubik',
                                                    fontWeight: FontWeight.w500,
                                                    color: kYellowColor,
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          /*Center(
                            child:GestureDetector(
                              onTap: () async {

                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 24.00,
                                  decoration: new BoxDecoration(
                                    image: new DecorationImage(
                                      image: ExactAssetImage(
                                          'assets/images/downlode.png'),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),*/
                          Center(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 25, right: 25),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (notApproved ==
                                          'Merchant ID is not approved') {
                                      } else {
                                        Share.share(imgqrCode);
                                      }
                                    },
                                    child: Container(
                                        width: 24,
                                        height: 24.00,
                                        decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                            image: ExactAssetImage(
                                                'assets/images/share.png'),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (notApproved ==
                                          'Merchant ID is not approved') {
                                      } else {
                                        Share.share(imgqrCode);
                                      }
                                    },
                                    child: Align(
                                      alignment: FractionalOffset.topLeft,
                                      child: Text(
                                        'Share QR',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w500,
                                          color: kYellowColor,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
