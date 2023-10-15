import 'package:mobiwoom/core/utils/cdata_parser.dart';

class User {
  Response response;
  String error;

  User({this.response});

  User.fromJson(Map<String, dynamic> json) {
    response = json['Response'] != null ? new Response.fromJson(json['Response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['Response'] = this.response.toJson();
    }
    return data;
  }

  User.withError(String errorValue)
      : response = Response(),
        error = errorValue;
}

class Response {
  String errorNumber;
  String source;
  String message;
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
  String userGender;
  String userGenderText;
  String userFirstName;
  String userLastName;
  String userAddress;
  String userCountry;
  String userZipCode;
  String userCity;
  String userLanguage;
  String userEMail;
  String userSignature;
  String userCreationDateTime;
  String userBirthDay;
  String userMaxSponsoredUsers;
  String userSponsoredUsersCount;
  String userVipStatusCount;

  Data(
      {this.userGender,
      this.userGenderText,
      this.userFirstName,
      this.userLastName,
      this.userAddress,
      this.userCountry,
      this.userZipCode,
      this.userCity,
      this.userLanguage,
      this.userEMail,
      this.userSignature,
      this.userCreationDateTime,
      this.userBirthDay,
      this.userMaxSponsoredUsers});

  Data.fromJson(Map<String, dynamic> json) {
    userGender = parseCDATA(json['User_Gender']);
    userGenderText = parseCDATA(json['User_GenderText']);
    userFirstName = parseCDATA(json['User_FirstName']);
    userLastName = parseCDATA(json['User_LastName']);
    userAddress = parseCDATA(json['User_Address']);
    userCountry = parseCDATA(json['User_Country']);
    userZipCode = parseCDATA(json['User_ZipCode']);
    userCity = parseCDATA(json['User_City']);
    userLanguage = parseCDATA(json['User_Language']);
    userEMail = parseCDATA(json['User_EMail']);
    userSignature = parseCDATA(json['User_Signature']);
    userCreationDateTime = parseCDATA(json['User_CreationDateTime']);
    userBirthDay = parseCDATA(json['User_BirthDay']);
    userMaxSponsoredUsers = parseCDATA(json['User_MaxSponsoredUsers']);
    userSponsoredUsersCount = parseCDATA(json['User_SponsoredUsersCount']);
    userVipStatusCount = parseCDATA(json['User_VipStatusCount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['User_Gender'] = this.userGender;
    data['User_GenderText'] = this.userGenderText;
    data['User_FirstName'] = this.userFirstName;
    data['User_LastName'] = this.userLastName;
    data['User_Address'] = this.userAddress;
    data['User_Country'] = this.userCountry;
    data['User_ZipCode'] = this.userZipCode;
    data['User_City'] = this.userCity;
    data['User_Language'] = this.userLanguage;
    data['User_EMail'] = this.userEMail;
    data['User_Signature'] = this.userSignature;
    data['User_CreationDateTime'] = this.userCreationDateTime;
    data['User_BirthDay'] = this.userBirthDay;
    data['User_MaxSponsoredUsers'] = this.userMaxSponsoredUsers;
    data['User_SponsoredUsersCount'] = this.userSponsoredUsersCount;
    data['User_VipStatusCount'] = this.userVipStatusCount;
    return data;
  }
}
