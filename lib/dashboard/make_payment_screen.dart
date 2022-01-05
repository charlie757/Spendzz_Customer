import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendzz/dashboard/dashboard_main_screen.dart';
class MakeMoney extends StatefulWidget {
  const MakeMoney({Key? key}) : super(key: key);

  @override
  _MakeMoneyState createState() => _MakeMoneyState();
}

class _MakeMoneyState extends State<MakeMoney> {
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
              "Make Money",
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
