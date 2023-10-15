class TokenRequest {
  Data _data;

  TokenRequest({Data data}) {
    this._data = data;
  }

  Data get data => _data;

  set data(Data data) => _data = data;

  TokenRequest.fromJson(Map<String, dynamic> json) {
    _data = json['Data'] != null && json['Data'] != "" ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._data != null) {
      data['Data'] = this._data.toJson();
    }
    return data;
  }
}

class Data {
  String token;
  String api;
  String userUniversalKey;
  String applicationVersion;
  String applicationToken;
  String userPhoneCountry;
  String commonApiLanguage;
  String commonApiVersion;
  String commonProcessToken;
  String commonTimeStamp;

  Data({
    this.token,
    this.api,
    this.userUniversalKey,
    this.userPhoneCountry,
    this.applicationVersion,
    this.applicationToken,
    this.commonApiLanguage,
    this.commonApiVersion,
    this.commonProcessToken,
    this.commonTimeStamp,
  });

  Data.fromJson(Map<String, dynamic> json) {
    token = json['Enrollment_Token'];
    api = json['Api'];
    userUniversalKey = json['Account_PhoneNumber'];
    userPhoneCountry = json['Account_PhoneCountry'];
    applicationVersion = json['Common_ApplicationVersion'];
    applicationToken = json['Common_ApplicationToken'];
    commonApiLanguage = json['Common_ApiLanguage'];
    commonApiVersion = json['Common_ApiVersion'];
    commonProcessToken = json['Common_ProcessToken'];
    commonTimeStamp = json['Common_TimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Enrollment_Token'] = this.token;
    data['Api'] = this.api;
    data['Account_PhoneNumber'] = this.userUniversalKey;
    data['Account_PhoneCountry'] = this.userPhoneCountry;
    data['Common_ApplicationVersion'] = this.applicationVersion;
    data['Common_ApplicationToken'] = this.applicationToken;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    return data;
  }
}