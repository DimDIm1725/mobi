class LicenseRequest {
  Data data;

  LicenseRequest({this.data});

  LicenseRequest.fromJson(Map<String, dynamic> json) {
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
  String userPinCode;
  String carPlate;
  String tag;
  String main;
  String applicationVersion;
  String applicationToken;
  String commonApiLanguage;
  String commonApiVersion;
  String commonProcessToken;

  String commonTimeStamp;

  Data(
      {this.api,
      this.userUniversalKey,
      this.userPinCode,
      this.carPlate,
      this.tag,
      this.main,
      this.applicationVersion,
      this.applicationToken,
      this.commonApiLanguage,
      this.commonApiVersion,
      this.commonProcessToken,
      this.commonTimeStamp});

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    userUniversalKey = json['User_UniversalKey'];
    userPinCode = json['User_PinCode'];
    carPlate = json['CarPlate'];
    tag = json['Tag'];
    main = json['Main'];
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
    data['User_PinCode'] = this.userPinCode;
    data['CarPlate'] = this.carPlate;
    data['Tag'] = this.tag;
    data['Main'] = this.main;
    data['Common_ApplicationVersion'] = this.applicationVersion;
    data['Common_ApplicationToken'] = this.applicationToken;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    return data;
  }
}
