import 'package:get/get.dart';
import 'package:spendzz/screens/account_screens/help_screens/normal_ticket/help_ticket_details.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/addMoney_screen/add_money_history.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendMoney_screen/contactScreen_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/sendPayment.dart';
import 'package:spendzz/screens/dashboard_screens/rating_review_screens/add_review_rating.dart';
import 'package:spendzz/screens/account_screens/account_screen.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/addMoney_screen/add_money_screen.dart';
import 'package:spendzz/screens/dashboard_screens/dashboard_main_screen.dart';
import 'package:spendzz/screens/account_screens/setting_screens/notifications.dart';
import 'package:spendzz/screens/dashboard_screens/payment_screens/passbook_screen.dart';
import 'package:spendzz/screens/login_signup_screens/signup_details_screen.dart';
import 'package:spendzz/screens/intro_screens/onboarding_screen.dart';
import 'package:spendzz/screens/login_signup_screens/otp_screen.dart';
import 'package:spendzz/screens/login_signup_screens/login_signup_screen.dart';
import 'package:spendzz/screens/intro_screens/splash_screen.dart';

import 'screens/account_screens/history_screen.dart';
import 'screens/account_screens/kyc_screen.dart';
import 'screens/intro_screens/pin_access_screen.dart';
import 'screens/account_screens/referEarn_screen.dart';
import 'screens/dashboard_screens/category_screens/all_category.dart';
import 'screens/dashboard_screens/rating_review_screens/review_rating_list_screen.dart';
import 'screens/dashboard_screens/category_screens/category_details.dart';
import 'screens/dashboard_screens/category_screens/single_category.dart';

class Routes{
  static final routes = [
    GetPage(name: '/', page: ()=> SplashScreen()/*Raise_Ticket_Normal_Detail('','')*/),
    GetPage(name: '/', page: ()=> DashboardMainScreen()),
    GetPage(name: '/', page: ()=> OnboardingScreen()),
    GetPage(name: '/', page: ()=> SignUp_SignIn()),
    GetPage(name: '/', page: ()=> MoreDetailsScreen()),
    GetPage(name: '/', page: ()=> DashboardMainScreen()),
    GetPage(name: '/', page: ()=> PassbookScreen()),
    GetPage(name: '/', page: ()=> AddMoneyScreen()),
    GetPage(name: '/', page: ()=> AccountScreen()),
    GetPage(name: '/', page: ()=> NotificationScreen()),
    GetPage(name: '/', page: ()=> AddReview('')),
    GetPage(name: '/', page: ()=> AllCategory()),
    GetPage(name: '/', page: ()=> ReviewAndRating('')),
    GetPage(name: '/', page: ()=> CategoryDetails('','','')),
   // GetPage(name: '/', page: ()=> SingleCategory()),
    GetPage(name: '/', page: ()=> HistoryScreen()),
    GetPage(name: '/', page: ()=> Kyc_screen()),
    GetPage(name: '/', page: ()=> Refer_Earn_Screen()),
   /* GetPage(name: '/', page: ()=> Invoice()),
   AppWebStudiopvt
    GetPage(name: '/', page: ()=> SubscribeScreen()),
    GetPage(name: '/', page: ()=> SubscribeScreenDetails()),
    GetPage(name: '/', page: ()=> SettingScreen()),
    GetPage(name: '/', page: ()=> WalletPinScreen()),
    GetPage(name: '/', page: ()=> ImageCropNewViewFileData()),
    GetPage(name: '/', page: ()=> Profile()),
    GetPage(name: '/', page: ()=> AddNewCardScreen()),
    GetPage(name: '/', page: ()=> ManageCard()),
    GetPage(name: '/', page: ()=> CloseHelpDetail()),
    GetPage(name: '/', page: ()=> HelpScreen()),
    GetPage(name: '/', page: ()=> Raise_Ticket()),*/

  ];
}