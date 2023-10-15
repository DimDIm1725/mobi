import 'package:mobiwoom/core/models/requests/contact_less_card.dart';
import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/responses/contact_less_card.dart';
import 'package:mobiwoom/locator.dart';

import 'api.dart';

class ContactLessCardService {
  Api _api = locator<Api>();

  Future<ContactLessCard> getAllContactLessCards(LoginRequest request) async {
    return await _api.getAllContactLessCards(request);
  }

  Future<ContactLessCard> addContactLessCard(
      ContactLessCardRequest request) async {
    return await _api.addContactLessCard(request);
  }

  Future<ContactLessCard> deleteContactLessCard(
      ContactLessCardRequest request) async {
    return await _api.deleteContactLessCard(request);
  }
}
