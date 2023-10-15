class BaseBankResponse {
  String token;
  String type;
  String creationDate;
  String cancelUrl;
  String pointOfSale;
  String language;
  String returnUrl;
  bool automaticRedirectAtSessionsEnd;
  Info info;
  PointOfSaleAddress pointOfSaleAddress;
  bool isSandbox;
  List<dynamic> scripts;
  ManageWallet manageWallet;

  BaseBankResponse(
      {this.token,
      this.type,
      this.creationDate,
      this.cancelUrl,
      this.pointOfSale,
      this.language,
      this.returnUrl,
      this.automaticRedirectAtSessionsEnd,
      this.info,
      this.pointOfSaleAddress,
      this.isSandbox,
      this.scripts,
      this.manageWallet});

  String error;

  BaseBankResponse.withError(String errorValue) : error = errorValue;

  BaseBankResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    type = json['type'];
    creationDate = json['creationDate'];
    cancelUrl = json['cancelUrl'];
    pointOfSale = json['pointOfSale'];
    language = json['language'];
    returnUrl = json['returnUrl'];
    automaticRedirectAtSessionsEnd = json['automaticRedirectAtSessionsEnd'];
    info = json['info'] != dynamic ? new Info.fromJson(json['info']) : dynamic;
    pointOfSaleAddress =
        json['pointOfSaleAddress'] != dynamic ? new PointOfSaleAddress.fromJson(json['pointOfSaleAddress']) : dynamic;
    isSandbox = json['isSandbox'];
    if (json['scripts'] != dynamic) {
      scripts = new List<dynamic>();
      json['scripts'].forEach((v) {
        scripts.add(v);
      });
    }
    manageWallet = json['manageWallet'] != dynamic ? new ManageWallet.fromJson(json['manageWallet']) : dynamic;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['type'] = this.type;
    data['creationDate'] = this.creationDate;
    data['cancelUrl'] = this.cancelUrl;
    data['pointOfSale'] = this.pointOfSale;
    data['language'] = this.language;
    data['returnUrl'] = this.returnUrl;
    data['automaticRedirectAtSessionsEnd'] = this.automaticRedirectAtSessionsEnd;
    if (this.info != dynamic) {
      data['info'] = this.info.toJson();
    }
    if (this.pointOfSaleAddress != dynamic) {
      data['pointOfSaleAddress'] = this.pointOfSaleAddress.toJson();
    }
    data['isSandbox'] = this.isSandbox;
    if (this.scripts != dynamic) {
      data['scripts'] = this.scripts.map((v) => v.toJson()).toList();
    }
    if (this.manageWallet != dynamic) {
      data['manageWallet'] = this.manageWallet.toJson();
    }
    return data;
  }
}

class Info {
  String paylineBuyerTitle;
  String paylineBuyerIp;
  String paylineBuyerLastName;
  String paylineBuyerEmail;
  String paylineBuyerFirstName;

  Info(
      {this.paylineBuyerTitle,
      this.paylineBuyerIp,
      this.paylineBuyerLastName,
      this.paylineBuyerEmail,
      this.paylineBuyerFirstName});

  Info.fromJson(Map<String, dynamic> json) {
    paylineBuyerTitle = json['PaylineBuyerTitle'];
    paylineBuyerIp = json['PaylineBuyerIp'];
    paylineBuyerLastName = json['PaylineBuyerLastName'];
    paylineBuyerEmail = json['PaylineBuyerEmail'];
    paylineBuyerFirstName = json['PaylineBuyerFirstName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PaylineBuyerTitle'] = this.paylineBuyerTitle;
    data['PaylineBuyerIp'] = this.paylineBuyerIp;
    data['PaylineBuyerLastName'] = this.paylineBuyerLastName;
    data['PaylineBuyerEmail'] = this.paylineBuyerEmail;
    data['PaylineBuyerFirstName'] = this.paylineBuyerFirstName;
    return data;
  }
}

class PointOfSaleAddress {
  String address1;
  String address2;
  String zipCode;
  String city;

  PointOfSaleAddress({this.address1, this.address2, this.zipCode, this.city});

