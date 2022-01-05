import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
class SendMoney extends StatefulWidget {
  const SendMoney({Key? key}) : super(key: key);

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backwardsCompatibility: false,
            systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Color(0xffFFF9EC)),
            toolbarHeight: 70,
            elevation: 0,
            backgroundColor: Color(0xffFFF9EC),
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
              "Send Money",
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

          ),
        ),
      ),

    );
  }
  void previousScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DashboardMainScreen()));
  }
}
