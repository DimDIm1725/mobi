import 'dart:convert';
import 'package:mobiwoom/core/utils/cdata_parser.dart';

class LoginResponse {
  Response _response;

  LoginResponse({Response response}) {
    this._response = response;
  }

  Response get response => _response;

  set response(Response response) => _response = response;

  LoginResponse.withError(String errorValue)
      : _response = Response(),
        _error = errorValue;
  String _error;
  LoginResponse.fromJson(Map<String, dynamic> json) {
    _response = json['Response'] != null ? new Response.fromJson(json['Response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._response != null) {
      data['Response'] = this._response.toJson();
    }
    return data;
  }

  String toJSONString() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._response != null) {
      data['Response'] = this._response.toJson();
    }
    return jsonEncode(data);
  }
}

class Response {
  String _errorNumber;
  String _source;
  dynamic _message;
  String _displayMessage;
  String _waitCount;
  String _recallCount;
  String _partnerId;
  String _partnerToken;
  String _partnerPhoneNumber;
  String _partnerPhoneCountry;
  String _userId;
  String _userToken;
  String _userPhoneNumber;
  String _userPhoneCountry;
  String _processToken;
  String _userLongitude;
  String _userLatitude;
  String _userVersion;
  Data _data;

  Response(
      {String errorNumber,
      String source,
      dynamic message,
      String displayMessage,
      String waitCount,
      String recallCount,
      String partnerId,
      String partnerToken,
      String partnerPhoneNumber,
      String partnerPhoneCountry,
      String userId,
      String userToken,
      String userPhoneNumber,
      String userPhoneCountry,
      String processToken,
      String userLatitude,
      String userLongitude,
      String userVersion,
      Data data}) {
    this._errorNumber = errorNumber;
    this._source = source;
    this._message = message;
    this._displayMessage = displayMessage;
    this._waitCount = waitCount;
    this._recallCount = recallCount;
    this._partnerId = partnerId;
    this._partnerToken = partnerToken;
    this._partnerPhoneNumber = partnerPhoneNumber;
    this._partnerPhoneCountry = partnerPhoneCountry;
    this._userId = userId;
    this._userToken = userToken;
    this._userPhoneNumber = userPhoneNumber;
    this._userPhoneCountry = userPhoneCountry;
    this._processToken = processToken;
    this._userLatitude = userLatitude;
    this._userLongitude = userLongitude;
    this._userVersion = userVersion;
    this._data = data;
  }

  String get errorNumber => _errorNumber;

  set errorNumber(String errorNumber) => _errorNumber = errorNumber;

  String get source => _source;

  set source(String source) => _source = source;

  dynamic get message => _message;

  set message(dynamic value) {
    _message = value;
  }

  String get displayMessage => _displayMessage;

  set displayMessage(String displayMessage) => _displayMessage = displayMessage;

  String get waitCount => _waitCount;

  set waitCount(String waitCount) => _waitCount = waitCount;

  String get recallCount => _recallCount;

  set recallCount(String recallCount) => _recallCount = recallCount;

  String get partnerId => _partnerId;

  set partnerId(String partnerId) => _partnerId = partnerId;

  String get partnerToken => _partnerToken;

  set partnerToken(String partnerToken) => _partnerToken = partnerToken;

  String get partnerPhoneNumber => _partnerPhoneNumber;

  set partnerPhoneNumber(String partnerPhoneNumber) => _partnerPhoneNumber = partnerPhoneNumber;

  String get partnerPhoneCountry => _partnerPhoneCountry;

  set partnerPhoneCountry(String partnerPhoneCountry) => _partnerPhoneCountry = partnerPhoneCountry;

  String get userId => _userId;

  set userId(String userId) => _userId = userId;

  String get userToken => _userToken;

  set userToken(String userToken) => _userToken = userToken;

  String get userPhoneNumber => _userPhoneNumber;

  set userPhoneNumber(String userPhoneNumber) => _userPhoneNumber = userPhoneNumber;

  String get userPhoneCountry => _userPhoneCountry;

  set userPhoneCountry(String userPhoneCountry) => _userPhoneCountry = userPhoneCountry;

  String get processToken => _processToken;

  set processToken(String processToken) => _processToken = processToken;

