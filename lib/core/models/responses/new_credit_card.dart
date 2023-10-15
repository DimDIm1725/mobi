class NewCreditCardResponse {
  Response response;

  NewCreditCardResponse({this.response});

  NewCreditCardResponse.fromJson(Map<String, dynamic> json) {
    response = json['Response'] != null ? new Response.fromJson(json['Response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['Response'] = this.response.toJson();
    }
    return data;
  }

  String error;

  NewCreditCardResponse.withError(String errorValue)
      : response = Response(),
        error = errorValue;
}

class Response {
  String errorNumber;
  String source;
  dynamic message;
  String displayMessage;
  String waitCount;
  String recallCount;
  String processRecall;
  String versionSQL;
  String versionPartner;
  String versionUser;
  String versionTPE;
  String versionPowerLabPartner;
  String versionPowerLabUser;
  String partnerId;
  String partnerToken;
  String partnerPhoneNumber;
  String partnerPhoneCountry;
  String userId;
  String userToken;
  String userPhoneNumber;
  String userPhoneCountry;
  String processToken;
  Data data;

  Response(
      {this.errorNumber,
      this.source,
      this.message,
      this.displayMessage,
      this.waitCount,
      this.recallCount,
      this.processRecall,
      this.versionSQL,
      this.versionPartner,
      this.versionUser,
      this.versionTPE,
      this.versionPowerLabPartner,
      this.versionPowerLabUser,
      this.partnerId,
      this.partnerToken,
      this.partnerPhoneNumber,
      this.partnerPhoneCountry,
      this.userId,
      this.userToken,
      this.userPhoneNumber,
      this.userPhoneCountry,
      this.processToken,
      this.data});

  Response.fromJson(Map<String, dynamic> json) {
    errorNumber = json['ErrorNumber'];
    source = json['Source'];
    message = json['Message'];
    displayMessage = json['DisplayMessage'];
    waitCount = json['WaitCount'];
    recallCount = json['RecallCount'];
    processRecall = json['ProcessRecall'];
    versionSQL = json['Version_SQL'];
    versionPartner = json['Version_Partner'];
    versionUser = json['Version_User'];
    versionTPE = json['Version_TPE'];
    versionPowerLabPartner = json['Version_PowerLabPartner'];
    versionPowerLabUser = json['Version_PowerLabUser'];
    partnerId = json['Partner_Id'];
    partnerToken = json['Partner_Token'];
    partnerPhoneNumber = json['Partner_PhoneNumber'];
    partnerPhoneCountry = json['Partner_PhoneCountry'];
    userId = json['User_Id'];
    userToken = json['User_Token'];
    userPhoneNumber = json['User_PhoneNumber'];
    userPhoneCountry = json['User_PhoneCountry'];
    processToken = json['ProcessToken'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorNumber'] = this.errorNumber;
    data['Source'] = this.source;
    data['Message'] = this.message;
    data['DisplayMessage'] = this.displayMessage;
    data['WaitCount'] = this.waitCount;
    data['RecallCount'] = this.recallCount;
    data['ProcessRecall'] = this.processRecall;
    data['Version_SQL'] = this.versionSQL;
    data['Version_Partner'] = this.versionPartner;
    data['Version_User'] = this.versionUser;
    data['Version_TPE'] = this.versionTPE;
    data['Version_PowerLabPartner'] = this.versionPowerLabPartner;
    data['Version_PowerLabUser'] = this.versionPowerLabUser;
    data['Partner_Id'] = this.partnerId;
    data['Partner_Token'] = this.partnerToken;
    data['Partner_PhoneNumber'] = this.partnerPhoneNumber;
    data['Partner_PhoneCountry'] = this.partnerPhoneCountry;
    data['User_Id'] = this.userId;
    data['User_Token'] = this.userToken;
    data['User_PhoneNumber'] = this.userPhoneNumber;
    data['User_PhoneCountry'] = this.userPhoneCountry;
    data['ProcessToken'] = this.processToken;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
 /* String creditCardToken;
  String threeDSecureReturnedCode;
  String threeDSecureActionURL;
  String threeDSecureMethod;
  String threeDSecureMdFieldName;
  String threeDSecureMdFieldValue;
  String threeDSecurePareqFieldName;
  String threeDSecurePareqFieldValue;
  String threeDSecureTransientData;
  String threeDSMethodeNotificationUrl;*/
  String paylineRedirectUrl;
  String paylineToken;

  Data(
      {/*this.creditCardToken,
      this.threeDSecureReturnedCode,
      this.threeDSecureActionURL,
      this.threeDSecureMethod,
      this.threeDSecureMdFieldName,
      this.threeDSecureMdFieldValue,
      this.threeDSecurePareqFieldName,
      this.threeDSecurePareqFieldValue,
      this.threeDSecureTransientData,
      this.threeDSMethodeNotificationUrl*/
      this.paylineToken,
      this.paylineRedirectUrl
      });

  Data.fromJson(Map<String, dynamic> json) {
  /*  creditCardToken = json['CreditCard_Token'];
    threeDSecureReturnedCode = json['ThreeDSecure_ReturnedCode'];
    threeDSecureActionURL = json['ThreeDSecure_ActionURL'];
    threeDSecureMethod = json['ThreeDSecure_Method'];
    threeDSecureMdFieldName = json['ThreeDSecure_MdFieldName'];
    threeDSecureMdFieldValue = json['ThreeDSecure_MdFieldValue'];
    threeDSecurePareqFieldName = json['ThreeDSecure_PareqFieldName'];
    threeDSecurePareqFieldValue = json['ThreeDSecure_PareqFieldValue'];
    threeDSecureTransientData = json['ThreeDSecure_TransientData'];
    threeDSMethodeNotificationUrl = json['ThreeDSecure_NotificationURL'];
    threeDSMethodeNotificationUrl = Uri.decodeFull(threeDSMethodeNotificationUrl);*/
    paylineToken = json['Token'];
    paylineRedirectUrl = json['RedirectURL'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   /* data['CreditCard_Token'] = this.creditCardToken;
    data['ThreeDSecure_ReturnedCode'] = this.threeDSecureReturnedCode;
    data['ThreeDSecure_ActionURL'] = this.threeDSecureActionURL;
    data['ThreeDSecure_Method'] = this.threeDSecureMethod;
    data['ThreeDSecure_MdFieldName'] = this.threeDSecureMdFieldName;
    data['ThreeDSecure_MdFieldValue'] = this.threeDSecureMdFieldValue;
    data['ThreeDSecure_PareqFieldName'] = this.threeDSecurePareqFieldName;
    data['ThreeDSecure_PareqFieldValue'] = this.threeDSecurePareqFieldValue;
    data['ThreeDSecure_TransientData'] = this.threeDSecureTransientData;
    data['ThreeDSecure_NotificationURL'] = this.threeDSMethodeNotificationUrl;*/
    data['Token'] = this.paylineToken;
    data['RedirectURL'] = this.paylineRedirectUrl;
    return data;
  }
}
