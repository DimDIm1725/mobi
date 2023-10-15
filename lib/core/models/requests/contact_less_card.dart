class ContactLessCardRequest {
  Data data;

  ContactLessCardRequest({this.data});

  ContactLessCardRequest.fromJson(Map<String, dynamic> json) {
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
  String commonApiVersion;
  String userPhoneNumber;
  String commonProcessToken;
  String commonTimeStamp;
  String userAccessKey;
  String userAccessKeyType;
  String userPhoneCountry;
  String commonApiLanguage;
  String applicationVersion;

  Data(
      {this.api,
      this.commonApplicationToken,
      this.commonApiVersion,
      this.userPhoneNumber,
      this.commonProcessToken,
      this.commonTimeStamp,
      this.userAccessKey,
      this.userAccessKeyType,
      this.userPhoneCountry,
      this.commonApiLanguage,
      this.applicationVersion});

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    commonApplicationToken = json['Common_ApplicationToken'];
    commonApiVersion = json['Common_ApiVersion'];
    userPhoneNumber = json['User_PhoneNumber'];
    commonProcessToken = json['Common_ProcessToken'];
    commonTimeStamp = json['Common_TimeStamp'];
    userAccessKey = json['User_AccessKey'];
    userAccessKeyType = json['User_AccessKeyType'];
    userPhoneCountry = json['User_PhoneCountry'];
    commonApiLanguage = json['Common_ApiLanguage'];
    applicationVersion = json['applicationVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Api'] = this.api;
    data['Common_ApplicationToken'] = this.commonApplicationToken;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['User_PhoneNumber'] = this.userPhoneNumber;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    data['User_AccessKey'] = this.userAccessKey;
    data['User_AccessKeyType'] = this.userAccessKeyType;
    data['User_PhoneCountry'] = this.userPhoneCountry;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['applicationVersion'] = this.applicationVersion;
    return data;
  }
}
