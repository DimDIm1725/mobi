import 'dart:convert';

class PaylineData {
  Response response;

  PaylineData({this.response});

  PaylineData.fromJson(Map<String, dynamic> json) {
    response = json['Response'] != null ? new Response.fromJson(json['Response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['Response'] = this.response.toJson();
    }
    return data;
  }

  String toJSONString() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['Response'] = this.response.toJson();
    }
    return jsonEncode(data);
  }

  PaylineData.withError(String errorValue)
      : response = Response(),
        _error = errorValue;
  String _error;
}

class Response {
  String errorNumber;
  String source;
  String message;
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
  String paylineServer;
  String paylineWebServer;
  String paylineServicesServer;
  String paylineMerchantId;
  String paylineAccessKey;
  String paylineVersion;
  String paylineContractNumber;
  String paylineReturnUrl;

  Data(
      {this.paylineServer,
      this.paylineMerchantId,
      this.paylineAccessKey,
      this.paylineVersion,
      this.paylineWebServer,
      this.paylineServicesServer,
      this.paylineContractNumber,
      this.paylineReturnUrl});

  Data.fromJson(Map<String, dynamic> json) {
    paylineServer = json['Payline_Server'];
    paylineMerchantId = json['Payline_MerchantId'];
    paylineWebServer = json['Payline_WebServer'];
    paylineServicesServer = json['Payline_ServicesServer'];
    paylineAccessKey = json['Payline_AccessKey'];
    paylineVersion = json['Payline_Version'];
    paylineContractNumber = json['Payline_ContractNumber'];
    paylineReturnUrl = json['Payline_ReturnUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Payline_Server'] = this.paylineServer;
    data['Payline_WebServer'] = this.paylineWebServer;
    data['Payline_ServicesServer'] = this.paylineServicesServer;
    data['Payline_MerchantId'] = this.paylineMerchantId;
    data['Payline_AccessKey'] = this.paylineAccessKey;
    data['Payline_Version'] = this.paylineVersion;
    data['Payline_ContractNumber'] = this.paylineContractNumber;
    data['Payline_ReturnUrl'] = paylineReturnUrl;
    return data;
  }
}