  PointOfSaleAddress.fromJson(Map<String, dynamic> json) {
    address1 = json['address1'];
    address2 = json['address2'];
    zipCode = json['zipCode'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['zipCode'] = this.zipCode;
    data['city'] = this.city;
    return data;
  }
}

class ManageWallet {
  int previousAction;
  int actionStatus;
  List<PaymentMethods> paymentMethods;
  bool updatePersonalDetails;
  List<Wallets> wallets;
  bool needsDeviceFingerprint;
  bool sensitiveInputContentMasked;
  int wRqtTypeDetail;

  ManageWallet(
      {this.previousAction,
      this.actionStatus,
      this.paymentMethods,
      this.updatePersonalDetails,
      this.wallets,
      this.needsDeviceFingerprint,
      this.sensitiveInputContentMasked,
      this.wRqtTypeDetail});

  ManageWallet.fromJson(Map<String, dynamic> json) {
    previousAction = json['previousAction'];
    actionStatus = json['actionStatus'];
    if (json['paymentMethods'] != dynamic) {
      paymentMethods = new List<PaymentMethods>();
      json['paymentMethods'].forEach((v) {
        paymentMethods.add(new PaymentMethods.fromJson(v));
      });
    }
    updatePersonalDetails = json['updatePersonalDetails'];
    if (json['wallets'] != dynamic) {
      wallets = new List<Wallets>();
      json['wallets'].forEach((v) {
        wallets.add(new Wallets.fromJson(v));
      });
    }
    needsDeviceFingerprint = json['needsDeviceFingerprint'];
    sensitiveInputContentMasked = json['sensitiveInputContentMasked'];
    wRqtTypeDetail = json['wRqtTypeDetail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['previousAction'] = this.previousAction;
    data['actionStatus'] = this.actionStatus;
    if (this.paymentMethods != dynamic) {
      data['paymentMethods'] = this.paymentMethods.map((v) => v.toJson()).toList();
    }
    data['updatePersonalDetails'] = this.updatePersonalDetails;
    if (this.wallets != dynamic) {
      data['wallets'] = this.wallets.map((v) => v.toJson()).toList();
    }
    data['needsDeviceFingerprint'] = this.needsDeviceFingerprint;
    data['sensitiveInputContentMasked'] = this.sensitiveInputContentMasked;
    data['wRqtTypeDetail'] = this.wRqtTypeDetail;
    return data;
  }
}

class PaymentMethods {
  String cardCode;
  String contractNumber;
  int paymentMethodAction;
  List<dynamic> paymentParamsToBeControlled;
  String state;
  bool hasLogo;
  bool hasForm;
  bool isIsolated;
  bool disabled;
  List<String> options;
  PaymentAdditionalData additionalData;
  List<dynamic> confirm;

  PaymentMethods(
      {this.cardCode,
      this.contractNumber,
      this.paymentMethodAction,
      this.paymentParamsToBeControlled,
      this.state,
      this.hasLogo,
      this.hasForm,
      this.isIsolated,
      this.disabled,
      this.options,
      this.additionalData,
      this.confirm});

