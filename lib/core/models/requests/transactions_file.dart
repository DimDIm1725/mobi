class TransactionFileRequest {
  Data _data;

  TransactionFileRequest({Data data}) {
    print('LoginRequest');
    this._data = data;
  }

  Data get data => _data;

  set data(Data data) => _data = data;

  TransactionFileRequest.fromJson(Map<String, dynamic> json) {
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
  String _api;
  String _userUniversalKey;
  String _userPhoneCountry;
  String _language;
  String _userPinCode;
  String _year;
  String _month;
  String _documentName;
  String _applicationVersion;
  String _applicationToken;
  String _commonApiLanguage;
  String _commonApiVersion;
  String _commonProcessToken;
  String _commonTimeStamp;

  Data({
    String api,
    String userUniversalKey,
    String userPhoneCountry,
    String language,
    String userPinCode,
    String year,
    String month,
    String documentName,
    String applicationVersion,
    String applicationToken,
    String commonApiLanguage,
    String commonApiVersion,
    String commonProcessToken,
    String commonTimeStamp
  }) {
    this._api = api;
    this._userUniversalKey = userUniversalKey;
    this._userPhoneCountry = userPhoneCountry;
    this._language = language;
    this._userPinCode = userPinCode;
    this._year = year;
    this._month = month;
    this._documentName = documentName;
    this._applicationVersion = applicationVersion;
    this._applicationToken = applicationToken;
    this._commonApiLanguage = commonApiLanguage;
    this._commonApiVersion = commonApiVersion;
    this._commonProcessToken = commonProcessToken;
    this._commonTimeStamp = commonTimeStamp;
  }

  Data.fromJson(Map<String, dynamic> json) {
    _api = json['Api'];
    _userUniversalKey = json['Account_PhoneNumber'];
    _userPhoneCountry = json['Account_PhoneCountry'];
    _language = json['Language'];
    _userPinCode = json['Account_PinCode'];
    _year = json['Year'];
    _month = json['Month'];
    _documentName = json['DocumentName'];
    _applicationVersion = json['Common_ApplicationVersion'];
    _applicationToken = json['Common_ApplicationToken'];
    _commonApiLanguage = json['Common_ApiLanguage'];
    _commonApiVersion = json['Common_ApiVersion'];
    _commonProcessToken = json['Common_ProcessToken'];
    _commonTimeStamp = json['Common_TimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Api'] = this._api;
    data['Account_PhoneNumber'] = this._userUniversalKey;
    data['Account_PhoneCountry'] = this._userPhoneCountry;
    data['Language'] = this._language;
    data['Account_PinCode'] = this._userPinCode;
    data['Year'] = this._year;
    data['Month'] = this._month;
    data['DocumentName'] = this._documentName;
    data['Common_ApplicationVersion'] = this._applicationVersion;
    data['Common_ApplicationToken'] = this._applicationToken;
    data['Common_ApiLanguage'] = this._commonApiLanguage;
    data['Common_ApiVersion'] = this._commonApiVersion;
    data['Common_ProcessToken'] = this._commonProcessToken;
    data['Common_TimeStamp'] = this._commonTimeStamp;
    return data;
  }

  String get documentName => _documentName;

  set documentName(String value) {
    _documentName = value;
  }

  String get year => _year;

  set year(String value) {
    _year = value;
  }

  String get month => _month;

  set month(String value) {
    _month = value;
  }

  String get commonApiVersion => _commonApiVersion;

  set commonApiVersion(String value) {
    _commonApiVersion = value;
  }

  String get commonProcessToken => _commonProcessToken;

  set commonProcessToken(String value) {
    _commonProcessToken = value;
  }

  String get commonTimeStamp => _commonTimeStamp;

  set commonTimeStamp(String value) {
    _commonTimeStamp = value;
  }

  String get api => _api;

  set api(String api) => _api = api;

  String get userUniversalKey => _userUniversalKey;

  set userUniversalKey(String userUniversalKey) => _userUniversalKey = userUniversalKey;

  String get userPhoneCountry => _userPhoneCountry;

  set userPhoneCountry(String userPhoneCountry) => _userPhoneCountry = userPhoneCountry;

  String get language => _language;

  set language(String language) => _language = language;

  String get userPinCode => _userPinCode;

  set userPinCode(String userPinCode) => _userPinCode = userPinCode;

  String get applicationVersion => _applicationVersion;

  set applicationVersion(String applicationVersion) => _applicationVersion = applicationVersion;

  String get applicationToken => _applicationToken;

  set applicationToken(String applicationToken) => _applicationToken = applicationToken;
}
