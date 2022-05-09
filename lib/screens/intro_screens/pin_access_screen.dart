import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendzz/api_module/api_config.dart';
import 'package:spendzz/resources/constants.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

class PinAccess extends StatefulWidget {
  const PinAccess({Key? key}) : super(key: key);

  @override
  _PinAccessState createState() => _PinAccessState();
}

class _PinAccessState extends State<PinAccess> {
  TextEditingController newTextEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  late String pin;
  Block_UnblockUser _block_unblockUser = Block_UnblockUser();

  @override
  void dispose() {
    newTextEditingController.dispose();
    focusNode.dispose();
    newTextEditingController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Form(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(height: 105),
                Center(
                    child: Image.asset(
                  "assets/images/splash_logo.png",
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width - 100,
                )),
                SizedBox(height: 25),
                Text(
                  'Enter Spendzz PIN',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: 25),
                Container(

                    padding: EdgeInsets.only(left: 80, right: 80),
                  child: PinCodeTextField(
                    controller: newTextEditingController,
                    inputFormatters: [

                      FilteringTextInputFormatter.digitsOnly
                    ],
                    obscureText: true,
                obscuringCharacter: '●',
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.circle,
                      borderRadius: BorderRadius.circular(25,),
                      activeColor: Colors.black,
                      disabledColor: Colors.black,selectedColor: Colors.black,
inactiveColor: Colors.black,
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),

                    length: 4,
                    appContext: context,
                    keyboardType: TextInputType.number,
                    pastedTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,

                    ), onChanged: (String value) {

                  },
                    onCompleted: (result) {
    if (result != null) {
            _callAccessPin(result);
          }

          // Your logic with code
          print(result);
          //pin=result;

          print(result);

                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _callAccessPin(String pin) async {
    EasyLoading.show(status: 'loading...');
    var mapBody = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth_token = prefs.getString('AUTH_TOKEN') ?? '';
    mapBody['pin'] = pin;
    var client = http.Client();
    EasyLoading.show(status: 'loading...');
    try {
      Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $auth_token',
      };
      var uriResponse = await client.post(
        Uri.parse(ApiConfig.app_base_url + ApiConfig.ACCESS_PIN),
        headers: headers,
        body: mapBody,
      );
      var dataAll = json.decode(uriResponse.body);
      print(dataAll);
      EasyLoading.dismiss();
      if (uriResponse.statusCode == 200) {
        if (dataAll['status'] == true) {
          Fluttertoast.showToast(
              msg: dataAll['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashboardMainScreen()));
        }
        else if (dataAll['status'] == false) {
          newTextEditingController.clear();
          if (dataAll['check_status'] == 0) {

            Fluttertoast.showToast(
                msg: dataAll['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
            _block_unblockUser.callLogOutApi(context);
          }
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
      }
    } finally {
      client.close();
    }
  }
}
