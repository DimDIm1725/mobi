import 'package:mobiwoom/core/utils/cdata_parser.dart';

class TransactionsFileResponse {
  Response response;

  TransactionsFileResponse({this.response});

  TransactionsFileResponse.fromJson(Map<String, dynamic> json) {
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

  TransactionsFileResponse.withError(String errorValue)
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
  String partnerId;
  String partnerCompanyName;
  String partnerVouchersDeniedDays;
  String currencyCode;
  String currencySymbol;
  String transactionCreationDateTime;
  String transactionAmount;
  String transactionAmountAvailable;
  String transactionAvailableDateTime;
  String transactionDeadlineToUse;
  String transactionIsVoucher;

  Row(
      {this.partnerId,
      this.partnerCompanyName,
      this.partnerVouchersDeniedDays,
      this.currencyCode,
      this.currencySymbol,
      this.transactionCreationDateTime,
      this.transactionAmount,
      this.transactionAmountAvailable,
      this.transactionAvailableDateTime,
      this.transactionDeadlineToUse,
      this.transactionIsVoucher});

  Row.fromJson(Map<String, dynamic> json) {
    partnerId = parseCDATA(json['Partner_Id']);
    partnerCompanyName = parseCDATA(json['Partner_CompanyName']);
    partnerVouchersDeniedDays = parseCDATA(json['Partner_VouchersDeniedDays']);
    currencyCode = parseCDATA(json['Currency_Code']);
    currencySymbol = parseCDATA(json['Currency_Symbol']);
    transactionCreationDateTime = parseCDATA(json['Transaction_CreationDateTime']);
    transactionAmount = parseCDATA(json['Transaction_Amount']);
    transactionAmountAvailable = parseCDATA(json['Transaction_AmountAvailable']);
    transactionAvailableDateTime = parseCDATA(json['Transaction_AvailableDateTime']);
    transactionDeadlineToUse = parseCDATA(json['Transaction_DeadlineToUse']);
    transactionIsVoucher = parseCDATA(json['Transaction_IsVoucher']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Partner_Id'] = this.partnerId;
    data['Partner_CompanyName'] = this.partnerCompanyName;
    data['Partner_VouchersDeniedDays'] = this.partnerVouchersDeniedDays;
    data['Currency_Code'] = this.currencyCode;
    data['Currency_Symbol'] = this.currencySymbol;
    data['Transaction_CreationDateTime'] = this.transactionCreationDateTime;
    data['Transaction_Amount'] = this.transactionAmount;
    data['Transaction_AmountAvailable'] = this.transactionAmountAvailable;
    data['Transaction_AvailableDateTime'] = this.transactionAvailableDateTime;
    data['Transaction_DeadlineToUse'] = this.transactionDeadlineToUse;
    data['Transaction_IsVoucher'] = this.transactionIsVoucher;
    return data;
  }
}
