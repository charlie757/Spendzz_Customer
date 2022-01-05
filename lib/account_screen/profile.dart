import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/dashboard/account_screen.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
import 'package:spendzz/intro_screen/languages.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String phoneNumber;
  late ProgressDialog pr;
  String location = 'Null, Press Button';
  late String Address;
  final Geolocator geolocator = Geolocator();
  //late String mobile;


  var image;
  late String images;
  late String name;
  TextEditingController fullNameController = new TextEditingController();
  late String emailAddress;
  TextEditingController emailController = TextEditingController();
  late String mobileNo;
  late String dob;
  TextEditingController dobController = TextEditingController();
  late String address;
  TextEditingController addressController = TextEditingController();



  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _uploadImageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _uploadImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  void _uploadImageFromGallery() async {
    final _picker = ImagePicker();

    var _pickedImage = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      image = _pickedImage!.path;
    });
  }
  void _uploadImageFromCamera() async {
    final _picker = ImagePicker();

    var _pickedImage = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      image = _pickedImage!.path;

    });
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNo = prefs.getString('MOBILE_NUMBER') ?? '';
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();
    mobileNo = "";
    getSharedPrefs();
    _callGetProfile();

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    pr = new ProgressDialog(context, type: ProgressDialogType.normal);
    //Optional
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

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
      Placemark place = placemarks[0];
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      setState(() {
        addressController.text = Address.toString();
      });

    }

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
            "Profile",
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
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formkey,
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                children: [
                  /*Container(
                      height: 110,
                      width: 110,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 80,
                              width: 80,
                              child: Container(
                                  //This is the cirtcle avatar want to change to square tyoe
                                  child: image != null
                                      ? Image.file(
                                          File(image),
                                          fit: BoxFit.none,
                                        )
                                      : Container(
                                    padding: EdgeInsets.only(left: 25, top: 25),
                                    height: 100,
                                    width: 100,
                                    child: Container(
                                      width: 35.00,
                                      height: 35.00,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13.0),
                                        image: DecorationImage(
                                          scale: 4,
                                          image: ExactAssetImage(
                                              'assets/images/account_profile.png'),
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ),),
                            ),
                          ),
                          Align(
                            alignment: FractionalOffset.bottomRight,
                            child: Container(
                              width: 35.00,
                              height: 35.00,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13.0),
                                color: Colors.red,
                                image: DecorationImage(
                                  scale: 4,
                                  image: ExactAssetImage(
                                      'assets/images/camera.png'),
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),*/
                  Container(
                      child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          //_onAlertPress();
                          _showPicker(context);
                          // _uploadImage();
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 25, top: 25),
                          height: 100,
                          width: 100,
                          child: Container(
                            width: 35.00,
                            height: 35.00,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(13.0),
                              image: DecorationImage(
                                scale: 4,
                                image: ExactAssetImage(
                                    'assets/images/account_profile.png'),
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        /*child: Container(
                              height: 100,
                                width: 100,
                                child: image != null
                                    ? Image.file(File(image),fit: BoxFit.scaleDown,
                                ) :null
                            ),*/
                        /*child: Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: new FileImage(File(image)),
                                      //image: new ExactAssetImage(_image.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ))*/
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Container(
                              //This is the cirtcle avatar want to change to square tyoe
                              child: image != null
                                  ? Image.file(
                                      File(image),
                                      fit: BoxFit.fitWidth,
                                    )
                                  : null),
                        ),
                      )
                    ],
                  )),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'Full Name',
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
                          key: const Key('name'),
                          controller: fullNameController,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter Name'
                             // border: InputBorder.none,

                            )
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 25),
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
                    /*child: TextFormField(
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                      controller: emailController,
                      autocorrect: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff787D86)),
                        ),
                      ),
                      *//*validator: (String? value) {
                          phoneNumber = value!;
                          String patttern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = new RegExp(patttern);
                          if (value.isEmpty) {
                            return 'Please enter Email Address';
                          } else if (!regExp.hasMatch(value)) {
                            return 'Please enter valid Email Address';
                          }
                        }*//*
                    ),*/
                    child:  TextField(
                        key: const Key('email'),
                        controller: emailController,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                            hintText: 'Enter Email'
                          // border: InputBorder.none,

                        )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'Phone Number',
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
                        Row(
                          children: [
                            Text(
                              mobileNo,
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.only(right: 5, top: 10),
                              child: Align(
                                alignment: FractionalOffset.bottomRight,
                                child: Text(
                                  'Verifed',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.green,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Container(
                          child: Divider(
                              height: 5,
                              thickness: 1,
                              color: Color(0xff787D86)),
                        ),
                        /* TextFormField(
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
                          enabled: false,
                          controller: phoneNoController,
                            autocorrect: true,
                            decoration: InputDecoration(
                              hintText: 'Enter Phone Number',
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff787D86)),
                              ),
                            ),
                            */ /*validator: (String? value) {
                              phoneNumber = value!;
                              String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = new RegExp(patttern);
                              if (value.isEmpty) {
                                return 'Please enter mobile number';
                              } else if (!regExp.hasMatch(value)) {
                                return 'Please enter valid mobile number';
                              }
                            }*/ /*),*/

                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'Date of Birth',
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
                            border: InputBorder.none,
                          ),
                          onTap: () async {
                            var date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            dobController.text =
                                date.toString().substring(0, 10);
                          },
                        ),
                        Container(
                          child: Divider(
                              height: 5,
                              thickness: 1,
                              color: Color(0xff787D86)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Align(
                            alignment: FractionalOffset.topLeft,
                            child: Text(
                              'Address',
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
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 150,
                              child:  TextField(

                                 keyboardType: TextInputType.multiline,
                                  maxLines: 2,
                                  key: const Key('name'),
                                  controller: addressController,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0,
                                  ),
                                  decoration: InputDecoration(
                                     border: InputBorder.none,
                                      hintText: 'Enter Address'
                                  )
                              )
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10, top: 0),
                                child: Align(
                                  alignment: FractionalOffset.topRight,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.my_location,
                                    ),
                                    iconSize: 25,
                                    color: kYellowColor,
                                    splashColor: Colors.purple,
                                    onPressed: () async {
                                      Position position =
                                          await _getGeoLocationPosition();
                                      address =
                                          'Lat: ${position.latitude} , Long: ${position.longitude}';

                                      GetAddressFromLatLong(position);

                                      // getLocation();
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Divider(
                              height: 5,
                              thickness: 1,
                              color: Color(0xff787D86)),
                        ),
                      ],
                    ),
                  ),
                  /*Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Align(
                              alignment: FractionalOffset.topLeft,
                              child: Text(
                                'Address',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: ()
                              async {
                                */ /*Position position = await _getGeoLocationPosition();
                                location ='Lat: ${position.latitude} , Long: ${position.longitude}';
                                GetAddressFromLatLong(position);*/ /*

                              },
                              child:  Container(
                                padding: EdgeInsets.only(left: 10, top: 0),
                                child: Align(
                                  alignment: FractionalOffset.topRight,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.my_location,
                                    ),
                                    iconSize: 25,
                                    color: kYellowColor,
                                    splashColor: Colors.purple,
                                    onPressed: () async {
                                      Position position = await _getGeoLocationPosition();
                                location ='Lat: ${position.latitude} , Long: ${position.longitude}';
                                GetAddressFromLatLong(position);
                                     // getLocation();
                                    },
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                        TextFormField(
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                          autocorrect: true,
                          enabled: false,
                          controller: addressController,
                          decoration: InputDecoration(

                            hintText:Address,
                            hintStyle: TextStyle(color: Colors.black),
                            //labelText: Address,
                           // hintText: ' 132, My Street, Kingston...',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff787D86)),
                            ),
                          ),
                       */ /*   validator: (String? value) {
                            phoneNumber = value!;
                            if (value.isEmpty) {
                              return 'Please enter Your Address';
                            }
                          },*/ /*
                        ),
                      ],
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 100.0, right: 100.0, top: 25, bottom: 55),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: kYellowColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: FlatButton(
                        onPressed: () {
                          /* if (_formkey.currentState!.validate()) {
                            // nextScreen();
                            Fluttertoast.showToast(
                                msg: "Profile Save successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            saveScreen();
                            return;
                          }*/
                          _callUpdateProfile();
                        },
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void previousScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }

  void saveScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }

  _callGetProfile() async {
    var register_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      register_token = prefs.getString('AUTH_TOKEN') ?? '';
    }
    var client = http.Client();
    EasyLoading.show();
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.GET_PROFILE),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $register_token'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        name =dataAll['data']['name'].toString();
        fullNameController.text = name.toString();

        emailAddress =dataAll['data']['email'].toString();
        emailController.text = emailAddress.toString();

        dob =dataAll['data']['dob'].toString();
        dobController.text = dob.toString();


        address =dataAll['data']['address'].toString();
        addressController.text = address.toString();



        image=dataAll['data']['profile'].toString();

        if (image != null) {

          image = ApiConfig.app_base_url + dataAll['data']['profile'].toString();
        }

      /*  mobileNo =dataAll['data']['mobile'].toString();
        mobileNoController.text = mobileNo.toString();

        dob =dataAll['data']['dob'].toString();
        dobController.text = dob.toString();

        address =dataAll['data']['address'].toString();
        addressController.text = address.toString();*/

        /*if(dataAll['data']['name'].toString()!=null)
        {
          name =dataAll['data']['name'].toString();
          fullNameController.text = name.toString();
        }*/

      /*  if(dataAll['data']['email'].toString()!=null)
        {
          name =dataAll['data']['email'].toString();
          emailController.text = emailAddress.toString();
        }*/

       /*  if(dataAll['data']['mobile'].toString()!=null)
        {
          mobileNo =dataAll['data']['mobile'].toString();
          //mobileNoController.text = name.toString();
        }*/
        /* if(dataAll['data']['dob'].toString()!=null)
        {
          dob =dataAll['data']['dob'].toString();
          dobController.text = dob.toString();
        }*/

        /* if(dataAll['data']['address'].toString()!=null)
        {
          address =dataAll['data']['address'].toString();
          addressController.text = address.toString();
        }*/
      }
    } finally {
      client.close();
    }
  }

  _callUpdateProfile() async {
    EasyLoading.show(status: 'loading...');
    var register_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      register_token = prefs.getString('AUTH_TOKEN') ?? '';
    }
    prefs.setString('NAME', fullNameController.text);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $register_token',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.app_base_url + ApiConfig.PROFILE));
    request.headers.addAll(headers);
    // final file = await http.MultipartFile.fromPath('file', image);
    //request.files.add(file);
    //   request.fields['profile_pic'] = file.length as String;
    request.files.add(await http.MultipartFile.fromPath('profile_pic', image));
    request.fields['name'] = fullNameController.text.toString();
    request.fields['email'] = emailController.text.toString();
    request.fields['address'] = addressController.text.toString();
    request.fields['dob'] = dobController.text.toString();
    var res = await request.send();
    var vb = await http.Response.fromStream(res);
    var allJson = json.decode(vb.body);
    if (vb.statusCode == 200) {
      EasyLoading.dismiss();

      Fluttertoast.showToast(
          msg: allJson['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      print(allJson);
    } else {
      Fluttertoast.showToast(
          msg: allJson['message'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
      EasyLoading.dismiss();
      //Show Dialog
      print(res);
      print(res.statusCode);
    }
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
  }
}
