class TaxiCheckRequest {
  Data data;

  TaxiCheckRequest({this.data});

  TaxiCheckRequest.fromJson(Map<String, dynamic> json) {
    data = json['Data'] != null && json['Data'] != "" ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String api;
  String partnerPhoneNumber;
  String partnerPhoneCountry;
  String buyerUserPhoneNumber;
  String buyerUserPhoneCountry;
  String buyerUserPinCode;
  String beneficiaryUserPhoneNumber;
  String beneficiaryUserPhoneCountry;
  String transactionAmount;
  String creditCardToken;
  String applicationVersion;
  String applicationToken;
  String commonApiLanguage;
  String commonApiVersion;
  String commonProcessToken;
  String commonTimeStamp;

  Data({
    this.api,
    this.partnerPhoneNumber,
    this.partnerPhoneCountry,
    this.buyerUserPhoneNumber,
    this.buyerUserPhoneCountry,
    this.buyerUserPinCode,
    this.beneficiaryUserPhoneNumber,
    this.beneficiaryUserPhoneCountry,
    this.transactionAmount,
    this.creditCardToken,
    this.applicationVersion,
    this.applicationToken,
    this.commonApiLanguage,
    this.commonApiVersion,
    this.commonProcessToken,
    this.commonTimeStamp,
  });

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    partnerPhoneNumber = json['Partner_PhoneNumber'];
    partnerPhoneCountry = json['Partner_PhoneCountry'];
    buyerUserPhoneNumber = json['BuyerUser_PhoneNumber'];
    buyerUserPhoneCountry = json['BuyerUser_PhoneCountry'];
    buyerUserPinCode = json['BuyerUser_PinCode'];
    beneficiaryUserPhoneNumber = json['BeneficiaryUser_PhoneNumber'];
    beneficiaryUserPhoneCountry = json['BeneficiaryUser_PhoneCountry'];
    transactionAmount = json['Transaction_Amount'];
    creditCardToken = json['CreditCard_Token'];
    applicationVersion = json['Common_ApplicationVersion'];
    applicationToken = json['Common_ApplicationToken'];
    commonApiLanguage = json['Common_ApiLanguage'];
    commonApiVersion = json['Common_ApiVersion'];
    commonProcessToken = json['Common_ProcessToken'];
    commonTimeStamp = json['Common_TimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Api'] = this.api;
    data['Partner_PhoneNumber'] = this.partnerPhoneNumber;
    data['Partner_PhoneCountry'] = this.partnerPhoneCountry;
    data['BuyerUser_PhoneNumber'] = this.buyerUserPhoneNumber;
    data['BuyerUser_PhoneCountry'] = this.buyerUserPhoneCountry;
    data['BuyerUser_PinCode'] = this.buyerUserPinCode;
    data['BeneficiaryUser_PhoneNumber'] = this.beneficiaryUserPhoneNumber;
    data['BeneficiaryUser_PhoneCountry'] = this.beneficiaryUserPhoneCountry;
    data['Transaction_Amount'] = this.transactionAmount;
    data['CreditCard_Token'] = this.creditCardToken;
    data['Common_ApplicationVersion'] = this.applicationVersion;
    data['Common_ApplicationToken'] = this.applicationToken;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    return data;
  }
}