  PaymentMethods.fromJson(Map<String, dynamic> json) {
    cardCode = json['cardCode'];
    contractNumber = json['contractNumber'];
    paymentMethodAction = json['paymentMethodAction'];
    if (json['paymentParamsToBeControlled'] != dynamic) {
      paymentParamsToBeControlled = new List<dynamic>();
      json['paymentParamsToBeControlled'].forEach((v) {
        paymentParamsToBeControlled.add(v);
      });
    }
    state = json['state'];
    hasLogo = json['hasLogo'];
    hasForm = json['hasForm'];
    isIsolated = json['isIsolated'];
    disabled = json['disabled'];
    options = json['options'].cast<String>();
    additionalData =
        json['additionalData'] != dynamic ? new PaymentAdditionalData.fromJson(json['additionalData']) : dynamic;
    if (json['confirm'] != dynamic) {
      confirm = new List<dynamic>();
      json['confirm'].forEach((v) {
        confirm.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardCode'] = this.cardCode;
    data['contractNumber'] = this.contractNumber;
    data['paymentMethodAction'] = this.paymentMethodAction;
    if (this.paymentParamsToBeControlled != dynamic) {
      data['paymentParamsToBeControlled'] = this.paymentParamsToBeControlled.map((v) => v.toJson()).toList();
    }
    data['state'] = this.state;
    data['hasLogo'] = this.hasLogo;
    data['hasForm'] = this.hasForm;
    data['isIsolated'] = this.isIsolated;
    data['disabled'] = this.disabled;
    data['options'] = this.options;
    if (this.additionalData != dynamic) {
      data['additionalData'] = this.additionalData.toJson();
    }
    if (this.confirm != dynamic) {
      data['confirm'] = this.confirm.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentAdditionalData {
  String hOLDERNAME;
  bool sAVEPAYMENTDATACHECKED;

  PaymentAdditionalData({this.hOLDERNAME, this.sAVEPAYMENTDATACHECKED});

  PaymentAdditionalData.fromJson(Map<String, dynamic> json) {
    hOLDERNAME = json['HOLDER_NAME'];
    sAVEPAYMENTDATACHECKED = json['SAVE_PAYMENT_DATA_CHECKED'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HOLDER_NAME'] = this.hOLDERNAME;
    data['SAVE_PAYMENT_DATA_CHECKED'] = this.sAVEPAYMENTDATACHECKED;
    return data;
  }
}

class Wallets {
  String cardCode;
  int index;
  bool isDefault;
  String cardType;
  bool isExpired;
  bool expiredMore6Months;
  bool hasCustomLogo;
  int customLogoRatio;
  bool hasCustomLogoUrl;
  bool hasCustomLogoBase64;
  bool isPmAPI;
  bool hasSpecificDisplay;
  List<dynamic> options;
  AdditionalData additionalData;
  List<dynamic> confirm;

  Wallets(
      {this.cardCode,
      this.index,
      this.isDefault,
      this.cardType,
      this.isExpired,
      this.expiredMore6Months,
      this.hasCustomLogo,
      this.customLogoRatio,
      this.hasCustomLogoUrl,
      this.hasCustomLogoBase64,
      this.isPmAPI,
      this.hasSpecificDisplay,
      this.options,
      this.additionalData,
      this.confirm});

  Wallets.fromJson(Map<String, dynamic> json) {
    cardCode = json['cardCode'];
    index = json['index'];
    isDefault = json['isDefault'];
    cardType = json['cardType'];
    isExpired = json['isExpired'];
    expiredMore6Months = json['expiredMore6Months'];
    hasCustomLogo = json['hasCustomLogo'];
    customLogoRatio = json['customLogoRatio'];
    hasCustomLogoUrl = json['hasCustomLogoUrl'];
    hasCustomLogoBase64 = json['hasCustomLogoBase64'];
    isPmAPI = json['isPmAPI'];
    hasSpecificDisplay = json['hasSpecificDisplay'];
    if (json['options'] != dynamic) {
      options = new List<dynamic>();
      json['options'].forEach((v) {
        options.add(v);
      });
    }
    additionalData = json['additionalData'] != dynamic ? new AdditionalData.fromJson(json['additionalData']) : dynamic;
    if (json['confirm'] != dynamic) {
      confirm = new List<dynamic>();
      json['confirm'].forEach((v) {
        confirm.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardCode'] = this.cardCode;
    data['index'] = this.index;
    data['isDefault'] = this.isDefault;
    data['cardType'] = this.cardType;
    data['isExpired'] = this.isExpired;
    data['expiredMore6Months'] = this.expiredMore6Months;
    data['hasCustomLogo'] = this.hasCustomLogo;
    data['customLogoRatio'] = this.customLogoRatio;
    data['hasCustomLogoUrl'] = this.hasCustomLogoUrl;
    data['hasCustomLogoBase64'] = this.hasCustomLogoBase64;
    data['isPmAPI'] = this.isPmAPI;
    data['hasSpecificDisplay'] = this.hasSpecificDisplay;
    if (this.options != dynamic) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    if (this.additionalData != dynamic) {
      data['additionalData'] = this.additionalData.toJson();
    }
    if (this.confirm != dynamic) {
      data['confirm'] = this.confirm.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdditionalData {
  String dATE;
  String hOLDER;
  String pAN;

  AdditionalData({this.dATE, this.hOLDER, this.pAN});

  AdditionalData.fromJson(Map<String, dynamic> json) {
    dATE = json['DATE'];
    hOLDER = json['HOLDER'];
    pAN = json['PAN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DATE'] = this.dATE;
    data['HOLDER'] = this.hOLDER;
    data['PAN'] = this.pAN;
    return data;
  }
}
