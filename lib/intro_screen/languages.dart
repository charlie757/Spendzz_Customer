import 'package:flutter/material.dart';

abstract class Languages {
  static Languages of(BuildContext context) {
    return Localizations.of(context, Languages);
  }

  String get appName;

  String get labelSignIn;

  String get signInBelow;

  String get email;

  String get mobileNumber;

  String get password;

  String get forgotPasswordQ;

  String get clickHere;

  String get dontHaveAnAccountQ;

  String get labelSignUp;

  String get or;

  String get changeEmailQ;

  String get changeEmail;

  String get kEmailNullError;

  String get kInvalidEmailError;

  String get kPassNullError;

  String get kShortPassError;

  String get kMatchPassError;

  String get hintPassword;

  String get hintEmail;

  String get hintMobileNumber;

  //Signup screen variables
  String get createAccount;

  String get msgCreateAccount;

  String get name;

  String get phoneNumber;

  String get code;

  String get bySigninUp;

  String get privacyPolicy;

  String get termsCondition;

  String get alreadyHaveAccount;

  String get hintName;

  String get ok;

  String get errorTermsCondition;

  String get errorPasswordLength;

  String get errorInvalidPasswordFormat;

  String get errorPasswordEmpty;

  String get errorMobileNumber;

  String get errorInvalidMobileNumber;

  String get errorCountryCode;

  String get errorInvalidEmail;

  String get errorEmptyEmail;

  String get errorNameEmpty;

  String get errorPasswordNotMatch;

  String get errorEmptyMobileNumber;

  String get errorEmptyCurrentPassword;

  String get errorEmptyNewPassword;

  String get errorEmptyConfirmNewPassword;

  String get errorConfirmPasswordNotMatch;

  String get errorDeliveryTime;

  String get errorReportType;

  String get errorSubReportType;

  String get errorAmountToPaid;

  String get errorUploadCredential;

  String get errorAcceptPolicy;

  String get errorServerError;

  //ForgotPassword Screen variables
  String get forgotPassword;

  String get msgRelevantDetails;

  String get getOtp;

  //OtpScreen variable
  String get verificationCode;

  String get msgVerificationCode;

  String get didNotReceived;

  String get resend;

  String get verify;

  //ResetPassword variable
  String get resetPassword;

  String get enterNewPassword;

  String get confirmNewPassword;

  String get changePassword;

  String get passwordReset;

  String get msgPasswordReset;

  //request type screen variable
  String get offlineRequest;

  String get onlineRequest;

  String get selectRequestType;

  //bottom navigation bar variable
  String get home;

  String get chat;

  String get myRequest;

  String get account;

  //home variables
  String get selectType;

  //side menu variables
  String get hello;

  String get profile;

  String get paymentDetails;

  String get aboutVideoLaudo;

  String get contactUs;

  String get faq;

  String get help;

  String get welcome;

  String get selectLanguage;

  String get english;

  String get portuguese;

  String get next;

  //Home Screen
  String get howCanWeHelp;

  String get postRequest;

  String get imagingExams;

  String get otherExams;

  //Online Request
  String get postOnlineRequest;

  String get chooseDeliveryTime;

  String get reportType;

  String get reportSubType;

  String get reportDetails;

  String get compare;

  String get uploadCredentials;

  String get uploadExam;

  String get recordComments;

  String get comments;

  String get amountToBePaid;

  String get payNow;

  //Thank you payment screen
  String get titlethankYouPayment;

  String get subTitleThankyou;

  String get viewRequest;

  //myrequest
  String get active;

  String get closed;

  String get requestId;

  String get requestDateTime;

  String get deliveryDateTime;

  String get pending;

  String get inProgress;

  String get accepted;

  String get completed;

  String get cancelled;

  String get deliveredOn;

  String get cancelledOn;

  //view request variables
  String get requestType;

  String get startDateTime;

  String get viewInvoice;

  String get expand;

  String get feedBackByProfessionals;

  String get recordedVideo;

  String get recordedAudio;

  String get rateProfessional;

  String get assigningProfessional;

  String get requestAccepted;

  String get requestpending;

  String get requestProcessing;

  String get requestCompleted;

  String get requestCancelled;

  //request cancel dialog
  String get titleRequestCancelled;

  String get subTitleRequestCancelled;

  String get requestOnline;

  String get cancellationTerms;

  String get cancel;

  String get cancellation;

  String get canellationFinalMessage;

  String get yes;

  String get no;

  String get areYouSure;

  String get needHelp;

  //Help Screens
  String get ticketNo;

  String get date;

  String get reason;

  String get message;

  String get backOnTop;

  String get view;

  //create help
  String get attachFile;

  String get submit;

  String get helpRequestId;

  String get helpTicketNum;

  String get helpReason;

  String get helpMessage;

  String get signout;

  String get currentPassword;

  String get newPassword;

  String get editProfile;

  String get done;

  String get anyQuestion;

  String get send;

//imaging offline request
  String get postOfflineRequest;

  String get whoAreYouLookingFor;

//How It Works
  String get howItWorks;

  String get step1;

  String get step2;

  String get step3;

  String get note;

  String get request;

  String get step1Message;

  String get step2Message;

  String get step3Message;

  String get noteDisclaimer;

  //professional bio
  String get professionalsBio;

  String get state;

  String get crm;

  String get rqe;

  String get profession;

  String get modality;

  String get experience;

  String get aboutMe;

  String get certificates;

  String get medicalCertificate;

  String get notifications;

  String get nearestHospitals;

  String get radiologists;

  String get viewAll;

  String get subspeciality;

  String get hospitalBio;

  String get aboutHospital;

  String get searchClinicians;

  String get searchRadiologist;

  String get radiologistFilter;

  String get rating;

  String get location;

  String get filterModality;

  String get filterSpeciality;

  String get filterSubSpeciality;

  String get reset;

  String get chatMessage;

  String get feedProfessional;

  String get requestTermsCondition;

  String get dateOfBirth;

  String get deliveryDuration;

  String get examType;

  String get changeLanguage;

  //Exception messages
  String get noInternet;

  String get enterOTP;

  String get enterNewMobileNo;

  String get verified;

  String get unVerified;

  String get open;

  String get errorEmptyMessage;

  String get chooseImage;

  String get fromGallery;

  String get fromCamera;

  String get noRecordFound;

  String get search;

  String get years;

  String get uploadedCredentials;

  String get uploadedExams;

  String get recordedComments;

  String get signUpSuccess;

  String get chats;

  String get msgPasswordChangeSuccess;

  String get crop;

  String get clinicianSurgeon;

  String get clinicianBio;

  String get physicianType;

  String get speciality;

  String get clinicianFilter;

  String get sessionExpired;

  String get userBlocked;

  String get medicalCertifications;

  String get specialityCertifications;

  String get locationEnableMessage;

  String get locationDeniedMessage;

  String get settings;

  String get hospitalFilter;

  String get enterYourEmail;

  String get confirmYourEmail;

  String get errorConfirmEmail;

  String get errorConfirmEmailNotMatch;

  String get alertVerifyMobileNumber;

  String get noProfessionalFound;

  String get locationRequiredMessage;
  String get total;
  String get adminFee;
  String get totalRefund;
  String get cancellationCharge;
  String get takeAction;
  String get msgMobileVerificationCode;
  String get feedback;
  String get clinicians;
  String get online;
  String get offline;
}
