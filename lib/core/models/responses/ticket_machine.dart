import 'package:mobiwoom/core/utils/cdata_parser.dart';

class TicketMachineResponse {
  Response response;

  TicketMachineResponse.withError(String errorValue)
      : response = Response(),
        _error = errorValue;
  String _error;

  TicketMachineResponse({this.response});

  TicketMachineResponse.fromJson(Map<String, dynamic> json) {
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
    data = json['Data'] != null && json['Data'].toString().isNotEmpty ? new Data.fromJson(json['Data']) : null;
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
  String ticketMachineId;
  String ticketMachineName;
  String ticketMachineAddress;
  String ticketMachineDistance;
  String pricingAreaName;
  String pricingAreaDefaultDuration;
  String pricingAreaMaxDuration;
  String pricingAreaAmountCalculationFormula;
  String partnerCompanyName;
  String partnerZipCode;
  String partnerCity;
  String partnerCountry;
  String parkingUsersFullDays;
  String parkingUsersHalfDays;
  String ticketMachineLat;
  String ticketMachineLon;


  Row(
      {this.ticketMachineId,
      this.ticketMachineName,
      this.ticketMachineAddress,
      this.ticketMachineDistance,
      this.pricingAreaName,
      this.pricingAreaDefaultDuration,
      this.pricingAreaMaxDuration,
      this.pricingAreaAmountCalculationFormula,
      this.partnerCompanyName,
      this.partnerZipCode,
      this.partnerCity,
      this.partnerCountry,
      this.parkingUsersFullDays,
      this.parkingUsersHalfDays,
      this.ticketMachineLat,
      this.ticketMachineLon});

  Row.fromJson(Map<String, dynamic> json) {
    ticketMachineId = parseCDATA(json['TicketMachine_Id']);
    ticketMachineName = parseCDATA(json['TicketMachine_Name']);
    ticketMachineAddress = parseCDATA(json['TicketMachine_Address']);
    ticketMachineDistance = parseCDATA(json['TicketMachine_Distance']);
    pricingAreaName = parseCDATA(json['PricingArea_Name']);
    pricingAreaDefaultDuration = parseCDATA(json['PricingArea_DefaultDuration']);
    pricingAreaMaxDuration = parseCDATA(json['PricingArea_MaxDuration']);
    pricingAreaAmountCalculationFormula = parseCDATA(json['PricingArea_AmountCalculationFormula']);
    partnerCompanyName = parseCDATA(json['Partner_CompanyName']);
    partnerZipCode = parseCDATA(json['Partner_ZipCode']);
    partnerCity = parseCDATA(json['Partner_City']);
    partnerCountry = parseCDATA(json['Partner_Country']);
    parkingUsersFullDays = parseCDATA(json['ParkingUsers_FullDays']);
    parkingUsersHalfDays = parseCDATA(json['ParkingUsers_HalfDays']);
    ticketMachineLat = parseCDATA(json['TicketMachine_Latitude']);
    ticketMachineLon = parseCDATA(json['TicketMachine_Longitude']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TicketMachine_Id'] = this.ticketMachineId;
    data['TicketMachine_Name'] = this.ticketMachineName;
    data['TicketMachine_Address'] = this.ticketMachineAddress;
    data['TicketMachine_Distance'] = this.ticketMachineDistance;
    data['PricingArea_Name'] = this.pricingAreaName;
    data['PricingArea_DefaultDuration'] = this.pricingAreaDefaultDuration;
    data['PricingArea_MaxDuration'] = this.pricingAreaMaxDuration;
    data['PricingArea_AmountCalculationFormula'] = this.pricingAreaAmountCalculationFormula;
    data['Partner_CompanyName'] = this.partnerCompanyName;
    data['Partner_ZipCode'] = this.partnerZipCode;
    data['Partner_City'] = this.partnerCity;
    data['Partner_Country'] = this.partnerCountry;
    data['ParkingUsers_FullDays'] = this.parkingUsersFullDays;
    data['ParkingUsers_HalfDays'] = this.parkingUsersHalfDays;
    data['TicketMachine_Latitude'] = this.ticketMachineLat;
    data['TicketMachine_Longitude'] = this.ticketMachineLon;
    return data;
  }
}
