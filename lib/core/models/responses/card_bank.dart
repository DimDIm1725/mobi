import 'dart:collection';

class CardBankResponse {
  GetCardsResponse getCardsResponse;

  CardBankResponse({this.getCardsResponse});

  CardBankResponse.fromJson(Map<String, dynamic> json) {
    getCardsResponse =
        json['getCardsResponse'] != null ? new GetCardsResponse.fromJson(json['getCardsResponse']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getCardsResponse != null) {
      data['getCardsResponse'] = this.getCardsResponse.toJson();
    }
    return data;
  }
}

class GetCardsResponse {
  Result result;
  CardsList cardsList;

  GetCardsResponse({this.result, this.cardsList});

  GetCardsResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? new Result.fromJson(json['result']) : null;
    cardsList = json['cardsList'] != null ? new CardsList.fromJson(json['cardsList']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    if (this.cardsList != null) {
      data['cardsList'] = this.cardsList.toJson();
    }
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

class CardsList {
  List<Cards> cards;

  CardsList({this.cards});

  CardsList.fromJson(Map<String, dynamic> json) {
    if (json['cards'] != null) {
      cards = new List<Cards>();
      print("RuntimeValue");
      print(json['cards']);
      if (json['cards'] is List<dynamic>) {
        json['cards'].forEach((v) {
          cards.add(new Cards.fromJson(v));
        });
      } else {
        cards.add(new Cards.fromJson(json['cards']));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cards != null) {
      data['cards'] = this.cards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cards {
  String walletId;
  String lastName;
  String firstName;
  String email;
  ShippingAddress shippingAddress;
  Card card;
  String cardInd;
  String comment;
  String isDisabled;
  ExtendedCard extendedCard;
  String isDefault;

  Cards(
      {this.walletId,
      this.lastName,
      this.firstName,
      this.email,
      this.shippingAddress,
      this.card,
      this.cardInd,
      this.comment,
      this.isDisabled,
      this.extendedCard,
      this.isDefault});

  Cards.fromJson(Map<String, dynamic> json) {
    walletId = json['walletId'];
    lastName = json['lastName'];
    firstName = json['firstName'];
    email = json['email'];
    shippingAddress = json['shippingAddress'] != null ? new ShippingAddress.fromJson(json['shippingAddress']) : null;
    card = json['card'] != null ? new Card.fromJson(json['card']) : null;
    cardInd = json['cardInd'];
    comment = json['comment'];
    isDisabled = json['isDisabled'];
    extendedCard = json['extendedCard'] != null ? new ExtendedCard.fromJson(json['extendedCard']) : null;
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['walletId'] = this.walletId;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['email'] = this.email;
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress.toJson();
    }
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    data['cardInd'] = this.cardInd;
    data['comment'] = this.comment;
    data['isDisabled'] = this.isDisabled;
    if (this.extendedCard != null) {
      data['extendedCard'] = this.extendedCard.toJson();
    }
    data['isDefault'] = this.isDefault;
    return data;
  }
}

class ShippingAddress {
  String name;
  String street1;
  String street2;
  String cityName;
  String zipCode;
  String country;
  String phone;

  ShippingAddress({this.name, this.street1, this.street2, this.cityName, this.zipCode, this.country, this.phone});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    street1 = json['street1'];
    street2 = json['street2'];
    cityName = json['cityName'];
    zipCode = json['zipCode'];
    country = json['country'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['street1'] = this.street1;
    data['street2'] = this.street2;
    data['cityName'] = this.cityName;
    data['zipCode'] = this.zipCode;
    data['country'] = this.country;
    data['phone'] = this.phone;
    return data;
  }
}

class Card {
  String number;
  String type;
  String expirationDate;
  String cvx;
  String ownerBirthdayDate;
  String password;
  String cardholder;

  Card({this.number, this.type, this.expirationDate, this.cvx, this.ownerBirthdayDate, this.password, this.cardholder});

  Card.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    type = json['type'];
    expirationDate = json['expirationDate'];
    cvx = json['cvx'];
    ownerBirthdayDate = json['ownerBirthdayDate'];
    password = json['password'];
    cardholder = json['cardholder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['type'] = this.type;
    data['expirationDate'] = this.expirationDate;
    data['cvx'] = this.cvx;
    data['ownerBirthdayDate'] = this.ownerBirthdayDate;
    data['password'] = this.password;
    data['cardholder'] = this.cardholder;
    return data;
  }
}

class ExtendedCard {
  String type;
  String network;
  String product;

  ExtendedCard({this.type, this.network, this.product});

  ExtendedCard.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    network = json['network'];
    product = json['product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['network'] = this.network;
    data['product'] = this.product;
    return data;
  }
}
