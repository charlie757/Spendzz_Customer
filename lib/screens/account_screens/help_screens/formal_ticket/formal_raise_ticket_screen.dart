import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/account_screens/account_screen.dart';
import 'package:spendzz/screens/account_screens/help_screens/normal_ticket/normal_help_screen.dart';
import 'package:spendzz/screens/account_screens/profile_screens/ImageCropNewView.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/all_category.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/category_details.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:http/http.dart' as http;
import '../../manage_cards_screens/input_formatters.dart';
class Fromal_Raise_Ticket extends StatefulWidget {
  static const String route = '/Raise_Ticket';
  @override
  _Fromal_Raise_TicketState createState() => _Fromal_Raise_TicketState();
}

class _Fromal_Raise_TicketState extends State<Fromal_Raise_Ticket> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  late String phoneNumber;

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<String> selectedItemValue = [];

  File? _image;
  final picker = ImagePicker();
  var imgValueUser = '';

  var imagePath = '';
  var imagePath_text = '';


  late String IssuesValue = '';
  late String? chooseValueProfession = 'Choose Issue';
  List<IssueList> issueListDataArray = [];


  var time = '';
   // 2016-01-25

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
        builder: (BuildContext context) =>
            CupertinoActionSheet(
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
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    var date = new DateTime.now().toString();

    var dateParse = DateTime.parse(date);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

    setState(() {

      time = formattedDate.toString() ;
      time = formattedDate.toString() ;

    });

    return WillPopScope(
        onWillPop: () async => true,
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
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: Column(
                  children: [
                  /*  Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 0, right: 5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Ticket Format',
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
                                      borderSide:
                                      BorderSide(color: Color(0xff787D86)),
                                    ),
                                  ),
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
                    SizedBox(
                      height: 10,
                    ),*/
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 0, right: 5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Title',
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
                                  controller: titleController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Title',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xff787D86)),
                                    ),
                                  ),
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
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 0, right: 5),
                            child: Column(
                              children: [
                                Align(
                                  alignment: FractionalOffset.topLeft,
                                  child: Text(
                                    'Description',
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
                                  controller: descriptionController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Description',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Color(0xff787D86)),
                                    ),
                                  ),
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
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 0, right: 5),
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
                                GestureDetector(
                                  onTap: ()
                                  {
                                    _actionSheet(context);
                                  },child:  Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: TextFormField(
                                            enabled: false,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  4),
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
                                              hintText:
                                              imagePath_text.toString(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _actionSheet(context);
                                        },
                                        child: Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                right: 25, top: 5),
                                            child: Align(
                                                alignment: FractionalOffset
                                                    .bottomRight,
                                                child: Icon(
                                                  Icons.drive_folder_upload,
                                                  color: kYellowColor,
                                                )),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
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
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 100,
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 0.0, bottom: 0),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Container(
                      height: 50,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 200,
                      decoration: BoxDecoration(
                          color: kYellowColor,
                          // borderRadius: BorderRadius.horizontal()),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: FlatButton(
                        onPressed: () {
                          if (titleController.text.isEmpty) {
                            EasyLoading.showToast('Please enter title.');
                          }
                          else if(descriptionController.text.isEmpty) {
                            EasyLoading.showToast('Please enter description.');
                          }
                          else{
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
        'POST', Uri.parse(ApiConfig.app_base_url + ApiConfig.SUBMIT_FORMAL_TICKETS));
    request.headers.addAll(headers);
    if(_image!=null)
    {
      final file = await http.MultipartFile.fromPath('attachment', _image!.path);
      request.files.add(file);
    }
    request.fields['title'] = titleController.text.toString();
    request.fields['description'] = descriptionController.text.toString();
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
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => NormalHelpScreen('')));

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