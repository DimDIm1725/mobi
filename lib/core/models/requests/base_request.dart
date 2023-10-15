class BaseRequest {
  Data data;

  BaseRequest({this.data});

  BaseRequest.fromJson(Map<String, dynamic> json) {
    data = json['Data'] != null && json['Data'] != "" ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String api;
  String commonApplicationToken;
  String commonApplicationVersion;
  String commonApiLanguage;
  String commonApiVersion;
  String commonProcessToken;
  String commonTimeStamp;
  String userPhoneNumber;
  String userPhoneCountry;
  String userLongitude;
  String userLatitude;
  bool messageByEmail;

  Data(
      {this.api,
      this.commonApplicationToken,
      this.commonApplicationVersion,
      this.commonApiLanguage,
      this.commonApiVersion,
      this.commonProcessToken,
      this.commonTimeStamp,
      this.userPhoneNumber,
      this.messageByEmail,
      this.userPhoneCountry,
      this.userLongitude,
      this.userLatitude});

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    commonApplicationToken = json['Common_ApplicationToken'];
    commonApplicationVersion = json['Common_ApplicationVersion'];
    commonApiLanguage = json['Common_ApiLanguage'];
    commonApiVersion = json['Common_ApiVersion'];
    commonProcessToken = json['Common_ProcessToken'];
    commonTimeStamp = json['Common_TimeStamp'];
    userPhoneNumber = json['User_PhoneNumber'];
    userPhoneCountry = json['User_PhoneCountry'];
    userLatitude = json['User_Latitude'];
    userLongitude = json['User_Longitude'];
    messageByEmail = json['MessageByEMail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Api'] = this.api;
    data['Common_ApplicationToken'] = this.commonApplicationToken;
    data['Common_ApplicationVersion'] = this.commonApplicationVersion;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    data['User_PhoneNumber'] = this.userPhoneNumber;
    data['User_PhoneCountry'] = this.userPhoneCountry;
    data['User_Latitude'] = this.userLatitude;
    data['User_Longitude'] = this.userLongitude;
    data['MessageByEMail'] = this.messageByEmail;


    return data;
  }
}
