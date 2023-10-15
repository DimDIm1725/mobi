import 'package:mobiwoom/core/utils/cdata_parser.dart';

class LicenseResponse {
  Response response;

  LicenseResponse({this.response});

  LicenseResponse.fromJson(Map<String, dynamic> json) {
    response = json['Response'] != null ? new Response.fromJson(json['Response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['Response'] = this.response.toJson();
    }
    return data;
  }

  String error;

  LicenseResponse.withError(String errorValue)
      : response = Response(),
        error = errorValue;
}

class Response {
  String errorNumber;
  String source;
  dynamic message;
  String displayMessage;
  String waitCount;
  String recallCount;
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
    partnerId = parseCDATA(json['Partner_Id']);
    partnerToken = parseCDATA(json['Partner_Token']);
    partnerPhoneNumber = parseCDATA(json['Partner_PhoneNumber']);
    partnerPhoneCountry = parseCDATA(json['Partner_PhoneCountry']);
    userId = parseCDATA(json['User_Id']);
    userToken = parseCDATA(json['User_Token']);
    userPhoneNumber = parseCDATA(json['User_PhoneNumber']);
    userPhoneCountry = parseCDATA(json['User_PhoneCountry']);
    processToken = parseCDATA(json['ProcessToken']);
    data = json['Data'] != null && json['Data'] != "" ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorNumber'] = this.errorNumber;
    data['Source'] = this.source;
    data['Message'] = this.message;
    data['DisplayMessage'] = this.displayMessage;
    data['WaitCount'] = this.waitCount;
    data['RecallCount'] = this.recallCount;
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
  String carPlate;
  String main;
  String tag;
  String startDateTime = '';
  String stopDateTime = '';
  String duration;
  String amount;
  String pricingAreaName;
  String ticketMachineName;
  String ticketMachineAddress;
  String partnerCompanyName;
  String partnerZipCode;
  String partnerCity;
  String partnerCountry;

  Row(
      {this.carPlate,
      this.main,
      this.tag,
      this.startDateTime,
      this.stopDateTime,
      this.duration,
      this.amount,
      this.pricingAreaName,
      this.ticketMachineName,
      this.ticketMachineAddress,
      this.partnerCompanyName,
      this.partnerZipCode,
      this.partnerCity,
      this.partnerCountry});

  Row.fromJson(Map<String, dynamic> json) {
    carPlate = parseCDATA(json['CarPlate']);
    main = parseCDATA(json['Main']);
    tag = parseCDATA(json['Tag']);
    startDateTime = parseCDATA(json['StartDateTime']);
    stopDateTime = parseCDATA(json['StopDateTime']);
    duration = parseCDATA(json['Duration']);
    amount = parseCDATA(json['Amount']);
    pricingAreaName = parseCDATA(json['PricingArea_Name']);
    ticketMachineName = parseCDATA(json['TicketMachine_Name']);
    ticketMachineAddress = parseCDATA(json['TicketMachine_Address']);
    partnerCompanyName = parseCDATA(json['Partner_CompanyName']);
    partnerZipCode = parseCDATA(json['Partner_ZipCode']);
    partnerCity = parseCDATA(json['Partner_City']);
    partnerCountry = parseCDATA(json['Partner_Country']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CarPlate'] = this.carPlate;
    data['Main'] = this.main;
    data['Tag'] = this.tag;
    data['StartDateTime'] = this.startDateTime;
    data['StopDateTime'] = this.stopDateTime;
    data['Duration'] = this.duration;
    data['Amount'] = this.amount;
    data['PricingArea_Name'] = this.pricingAreaName;
    data['TicketMachine_Name'] = this.ticketMachineName;
    data['TicketMachine_Address'] = this.ticketMachineAddress;
    data['Partner_CompanyName'] = this.partnerCompanyName;
    data['Partner_ZipCode'] = this.partnerZipCode;
    data['Partner_City'] = this.partnerCity;
    data['Partner_Country'] = this.partnerCountry;
    return data;
  }
}
