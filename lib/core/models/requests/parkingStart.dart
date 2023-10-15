class ParkingStartRequest {
  Data data;

  ParkingStartRequest({this.data});

  ParkingStartRequest.fromJson(Map<String, dynamic> json) {
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
  String commonProcessToken;
  String commonTimeStamp;
  String userCarPlate;
  String ticketMachineId;
  double duration;
  String creditCardToken;
  String userPhoneCountry;
  String userPinCode;
  String commonApiVersion;
  String userUniversalKey;
  String commonApiLanguage;
  String applicationVersion;

  Data(
      {this.api,
      this.commonApplicationToken,
      this.commonProcessToken,
      this.userUniversalKey,
      this.commonTimeStamp,
      this.userCarPlate,
      this.ticketMachineId,
      this.duration,
      this.commonApiVersion,
      this.creditCardToken,
      this.userPhoneCountry,
      this.userPinCode,
      this.commonApiLanguage,
      this.applicationVersion});

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    commonApplicationToken = json['Common_ApplicationToken'];
    userUniversalKey = json['User_UniversalKey'];
    commonProcessToken = json['Common_ProcessToken'];
    commonTimeStamp = json['Common_TimeStamp'];
    userCarPlate = json['User_CarPlate'];
    ticketMachineId = json['TicketMachine_Id'];
    duration = json['Duration'];
    creditCardToken = json['CreditCard_Token'];
    userPhoneCountry = json['User_PhoneCountry'];
    userPinCode = json['User_PinCode'];
    commonApiVersion = json['Common_ApiVersion'];
    commonApiLanguage = json['Common_ApiLanguage'];
    applicationVersion = json['Common_ApplicationVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Api'] = this.api;
    data['Common_ApplicationToken'] = this.commonApplicationToken;
    data['User_UniversalKey'] = this.userUniversalKey;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    data['User_CarPlate'] = this.userCarPlate;
    data['TicketMachine_Id'] = this.ticketMachineId;
    data['Duration'] = this.duration;
    data['CreditCard_Token'] = this.creditCardToken;
    data['User_PhoneCountry'] = this.userPhoneCountry;
    data['User_PinCode'] = this.userPinCode;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApplicationVersion'] = this.applicationVersion;
    return data;
  }
}
