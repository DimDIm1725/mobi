class TicketMachineRequest {
  Data data;

  TicketMachineRequest({this.data});

  TicketMachineRequest.fromJson(Map<String, dynamic> json) {
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
  String userLatitude;
  String userLongitude;
  String userCarPlate;
  String commonApiLanguage;
  String commonApiVersion;
  String applicationVersion;

  Data({
    this.api,
    this.commonApplicationToken,
    this.commonProcessToken,
    this.commonTimeStamp,
    this.userLatitude,
    this.userLongitude,
    this.userCarPlate,
    this.commonApiLanguage,
    this.commonApiVersion,
    this.applicationVersion
  });

  Data.fromJson(Map<String, dynamic> json) {
    api = json['Api'];
    commonApplicationToken = json['Common_ApplicationToken'];
    commonProcessToken = json['Common_ProcessToken'];
    commonTimeStamp = json['Common_TimeStamp'];
    userLatitude = json['User_Latitude'];
    userLongitude = json['User_Longitude'];
    userCarPlate = json['User_CarPlate'];
    commonApiLanguage = json['Common_ApiLanguage'];
    commonApiVersion = json['Common_ApiVersion'];
    applicationVersion = json['Common_ApplicationVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Api'] = this.api;
    data['Common_ApplicationToken'] = this.commonApplicationToken;
    data['Common_ProcessToken'] = this.commonProcessToken;
    data['Common_TimeStamp'] = this.commonTimeStamp;
    data['User_Latitude'] = this.userLatitude;
    data['User_Longitude'] = this.userLongitude;
    data['User_CarPlate'] = this.userCarPlate;
    data['Common_ApiLanguage'] = this.commonApiLanguage;
    data['Common_ApiVersion'] = this.commonApiVersion;
    data['Common_ApplicationVersion'] = this.applicationVersion;
    return data;
  }
}
