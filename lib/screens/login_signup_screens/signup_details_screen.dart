import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/resources/ConnectivityProvider.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;

class MoreDetailsScreen extends StatefulWidget {
  static const String route = '/MoreDetailsScreen';

  const MoreDetailsScreen({Key? key}) : super(key: key);

  @override
  _MoreDetailsScreenState createState() => _MoreDetailsScreenState();
}

class _MoreDetailsScreenState extends State<MoreDetailsScreen> {
  bool isChecked = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final dateController = TextEditingController();

  late String emailAddress;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // late FirebaseMessaging messaging;

  var device_id = "";
  var device_type = "";

  @override
  void initState() {
    super.initState();
    fetchlocation();

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
      device_id = value.toString();
      device_id = value.toString();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    // _getGeoLocationPosition();
    if (Platform.isAndroid) {
      device_type = "Android";
      // Android-specific code
    } else if (Platform.isIOS) {
      // iOS-specific code
      device_type = "IOS";
    }
  }

  fetchlocation() async {
    Position position = await _getGeoLocationPosition();
    GetAddressFromLatLong(position);
  }

  String location = 'Press Button';
  String Address = 'search';
  String placeMark = '';

  var latitude = '';
  var longitude = '';
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    latitude = position.latitude.toString();
    longitude = position.longitude.toString();
    print("latitude ${latitude}");
    print("longitude ${longitude}");
    Placemark place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  String patttern =
      r'^(([^<>()[\]\\.,;:@\"]+(\.[^<>()[\]\\.,;:@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  Widget build(BuildContext context) {
    final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kstatusBarColor,
    ));
    FocusNode myFocusNode = new FocusNode();
    return new WillPopScope(
        onWillPop: () async {
          _onBackPressed();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Form(
              // autovalidate: true,
              key: _formkey,
              child: Container(
                padding: EdgeInsets.only(bottom: 125),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _onBackPressed();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 75, left: 25),
                        child: Align(
                          alignment: FractionalOffset.topLeft,
                          child: Icon(
                            Icons.keyboard_backspace_outlined,
                            color: Color(0xff303030),
                            size: 25.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 25),
                      child: Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Enter More Details',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 24.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Full Name *',
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
                              LengthLimitingTextInputFormatter(50),
                            ],
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            autocorrect: true,
                            controller: fullNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter Name',
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff303030)),
                              ),
                            ),
                            /* validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter Full Name';
                              }
                            },
*/
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Align(
                        alignment: FractionalOffset.topLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: TextFormField(
                        inputFormatters: [
                          // BlacklistingTextInputFormatter(RegExp(r"\s"))

                          // FilteringTextInputFormatter.digitsOnly
                        ],
                        // validator: (value) => EmailValidator.validate(value!) ? null : "Please enter a valid email",
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                        autocorrect: true,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter Email',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff787D86)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Date of Birth *',
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
                            readOnly: true,
                            controller: dobController,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            autocorrect: true,
                            decoration: InputDecoration(
                              hintText: 'Pick your Date of Birth',
                            ),
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: new DateTime.now()
                                      .subtract(new Duration(days: 0)));

                              dobController.text =
                                  date.toString().substring(0, 10);
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                      child: Column(
                        children: [
                          Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Referral Code (Optional)',
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
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(15),
                              ],
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                              autocorrect: true,
                              controller: referralCodeController,
                              decoration: InputDecoration(
                                hintText: 'Enter Referral Code',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff787D86)),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15),
                            child: Align(
                                alignment: FractionalOffset.topLeft,
                                child: Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: kYellowColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    value: isChecked,
                                    onChanged: (bool? b) {
                                      setState(() {
                                        isChecked = b!;
                                      });
                                    },
                                  ),
                                )),
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 25),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "By signing you agree to our ",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      )),
                                  TextSpan(
                                      text: "T&C",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        color: kYellowColor,
                                        decoration: TextDecoration.underline,
                                        fontSize: 14.0,
                                      )),
                                  TextSpan(
                                      text: " and\n",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black,
                                        fontSize: 14.0,
                                      )),
                                  TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                        color: kYellowColor,
                                        decoration: TextDecoration.underline,
                                        fontSize: 14.0,
                                      )),
                                ]),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
                          onPressed: () async {
                            // fetchlocation();

                            Position position = await _getGeoLocationPosition();
                            GetAddressFromLatLong(position);
                            RegExp regExp = new RegExp(patttern.trim());
                            if (fullNameController.text.isEmpty) {
                              EasyLoading.showToast('Please enter Full Name.');
                              // return;
                            } else if (emailController.text.length >= 1) {
                              if (!regExp.hasMatch(emailController.text)) {
                                EasyLoading.showToast(
                                    'Please enter Valid Email Address.');
                                // return;
                              }
                            } else if (dobController.text.isEmpty) {
                              EasyLoading.showToast('Please enter dob.');
                              // return;
                            } else if (isChecked == false) {
                              EasyLoading.showToast(
                                  'Please Accept Privacy Policy ');
                              // return;
                            } else {
                              _callSignCompleteApiInDataListings();
                            }
                            // // _callSignCompleteApiInDataListings();
                            // print("tap");
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
          floatingActionButton: Stack(
            children: [
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    height: 150,
                    child: Image.asset(
                      "assets/images/splash_background2.png",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    )), //Your widget here,
              ),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                    height: 140,
                    child: Image.asset(
                      "assets/images/splash_background1.png",
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                    ) //Your widget here,
                    ),
              ),
            ],
          ),
        ));
  }

  _callSignCompleteApiInDataListings() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var register_token = prefs.getString('REGISTER_TOKEN') ?? '';
    mapBody['lat'] = latitude;
    mapBody['long'] = longitude;
    mapBody['name'] = fullNameController.text;
    mapBody['email'] = emailController.text.trimRight();
    mapBody['dob'] = dobController.text;
    mapBody['referral'] = referralCodeController.text;
    mapBody['register_token'] = register_token;
    mapBody['device_id'] = device_id;
    mapBody['device_type'] = device_type;

    var client = http.Client();
    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.SIGNUP_COMPLETE),
          body: mapBody);
      print(mapBody);
      var dataAll = json.decode(uriResponse.body);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        Fluttertoast.showToast(
            msg: dataAll['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);

        prefs.setString('NAME', fullNameController.text);
        prefs.setString('EMAIL', emailController.text);
        prefs.setString('AUTH_TOKEN', dataAll['auth_token'].toString());
        prefs.setString('REFERRAL_CODE', dataAll['referral_code'].toString());
        prefs.setBool('IS_LOGIN_DATA_STATUS', true);
        NextScreen();
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

  void NextScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }

  _onBackPressed() async {
    //SharedPreferences prefs =  SharedPreferences.getInstance() as SharedPreferences;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return showDialog(
      context: context,
      barrierColor: Color(0x00ffffff),
      builder: (context) => new AlertDialog(
        title: new Text(
          'Exit Confirmation',
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontStyle: FontStyle.normal,
            fontSize: 17.0,
          ),
        ),
        content: new Text(
          'Do you want to exit ?',
          style: TextStyle(
            fontFamily: 'Rubik',
            fontWeight: FontWeight.w400,
            color: Colors.black87,
            fontStyle: FontStyle.normal,
            fontSize: 14.0,
          ),
        ),
        actions: <Widget>[
          new Container(
            padding: EdgeInsets.all(1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Ink(
                  height: 35,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ), // LinearGradientBoxDecoration
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(true);
                      prefs.setBool('IS_LOGIN_DATA_STATUS', false);
                    },
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    splashColor: kYellowColor,
                    child: Container(
                      decoration: BoxDecoration(
                          color: kYellowColor,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          'No',
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
                  // Red will correctly spread over gradient
                ),
                SizedBox(
                  width: 10,
                ),
                Ink(
                  height: 35,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ), // LinearGradientBoxDecoration
                  child: InkWell(
                    onTap: () {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else {
                        exit(0);
                      }
                    },
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    splashColor: kYellowColor,
                    child: Align(
                      child: Container(
                        decoration: BoxDecoration(
                            color: kYellowColor,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: FlatButton(
                          onPressed: () {
                            if (Platform.isAndroid) {
                              SystemNavigator.pop();
                            } else {
                              exit(0);
                            }
                          },
                          child: Text(
                            'Yes',
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
                  // Red will correctly spread over gradient
                ),
              ],
            ),
          )
        ],
      ),
    );
    // false;
  }
}
