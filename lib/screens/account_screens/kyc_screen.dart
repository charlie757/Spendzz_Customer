import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/account_screens/account_screen.dart';
import 'package:spendzz/screens/account_screens/manage_cards_screens/payment_card.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/category_details.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
import 'profile_screens/ImageCropNewView.dart';
import 'manage_cards_screens/input_formatters.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  cameras = await availableCameras();
  runApp(Kyc_screen());
}

class Kyc_screen extends StatefulWidget {
  static const String route = '/Kyc_screen';
  final List<CameraDescription>? cameras;

  const Kyc_screen({this.cameras, Key? key}) : super(key: key);

  //const Kyc_screen({Key? key}) : super(key: key);

  @override
  _Kyc_screenState createState() => _Kyc_screenState();
}

class _Kyc_screenState extends State<Kyc_screen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  late String phoneNumber;
  var _paymentCard = PaymentCard();
  var image;
  late String aadhaarCard;
  TextEditingController aadhaarNoController = new TextEditingController();
  late String SelectType;
  var imagesBaseUrl = '';
  var aadhaarBackImage = '';
  var selfieImage = '';
  File? _aadhaarFrontImage;
  File? _aadhaarBackImage;
  File? _selfieImage;
  var kyc_status = 0;

  //File? _image;
  final picker = ImagePicker();
  bool is_login_status = false;
  var aadhaarFrontImage = '';
  late String statusText = '';
  late String massageText = '';

  //profession Data
  late String ProfessionId = '';
  late String? chooseValueProfession = '';
  List<ProfessionCategory> listProfessionCategoryDataArray = [];

  //Salary Data
  late String SalaryId = '';
  late String chooseValueSalary = '';
  List<SalaryCategory> listSalaryCategoryDataArray = [];
  bool KycStatusBool = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _actionSheet_aadhaarFrontImage(context) {
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
                    getImageFromGallery_aadhaarFrontImage();
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text('Pick From Camera'),
                  onPressed: () {
                    getImageFromCamera_aadhaarFrontImage();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future getImageFromGallery_aadhaarFrontImage() async {
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
      _aadhaarFrontImage = pickedFile;
    });
  }

  Future getImageFromCamera_aadhaarFrontImage() async {
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
      _aadhaarFrontImage = pickedFile;
    });
  }

  Future getImageFromGallery_aadhaarBackImage() async {
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
      _aadhaarBackImage = pickedFile;
    });
    // _uploadImageToServerProfileImagevalue();
  }

  Future getImageFromCamera_aadhaarBackImage() async {
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
      _aadhaarBackImage = pickedFile;
    });
  }

  _actionSheet_aadhaarBackImage(context) {
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
                    getImageFromGallery_aadhaarBackImage();
                    Navigator.of(context).pop();
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text('Pick From Camera'),
                  onPressed: () {
                    getImageFromCamera_aadhaarBackImage();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future getImageFromCamera_selfieImage() async {
    var pickedFile;
    var pickedFiletemp = await picker.getImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
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
      _selfieImage = pickedFile;
    });
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      is_login_status = true;
      _callProfessionCategoryApiInDataListings(
          prefs.getString('AUTH_TOKEN').toString());
      _callSalaryCategoryApiInDataListings(
          prefs.getString('AUTH_TOKEN').toString());
      _callGetKycDetails(prefs.getString('AUTH_TOKEN').toString());
      _callGetKysStatus(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {});
  }

  _callGetKysStatus(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.GET_KYC_STATUS),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        kyc_status = dataAll['kyc_is_submitted'];
        KycStatusBool = dataAll['status'];
        if (kyc_status == 1 && KycStatusBool == true) {
          statusText = "KYC Approved";
        } else if (kyc_status == 0 && KycStatusBool == false) {
          statusText = "KYC Rejected";
        } else if (kyc_status == 1 && KycStatusBool == false) {
          statusText = "KYC Under Process";
        } else if (kyc_status == 2 && KycStatusBool == false) {
          statusText = "";
        }
        /*if (kyc_status == 0) {
          statusText = "Reject";
        } else {
          statusText = 'Approved';
        }*/
        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  _callGetKycDetails(String tokenData) async {
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.post(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.GET_KYC_DETAILS),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenData'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        var arrData = dataAll['data'];
        if (dataAll['status'] == false) {}

        imagesBaseUrl = dataAll['file_url'].toString();
        for (var i = 0; i < arrData.length; i++) {
          var dictFaq = arrData[i];

          if (dictFaq['kyc_status'].toString() == "2") {
            //chooseValueProfession = dictFaq['profession_type'].toString();
            //chooseValueSalary = dictFaq['salary'].toString();
            chooseValueProfession = "";
            chooseValueSalary = "";
          } else {
            aadhaarNoController.text = dictFaq['aadhar_no'].toString();
            aadhaarFrontImage =
                imagesBaseUrl + "/" + dictFaq['aadhar_front'].toString();
            aadhaarBackImage =
                imagesBaseUrl + "/" + dictFaq['aadhar_back'].toString();
            selfieImage = imagesBaseUrl + "/" + dictFaq['selfie'].toString();
            chooseValueProfession = dictFaq['profession_type'].toString();
            chooseValueSalary = dictFaq['salary'].toString();
            _callProfessionCategoryApiInDataListings(tokenData);
          }

          setState(() {});
        }
      }
    } finally {
      client.close();
    }
  }

  _callProfessionCategoryApiInDataListings(
    String tokenData,
  ) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenData',
    };
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.PROFESSION_TYPE),
          headers: headers);
      var data = json.decode(uriResponse.body);
      print(data);
      EasyLoading.dismiss();

      if (uriResponse.statusCode == 200) {
        var arrData = data['data'];
        setState(() {
          listProfessionCategoryDataArray.clear();
        });
        for (var i = 0; i < arrData.length; i++) {
          var dictFaq = arrData[i];
          var mdlProducts = ProfessionCategory();
          mdlProducts.id = dictFaq['id'].toString();
          mdlProducts.name = dictFaq['title'].toString();
          //chooseValueProfession=mdlProducts.id;
          listProfessionCategoryDataArray.add(mdlProducts);
        }
        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  _callSalaryCategoryApiInDataListings(String tokenData) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenData',
    };
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.SALARY),
          headers: headers);
      var data = json.decode(uriResponse.body);
      print(data);
      EasyLoading.dismiss();

      if (uriResponse.statusCode == 200) {
        var arrData = data['data'];
        setState(() {
          listSalaryCategoryDataArray.clear();
        });
        for (var i = 0; i < arrData.length; i++) {
          var dictFaq = arrData[i];
          var mdlProducts = SalaryCategory();
          mdlProducts.id = dictFaq['id'].toString();
          mdlProducts.amount = dictFaq['title'].toString();
          // chooseValueSalary=mdlProducts.id;
          listSalaryCategoryDataArray.add(mdlProducts);
        }
        setState(() {});
      }
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return WillPopScope(
        onWillPop: () async {
          previousScreen();
          return true;
        },
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
                "KYC",
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
            physics: AlwaysScrollableScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (kyc_status == 1 && KycStatusBool == true) ...[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 58,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: klightYelloColor,
                                  // No such attribute
                                ),
                                child: Align(
                                  alignment: FractionalOffset.center,
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )),
                          ] else if (kyc_status == 0 &&
                              KycStatusBool == false) ...[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 58,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: klightYelloColor,
                                  // No such attribute
                                ),
                                child: Align(
                                  alignment: FractionalOffset.center,
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )),
                          ] else if (kyc_status == 1 &&
                              KycStatusBool == false) ...[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 58,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: klightYelloColor,
                                  // No such attribute
                                ),
                                child: Align(
                                  alignment: FractionalOffset.center,
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.orangeAccent,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )),
                          ] else
                            ...[],

                          //todo Profession DropDown Code
                          Container(
                            padding:
                                EdgeInsets.only(left: 0, right: 0, top: 15),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 15),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: FractionalOffset.topLeft,
                                        child: Text(
                                          'Profession',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      if (kyc_status == 0 &&
                                              KycStatusBool == false ||
                                          kyc_status == 2 &&
                                              KycStatusBool == false) ...[
                                        DropdownButtonFormField(
                                          value:
                                              chooseValueProfession!.isNotEmpty
                                                  ? chooseValueProfession
                                                  : null,
                                          icon: Icon(Icons.arrow_drop_down),
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.black54))),
                                          iconSize: 24,
                                          elevation: 16,
                                          isExpanded: true,
                                          hint: Text(
                                              chooseValueProfession.toString()),
                                          onChanged: (String? newValue) {
                                            chooseValueProfession =
                                                newValue.toString();
                                            debugPrint('sdjnfsjkdfsf' +
                                                '$chooseValueProfession');
                                          },
                                          items: listProfessionCategoryDataArray
                                              .map((item) {
                                            return new DropdownMenuItem(
                                              value: item.id,
                                              child: Text(
                                                item.name.toString(),
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ] else ...[
                                        DropdownButtonFormField(
                                          value:
                                              chooseValueProfession!.isNotEmpty
                                                  ? chooseValueProfession
                                                  : null,
                                          icon: Icon(Icons.arrow_drop_down),
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.black54))),
                                          iconSize: 24,
                                          elevation: 16,
                                          isExpanded: true,
                                          hint: Text(
                                              chooseValueProfession.toString()),
                                          onChanged: null,
                                          items: listProfessionCategoryDataArray
                                              .map((item) {
                                            return new DropdownMenuItem(
                                              value: item.id,
                                              child: Text(
                                                item.name.toString(),
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //todo Salary DropDown Code
                          Container(
                            padding:
                                EdgeInsets.only(left: 0, right: 0, top: 15),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 15),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: FractionalOffset.topLeft,
                                        child: Text(
                                          'Salary',
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w300,
                                            color: Colors.black,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      if (kyc_status == 0 &&
                                              KycStatusBool == false ||
                                          kyc_status == 2 &&
                                              KycStatusBool == false) ...[
                                        DropdownButtonFormField(
                                          value: chooseValueSalary.isNotEmpty
                                              ? chooseValueSalary
                                              : null,
                                          icon: Icon(Icons.arrow_drop_down),
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.black54))),
                                          iconSize: 24,
                                          elevation: 16,
                                          isExpanded: true,
                                          hint: Text(
                                              chooseValueSalary.toString()),
                                          onChanged: (String? newValue) {
                                            chooseValueSalary =
                                                newValue.toString();
                                            debugPrint('sdjnfsjkdfsf' +
                                                '$chooseValueSalary');
                                          },
                                          items: listSalaryCategoryDataArray
                                              .map((item) {
                                            return new DropdownMenuItem(
                                              value: item.id,
                                              child: Text(
                                                item.amount.toString(),
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ] else ...[
                                        DropdownButtonFormField(
                                          value: chooseValueSalary.isNotEmpty
                                              ? chooseValueSalary
                                              : null,
                                          icon: Icon(Icons.arrow_drop_down),
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Colors.black54))),
                                          iconSize: 24,
                                          elevation: 16,
                                          isExpanded: true,
                                          hint: Text(
                                              chooseValueSalary.toString()),
                                          onChanged: null,
                                          items: listSalaryCategoryDataArray
                                              .map((item) {
                                            return new DropdownMenuItem(
                                              value: item.id,
                                              child: Text(
                                                item.amount.toString(),
                                                style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Aadhaar Number',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                if (kyc_status == 0 || kyc_status == 2) ...[
                                  TextField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        //LengthLimitingTextInputFormatter(12),
                                        FilteringTextInputFormatter.digitsOnly,
                                        new LengthLimitingTextInputFormatter(
                                            12),
                                        // new CardNumberInputFormatter()
                                      ],
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                      autocorrect: true,
                                      controller: aadhaarNoController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Aadhaar Number',
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff787D86)),
                                        ),
                                      ))
                                ] else ...[
                                  TextField(
                                      enableInteractiveSelection: false,
                                      // will disable paste operation
                                      enabled: false,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(12),
                                      ],
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                      autocorrect: true,
                                      controller: aadhaarNoController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Aadhaar Number',
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff787D86)),
                                        ),
                                      ))
                                ],
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Upload Aadhaar Front",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0, top: 0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0)),
                                                      child: CachedNetworkImage(
                                                          height: 87,
                                                          width: 165,
                                                          imageUrl:
                                                              aadhaarFrontImage,
                                                          placeholder: (context,
                                                                  url) =>
                                                              Transform.scale(
                                                                scale: 0.4,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color:
                                                                      kYellowColor,
                                                                  strokeWidth:
                                                                      3,
                                                                ),
                                                              ),
                                                          /*CircularProgressIndicator(
                                                        color: kYellowColor,

                                                      ),*/
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                                  height: 145,
                                                                  width: 165,
                                                                  child: Container(
                                                                      decoration: BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.black38,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      child: Center(
                                                                          child: Image.asset(
                                                                        'assets/images/upload.png',
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
                                                                      )))
                                                                  /*Image.asset('assets/images/upload.png')*/
                                                                  ),
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ),
                                                  if (kyc_status == 0 ||
                                                      kyc_status == 2) ...[
                                                    GestureDetector(
                                                      onTap: () {
                                                        _actionSheet_aadhaarFrontImage(
                                                            context);
                                                      },
                                                      child: Container(
                                                        height: 87,
                                                        width: 165,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            image: DecorationImage(
                                                                image: _aadhaarFrontImage ==
                                                                        null
                                                                    ? NetworkImage(
                                                                        aadhaarFrontImage
                                                                            .toString())
                                                                    : FileImage(
                                                                            _aadhaarFrontImage!)
                                                                        as ImageProvider,
                                                                fit: BoxFit
                                                                    .fill)),
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: 87,
                                                        width: 165,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            image: DecorationImage(
                                                                image: _aadhaarFrontImage ==
                                                                        null
                                                                    ? NetworkImage(
                                                                        aadhaarFrontImage
                                                                            .toString())
                                                                    : FileImage(
                                                                            _aadhaarFrontImage!)
                                                                        as ImageProvider,
                                                                fit: BoxFit
                                                                    .fill)),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Upload Aadhaar Back",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0, top: 0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0)),
                                                      child: CachedNetworkImage(
                                                          height: 87,
                                                          width: 165,
                                                          imageUrl:
                                                              aadhaarBackImage
                                                                  .toString(),
                                                          placeholder: (context,
                                                                  url) =>
                                                              Transform.scale(
                                                                scale: 0.4,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color:
                                                                      kYellowColor,
                                                                  strokeWidth:
                                                                      3,
                                                                ),
                                                              ),
                                                          /*CircularProgressIndicator(
                                                        color: kYellowColor,

                                                      ),*/
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Container(
                                                                  height: 145,
                                                                  width: 165,
                                                                  child: Container(
                                                                      decoration: BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              Colors.black38,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
                                                                      ),
                                                                      child: Center(
                                                                          child: Image.asset(
                                                                        'assets/images/upload.png',
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
                                                                      )))
                                                                  /*Image.asset('assets/images/upload.png')*/
                                                                  ),
                                                          fit: BoxFit.fill),
                                                    ),
                                                  ),
                                                  if (kyc_status == 0 ||
                                                      kyc_status == 2) ...[
                                                    GestureDetector(
                                                      onTap: () {
                                                        _actionSheet_aadhaarBackImage(
                                                            context);
                                                      },
                                                      child: Container(
                                                        height: 87,
                                                        width: 165,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            image: DecorationImage(
                                                                image: _aadhaarBackImage ==
                                                                        null
                                                                    ? NetworkImage(
                                                                        aadhaarBackImage
                                                                            .toString())
                                                                    : FileImage(
                                                                            _aadhaarBackImage!)
                                                                        as ImageProvider,
                                                                fit: BoxFit
                                                                    .fill)),
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: 87,
                                                        width: 165,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            image: DecorationImage(
                                                                image: _aadhaarBackImage ==
                                                                        null
                                                                    ? NetworkImage(
                                                                        aadhaarBackImage
                                                                            .toString())
                                                                    : FileImage(
                                                                            _aadhaarBackImage!)
                                                                        as ImageProvider,
                                                                fit: BoxFit
                                                                    .fill)),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Upload Selfie",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 0, top: 0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          child: CachedNetworkImage(
                                              height: 145,
                                              width: 165,
                                              imageUrl: selfieImage.toString(),
                                              placeholder: (context, url) =>
                                                  Transform.scale(
                                                    scale: 0.4,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: kYellowColor,
                                                      strokeWidth: 3,
                                                    ),
                                                  ),
                                              /*CircularProgressIndicator(
                                                        color: kYellowColor,

                                                      ),*/
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Container(
                                                      height: 145,
                                                      width: 165,
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors
                                                                  .black38,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: Center(
                                                              child:
                                                                  Image.asset(
                                                            'assets/images/upload.png',
                                                            height: 50,
                                                            width: 50,
                                                          )))
                                                      /*Image.asset('assets/images/upload.png')*/
                                                      ),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      if (kyc_status == 0 ||
                                          kyc_status == 2) ...[
                                        GestureDetector(
                                          onTap: () async {
                                            getImageFromCamera_selfieImage();
                                          },
                                          child: Container(
                                            height: 145,
                                            width: 165,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                image: DecorationImage(
                                                    image: _selfieImage == null
                                                        ? NetworkImage(
                                                            selfieImage
                                                                .toString())
                                                        : FileImage(
                                                                _selfieImage!)
                                                            as ImageProvider,
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                      ] else ...[
                                        GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                            height: 145,
                                            width: 165,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                image: DecorationImage(
                                                    image: _selfieImage == null
                                                        ? NetworkImage(
                                                            selfieImage
                                                                .toString())
                                                        : FileImage(
                                                                _selfieImage!)
                                                            as ImageProvider,
                                                    fit: BoxFit.fill)),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
            child: Stack(
              children: [
                if (kyc_status == 0 || kyc_status == 2) ...[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 0),
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
                          onPressed: () {
                            String patttern = r'(^(?:[+0]9)?[0-9]{12,12}$)';
                            RegExp regExp = new RegExp(patttern.trim());
                            if (chooseValueProfession == '') {
                              EasyLoading.showToast(
                                  'Please select Profession Category');
                            } else if (chooseValueSalary == '') {
                              EasyLoading.showToast(
                                  'Please select Salary Category');
                            } else if (aadhaarNoController.text.isEmpty) {
                              EasyLoading.showToast('Please Enter Aadhaar No');
                              return;
                            } else if (!regExp
                                .hasMatch(aadhaarNoController.text)) {
                              EasyLoading.showToast(
                                  'Please Enter 12 Digits Aadhaar No');
                              return;
                            } else if (_aadhaarFrontImage == null) {
                              EasyLoading.showToast(
                                  'Please select Aadhaar Front Image.');
                            } else if (_aadhaarBackImage == null) {
                              EasyLoading.showToast(
                                  'Please select Aadhaar Back Image.');
                            } else if (_selfieImage == null) {
                              EasyLoading.showToast(
                                  'Please select SelfieImage.');
                            } else {
                              _callUpdateKyc();
                            }
                          },
                          child: Text(
                            'Submit',
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
                  )
                ] else
                  ...[],
              ],
            ),
          )),
        ));
  }

  void nextScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CategoryDetails('', '', '')));
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }

  _callUpdateKyc() async {
    EasyLoading.show(status: 'loading...');
    var register_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      register_token = prefs.getString('AUTH_TOKEN') ?? '';
    }
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $register_token',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConfig.app_base_url + ApiConfig.ADD_KYC_DETAILS));
    request.headers.addAll(headers);

    if (_aadhaarFrontImage != null) {
      final fileAadhar_front = await http.MultipartFile.fromPath(
          'aadhar_front', _aadhaarFrontImage!.path);
      request.files.add(fileAadhar_front);
    }

    if (_aadhaarBackImage != null) {
      final fileAadhar_back = await http.MultipartFile.fromPath(
          'aadhar_back', _aadhaarBackImage!.path);
      request.files.add(fileAadhar_back);
    }

    if (_selfieImage != null) {
      final fileSelfie =
          await http.MultipartFile.fromPath('selfie', _selfieImage!.path);
      request.files.add(fileSelfie);
    }
    request.fields['aadhar_card_no'] = aadhaarNoController.text.toString();
    request.fields['profession_type'] = chooseValueProfession.toString();
    request.fields['salary'] = chooseValueSalary.toString();
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
      setState(() {});
      _callGetKycDetails(prefs.getString('AUTH_TOKEN').toString());
      previousScreen();
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
}

class ProfessionCategory {
  String id = '';
  String name = '';
}

class SalaryCategory {
  String id = '';
  String amount = '';
}