 /* String get userLatitude => _userLatitude;

  set userLatitude(String userLatitude) => _userLatitude = userLatitude;

  String get userLongitude => _userLongitude;

  set userLongitude(String userLongitude) => _userLongitude = userLongitude;*/

  String get userVersion => _userVersion;

  set userVersion(String userVersion) => _userVersion = userVersion;

  Data get data => _data;

  set data(Data data) => _data = data;

  Response.fromJson(Map<String, dynamic> json) {
    _errorNumber = parseCDATA(json['ErrorNumber']);
    _source = parseCDATA(json['Source']);
    _message = parseCDATA(json['Message']);
    _displayMessage = parseCDATA(json['DisplayMessage']);
    _waitCount = parseCDATA(json['WaitCount']);
    _recallCount = parseCDATA(json['RecallCount']);
    _partnerId = parseCDATA(json['Partner_Id']);
    _partnerToken = parseCDATA(json['Partner_Token']);
    _partnerPhoneNumber = parseCDATA(json['Partner_PhoneNumber']);
    _partnerPhoneCountry = parseCDATA(json['Partner_PhoneCountry']);
    _userId = parseCDATA(json['User_Id']);
    _userToken = parseCDATA(json['User_Token']);
    _userPhoneNumber = parseCDATA(json['User_PhoneNumber']);
    _userPhoneCountry = parseCDATA(json['User_PhoneCountry']);
    _processToken = parseCDATA(json['ProcessToken']);
  //  _userLongitude = parseCDATA(json['User_Longitude']);
  //  _userLatitude = parseCDATA(json['User_Latitude']);
    _userVersion = parseCDATA(json['Version_User']);
    _data = json['Data'] != null && json['Data'].toString().isNotEmpty ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorNumber'] = this._errorNumber;
    data['Source'] = this._source;
    data['Message'] = this._message;
    data['DisplayMessage'] = this._displayMessage;
    data['WaitCount'] = this._waitCount;
    data['RecallCount'] = this._recallCount;
    data['Partner_Id'] = this._partnerId;
    data['Partner_Token'] = this._partnerToken;
    data['Partner_PhoneNumber'] = this._partnerPhoneNumber;
    data['Partner_PhoneCountry'] = this._partnerPhoneCountry;
    data['User_Id'] = this._userId;
    data['User_Token'] = this._userToken;
    data['User_PhoneNumber'] = this._userPhoneNumber;
    data['User_PhoneCountry'] = this._userPhoneCountry;
  //  data['User_Latitude'] = this._userLatitude;
  //  data['User_Longitude'] = this._userLongitude;
    data['Version_User'] = this._userVersion;
    data['ProcessToken'] = this._processToken;
    if (this._data != null) {
      data['Data'] = this._data.toJson();
    }
    return data;
  }
}

class Data {
  String _userGender;
  String _userGenderText;
  String _userFirstName;
  String _userLastName;
  String _userAddress;
  String _userCountry;
  String _userZipCode;
  String _userCity;
 // String _userPhoneNumber;
  String _userLanguage;
  String _userEMail;
  String _userLatitude;
  String _userLongitude;
  String _userWalletId;
  String _userSignature;
  String _userFunctionalWallet;
  String _userCreationDateTime;
  String _userBirthDay;
  String _userMaxSponsoredUsers;
  String _userSponsoredUsersCount;
  String _userVipStatusCount;
//  String _userAccessKeyMobileCity;
// String _userWordPressId;
  // String _userVersion;
  String _amount;
  String _userTicketMachinesCountInUse;
  String _systemUrlNews;

