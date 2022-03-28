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
import 'normal_help_screen.dart';

class Raise_Ticket_Normal_Detail extends StatefulWidget {
  var ticketId = '';
  var message = '';

  Raise_Ticket_Normal_Detail(this.ticketId,this.message);
  @override
  _Raise_Ticket_Normal_DetailState createState() => _Raise_Ticket_Normal_DetailState(ticketId,message);
}

class _Raise_Ticket_Normal_DetailState extends State<Raise_Ticket_Normal_Detail> {

  _Raise_Ticket_Normal_DetailState(this.ticketId,this.message);
  var ticketId='';
  var message = '';
  late String phoneNumber;

  List<TicketDetails> ticketDetails = [];
  var isDataFetched = false;

  String ticketNumber = '';
  String raisedOn = '';
  String issue = '';

  File? _image;
  final picker = ImagePicker();
  var imgValueUser = '';

  var imagePath = '';
  var imagePath_text = '';


  var massageType='';

  TextEditingController commantController = TextEditingController();


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
    _checkToken();
  }
  _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      _callTransactionHistory(prefs.getString('AUTH_TOKEN').toString());
    }
    setState(() {});
  }

  _callTransactionHistory(String tokenData) async {
    var auth_token = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('AUTH_TOKEN') != null) {
      auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    }
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      var uriResponse = await client.get(
          Uri.parse(ApiConfig.app_base_url +
              ApiConfig.TICKET_REPLAY_LIST +
              /*ticketId.toString()*/'12374850'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $auth_token'
          });
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      setState(() {
        ticketDetails.clear();
      });
      if (uriResponse.statusCode == 200) {
        ticketNumber = dataAll['top_data']['tid'];
        issue = dataAll['top_data']['issue_type'];
        var dateTime = dataAll['top_data']['created_at'];
        var date = dateTime.split('T');
        var date1 = date[0].trim();
        var time = dateTime.split('T') + dateTime.split('.');
        var time1 = time[1].trim();
        var time2 = time1.split('.');
        var timeFinal = time2[0].trim();
        raisedOn = date1 + ", " + timeFinal;
        // raisedOn = dataAll['top_data']['created_at'];
        var arrResults = dataAll['data'];
        isDataFetched = true;
        for (var i = 0; i < arrResults.length; i++) {
          var dictResult = arrResults[i];
          var mdlSubData = TicketDetails();
          mdlSubData.date = dictResult['date_time'].toString();
          mdlSubData.message = dictResult['message'].toString();
          mdlSubData.type=dictResult['utype'].toString();
          mdlSubData.name=dictResult['get_user_info']['name'].toString();

          massageType=dictResult['utype'].toString();


          /* mdlSubData.type = dictResult['type'].toString();
          mdlSubData.transaction_id = dictResult['un_id'].toString();*/

          ticketDetails.add(mdlSubData);
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
                        '#' + ticketId,
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
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 15),
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Ticket Number",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff303030),
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Container(
                                child: Expanded(
                                    child: Text(
                                      ticketNumber.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff303030),
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                    )))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "Raised On",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff303030),
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Container(
                                child: Expanded(
                                    flex: 1,
                                    child: Text(
                                      raisedOn.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff303030),
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                    )))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                issue.toString(),
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff303030),
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Container(
                                child: Expanded(
                                    child: Text(
                                      "Payment Failed",
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff303030),
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                    )))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Message",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w300,
                            color: kYellowColor,
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          message,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w500,
                            color: Color(0xff303030),
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0,
                          ),
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
                  Container(
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(left: 5,right: 5),
                        child: Column(
                          children: <Widget>[
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: ticketDetails.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (ctx, index) {
                                var mdlSubData = ticketDetails[index];
                                return Container(
                                  child: Column(
                                    children: [
                                      if(mdlSubData.type=="customer")...[
                                        Card(
                                          elevation: 0,
                                          child:  GestureDetector(
                                            onTap: () {
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xffe3dcdc),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(30.0),
                                                  bottomLeft: Radius.circular(30.0),
                                                  bottomRight: Radius.circular(30.0),
                                                  topLeft: Radius.circular(30.0),
                                                ),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.all(12.0),
                                                padding: EdgeInsets.only(left: 5),
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(left: 15,right: 15),
                                                            width: 48.00,
                                                            height: 48.00,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              color: Colors.red,
                                                              image: DecorationImage(
                                                                scale: 2,
                                                                image: ExactAssetImage(
                                                                    'assets/images/makepayment.png'),
                                                                fit: BoxFit.scaleDown,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Container(
                                                            padding: EdgeInsets.only(
                                                              top: 15,
                                                              right: 15,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Container(
                                                                    alignment: Alignment.topLeft,
                                                                    child: Text(
                                                                      mdlSubData.name,
                                                                      style: TextStyle(
                                                                        fontFamily: 'Rubik',
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.black,
                                                                        letterSpacing: 2,
                                                                        fontStyle: FontStyle.normal,
                                                                        fontSize: 16.0,
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Container(
                                                                    alignment: Alignment.topLeft,
                                                                    child: Text(
                                                                      mdlSubData.date,
                                                                      style: TextStyle(
                                                                        fontFamily: 'Rubik',
                                                                        fontWeight: FontWeight.w300,
                                                                        color: Colors.black,
                                                                        fontStyle: FontStyle.normal,
                                                                        fontSize: 14.0,
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                              padding: EdgeInsets.only(left: 5),
                                                              child: Text(
                                                                mdlSubData.message,
                                                                style: TextStyle(
                                                                  fontFamily: 'Rubik',
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.black,
                                                                  letterSpacing: 2,
                                                                  fontStyle: FontStyle.normal,
                                                                  fontSize: 16.0,
                                                                ),
                                                              )
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),),
                                      ]
                                      else...[
                                        Card(
                                          elevation: 0,
                                          child:  GestureDetector(
                                            onTap: () {
                                              // nextScreen();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.all(2.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xffeea059),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(30.0),
                                                  bottomLeft: Radius.circular(30.0),
                                                  bottomRight: Radius.circular(30.0),
                                                  topLeft: Radius.circular(30.0),
                                                ),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.all(12.0),
                                                padding: EdgeInsets.only(left: 5),
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets.only(left: 15,right: 15),
                                                            width: 48.00,
                                                            height: 48.00,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20.0),
                                                              color: Colors.red,
                                                              image: DecorationImage(
                                                                scale: 2,
                                                                image: ExactAssetImage(
                                                                    'assets/images/makepayment.png'),
                                                                fit: BoxFit.scaleDown,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Container(
                                                            padding: EdgeInsets.only(
                                                              top: 15,
                                                              right: 15,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                Container(
                                                                    alignment: Alignment.topLeft,
                                                                    child: Text(
                                                                      mdlSubData.name,
                                                                      style: TextStyle(
                                                                        fontFamily: 'Rubik',
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.black,
                                                                        letterSpacing: 2,
                                                                        fontStyle: FontStyle.normal,
                                                                        fontSize: 16.0,
                                                                      ),
                                                                    )),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Container(
                                                                    alignment: Alignment.topLeft,
                                                                    child: Text(
                                                                      mdlSubData.date,
                                                                      style: TextStyle(
                                                                        fontFamily: 'Rubik',
                                                                        fontWeight: FontWeight.w300,
                                                                        color: Colors.black,
                                                                        fontStyle: FontStyle.normal,
                                                                        fontSize: 14.0,
                                                                      ),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                              padding: EdgeInsets.only(left: 5),
                                                              child: Text(
                                                                mdlSubData.message,
                                                                style: TextStyle(
                                                                  fontFamily: 'Rubik',
                                                                  fontWeight: FontWeight.w500,
                                                                  color: Colors.black,
                                                                  letterSpacing: 2,
                                                                  fontStyle: FontStyle.normal,
                                                                  fontSize: 16.0,
                                                                ),
                                                              )
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),),
                                      ],

                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 25,
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
                                controller: commantController,
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
                          _callMessage();
                        },
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
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CategoryDetails('', '', '')));
  }

  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AccountScreen()));
  }
 _callMessage() async {
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
        'POST', Uri.parse(ApiConfig.app_base_url + ApiConfig.TICKET_REPLAY_MESSAGE));
    request.headers.addAll(headers);
    if(_image!=null)
    {
      final file = await http.MultipartFile.fromPath('attachment', _image!.path);
      request.files.add(file);
    }
    request.fields['message'] = commantController.text.toString();
    request.fields['ticket_id'] = ticketId;
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
class TicketDetails {
  String name = '';
  String message = '';
  String date = '';
  String transaction_id = '';
  String type = '';
}

