import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

const kContentColorLightTheme = Colors.black;
const kContentColorDarkTheme = Colors.white;
const kYellowColor = Color(0xFFEE4B23);
const kstatusBarColor = /*Color(0xff5369AE)*/ Colors.white;
const klightYelloColor = Color(0xffFFF9EC);
const blackTextColor = Color(0xff303030);
/*String get noInternet => 'No Internet connection';*/
String get ok => "Dismiss";
Future<bool> checkInternet() async {
  var connectivityResult = await DataConnectionChecker()
      .hasConnection; //await (Connectivity().checkConnectivity());
  // if (connectivityResult == ConnectivityResult.mobile) {
  //   return true;
  // } else if (connectivityResult == ConnectivityResult.wifi) {
  //   return true;
  // }
  // return false;
  return connectivityResult;
}

showErrorSnackBar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      backgroundColor: Colors.red.shade500,
      content: Text(message),
      action: SnackBarAction(
        label: ok,
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
}

showSuccessSnackBar(BuildContext context, String message) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      backgroundColor: Colors.green.shade500,
      content: Text(message),
      action: SnackBarAction(
        label: ok,
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
}
