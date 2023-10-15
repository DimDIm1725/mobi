class TransferCashBack {
  Data data;

  TransferCashBack({this.data});

  TransferCashBack.fromJson(Map<String, dynamic> json) {
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
  String fromUserPhoneNumber;
  String fromUserPhoneCountry;
  String fromUserPinCode;
  String toUserPhoneNumber;
  String toUserPhoneCountry;
  String applicationVersion;
  String applicationToken;
  String commonApiLanguage;
  String commonApiVersion;
  String commonProcessToken;
  String commonTimeStamp;

  Data({
    this.api,
    this.fromUserPhoneNumber,
    this.fromUserPhoneCountry,
    this.fromUserPinCode,
    this.toUserPhoneNumber,
    this.toUserPhoneCountry,
    this.applicationVersion,
    this.applicationToken,
    this.commonApiLanguage,
    this.commonApiVersion,
    this.commonProcessToken,
    this.commonTimeStamp,
  });

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    fromUserPhoneNumber = json['FromUser_PhoneNumber'];
    fromUserPhoneCountry = json['FromUser_PhoneCountry'];
    fromUserPinCode = json['FromUser_PinCode'];
    toUserPhoneNumber = json['ToUser_PhoneNumber'];
    toUserPhoneCountry = json['ToUser_PhoneCountry'];
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
    data['FromUser_PhoneNumber'] = this.fromUserPhoneNumber;
    data['FromUser_PhoneCountry'] = this.fromUserPhoneCountry;
    data['FromUser_PinCode'] = this.fromUserPinCode;
    data['ToUser_PhoneNumber'] = this.toUserPhoneNumber;
    data['ToUser_PhoneCountry'] = this.toUserPhoneCountry;
    data['Common_ApplicationVersion'] = this.applicationVersion;
    data['Common_ApplicationToken'] = this.applicationToken;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    return data;
  }
}
