class TokenResponse {
  Response response;

  TokenResponse({this.response});

  TokenResponse.fromJson(Map<String, dynamic> json) {
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

  TokenResponse.withError(String errorValue)
      : response = Response(),
        error = errorValue;
}

class Response {
  String errorNumber;
  String processToken;
  dynamic message;

  Response(
      {this.errorNumber,
      this.processToken,
      this.message});

  Response.fromJson(Map<String, dynamic> json) {
    errorNumber = json['ErrorNumber'];
    processToken = json['ProcessToken'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorNumber'] = this.errorNumber;
    data['ProcessToken'] = this.processToken;
    data['Message'] = this.message;
    return data;
  }
}