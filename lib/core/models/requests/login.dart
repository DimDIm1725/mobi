class LoginRequest {
  Data _data;

  LoginRequest({Data data}) {
    print('LoginRequest');
    this._data = data;
  }

  Data get data => _data;

  set data(Data data) => _data = data;

  LoginRequest.fromJson(Map<String, dynamic> json) {
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
  String _userBrowserType;
  String _userEmail;
  String _language;
  String _userPinCode;
  String _applicationVersion;
  String _applicationToken;
  String _creditCardToken;
  String _carPlate;
  String _cashBackPendingToken;
  String _commonApiLanguage;
  String _commonApiVersion;
  String _commonProcessToken;
  String _commonTimeStamp;
  String _accountPhoneCellularType;
  String _accountPhonePushCode;
  String _accountBrowserPushKey;
  String _accountBrowserPushEndPoint;
  String _accountBrowserPushAuthentication;
  String _userLongitude;
  String _userLatitude;
  String _enrollmentToken;
  String _year;
  String _month;

  Data({
    String api,
    String userUniversalKey,
    String userPhoneCountry,
    String userBrowserType,
    String language,
    String userPinCode,
    String applicationVersion,
    String applicationToken,
    String creditCardToken,
    String cashBackPendingToken,
    String carPlate,
    String commonApiLanguage,
    String commonApiVersion,
    String commonProcessToken,
    String commonTimeStamp,
    String userEmail,
    String accountPhoneCellularType,
    String accountPhonePushCode,
    String accountBrowserPushKey,
    String accountBrowserPushEndPoint,
    String accountBrowserPushAuthentication,
    String userLongitude,
    String userLatitude,
    String enrollmentToken,
    String year,
    String month
  }) {
    this._api = api;
    this._userUniversalKey = userUniversalKey;
    this._userPhoneCountry = userPhoneCountry;
    this._userBrowserType = userBrowserType;
    this._language = language;
    this._userPinCode = userPinCode;
    this._applicationVersion = applicationVersion;
    this._applicationToken = applicationToken;
    this._creditCardToken = creditCardToken;
    this._carPlate = carPlate;
    this._cashBackPendingToken = cashBackPendingToken;
    this._commonApiLanguage = commonApiLanguage;
    this._commonApiVersion = commonApiVersion;
    this._commonProcessToken = commonProcessToken;
    this._commonTimeStamp = commonTimeStamp;
    this._userEmail = userEmail;
    this._accountPhoneCellularType = accountPhoneCellularType;
    this._accountPhonePushCode = accountPhonePushCode;
    this._accountBrowserPushKey = accountBrowserPushKey;
    this._accountBrowserPushEndPoint = accountBrowserPushEndPoint;
    this._accountBrowserPushAuthentication = accountBrowserPushAuthentication;
    this._userLongitude = userLongitude;
    this._userLatitude = userLatitude;
    this._enrollmentToken = enrollmentToken;
    this._year = year;
    this._month = month;
  }

  Data.fromJson(Map<String, dynamic> json) {
    _api = json['Api'];
    _userUniversalKey = json['User_UniversalKey'];
    _userPhoneCountry = json['User_PhoneCountry'];
    _userBrowserType = json['User_BrowserType'];
    _userEmail = json['User_EMail'];
    _language = json['Language'];
    _userPinCode = json['User_PinCode'];
    _applicationVersion = json['Common_ApplicationVersion'];
    _applicationToken = json['Common_ApplicationToken'];
    _creditCardToken = json['CreditCard_Token'];
    _carPlate = json['CarPlate'];
    _cashBackPendingToken = json['CashBackPending_Token'];
    _commonApiLanguage = json['Common_ApiLanguage'];
    _commonApiVersion = json['Common_ApiVersion'];
    _commonProcessToken = json['Common_ProcessToken'];
    _commonTimeStamp = json['Common_TimeStamp'];
    _accountPhonePushCode = json['User_PhonePushCode'];
    _accountPhoneCellularType = json['User_PhoneCellularType'];
    _accountBrowserPushKey = json['User_BrowserPushKey'];
    _accountBrowserPushEndPoint = json['User_BrowserPushEndPoint'];
    _accountBrowserPushAuthentication = json['User_BrowserPushAuthentification'];
    _userLongitude = json['User_Longitude'];
    _userLatitude = json['User_Latitude'];
    _enrollmentToken = json['Enrollment_Token'];
    _year = json['Year'];
    _month = json['Month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Api'] = this._api;
    data['User_UniversalKey'] = this._userUniversalKey;
    data['User_PhoneCountry'] = this._userPhoneCountry;
    data['User_BrowserType'] = this._userBrowserType;
    data['User_EMail'] = this._userEmail;
    data['Language'] = this._language;
    data['User_PinCode'] = this._userPinCode;
    data['Common_ApplicationVersion'] = this._applicationVersion;
    data['Common_ApplicationToken'] = this._applicationToken;
    data['CreditCard_Token'] = this._creditCardToken;
    data['CarPlate'] = this._carPlate;
    data['CashBackPending_Token'] = this._cashBackPendingToken;
    data['Common_ApiLanguage'] = this._commonApiLanguage;
    data['Common_ApiVersion'] = this._commonApiVersion;
    data['Common_ProcessToken'] = this._commonProcessToken;
    data['Common_TimeStamp'] = this._commonTimeStamp;
    data['User_PhoneCellularType'] = this._accountPhoneCellularType;
    data['User_PhonePushCode'] = this._accountPhonePushCode;
    data['User_BrowserPushKey'] = this._accountBrowserPushKey;
    data['User_BrowserPushEndPoint'] = this._accountBrowserPushEndPoint;
    data['User_BrowserPushAuthentification'] = this._accountBrowserPushAuthentication;
    data['User_Longitude'] = this._userLongitude;
    data['User_Latitude'] = this._userLatitude;
    data['Year'] = this._year;
    data['Month'] = this._month;
    return data;
  }

  String get month => _month;

  set month(String value) {
    _month = value;
  }

  String get year => _year;

  set year(String value) {
    _year = value;
  }

  String get accountPhoneCellularType => _accountPhoneCellularType;

  set accountPhoneCellularType(String value) {
    _accountPhoneCellularType = value;
  }

  String get cashBackPendingToken => _cashBackPendingToken;

  set cashBackPendingToken(String value) {
    _cashBackPendingToken = value;
  }

  String get commonApiLanguage => _commonApiLanguage;

  set commonApiLanguage(String value) {
    _commonApiLanguage = value;
  }

  String get commonApiVersion => _commonApiVersion;

  set commonApiVersion(String value) {
    _commonApiVersion = value;
  }

  String get commonProcessToken => _commonProcessToken;

  set commonProcessToken(String value) {
    _commonProcessToken = value;
  }

  String get carPlate => _carPlate;

  set carPlate(String value) {
    _carPlate = value;
  }

  String get userEmail => _userEmail;

  set userEmail(String value) {
    _userEmail = value;
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

  String get userBrowserType => _userBrowserType;

  set userBrowserType(String userBrowserType) => _userBrowserType = userBrowserType;

  String get language => _language;

  set language(String language) => _language = language;

  String get userPinCode => _userPinCode;

  set userPinCode(String userPinCode) => _userPinCode = userPinCode;

  String get applicationVersion => _applicationVersion;

  set applicationVersion(String applicationVersion) => _applicationVersion = applicationVersion;

  String get applicationToken => _applicationToken;

  set applicationToken(String applicationToken) => _applicationToken = applicationToken;

  String get creditCardToken => _creditCardToken;

  set creditCardToken(String value) {
    _creditCardToken = value;
  }

  String get cardPlate => _carPlate;

  set cardPlate(String value) {
    _carPlate = value;
  }

  String get accountPhonePushCode => _accountPhonePushCode;

  set accountPhonePushCode(String value) {
    _accountPhonePushCode = value;
  }

  String get userLatitude => _userLatitude;

  set userLatitude(String value) {
    _userLatitude = value;
  }

  String get userLongitude => _userLongitude;

  set userLongitude(String value) {
    _userLongitude = value;
  }

  String get enrollmentToken => _enrollmentToken;

  set enrollmentToken(String value) {
    _enrollmentToken = value;
  }
}
