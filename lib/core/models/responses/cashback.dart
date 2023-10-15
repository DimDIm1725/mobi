import 'package:mobiwoom/core/utils/cdata_parser.dart';

class CashBack {
  Response response;

  CashBack({this.response});

  CashBack.fromJson(Map<String, dynamic> json) {
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

  CashBack.withError(String errorValue)
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
  String id;
  String transactionCreationDateTime;
  String partnerId;
  String partnerCompanyName;
  String userId;
  String userNames;
  String currencyCode;
  String currencySymbol;
  String transactionDeadlineToUse;
  String type;
  String sumDebit;
  String sumCredit;
  String paymentbyCashback;
  String paymentbyCreditcard;
  String reimbursmentCashback;
  String canceledVouchers;
  String usedVouchers;
  String cashbackTransfertDebit;
  String cashbackTransferCredit;
  String cashback;
  String vouchers;

  Row(
      {this.id,
      this.transactionCreationDateTime,
      this.partnerId,
      this.partnerCompanyName,
      this.userId,
      this.userNames,
      this.currencyCode,
      this.currencySymbol,
      this.transactionDeadlineToUse,
      this.type,
      this.sumDebit,
      this.sumCredit,
      this.paymentbyCashback,
      this.paymentbyCreditcard,
      this.reimbursmentCashback,
      this.canceledVouchers,
      this.usedVouchers,
      this.cashbackTransfertDebit,
      this.cashbackTransferCredit,
      this.cashback,
      this.vouchers});

  Row.fromJson(Map<String, dynamic> json) {
    id = parseCDATA(json['Id']);
    partnerId = parseCDATA(json['Partner_Id']);
    partnerCompanyName = parseCDATA(json['Partner_CompanyName']);
    userId = parseCDATA(json['User_Id']);
    userNames = parseCDATA(json['User_Names']);
    currencyCode = parseCDATA(json['Currency_Code']);
    currencySymbol = parseCDATA(json['Currency_Symbol']);
    transactionCreationDateTime = parseCDATA(json['CreationDateTimeLocal']);
    transactionDeadlineToUse = parseCDATA(json['DeadlineToUse']);
    type = parseCDATA(json['Type']);
    sumDebit = parseCDATA(json['SumDebit']);
    sumCredit = parseCDATA(json['SumCredit']);
    paymentbyCashback = parseCDATA(json['PaymentByCashBack']);
    paymentbyCreditcard = parseCDATA(json['PaymentByCreditCard']);
    reimbursmentCashback = parseCDATA(json['ReimbursementCashBack']);
    canceledVouchers = parseCDATA(json['CanceledVouchers']);
    usedVouchers = parseCDATA(json['UsedVouchers']);
    cashbackTransfertDebit = parseCDATA(json['CashBackTransferDebit']);
    cashbackTransferCredit = parseCDATA(json['CashBackTransferCredit']);
    cashback = parseCDATA(json['CashBack']);
    vouchers = parseCDATA(json['Vouchers']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Partner_Id'] = this.partnerId;
    data['Partner_CompanyName'] = this.partnerCompanyName;
    data['User_Id'] = this.userId;
    data['User_Names'] = this.userNames;
    data['Currency_Code'] = this.currencyCode;
    data['Currency_Symbol'] = this.currencySymbol;
    data['CreationDateTimeLocal'] = this.transactionCreationDateTime;
    data['DeadlineToUse'] = this.transactionDeadlineToUse;
    data['Type'] = this.type;
    data['SumDebit'] = this.type;
    data['SumCredit'] = this.type;
    data['PaymentByCashBack'] = this.type;
    data['PaymentByCreditCard'] = this.type;
    data['ReimbursementCashBack'] = this.type;
    data['CanceledVouchers'] = this.type;
    data['UsedVouchers'] = this.type;
    data['CashBackTransferDebit'] = this.type;
    data['CashBackTransferCredit'] = this.type;
    data['CashBack'] = this.type;
    data['Vouchers'] = this.type;
    return data;
  }
}
