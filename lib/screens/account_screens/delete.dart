/*

import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
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

import 'package:http/http.dart' as http;
import 'package:spendzz_merchant/account_screen.dart';
import 'package:spendzz_merchant/login_signup/registration_webView.dart';
import 'package:spendzz_merchant/api_module/api_config.dart';
import 'package:spendzz_merchant/login_signup/signup_screen.dart';
import 'package:spendzz_merchant/resources/constants.dart';
import 'package:spendzz_merchant/utilities/ImageCropNewView.dart';
import 'package:url_launcher/url_launcher.dart';

import '../login_signup/about_business.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String phoneNumber='';
  late ProgressDialog pr;
  String location = 'Null, Press Button';
  late String Address;
  final Geolocator geolocator = Geolocator();
  bool descTextShowFlag = false;
  late String dropdownvalue='';
  late String id='';
  late String chooseValue='Choose One';
  late List<BusinessCategory> businessCategory;

  List<BusinessCategory> listBusinessCategoryDataArray = [];
  List<BusinessCategory> stateList = [];
  List<BusinessCategory> cityList = [];

  TextEditingController fullNameController = new TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController registrationProfController = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  bool is_login_status = false;
  var imgValueUser = '';
  late String aaa;
  String registrationProf = '';
  String fileType = 'All';
  var fileTypeList = ['All', 'Image', 'Video', 'Audio','MultipleFile'];
  FilePickerResult? result;
  PlatformFile? file;
  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  String _pdf = "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf";

  late String category='';

  late String state='';
  late String city='';
  late String mycity='';

  bool isOnCreat = true ;

  @override
  void initState() {
    super.initState();
    _checkToken();
    _callGetState();

  }

  Future getImageFromGallery() async {
    var pickedFile;
    var pickedFiletemp = await picker.getImage(source: ImageSource.gallery);
    var profimage = File(pickedFiletemp!.path);
    var aargs = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // set to false
        pageBuilder: (____, _, ___) => ImageCropNewViewFileData(profimage),
      ),
    );
    print(aargs);
    if (aargs != null) {
      pickedFile = (aargs as File);
    }
    setState(() {
      _image = pickedFile;
    });
    // _uploadImageToServerProfileImagevalue();
  }

  Future getImageFromCamera() async {
    var pickedFile;
    var pickedFiletemp = await picker.getImage(source: ImageSource.camera);
    var profimage = File(pickedFiletemp!.path);
    var aargs = await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // set to false
        pageBuilder: (____, _, ___) => ImageCropNewViewFileData(profimage),
      ),
    );
    print(aargs);
    if (aargs != null) {
      pickedFile = (aargs as File);
    }
    setState(() {
      _image = pickedFile;
    });
    // _uploadImageToServerProfileImagevalue();
  }

  _actionSheet(context) {
    return showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text('Choose Image'),
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Choose From Gallery'),
              onPressed: () {
                getImageFromGallery();
                Navigator.of(context).pop();
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Pick From Camera'),
              onPressed: () {
                getImageFromCamera();
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      is_login_status = true;
      _callBusinessCategoryApiInDataListings();

      if(isOnCreat){
        _callGetProfile(prefs.getString('AUTH_TOKEN').toString());
      }

    }
    setState(() {
    });
  }

  _callBusinessCategoryApiInDataListings() async {
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var register_token = prefs.getString('REGISTER_TOKEN') ?? '';
    mapBody['register_token'] = register_token;
    var client = http.Client();
    EasyLoading.show();
    try {
      var uriResponse = await client.post(Uri.parse(ApiConfig.app_base_url + ApiConfig.BUSINESS_CATEGORY), body: mapBody);
      var data = json.decode(uriResponse.body);

      print(data);
      EasyLoading.dismiss();

      if(uriResponse.statusCode == 200)
      {
        var arrData = data['data'];
        setState(() {
          listBusinessCategoryDataArray.clear();
        });
        for (var i=0; i<arrData.length; i++) {
          var dictFaq = arrData[i];
          var mdlProducts = BusinessCategory();
          mdlProducts.id = dictFaq['id'].toString();
          mdlProducts.name = dictFaq['name'].toString();
          listBusinessCategoryDataArray.add(mdlProducts);
          //print(mdlProducts.name = dictFaq['name'].toString());
        }
        setState(() {
        });
      }
    } finally {
      client.close();
    }
  }

  _callGetProfile(String tokenData) async {
    var client = http.Client();
    EasyLoading.show();

    debugPrint('sdjnfsjkdfsf'+'$tokenData');

    try {
      var uriResponse = await client.get( Uri.parse(ApiConfig.app_base_url + ApiConfig.GET_PROFILE),
          headers: {'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });

      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {

        fullNameController.text = dataAll['data']['name'].toString();
        emailController.text = dataAll['data']['email'].toString();
        phoneNumber = dataAll['data']['mobile'].toString();
        dobController.text = dataAll['data']['established'].toString();
        addressController.text = dataAll['data']['address'].toString();
        registrationProf=  dataAll['data']['registration_proof'].toString();

        category           =  dataAll['data']['category'].toString();
        imgValueUser       =  dataAll['profile_url'].toString()+ "/" +dataAll['data']['profile'].toString();

        state              =  dataAll['data']['state'].toString();
        mycity             =  dataAll['data']['city'].toString();

        _callGetCity(state);

        debugPrint('getstate $state');


        for (var i=0; i<stateList.length; i++) {
          if(stateID == stateList[i].id){
             state = stateList[i].name;
             debugPrint('getstate $state');
             break;
          }
        }



        //


        setState(() {});

      }

    } finally {  client.close(); }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));

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
            // key: _formkey,
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    padding: EdgeInsets.only( top: 10,),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 0,top: 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            child: CachedNetworkImage(
                                height: 80,
                                width: 80,
                                imageUrl: imgValueUser.toString(),
                                placeholder: (context, url) => Transform.scale(
                                  scale: 0.4,
                                  child: CircularProgressIndicator(
                                    color: kYellowColor,
                                    strokeWidth: 3,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                    height: 80,
                                    width: 80,
                                    child: Image.asset('assets/images/account_profile.png')
                                ),
                                fit: BoxFit.cover
                            ),
                          ),
                        ),
                        Container(
                          width: 80.0, height: 80.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: _image == null ? NetworkImage(imgValueUser.toString()) :
                                  FileImage(_image!) as ImageProvider, fit: BoxFit.cover
                              )
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            _actionSheet(context);
                          },
                          child: Align(
                            alignment:
                            FractionalOffset.bottomRight,
                            child: Container(
                              padding: EdgeInsets.only(left: 14,top: 23),
                              width: 35.00,
                              height: 35.00,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(13.0),
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
                        )

                      ],
                    ),
                  ),
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
                            decoration: InputDecoration(hintText: 'Enter Name'
                              // border: InputBorder.none,

                            ))
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
                    child: TextFormField(
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
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter Email Address',
                        hintStyle:
                        TextStyle(fontSize: 16.0, color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff787D86)),
                        ),
                      ),
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
                              phoneNumber,
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
                                  'Verified',
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
                      ],
                    ),
                  ),
                  SizedBox( height: 5,  ),
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
                          height: 1,
                        ),
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: TextField(
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
                                        hintText: 'Enter Address'))),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {},
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
                                      var address =
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
                  //select state
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'State *',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),

                        DropdownButtonFormField(
                          value: state.isNotEmpty ? state : null,
                          icon: Icon(Icons.arrow_drop_down),
                          decoration: InputDecoration(enabledBorder: UnderlineInputBorder( borderSide: BorderSide(  color: Colors.black54))),
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          hint: Text(state),
                          onChanged: (String? newValue) {

                            isOnCreat = false;
                            mycity ='';
                            state  = newValue.toString();

                            debugPrint('sdjnfsjkdfsf'+'$state');
                            _callGetCity(state);

                          },
                          items: stateList!.map((item)DropdownMenuItem<ProfessionCategory>>((ProfessionCategory values){
                                return new DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.name.toString(), style: TextStyle(color: Colors.black.withOpacity(0.7)),),
                                );
                              }).toList(),),

                      ],
                    ),
                  ),

                  //select city
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'City *',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),

                        DropdownButtonFormField(
                          value: city.isNotEmpty ? city : null,
                          icon: Icon(Icons.arrow_drop_down),
                          decoration: InputDecoration(enabledBorder: UnderlineInputBorder( borderSide: BorderSide(  color: Colors.black54))),
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          hint: Text(city),
                          onChanged: (String? newValue) {
                            city  = newValue.toString();

                            debugPrint('sdjnfsjkdfsf'+'$city');

                          },
                          items: cityList!.map(
                                  (item)
DropdownMenuItem<ProfessionCategory>>((ProfessionCategory values)
 {
                                return new DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.name.toString(), style: TextStyle(color: Colors.black.withOpacity(0.7)),
                                  ),
                                );
                              }).toList(),
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
                            'Category of Business *',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
DropdownButtonFormField(
                          value: category,
                          icon: Icon(Icons.arrow_drop_down),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black54))),
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          hint: Text(category),
                          onChanged: (value) {
                            setState(() {
                              if(value != null)
                                dropdownvalue = value.toString();
                             // id = value!.id;
                              category=value.toString();
                            });
                          },
                          items: listBusinessCategoryDataArray
                              .map<DropdownMenuItem<BusinessCategory>>((BusinessCategory values) {
                            return new DropdownMenuItem<BusinessCategory>(
                              value: values,
                              child: Text(values.name.toString(),style: TextStyle(
                                  color: Colors.black.withOpacity(0.7)
                              ),),
                            );
                          }).toList(),
                        ),


                        DropdownButtonFormField(
                          // value: category,
                          value: category.isNotEmpty ? category : null,
                          // value: chooseValueProfession,
                          icon: Icon(Icons.arrow_drop_down),
                          decoration: InputDecoration( enabledBorder: UnderlineInputBorder(borderSide: BorderSide(  color: Colors.black54))),
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          hint: Text(category),
                          onChanged: (String? newValue) {
                            category=newValue.toString();
                            category=newValue.toString();
setState(() {
                              if (newValue != null) {
                                category == newValue.toString();
                                setState(() {
                                });
                              }
                            });

                          },
                          items: listBusinessCategoryDataArray!.map(
                                  (item)
DropdownMenuItem<ProfessionCategory>>((ProfessionCategory values)
 {
                                return new DropdownMenuItem(
                                  value: item.id,
                                  child: Text(item.name.toString(), style: TextStyle(color: Colors.black.withOpacity(0.7)),
                                  ),
                                );
                              }).toList(),
                        ),

                      ],
                    ),
                  ),

                  SizedBox( height: 10, ),

                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'Established Since',
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
                                lastDate: new DateTime.now().subtract(new Duration(days: 0)));
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
                    padding: EdgeInsets.only(left: 25, right: 25, top: 15),
                    child: Column(
                      children: [
                        Align(
                          alignment: FractionalOffset.topLeft,
                          child: Text(
                            'Registration Proof',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: TextField(
                                    enabled: false,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0,
                                    ),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: registrationProf))),
                            Spacer(),
                            GestureDetector(
                              onTap: ()
                              {
                                final path = registrationProf;
                                var pdf=path.split(".").last;

                                if(pdf=="pdf")
                                {
                                  _launchUrlpdf();
                                }
                                else
                                {
                                  //_launchUrlOther();
                                  webViewScreen();
                                }
                                // _launchUrl();
                                // webViewScreen();
                              },child:  Text("view",
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w500,
                                color: kYellowColor,
                                fontStyle: FontStyle.normal,
                                fontSize: 14.0,
                              ),),
                            )

                          ],
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 5,),

                  Container(
                    padding: EdgeInsets.only(left: 25,right: 25),
                    child: Divider(
                        height: 5,
                        thickness: 1,
                        color: Color(0xff787D86)),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 100.0, right: 100.0, top: 25, bottom: 55),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: kYellowColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: FlatButton(
                        onPressed: () {


                          String patttern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = new RegExp(patttern);

                          if (emailController.text.isNotEmpty && !regExp.hasMatch(emailController.text)) {
                            EasyLoading.showToast('Please enter Valid Email Address.');
                            return;
                          } else if(state == ''){

                            EasyLoading.showToast('Please select your state.');

                          }else if(city == ''){

                            EasyLoading.showToast('Please select your city.');

                          }else {
                            _callUpdateProfile();
                          }

                          //_callUpdateProfile();
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
        MaterialPageRoute(builder: (context) => AccountScreen()));
  }

  void saveScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AccountScreen()));
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
        'POST', Uri.parse(ApiConfig.app_base_url + ApiConfig.PROFILE_UPDATE));
    request.headers.addAll(headers);
    if(_image!=null)
    {
      final file = await http.MultipartFile.fromPath('profile', _image!.path);
      request.files.add(file);
    }


    request.fields['name']        = fullNameController.text.toString();
    request.fields['email']       = emailController.text.toString();
    request.fields['address']     = addressController.text.toString();
    request.fields['established'] = dobController.text.toString();
    request.fields['category']    = category;

    request.fields['city']        = city;
    request.fields['state']       = state;

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
      saveScreen();
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


  _callGetState() async {

    var client = http.Client();
    // EasyLoading.show();
    try {
      var uriResponse = await client.get(Uri.parse(ApiConfig.GET_STATE));
      var dataAll = json.decode(uriResponse.body);
      // EasyLoading.dismiss();

      if (uriResponse.statusCode == 200) {

        var arrData = dataAll['data'];

        try {
          setState(() {
            stateList.clear();
          });
        } catch (e) {
          print(e);
        }

        for (var i=0; i<arrData.length; i++) {

          var dictFaq = arrData[i];
          var mdlProducts = BusinessCategory();
          mdlProducts.id = dictFaq['id'].toString();
          mdlProducts.name = dictFaq['name'].toString();
          stateList.add(mdlProducts);
        }

        setState(() { });
      } else{
        EasyLoading.showToast(dataAll['message'].toString());
      }
    } finally {
      client.close();
    }

  }

  _callGetCity(cityId) async {

    var client = http.Client();
    // EasyLoading.show();
    try {
      var uriResponse = await client.get(Uri.parse(ApiConfig.GET_CITY+cityId));
      var dataAll = json.decode(uriResponse.body);
      // EasyLoading.dismiss();

      if (uriResponse.statusCode == 200) {

        var arrData = dataAll['data'];

        try {
          setState(() {  cityList.clear(); });
        } catch (e) {print(e);}

        for (var i=0; i<arrData.length; i++) {

          var dictFaq = arrData[i];
          var mdlProducts       = BusinessCategory();
          mdlProducts.id        = dictFaq['id'].toString();
          mdlProducts.name      = dictFaq['name'].toString();
          mdlProducts.state_id  = dictFaq['state_id'].toString();
          cityList.add(mdlProducts);
        }

        city = mycity;

        setState(() { });

      } else{
        EasyLoading.showToast(dataAll['message'].toString());
      }
    } finally {
      client.close();
    }
  }


  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
  }

  _launchUrlpdf() async {
    if (await canLaunch(registrationProf)) {
      await launch(registrationProf,
forceSafariVC: true, forceWebView: true
);
    } else {
      throw 'Could not launch $registrationProf';
    }
  }

  webViewScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Registration_WebView(registrationProf)));
  }

}
class BusinessCategory {
  String id = '';
  String name = '';
  String state_id = '';
}
*/