  Data(
      {String userGender,
      String userGenderText,
      String userFirstName,
      String userLastName,
      String userAddress,
      String userCountry,
      String userZipCode,
      String userCity,
      String userPhoneNumber,
      String userLanguage,
      String userEMail,
      String userLatitude,
      String userLongitude,
      String userWalletId,
      String userSignature,
      String userFunctionalWallet,
      String userCreationDateTime,
      String userBirthDay,
      String userMaxSponsoredUsers,
      String userSponsoredUsersCount,
      String userVipStatusCount,
      String userAccessKeyMobileCity,
      String userWordPressId,
   //   String version,
      String userTicketMachinesCountInUse,
      String amount}) {
    this._userGender = userGender;
    this._userGenderText = userGenderText;
    this._userFirstName = userFirstName;
    this._userLastName = userLastName;
    this._userAddress = userAddress;
    this._userCountry = userCountry;
    this._userZipCode = userZipCode;
    this._userCity = userCity;
  //  this._userPhoneNumber = userPhoneNumber;
    this._userLanguage = userLanguage;
    this._userEMail = userEMail;
    this._userLatitude = userLatitude;
    this._userLongitude = userLongitude;
    this._userWalletId = userWalletId;
    this._userSignature = userSignature;
    this._userFunctionalWallet = userFunctionalWallet;
    this._userCreationDateTime = userCreationDateTime;
    this._userBirthDay = userBirthDay;
    this._userMaxSponsoredUsers = userMaxSponsoredUsers;
    this._userSponsoredUsersCount = userSponsoredUsersCount;
    this._userVipStatusCount = userVipStatusCount;
  //  this._userAccessKeyMobileCity = userAccessKeyMobileCity;
  //  this._userWordPressId = userWordPressId;
  //  this._userVersion = userVersion;
    this._userTicketMachinesCountInUse = userTicketMachinesCountInUse;
    this._amount = amount;
  }

  String get userGender => _userGender;

  set userGender(String userGender) => _userGender = userGender;

  String get userGenderText => _userGenderText;

  set userGenderText(String userGenderText) => _userGenderText = userGenderText;

  String get userFirstName => _userFirstName;

  set userFirstName(String userFirstName) => _userFirstName = userFirstName;

  String get userLastName => _userLastName;

  set userLastName(String userLastName) => _userLastName = userLastName;

  String get userAddress => _userAddress;

  set userAddress(String userAddress) => _userAddress = userAddress;

  String get userCountry => _userCountry;

  set userCountry(String userCountry) => _userCountry = userCountry;

  String get userZipCode => _userZipCode;

  set userZipCode(String userZipCode) => _userZipCode = userZipCode;

  String get userCity => _userCity;

  set userCity(String userCity) => _userCity = userCity;

 /* String get userPhoneNumber => _userPhoneNumber;

  set userPhoneNumber(String userPhoneNumber) => _userPhoneNumber = userPhoneNumber;*/

  String get userLanguage => _userLanguage;

  set userLanguage(String userLanguage) => _userLanguage = userLanguage;

  String get userEMail => _userEMail;

  set userEMail(String userEMail) => _userEMail = userEMail;

  String get userLatitude => _userLatitude;

  set userLatitude(String userLatitude) => _userLatitude = userLatitude;

  String get userLongitude => _userLongitude;

  set userLongitude(String userLongitude) => _userLongitude = userLongitude;

  String get userWalletId => _userWalletId;

  set userWalletId(String userWalletId) => _userWalletId = userWalletId;

  String get userSignature => _userSignature;

  set userSignature(String userSignature) => _userSignature = userSignature;

  String get userFunctionalWallet => _userFunctionalWallet;

  set userFunctionalWallet(String userFunctionalWallet) => _userFunctionalWallet = userFunctionalWallet;

  String get userCreationDateTime => _userCreationDateTime;

  set userCreationDateTime(String userCreationDateTime) => _userCreationDateTime = userCreationDateTime;

  String get userBirthDay => _userBirthDay;

  set userBirthDay(String userBirthDay) => _userBirthDay = userBirthDay;

  String get userMaxSponsoredUsers => _userMaxSponsoredUsers;

  set userMaxSponsoredUsers(String userMaxSponsoredUsers) => _userMaxSponsoredUsers = userMaxSponsoredUsers;

  String get userSponsoredUsersCount => _userSponsoredUsersCount;

  set userSponsoredUsersCount(String userSponsoredUsersCount) => _userSponsoredUsersCount = userSponsoredUsersCount;

  String get userVipStatusCount => _userVipStatusCount;

  set userVipStatusCount(String userVipStatusCount) => _userVipStatusCount = userVipStatusCount;

 // String get userAccessKeyMobileCity => _userAccessKeyMobileCity;

 // set userAccessKeyMobileCity(String userAccessKeyMobileCity) => _userAccessKeyMobileCity = userAccessKeyMobileCity;

 // String get userWordPressId => _userWordPressId;

