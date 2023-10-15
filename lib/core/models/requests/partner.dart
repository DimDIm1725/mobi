class PartnerRequest {
  Data data;

  PartnerRequest({this.data});

  PartnerRequest.fromJson(Map<String, dynamic> json) {
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
  String userPhoneNumber;
  String userPhoneCountry;
  String language;
  String userLatitude;
  String userLongitude;
  String applicationVersion;
  String applicationToken;
  String commonApiLanguage;
  String commonApiVersion;
  String commonProcessToken;
  String commonTimeStamp;

  Data(
      {this.api,
      this.userPhoneNumber,
      this.userPhoneCountry,
      this.language,
      this.userLatitude,
      this.userLongitude,
      this.applicationVersion,
      this.applicationToken,
      this.commonApiLanguage,
      this.commonApiVersion,
      this.commonProcessToken,
      this.commonTimeStamp});

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    userPhoneNumber = json['User_PhoneNumber'];
    userPhoneCountry = json['User_PhoneCountry'];
    language = json['Language'];
    userLatitude = json['User_Latitude'];
    userLongitude = json['User_Longitude'];
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
    data['User_PhoneNumber'] = this.userPhoneNumber;
    data['User_PhoneCountry'] = this.userPhoneCountry;
    data['Language'] = this.language;
    data['User_Latitude'] = this.userLatitude;
    data['User_Longitude'] = this.userLongitude;
    data['Common_ApplicationVersion'] = this.applicationVersion;
    data['Common_ApplicationToken'] = this.applicationToken;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    return data;
  }
}
