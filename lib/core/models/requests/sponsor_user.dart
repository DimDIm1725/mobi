class SponsorUser {
  Data data;

  SponsorUser({this.data});

  SponsorUser.fromJson(Map<String, dynamic> json) {
    data = json['Data'] != null && json['Data'] != "" ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String api;
  String commonApplicationToken;
  String commonApplicationVersion;
  String commonApiLanguage;
  String commonApiVersion;
  String commonProcessToken;
  String commonTimeStamp;
  String userPhoneNumber;
  String userPhoneCountry;
  String userCountry;
  String userFirstName;
  String userLastName;
  String userEMail;
  String userLanguage;
  String sponsorPhoneNumber;
  String sponsorPhoneCountry;

  Data({
    this.api,
    this.commonApplicationToken,
    this.commonApplicationVersion,
    this.commonApiLanguage,
    this.commonApiVersion,
    this.commonProcessToken,
    this.commonTimeStamp,
    this.userPhoneNumber,
    this.userPhoneCountry,
    this.userCountry,
    this.userFirstName,
    this.userLastName,
    this.userEMail,
    this.userLanguage,
    this.sponsorPhoneNumber,
    this.sponsorPhoneCountry,
  });

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    commonApplicationToken = json['Common_ApplicationToken'];
    commonApplicationVersion = json['Common_ApplicationVersion'];
    commonApiLanguage = json['Common_ApiLanguage'];
    commonApiVersion = json['Common_ApiVersion'];
    commonProcessToken = json['Common_ProcessToken'];
    commonTimeStamp = json['Common_TimeStamp'];
    userPhoneNumber = json['User_PhoneNumber'];
    userPhoneCountry = json['User_PhoneCountry'];
    userCountry = json['User_Country'];
    userFirstName = json['User_FirstName'];
    userLastName = json['User_LastName'];
    userEMail = json['User_EMail'];
    userLanguage = json['User_Language'];
    sponsorPhoneNumber = json['Sponsor_PhoneNumber'];
    sponsorPhoneCountry = json['Sponsor_PhoneCountry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Api'] = this.api;
    data['Common_ApplicationToken'] = this.commonApplicationToken;
    data['Common_ApplicationVersion'] = this.commonApplicationVersion;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    data['User_PhoneNumber'] = this.userPhoneNumber;
    data['User_PhoneCountry'] = this.userPhoneCountry;
    data['User_Country'] = this.userCountry;
    data['User_FirstName'] = this.userFirstName;
    data['User_LastName'] = this.userLastName;
    data['User_EMail'] = this.userEMail;
    data['User_Language'] = this.userLanguage;
    data['Sponsor_PhoneNumber'] = this.sponsorPhoneNumber;
    data['Sponsor_PhoneCountry'] = this.sponsorPhoneCountry;
    return data;
  }
}
