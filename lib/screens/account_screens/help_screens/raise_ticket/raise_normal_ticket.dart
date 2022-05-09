import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/account_screens/account_screen.dart';
import 'package:spendzz/screens/account_screens/profile_screens/ImageCropNewView.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/all_category.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/category_details.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
import '../../manage_cards_screens/input_formatters.dart';
import '../normal_ticket/all_help_ticket_screen.dart';

class Raise_Ticket_Normal extends StatefulWidget {
  static const String route = '/Raise_Ticket_Normal';

  var transaction_ID = '';
  Raise_Ticket_Normal(this.transaction_ID);
  @override
  _Raise_Ticket_NormalState createState() =>
      _Raise_Ticket_NormalState(transaction_ID);
}

class _Raise_Ticket_NormalState extends State<Raise_Ticket_Normal> {
  _Raise_Ticket_NormalState(this.transaction_ID);
  var transaction_ID = '';
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  late String phoneNumber;

  TextEditingController transactionIdController = new TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  List<String> selectedItemValue = [];

  File? _image;
  final picker = ImagePicker();
  var imgValueUser = '';

  var imagePath = '';
  var imagePath_text = '';

  late String IssuesValue = '';
  late String? chooseValueProfession = 'Choose Issue';
  List<IssueList> issueListDataArray = [];

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
      _image = pickedFile;
      imagePath = _image!.path.toString();
      imagePath_text = imagePath.substring(imagePath.length - 16);
      imageController.text = imagePath_text;
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
      imagePath = _image!.path.toString();
      imagePath_text = imagePath.substring(imagePath.length - 16);
      imageController.text = imagePath_text;
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
            ));
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callIssueDataListings(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {});
  }

  _callIssueDataListings(String tokenData) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokenData',
    };
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url + ApiConfig.TICKETS_ISSUE),
          headers: headers);
      var data = json.decode(uriResponse.body);
      print(data);
      EasyLoading.dismiss();

      if (uriResponse.statusCode == 200) {
        var arrData = data['data'];
        setState(() {
          issueListDataArray.clear();
        });
        for (var i = 0; i < arrData.length; i++) {
          var dictFaq = arrData[i];
          var mdlProducts = IssueList();
          mdlProducts.id = dictFaq['title'].toString();
          mdlProducts.title = dictFaq['title'].toString();
          issueListDataArray.add(mdlProducts);
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
        onWillPop: () async => true,
        child: Scaffold(
          // key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              // systemOverlayStyle:
              //     SystemUiOverlayStyle(statusBarColor: Colors.white),
              elevation: 0,
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
                "Raise Ticket",
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
          body: Container(
            // color: Colors.red,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction ID',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      TextField(
                          enabled: false,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                          decoration: InputDecoration(
                              hintText: transaction_ID.toString(),
                              hintStyle: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 14.0)
                              // border: InputBorder.none,

                              )),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Issue',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      DropdownButtonFormField(
                        icon: Icon(Icons.arrow_drop_down),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54))),
                        iconSize: 24,
                        elevation: 16,
                        isExpanded: true,
                        hint: Text(chooseValueProfession!),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              chooseValueProfession = newValue;
                              /*chooseValueProfession == newValue;
                                          IssuesValue = newValue.toString();
                                          chooseValueProfession =
                                              newValue.toString();*/
                            }
                          });
                        },
                        items: issueListDataArray.map((item) {
                          return new DropdownMenuItem(
                            value: item.id.toString(),
                            child: Text(
                              item.title.toString(),
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Message',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      TextFormField(
                        minLines: 1,
                        maxLines: 5,
                        // allow user to enter 5 line in textfield
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0,
                        ),
                        autocorrect: true,
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: 'Enter Message',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff787D86)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Upload Image',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            _actionSheet(context);
                          },
                          child: TextFormField(
                            readOnly: true,
                            controller: imageController,
                            // enabled: false,

                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              // fontWeight: FontWeight.w300,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            autocorrect: true,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                              onTap: () {
                                _actionSheet(context);
                              },
                              child: Icon(
                                Icons.drive_folder_upload,
                                color: kYellowColor,
                              ),
                            )),
                          )),
                    ],
                  ),
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
                    onPressed: () {
                      if (chooseValueProfession == 'Choose Issue') {
                        EasyLoading.showToast('Please select Issue');
                      } else if (messageController.text.isEmpty) {
                        EasyLoading.showToast('Please enter Message.');
                      } else {
                        _callSubmitTicket();
                      }
                    },
                    child: Text(
                      'Submit Ticket',
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

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }

  _callSubmitTicket() async {
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
        'POST', Uri.parse(ApiConfig.app_base_url + ApiConfig.SUBMIT_TICKETS));
    request.headers.addAll(headers);
    if (_image != null) {
      final file =
          await http.MultipartFile.fromPath('attachment', _image!.path);
      request.files.add(file);
    }
    request.fields['transaction_id'] = transaction_ID.toString();
    request.fields['issue_type'] = chooseValueProfession.toString();
    request.fields['message'] = messageController.text.toString();
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AllHelpTicket('')));
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

class IssueList {
  String id = '';
  String title = '';
}
