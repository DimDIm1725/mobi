class CardRequest {
  Data _data;

  CardRequest({Data data}) {
    this._data = data;
  }

  Data get data => _data;

  set data(Data data) => _data = data;

  CardRequest.fromJson(Map<String, dynamic> json) {
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
  String tag;
  String main;
  String type;
  String number;
  String month;
  String year;
  String holderName;
  String code;
  String api;
  String userUniversalKey;
  String userId;
  String applicationVersion;
  String applicationToken;
  String userPhoneCountry;
  String userPincode;
  String commonApiLanguage;
  String commonApiVersion;
  String commonProcessToken;
  String commonTimeStamp;

  Data({
    this.token,
    this.tag,
    this.main,
    this.type,
    this.number,
    this.month,
    this.year,
    this.holderName,
    this.code,
    this.api,
    this.userId,
    this.userUniversalKey,
    this.userPhoneCountry,
    this.applicationVersion,
    this.applicationToken,
    this.userPincode,
    this.commonApiLanguage,
    this.commonApiVersion,
    this.commonProcessToken,
    this.commonTimeStamp,
  });

  Data.fromJson(Map<String, dynamic> json) {
    token = json['Token'];
    tag = json['Tag'];
    main = json['Main'];
    type = json['Type'];
    number = json['Number'];
    month = json['Month'];
    year = json['Year'];
    holderName = json['HolderName'];
    code = json['Code'];
    api = json['Api'];
    userUniversalKey = json['Account_PhoneNumber'];
    userPhoneCountry = json['Account_PhoneCountry'];
    applicationVersion = json['Common_ApplicationVersion'];
    applicationToken = json['Common_ApplicationToken'];
    userPincode = json['User_PinCode'];
    commonApiLanguage = json['Common_ApiLanguage'];
    commonApiVersion = json['Common_ApiVersion'];
    commonProcessToken = json['Common_ProcessToken'];
    commonTimeStamp = json['Common_TimeStamp'];
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Token'] = this.token;
    data['Tag'] = this.tag;
    data['Main'] = this.main;
    data['Type'] = this.type;
    data['Number'] = this.number;
    data['Month'] = this.month;
    data['Year'] = this.year;
    data['HolderName'] = this.holderName;
    data['Code'] = this.code;
    data['Api'] = this.api;
    data['Account_PhoneNumber'] = this.userUniversalKey;
    data['Account_PhoneCountry'] = this.userPhoneCountry;
    data['Common_ApplicationVersion'] = this.applicationVersion;
    data['Common_ApplicationToken'] = this.applicationToken;
    data['user_PinCode'] = this.userPincode;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    data['UserId'] = this.userId;
    return data;
  }
}
