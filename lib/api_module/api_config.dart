class ApiConfig {
  ApiConfig._();
//https://doapi.alphonic.net.in
  static const String app_base_url = 'https://testalphonic.com/projects/ramkesh/spendzz/api/user/v2/';
  //static const String app_base_url = 'http://127.0.0.1:8000/spendzz/api/user/v2/';
  //static const String app_base_url = 'https://spendzz.com/api/user/v2/';
  static const String SIGNUP_WITH_MOBILE = 'sign-up';
  static const String VERIFY_OTP = 'verify-otp';
  static const String SIGNUP_COMPLETE = 'sign-complete';
  static const String GET_PROFILE = 'user-details';
  static const String PROFILE = 'user-profile-update';
  static const String LOG_OUT = 'logout';
  static const String EXCITING_OFFERS = 'order/product/';
  static const String PROFESSION_TYPE = 'profession-type';
  static const String SALARY = 'profession-salary';
  static const String GET_KYC_DETAILS = 'get-user-kyc-details';
  static const String GET_SUBSCRIBE_DETAILS = 'subscription-plan';
  static const String ADD_KYC_DETAILS = 'add-user-kyc-details';
  static const String PAYMENT_UPDATE ='payment-update';
  static const String PAYMENT_HISTORY ='payment-history';
  static const String GET_KYC_STATUS ='kyc-status';
  static const String ADD_MONEY_FROM_WALLET ='user-add-money-to-wallet';
  static const String APPLY_PROMO_CODE ='promo-code-apply';

  static const String POST_REVIEW_RATING ='reviews-and-rating';
  static const String GET_REVIEW_RATING ='reviews-and-rating-list/';
  static const String CHECK_PIN_STATUS ='check-pin-status';
  static const String CHANGE_PIN_STATUS ='change-pin-status';
  static const String WALLET_PIN ='wallet-pin';
  static const String ACCESS_PIN ='access-to-pin';
  static const String CHECK_PIN_FIELD ='check-pin-updation';
  static const String PASSBOOK_USER_BALANCE ='wallet-balence';
  static const String PASSBOOK_HISTORY ='user-wallet-history';
  static const String TRANSACTION_HISTORY ='user-transaction-history';
  static const String CHECK_VALID_NUMBER ='find-number-to-pay';
  static const String SEND_MONEY_TO_MERCHANT ='send-money-to-merchant';
  static const String SEND_MONEY_TO_CUSTOMER ='send-money-to-customer';
  static const String FEATURED_MERCHANT_CATEGORY ='merchant-categories';
  static const String PROMO_CODE_LIST_BOTH ='promo-code-list/both';
  static const String PROMO_CODE_LIST_ADD_MONEY ='promo-code-list/add';
  static const String PROMO_CODE_LIST_PAY_MONEY ='promo-code-list/send';
  static const String PROMO_CODE_DETAILS ='promo-code-info';
  static const String SINGLE_MERCHANT_CATEGORY_LIST ='shop-info-category-wise';
  static const String CATEGORY_DETAIL ='shop-details-by-id';
  static const String QR_PAYMENT ='scan-qr-id';
  static const String ALL_TICKETS ='raise-normal_ticket-list';
  static const String TICKETS_ISSUE ='ticket-issue';
  static const String SUBMIT_TICKETS ='raise-ticket';
  static const String SUBMIT_FORMAL_TICKETS ='formal-raise-ticket';
  static const String ALL_TICKETS_LIST ='raise-ticket-list';
  static const String TRANSACTION_HISTORY_DETAILS ='user-transaction-details';
  static const String FILTER_HISTORY ='transaction-filter';
  static const String TICKET_REPLAY_LIST ='reply-to-ticket-list/';
  static const String TICKET_REPLAY_MESSAGE ='reply-to-ticket';
  static const String SUBSCRIBE_SCREEN_STATUS ='subscription-status';
  static const String REFERRAL_CODE ='customer-referral-code';
  static const String GET_CUSTOMER_QR_CODE = 'customer-qr-code';
  static const String NOTIFICATIONS = 'notifications-list-customer';
  static const String KYC_LIMIT = 'check-kyc-updated';
 // https://testalphonic.com/projects/ramkesh/spendzz/api/user/v2/notifications-list-customer
  static const String RESEND_CONTACT = 'last-contacts';
  //https://testalphonic.com/projects/ramkesh/spendzz/api/user/v2/customer-qr-code
  /*https://testalphonic.com/projects/ramkesh/spendzz/api/user/v2/reply-to-ticket
  ticket_id:12374850
  message:nop
  attachment:
 // https://testalphonic.com/projects/ramkesh/spendzz/api/user/v2/formal-raise-ticket*/


}