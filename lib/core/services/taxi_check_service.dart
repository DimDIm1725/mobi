import 'package:mobiwoom/core/models/requests/card.dart';
import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/taxi_check.dart';
import 'package:mobiwoom/core/models/requests/user.dart';
import 'package:mobiwoom/core/models/responses/card.dart';
import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/locator.dart';

class TaxiCheckService {
  Api _api = locator<Api>();

  Future<Card> getAllSavedCards(LoginRequest loginRequest) async {
    return await _api.getAllSavedCards(loginRequest);
  }

  Future<Card> setAsMainCard(LoginRequest loginRequest) async {
    return await _api.setAsMainCard(loginRequest);
  }

  Future<Card> deleteCard(LoginRequest loginRequest) async {
    return await _api.deleteCard(loginRequest);
  }

  Future<Card> addCard(CardRequest cardRequest) async {
    return await _api.addCard(cardRequest);
  }

  getCustomerFromCard(LoginRequest request) async {
    return await _api.getCustomerFromCard(request);
  }

  sendTaxiCheck(TaxiCheckRequest request) async {
    return await _api.sendTaxiCheck(request);
  }

  addRecipient(User request) async {
    return await _api.addRecipient(request);
  }
}