 // set userWordPressId(String userWordPressId) => _userWordPressId = userWordPressId;

 // String get userVersion => _userVersion;

 // set version(String version) => _userVersion = version;

  String get userTicketMachinesCountInUse => _userTicketMachinesCountInUse;

  set userTicketMachinesCountInUse(String userTicketMachinesCountInUse) => _userTicketMachinesCountInUse = userTicketMachinesCountInUse;

  String get amount => _amount;

  set amount(String value) {
    _amount = value;
  }

  String get systemUrl => _systemUrlNews;

  set systemUrl(String systemUrl) => _systemUrlNews = systemUrl;

  Data.fromJson(Map<String, dynamic> json) {
    _userGender = parseCDATA(json['User_Gender']);
    _userGenderText = parseCDATA(json['User_GenderText']);
    _userFirstName = parseCDATA(json['User_FirstName']);
    _userLastName = parseCDATA(json['User_LastName']);
    _userAddress = parseCDATA(json['User_Address']);
    _userCountry = parseCDATA(json['User_Country']);
    _userZipCode = parseCDATA(json['User_ZipCode']);
    _userCity = parseCDATA(json['User_City']);
 //   _userPhoneNumber = parseCDATA(json['User_PhoneNumber']);
    _userLanguage = parseCDATA(json['User_Language']);
    _userEMail = parseCDATA(json['User_EMail']);
    _userLatitude = parseCDATA(json['User_Latitude']);
    _userLongitude = parseCDATA(json['User_Longitude']);
    _userWalletId = parseCDATA(json['User_WalletId']);
    _userSignature = parseCDATA(json['User_Signature']);
    _userFunctionalWallet = parseCDATA(json['User_FunctionalWallet']);
    _userCreationDateTime = parseCDATA(json['User_CreationDateTime']);
    _userBirthDay = parseCDATA(json['User_BirthDay']);
    _userMaxSponsoredUsers = parseCDATA(json['User_MaxSponsoredUsers']);
    _userSponsoredUsersCount = parseCDATA(json['User_SponsoredUsersCount']);
    _userVipStatusCount = parseCDATA(json['User_VipStatusCount']);
 //   _userAccessKeyMobileCity = parseCDATA(json['User_AccessKeyMobileCity']);
  //  _userWordPressId = parseCDATA(json['User_WordPressId']);
  //  _userVersion = parseCDATA(json['Version_User']);
    _userTicketMachinesCountInUse = parseCDATA(json['User_TicketMachinesCountInUse']);
    _amount = parseCDATA(json['Amount']);
    _systemUrlNews = parseCDATA(json['System_UrlNews']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['User_Gender'] = this._userGender;
    data['User_GenderText'] = this._userGenderText;
    data['User_FirstName'] = this._userFirstName;
    data['User_LastName'] = this._userLastName;
    data['User_Address'] = this._userAddress;
    data['User_Country'] = this._userCountry;
    data['User_ZipCode'] = this._userZipCode;
    data['User_City'] = this._userCity;
 //   data['User_PhoneNumber'] = this._userPhoneNumber;
    data['User_Language'] = this._userLanguage;
    data['User_EMail'] = this._userEMail;
    data['User_Latitude'] = this._userLatitude;
    data['User_Longitude'] = this._userLongitude;
    data['User_WalletId'] = this._userWalletId;
    data['User_Signature'] = this._userSignature;
    data['User_FunctionalWallet'] = this._userFunctionalWallet;
    data['User_CreationDateTime'] = this._userCreationDateTime;
    data['User_BirthDay'] = this._userBirthDay;
    data['User_MaxSponsoredUsers'] = this._userMaxSponsoredUsers;
    data['User_SponsoredUsersCount'] = this._userSponsoredUsersCount;
    data['User_VipStatusCount'] = this._userVipStatusCount;
  //  data['User_AccessKeyMobileCity'] = this._userAccessKeyMobileCity;
  //  data['User_WordPressId'] = this._userWordPressId;
 //   data['Version_User'] = this._userVersion;
    data['Amount'] = this._amount;
    data['User_TicketMachinesCountInUse'] = this._userTicketMachinesCountInUse;
    data['System_UrlNews'] = this._systemUrlNews;
    return data;
  }
}
