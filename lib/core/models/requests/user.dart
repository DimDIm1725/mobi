class User {
  Data data;

  User({this.data});

  User.fromJson(Map<String, dynamic> json) {
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
  String userPhoneNumber;
  String userUniversalKey;
  String userPhoneCountry;
  String userLanguage;
  String userGender;
  String userFirstName;
  String userLastName;
  String userAddress;
  bool userSignature;
  bool messageBySMS;
  String userCountry;
  String userZipCode;
  String userCity;
  String userEmail;
  String userBirthDay;
  String applicationVersion;
  String applicationToken;
  String commonApiLanguage;
  String commonApiVersion;
  String commonProcessToken;
  String commonTimeStamp;

  Data({
    this.api,
    this.userPhoneNumber,
    this.userUniversalKey,
    this.userPhoneCountry,
    this.userLanguage,
    this.userGender,
    this.userFirstName,
    this.userLastName,
    this.userAddress,
    this.userCountry,
    this.userZipCode,
    this.userCity,
    this.userEmail,
    this.userBirthDay,
    this.applicationVersion,
    this.userSignature,
    this.messageBySMS,
    this.applicationToken,
    this.commonApiLanguage,
    this.commonApiVersion,
    this.commonProcessToken,
    this.commonTimeStamp,
  });

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    userPhoneNumber = json['User_PhoneNumber'];
    userUniversalKey = json['User_UniversalKey'];
    userPhoneCountry = json['User_PhoneCountry'];
    userLanguage = json['User_Language'];
    userGender = json['User_Gender'];
    userFirstName = json['User_FirstName'];
    userLastName = json['User_LastName'];
    userAddress = json['User_Address'];
    userCountry = json['User_Country'];
    userZipCode = json['User_ZipCode'];
    userCity = json['User_City'];
    userEmail = json['User_Email'];
    userBirthDay = json['User_BirthDay'];
    applicationVersion = json['Common_ApplicationVersion'];
    userSignature = json['User_Signature'];
    messageBySMS = json['MessageBySms'];
    applicationToken = json['Common_ApplicationToken'];
    commonApiLanguage = json['Common_ApiLanguage'];
    commonApiVersion = json['Common_ApiVersion'];
    commonProcessToken = json['Common_ProcessToken'];
    commonTimeStamp = json['Common_TimeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Api'] = this.api;
    data['User_PhoneNumber'] = this.userPhoneNumber;
    data['User_UniversalKey'] = this.userUniversalKey;
    data['User_PhoneCountry'] = this.userPhoneCountry;
    data['User_Language'] = this.userLanguage;
    data['User_Gender'] = this.userGender;
    data['User_FirstName'] = this.userFirstName;
    data['User_LastName'] = this.userLastName;
    data['User_Address'] = this.userAddress;
    data['User_Country'] = this.userCountry;
    data['User_ZipCode'] = this.userZipCode;
    data['User_City'] = this.userCity;
    data['User_Email'] = this.userEmail;
    data['User_BirthDay'] = this.userBirthDay;
    data['Common_ApplicationVersion'] = this.applicationVersion;
    data['Common_ApplicationToken'] = this.applicationToken;
    data['MessageBySms'] = this.messageBySMS;
    data['User_Signature'] = this.userSignature;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    return data;
  }
}
