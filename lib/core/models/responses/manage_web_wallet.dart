class ManageWebWalletResponse {
  DoWebPaymentResponse manageWebWalletResponse;

  ManageWebWalletResponse({this.manageWebWalletResponse});

  ManageWebWalletResponse.fromJson(Map<String, dynamic> json) {
    manageWebWalletResponse = json['manageWebWalletResponse'] != null
        ? new DoWebPaymentResponse.fromJson(json['manageWebWalletResponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.manageWebWalletResponse != null) {
      data['manageWebWalletResponse'] = this.manageWebWalletResponse.toJson();
    }
    return data;
  }
}

class DoWebPaymentResponse {
  Result result;
  String token;
  String redirectURL;

  DoWebPaymentResponse({this.result, this.token, this.redirectURL});

  DoWebPaymentResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
    token = json['token'];
    redirectURL = json['redirectURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['token'] = this.token;
    data['redirectURL'] = this.redirectURL;
    return data;
  }
}

class Result {
  String code;
  String shortMessage;
  String longMessage;

  Result({this.code, this.shortMessage, this.longMessage});

  Result.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    shortMessage = json['shortMessage'];
    longMessage = json['longMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['shortMessage'] = this.shortMessage;
    data['longMessage'] = this.longMessage;
    return data;
  }
}
