import 'package:mobiwoom/core/utils/cdata_parser.dart';

class Card {
  Response response;
  String error;

  Card.withError(String errorValue)
      : response = Response(),
        error = errorValue;

  Card({this.response});

  Card.fromJson(Map<String, dynamic> json) {
    response = json['Response'] != null ? new Response.fromJson(json['Response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['Response'] = this.response.toJson();
    }
    return data;
  }
}

class Response {
  String errorNumber;
  String source;
  dynamic message;
  String displayMessage;
  String waitCount;
  String recallCount;
  String processRecall;
  String versionSQL;
  String versionPartner;
  String versionUser;
  String versionTPE;
  String partnerId;
  String partnerToken;
  String partnerPhoneNumber;
  String partnerPhoneCountry;
  String userId;
  String userToken;
  String userPhoneNumber;
  String userPhoneCountry;
  String processToken;
  Data data;

  Response(
      {this.errorNumber,
      this.source,
      this.message,
      this.displayMessage,
      this.waitCount,
      this.recallCount,
      this.processRecall,
      this.versionSQL,
      this.versionPartner,
      this.versionUser,
      this.versionTPE,
      this.partnerId,
      this.partnerToken,
      this.partnerPhoneNumber,
      this.partnerPhoneCountry,
      this.userId,
      this.userToken,
      this.userPhoneNumber,
      this.userPhoneCountry,
      this.processToken,
      this.data});

  Response.fromJson(Map<String, dynamic> json) {
    errorNumber = parseCDATA(json['ErrorNumber']);
    source = parseCDATA(json['Source']);
    message = parseCDATA(json['Message']);
    displayMessage = parseCDATA(json['DisplayMessage']);
    waitCount = parseCDATA(json['WaitCount']);
    recallCount = parseCDATA(json['RecallCount']);
    processRecall = parseCDATA(json['ProcessRecall']);
    versionSQL = parseCDATA(json['Version_SQL']);
    versionPartner = parseCDATA(json['Version_Partner']);
    versionUser = parseCDATA(json['Version_User']);
    versionTPE = parseCDATA(json['Version_TPE']);
    partnerId = parseCDATA(json['Partner_Id']);
    partnerToken = parseCDATA(json['Partner_Token']);
    partnerPhoneNumber = parseCDATA(json['Partner_PhoneNumber']);
    partnerPhoneCountry = parseCDATA(json['Partner_PhoneCountry']);
    userId = parseCDATA(json['User_Id']);
    userToken = parseCDATA(json['User_Token']);
    userPhoneNumber = parseCDATA(json['User_PhoneNumber']);
    userPhoneCountry = parseCDATA(json['User_PhoneCountry']);
    processToken = parseCDATA(json['ProcessToken']);
    data = json['Data'] != null && json["Data"] != "" ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorNumber'] = this.errorNumber;
    data['Source'] = this.source;
    data['Message'] = this.message;
    data['DisplayMessage'] = this.displayMessage;
    data['WaitCount'] = this.waitCount;
    data['RecallCount'] = this.recallCount;
    data['ProcessRecall'] = this.processRecall;
    data['Version_SQL'] = this.versionSQL;
    data['Version_Partner'] = this.versionPartner;
    data['Version_User'] = this.versionUser;
    data['Version_TPE'] = this.versionTPE;
    data['Partner_Id'] = this.partnerId;
    data['Partner_Token'] = this.partnerToken;
    data['Partner_PhoneNumber'] = this.partnerPhoneNumber;
    data['Partner_PhoneCountry'] = this.partnerPhoneCountry;
    data['User_Id'] = this.userId;
    data['User_Token'] = this.userToken;
    data['User_PhoneNumber'] = this.userPhoneNumber;
    data['User_PhoneCountry'] = this.userPhoneCountry;
    data['ProcessToken'] = this.processToken;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Row> row;

  Data({this.row});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Row'] != null) {
      row = new List<Row>();
      json['Row'].forEach((v) {
        row.add(new Row.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.row != null) {
      data['Row'] = this.row.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Row {
  String token;
  String tag;
  String main;
  String type;
  String number;
  String month;
  String year;
  String holderName;
  String code;

  Row({
    this.token,
    this.tag,
    this.main,
    this.type,
    this.number,
    this.month,
    this.year,
    this.holderName,
    this.code,
  });

  Row.fromJson(Map<String, dynamic> json) {
    token = parseCDATA(json['Token']);
    tag = parseCDATA(json['Tag']);
    main = parseCDATA(json['Main']);
    type = parseCDATA(json['Type']);
    number = parseCDATA(json['Number']);
    month = parseCDATA(json['Month']);
    year = parseCDATA(json['Year']);
    holderName = parseCDATA(json['HolderName']);
    code = parseCDATA(json['Code']);
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
    return data;
  }
}
