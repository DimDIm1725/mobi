class PincodeRequest {
  Data data;

  PincodeRequest({this.data});

  PincodeRequest.fromJson(Map<String, dynamic> json) {
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
  String userUniversalKey;
  String userNewPinCode;
  String confirmNewPincode;
  String userPhoneCountry;
  String language;
  String userOldPinCode;
  String applicationVersion;
  String applicationToken;
  String commonApiLanguage;
  String commonApiVersion;
  String commonProcessToken;

  String commonTimeStamp;

  Data({
    this.api,
    this.userUniversalKey,
    this.userNewPinCode,
    this.userPhoneCountry,
    this.language,
    this.confirmNewPincode,
    this.userOldPinCode,
    this.applicationVersion,
    this.applicationToken,
    this.commonApiLanguage,
    this.commonApiVersion,
    this.commonProcessToken,
    this.commonTimeStamp,
  });

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    userUniversalKey = json['User_UniversalKey'];
    userNewPinCode = json['User_NewPinCode'];
    userPhoneCountry = json['User_PhoneCountry'];
    language = json['Language'];
    userOldPinCode = json['User_OldPinCode'];
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
    data['User_UniversalKey'] = this.userUniversalKey;
    data['User_NewPinCode'] = this.userNewPinCode;
    data['User_PhoneCountry'] = this.userPhoneCountry;
    data['Language'] = this.language;
    data['User_OldPinCode'] = this.userOldPinCode;
    data['Common_ApplicationVersion'] = this.applicationVersion;
    data['Common_ApplicationToken'] = this.applicationToken;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    return data;
  }
}
