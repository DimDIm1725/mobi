import 'package:mobiwoom/core/models/requests/card.dart';
import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/sendToken.dart';
import 'package:mobiwoom/core/models/responses/base_bank_response.dart';
import 'package:mobiwoom/core/models/responses/card.dart';
import 'package:mobiwoom/core/models/responses/new_credit_card.dart';
import 'package:mobiwoom/core/models/responses/sendToken.dart';
import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/core/services/api_xml.dart';
import 'package:mobiwoom/locator.dart';
import 'package:xml_parser/xml_parser.dart';

class CardService {
  Api _api = locator<Api>();
 // ApiXml _apiXml = locator<ApiXml>();

  Future<Card> getAllSavedCards(LoginRequest loginRequest) async {
    return await _api.getAllSavedCards(loginRequest);
  }

  Future<Card> setAsMainCard(LoginRequest loginRequest) async {
    return await _api.setAsMainCard(loginRequest);
  }

  Future<Card> deleteCard(LoginRequest loginRequest) async {
    return await _api.deleteCard(loginRequest);
  }

/*  Future<BaseBankResponse> deleteCardFromBank(String token, String cardId) async {
    return await _apiXml.deleteCardFromBank(token, cardId);
  }*/

 /* Future<BaseBankResponse> setMainCardFromBank(String token, String cardId) async {
    return await _apiXml.setMainCardFromBank(token, cardId);
  }*/

 /* Future<dynamic> activateToken(String url) async {
    return await _apiXml.activateToken(url);
  }*/

  Future<NewCreditCardResponse> addCard(CardRequest cardRequest) async {
    return await _api.addCard(cardRequest);
  }

  Future<TokenResponse> sendToken(TokenRequest tokenRequest) async {
    return await _api.sendToken(tokenRequest);
  }

 /* Future<XmlDocument> getAllSavedCardsFromBank(dynamic data) async {
    return await _apiXml.getCardList(data);
  }*/

 /* Future<XmlDocument> getTokenFromBank(dynamic data) async {
    return await _apiXml.getTokenFromBank(data);
  }*/

/*  Future<XmlDocument> addBankCard(dynamic data) async {
    return await _apiXml.addBankCard(data);
  }*/
}
