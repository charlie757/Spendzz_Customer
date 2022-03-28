import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/screens/account_screens/setting_screens/notifications.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/all_category.dart';
import 'package:spendzz/screens/dashboard_screens/category_screens/category_details.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/pay_money_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendPayment.dart';
import 'package:url_launcher/url_launcher.dart';


class ContactList extends StatefulWidget {
  static const String route = '/ContactList';


  const ContactList({Key? key}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  late String amount = '';
  List<PassbookHistoryList> passbookHistoryList = [];
  var isDataFetched = false;
  TextEditingController mobileNoController = TextEditingController();

  List<Contact>? contacts;

  var merchant_id='';



  @override
  void initState() {

    super.initState();
    getContact();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      print(contacts);

      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(Platform.isAndroid)
        {

          Navigator.push(context, MaterialPageRoute(builder: (context) =>DashboardMainScreen()));
        }
        else
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>DashboardMainScreen()));
        }
        //ShowDialog();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Color(0xffFFF9EC)),
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Colors.white,
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
              "",
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
          scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15,right: 1),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Enter Mobile Number to\nPay",
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 28.0,
                        ),
                      ),
                    )
                  ),
                  SizedBox(height: 15,),
                  Container(
                      padding: EdgeInsets.only(left: 15,right: 1),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Send Money Directly to Wallet",
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.0,
                          ),
                        ),
                      )
                  ),
                  SizedBox(height: 25,),
                  Container(
                    margin: new EdgeInsets.symmetric(horizontal: 15.0),
                    padding: EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: kYellowColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                width: 200,
                                child: GestureDetector(
                                  onTap: () {
                                  },
                                  child:TextFormField(
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

                                controller: mobileNoController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Phone Number',
                                  border: InputBorder.none,
                                ),
                              )
                                )),
                          ],
                        ),
                        /*Align(
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
                                )))*/
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                     height: MediaQuery.of(context).size.height,
                    child: (contacts) == null
                        ?Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Align(child: CircularProgressIndicator(color: kYellowColor,)) //Container
                    )
                    /*Align(child: CircularProgressIndicator(color: kYellowColor,))*/
                        : ListView.builder(
                      itemCount: contacts!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Uint8List? image = contacts![index].photo;
                        String num = (contacts![index].phones.isNotEmpty) ? (contacts![index].phones.first.number) : "--";
                        return ListTile(
                            leading:Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xff5369AE),
                                    kYellowColor,

                                  ],
                                )
                                ),
                                child: (contacts![index].photo!= null)
                                    ? CircleAvatar(
                                  backgroundImage: MemoryImage(image!),
                                )
                                    : CircleAvatar(
                                    child: Icon(Icons.person,color: Colors.white),
                                    backgroundColor: Colors.transparent)),
                           /* leading: (contacts![index].photo == null)
                                ? const CircleAvatar(backgroundColor:kYellowColor,child: Icon(Icons.person,color: Colors.white))
                                : CircleAvatar(backgroundImage: MemoryImage(image!),backgroundColor: kYellowColor,),*/
                            title: Text(
                                "${contacts![index].name.first} ${contacts![index].name.last}"),
                            subtitle: Text(num),
                            onTap: () {
                              if (contacts![index].phones.isNotEmpty) {
                                mobileNoController.text=contacts![index].phones.first.number;
                                //launch('tel: ${num}');
                              }
                            },);
                      },
                    )
                  )

                ],
              ),
            ),
          ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
            child: Container(
              width: MediaQuery.of(context).size.width - 0,
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 0, right: 0, top: 25, bottom: 25),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                     /* decoration: BoxDecoration(
                          color: kYellowColor,
                          borderRadius: BorderRadius.circular(10.0)),*/
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          shape: BoxShape.rectangle,gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          //Color(0xff5369AE),
                          kYellowColor,
                          kYellowColor,
                          /*Colors.green,
                          Colors.indigo,
                          Colors.yellow,*/
                          //Colors.orange
                        ],
                      )
                      ),
                      child: FlatButton(
                        onPressed: () {
                          String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                          RegExp regExp = new RegExp(patttern);
                          if (mobileNoController.text.isEmpty) {
                            EasyLoading.showToast('Please enter Mobile Number');
                            return;
                          }
                          if (!regExp.hasMatch(mobileNoController.text)) {
                            EasyLoading.showToast('Please enter Valid Mobile Number');
                            return;
                          } else {
                            _callCheckValidMobile();
                            /*Navigator.push(
                                context, MaterialPageRoute(builder: (context) => PayMoneyScreen()));*/
                           // openCheckout();
                          }
                        },
                        child: Text(
                          'Proceed',
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
            )),
        ),
      );

  }
  void nextScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PayMoneyScreen('','')));
  }
  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }
  _callCheckValidMobile() async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['mobile'] = mobileNoController.text.toString();
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
         /* Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);*/


          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PayMoneyScreen(merchant_id,'')));
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

class PassbookHistoryList {
  String name = '';
  String amount = '';
  String date = '';
}
