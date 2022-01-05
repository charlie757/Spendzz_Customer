import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendzz/intro_screen/signup_mobile.dart';
import 'package:spendzz/resources/constants.dart';
import 'UnbordingContent.dart';

class OnboardingScreen extends StatefulWidget {
  static const String route = '/OnboardingScreen';


  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kstatusBarColor,
    ));
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/splash.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 380,
                  child: Container(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: contents.length,
                      onPageChanged: (int index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemBuilder: (_, i) {
                        return Padding(
                          padding:
                          EdgeInsets.only(top: 0, left: 0, right: 0),
                          child: Column(
                            children: [
                              Center(
                                  child: Image.asset(
                                    contents[i].image,
                                    fit: BoxFit.fitWidth,
                                    height: 200,
                                    width: 200,
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding:
                                EdgeInsets.only(top: 0, left: 15, right: 25),
                                child: Center(
                                  child: Text(
                                    contents[i].title,
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10.0),
                              Center(
                                  child: Container(
                                    padding:
                                    EdgeInsets.only(top: 0, left: 15, right: 15),
                                    child: Text(
                                      contents[i].discription,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  )
                              )


                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(bottom: 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              contents.length,
                                  (index) => buildDot(index, context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Align(
                          child: Container(
                            height: 60,
                            child: FlatButton(
                              child: Text(
                                currentIndex == contents.length - 1
                                    ? "Continue"
                                    : "Skip",
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontWeight: FontWeight.w700,
                                  color: kYellowColor,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              onPressed: () {
                                if (currentIndex == contents.length - 1) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SignUp_SignIn(),
                                    ),
                                  );
                                }
                                _controller.nextPage(
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.bounceIn,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
           // child: Text('scsokopkpokoojidjdijkodjdijijdoodrfk\njdsijijsdidjidjdidjssidjsddijdijsis\n'),

          ),
        ),
      );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 20 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        //color: Theme.of(context).primaryColor,
        color: kYellowColor,
      ),
    );
  }
}
