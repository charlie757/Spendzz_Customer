import 'package:flutter/material.dart';
import 'package:spendzz/screens/account_screens/subscribtion_screens/SubscribeScreenDetails.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';


class Invoice extends StatefulWidget {
  //const Registration_WebView({Key? key}) : super(key: key);

  var invoiceFull = '';
  Invoice(this.invoiceFull);

    @override
  _InvoiceState createState() => _InvoiceState(invoiceFull);
}

class _InvoiceState extends State<Invoice> {
  _InvoiceState(this.invoiceFull);
  var invoiceFull = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "RegistrationProof",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontStyle: FontStyle.normal,
              fontSize: 20.0,
            ),
          ),
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
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,

            child: WebView(
              backgroundColor: Colors.white,
              zoomEnabled: true,
              initialUrl: invoiceFull,
            ),
          )/*WebView(
            initialUrl: registrationProf.toString(),
            javascriptMode: JavascriptMode.unrestricted,
          ),*/
        ),
      ),
    );
  }

  void previousScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SubscribeScreenDetails()));
  }

  _launchInvoice() async {
    if (await canLaunch(
        invoiceFull)) {
      await launch(invoiceFull);
    } else {
      throw 'Could not launch $invoiceFull';
    }
  }
}
