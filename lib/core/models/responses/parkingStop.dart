import 'dart:convert';
import 'package:mobiwoom/core/utils/cdata_parser.dart';

class ParkingStopResponse {
  Response _response;

  ParkingStopResponse({Response response}) {
    this._response = response;
  }

  Response get response => _response;

  set response(Response response) => _response = response;

  ParkingStopResponse.withError(String errorValue)
      : _response = Response(),
        _error = errorValue;
  String _error;
  ParkingStopResponse.fromJson(Map<String, dynamic> json) {
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

  String get userLatitude => _userLatitude;

  set userLatitude(String userLatitude) => _userLatitude = userLatitude;

  String get userLongitude => _userLongitude;

  set userLongitude(String userLongitude) => _userLongitude = userLongitude;

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
    _userLongitude = parseCDATA(json['User_Longitude']);
    _userLatitude = parseCDATA(json['User_Latitude']);
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
    data['User_Latitude'] = this._userLatitude;
    data['User_Longitude'] = this._userLongitude;
    data['ProcessToken'] = this._processToken;
    if (this._data != null) {
      data['Data'] = this._data.toJson();
    }
    return data;
  }
}

class Data {
  String _amount;

  Data({String amount}) {
    this._amount = amount;
  }

  String get amount => _amount;

  set amount(String value) {
    _amount = value;
  }

  Data.fromJson(Map<String, dynamic> json) {
    _amount = parseCDATA(json['Amount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Amount'] = this._amount;
    return data;
  }
}
