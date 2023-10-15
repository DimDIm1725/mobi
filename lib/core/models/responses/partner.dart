import 'package:mobiwoom/core/utils/cdata_parser.dart';

class PartnerResponse {
  Response response;

  PartnerResponse.withError(String errorValue)
      : response = Response(),
        _error = errorValue;
  String _error;

  PartnerResponse({this.response});

  PartnerResponse.fromJson(Map<String, dynamic> json) {
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
  String systemId;
  String systemCountry;
  String systemName;
  String clusterId;
  String clusterType;
  String clusterName;
  String partnerId;
  String partnerPhoneNumber;
  String partnerCompanyName;
  String partnerAddress;
  String partnerCountry;
  String partnerZipCode;
  String partnerCity;
  String partnerAdditionalInformation;
  String partnerLatitude;
  String partnerLongitude;
  String partnerDistance;
  String currencyCode;
  String currencySymbol;
  String activityId;
  String activityName;
  String transactionPercentage;
  String transactionAdditionalCashBack;
  String transactionAvailableAmount;
  String transactionAvailableAmountVouchers;
  String transactionSubsidyAmount1;
  String transactionSubsidyAmount2;
  String userType;
  String userPercentage;
  String partnerVoucherValueSponsor;
  String partnerVoucherValueSponsored;
  String partnerValidityVoucher;

  Row(
      {this.systemId,
      this.systemCountry,
      this.systemName,
      this.clusterId,
      this.clusterType,
      this.clusterName,
      this.partnerId,
      this.partnerPhoneNumber,
      this.partnerCompanyName,
      this.partnerAddress,
      this.partnerCountry,
      this.partnerZipCode,
      this.partnerCity,
      this.partnerAdditionalInformation,
      this.partnerLatitude,
      this.partnerLongitude,
      this.partnerDistance,
      this.currencyCode,
      this.currencySymbol,
      this.activityId,
      this.activityName,
      this.transactionPercentage,
      this.transactionAdditionalCashBack,
      this.transactionAvailableAmount,
      this.transactionAvailableAmountVouchers,
      this.transactionSubsidyAmount1,
      this.transactionSubsidyAmount2,
      this.userType,
      this.userPercentage,
      this.partnerVoucherValueSponsor,
      this.partnerVoucherValueSponsored,
      this.partnerValidityVoucher});

  Row.fromJson(Map<String, dynamic> json) {
    systemId = parseCDATA(json['System_Id']);
    systemCountry = parseCDATA(json['System_Country']);
    systemName = parseCDATA(json['System_Name']);
    clusterId = parseCDATA(json['Cluster_Id']);
    clusterType = parseCDATA(json['Cluster_Type']);
    clusterName = parseCDATA(json['Cluster_Name']);
    partnerId = parseCDATA(json['Partner_Id']);
    partnerPhoneNumber = parseCDATA(json['Partner_PhoneNumber']);
    partnerCompanyName = parseCDATA(json['Partner_CompanyName']);
    partnerAddress = parseCDATA(json['Partner_Address']);
    partnerCountry = parseCDATA(json['Partner_Country']);
    partnerZipCode = parseCDATA(json['Partner_ZipCode']);
    partnerCity = parseCDATA(json['Partner_City']);
    partnerAdditionalInformation = parseCDATA(json['Partner_AdditionalInformation']);
    partnerLatitude = parseCDATA(json['Partner_Latitude']);
    partnerLongitude = parseCDATA(json['Partner_Longitude']);
    partnerDistance = parseCDATA(json['Partner_Distance']);
    currencyCode = parseCDATA(json['Currency_Code']);
    currencySymbol = parseCDATA(json['Currency_Symbol']);
    activityId = parseCDATA(json['Activity_Id']);
    activityName = parseCDATA(json['Activity_Name']);
    transactionPercentage = parseCDATA(json['Transaction_Percentage']);
    transactionAdditionalCashBack = parseCDATA(json['Transaction_AdditionalCashBack']);
    transactionAvailableAmount = parseCDATA(json['Transaction_AvailableAmount']);
    transactionAvailableAmountVouchers = parseCDATA(json['Transaction_AvailableAmountVouchers']);
    transactionSubsidyAmount1 = parseCDATA(json['Transaction_SubsidyAmount1']);
    transactionSubsidyAmount2 = parseCDATA(json['Transaction_SubsidyAmount2']);
    userType = parseCDATA(json['User_Type']);
    userPercentage = parseCDATA(json['User_Percentage']);
    partnerVoucherValueSponsor = parseCDATA(json['Partner_VoucherValueSponsor']);
    partnerVoucherValueSponsored = parseCDATA(json['Partner_VoucherValueSponsored']);
    partnerValidityVoucher = parseCDATA(json['Partner_ValidityVoucher']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['System_Id'] = this.systemId;
    data['System_Country'] = this.systemCountry;
    data['System_Name'] = this.systemName;
    data['Cluster_Id'] = this.clusterId;
    data['Cluster_Type'] = this.clusterType;
    data['Cluster_Name'] = this.clusterName;
    data['Partner_Id'] = this.partnerId;
    data['Partner_PhoneNumber'] = this.partnerPhoneNumber;
    data['Partner_CompanyName'] = this.partnerCompanyName;
    data['Partner_Address'] = this.partnerAddress;
    data['Partner_Country'] = this.partnerCountry;
    data['Partner_ZipCode'] = this.partnerZipCode;
    data['Partner_City'] = this.partnerCity;
    data['Partner_AdditionalInformation'] = this.partnerAdditionalInformation;
    data['Partner_Latitude'] = this.partnerLatitude;
    data['Partner_Longitude'] = this.partnerLongitude;
    data['Partner_Distance'] = this.partnerDistance;
    data['Currency_Code'] = this.currencyCode;
    data['Currency_Symbol'] = this.currencySymbol;
    data['Activity_Id'] = this.activityId;
    data['Activity_Name'] = this.activityName;
    data['Transaction_Percentage'] = this.transactionPercentage;
    data['Transaction_AdditionalCashBack'] = this.transactionAdditionalCashBack;
    data['Transaction_AvailableAmount'] = this.transactionAvailableAmount;
    data['Transaction_AvailableAmountVouchers'] = this.transactionAvailableAmountVouchers;
    data['Transaction_SubsidyAmount1'] = this.transactionSubsidyAmount1;
    data['Transaction_SubsidyAmount2'] = this.transactionSubsidyAmount2;
    data['User_Type'] = this.userType;
    data['User_Percentage'] = this.userPercentage;
    data['Partner_VoucherValueSponsor'] = this.partnerVoucherValueSponsor;
    data['Partner_VoucherValueSponsored'] = this.partnerVoucherValueSponsored;
    data['Partner_ValidityVoucher'] = this.partnerValidityVoucher;
    return data;
  }
}
