import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:mobiwoom/core/models/requests/contact_less_card.dart'
    as cardReq;
import 'package:mobiwoom/core/models/requests/login.dart' as requestLogin;
import 'package:mobiwoom/core/models/responses/contact_less_card.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/services/contactless_card_service.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/constants.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/localization.dart';

class ContactLessCardModel extends BaseModel {
  ContactLessCardService cardService = locator<ContactLessCardService>();
  ContactLessCard card;
  cardReq.ContactLessCardRequest cardRequest;

  ViewState _modalState = ViewState.Idle;
  dynamic errorMessage;
  String successMessage;

  ViewState get modalState => _modalState;

  void setModalState(ViewState viewState) {
    _modalState = viewState;
    notifyListeners();
  }

  getAllContactLessCards() async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();

    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
        api: 'ContactlessCardsList',
        userUniversalKey: loginResponse.response.userPhoneNumber,
        userBrowserType: getAccountBrowserType(),
        language: loginResponse.response.data.userLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        commonApiLanguage: kApiLanguage,
        commonApiVersion: kAppVersion,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    card = await cardService.getAllContactLessCards(loginRequest);
    setState(ViewState.Idle);
  }

  Future<bool> addContactLessCard() async {
    bool status = false;
    setModalState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    if (cardRequest.data.userAccessKey.isEmpty) {
      errorMessage = AppLocalizations.of(
              locator<Application>().navigatorKey.currentContext)
          .translate('card_number_cannot_be_empty');
      return false;
    }

    if (cardRequest.data.userAccessKey.length < 10) {
      errorMessage = AppLocalizations.of(
              locator<Application>().navigatorKey.currentContext)
          .translate('card_number_constraint');
      return false;
    }

    cardRequest.data.api = 'ContactlessCardAssign';
    cardRequest.data.userPhoneNumber = loginResponse.response.userPhoneNumber;
    cardRequest.data.userPhoneCountry = loginResponse.response.data.userCountry;
    cardRequest.data.commonApiVersion = kAppVersion;
    cardRequest.data.commonApiLanguage =
        loginResponse.response.data.userLanguage;
    cardRequest.data.userAccessKeyType = "1";
    cardRequest.data.applicationVersion = kVersion;
    cardRequest.data.commonTimeStamp =
        DateFormat(kRequestDateFormat).format(DateTime.now());
    cardRequest.data.commonApplicationToken = kApplicationToken;
    ContactLessCard cardResponse =
        await cardService.addContactLessCard(cardRequest);
    if (cardResponse.response.errorNumber == '0') {
      successMessage = AppLocalizations.of(
              locator<Application>().navigatorKey.currentContext)
          .translate('contact_less_card_added_successfully');
      status = true;
    } else {
      if (cardResponse.response.message is LinkedHashMap) {
        errorMessage = cardResponse.response.message['#cdata-section'];
      } else {
        errorMessage = cardResponse.response.message;
      }
      status = false;
    }
    setModalState(ViewState.Idle);
    return status;
  }

  Future<bool> deleteContactLessCard(String cardNumber) async {
    bool status = false;
    setModalState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    cardReq.ContactLessCardRequest contactLessCardRequest =
        cardReq.ContactLessCardRequest(
      data: cardReq.Data(
        api: 'ContactlessCardRelease',
        userAccessKey: cardNumber,
        userPhoneNumber: loginResponse.response.userPhoneNumber,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        userAccessKeyType: "1",
        commonTimeStamp: DateFormat(kRequestDateFormat).format(DateTime.now()),
        commonApplicationToken: kApplicationToken,
        applicationVersion: kVersion,
      ),
    );

    ContactLessCard cardResponse =
        await cardService.deleteContactLessCard(contactLessCardRequest);
    if (cardResponse.response.errorNumber == '0') {
      successMessage =
          '${AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('contactLess_card')} $cardNumber ${AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('deleted_successfully')}';
      status = true;
    } else {
      if (cardResponse.response.message is LinkedHashMap) {
        errorMessage = cardResponse.response.message['#cdata-section'];
      } else {
        errorMessage = cardResponse.response.message;
      }
      status = false;
    }
    setModalState(ViewState.Idle);
    return status;
  }
}
