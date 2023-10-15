import 'dart:collection';

import 'package:flutter/material.dart' as material;
import 'package:mobiwoom/core/models/requests/login.dart' as requestLogin;
import 'package:mobiwoom/core/models/requests/taxi_check.dart' as taxiReq;
import 'package:mobiwoom/core/models/requests/user.dart' as userReq;
import 'package:mobiwoom/core/models/responses/card.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/services/card_service.dart';
import 'package:mobiwoom/core/services/taxi_check_service.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/constants.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/localization.dart';

class TaxiCheckModel extends BaseModel {
  bool showErrorMessage = false;
  taxiReq.TaxiCheckRequest taxiCheckRequest = locator<taxiReq.TaxiCheckRequest>();
  CardService cardService = locator<CardService>();
  TaxiCheckService taxiCheckService = locator<TaxiCheckService>();
  userReq.User user = locator<userReq.User>();
  Card card;
  Row mainCard;
  String recipientName;

  String receipientPhone;

  TaxiCheckModel() {
    taxiCheckRequest.data = taxiReq.Data();
    user.data = userReq.Data();
  }

  getAllPriceDropDownValues() {
    List<material.DropdownMenuItem<dynamic>> priceDropDownValues = [];
    for (int i = 5; i <= 30; i += 5) {
      priceDropDownValues.add(material.DropdownMenuItem(
        child: material.Text(
          '$i ${AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('moneySymbol')}',
          overflow: material.TextOverflow.visible,
        ),
        value: i.toString(),
      ));
    }
    return priceDropDownValues;
  }

  Future<Card> getAllSavedCards() async {
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();

    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
        api: 'UserCreditCardsList',
        userUniversalKey: loginResponse.response.userPhoneNumber,
        userBrowserType: getAccountBrowserType(),
        language: loginResponse.response.data.userLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    card = await cardService.getAllSavedCards(loginRequest);
    mainCard = card.response.data?.row?.firstWhere((element) => element.main == 'True', orElse: () => null);
    return card;
  }

  Future<bool> getCustomerFromCard(String number) async {
    bool status = false;
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
        api: 'UserParseLite',
        userUniversalKey: number,
        userBrowserType: getAccountBrowserType(),
        language: loginResponse.response.data.userLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    LoginResponse response = await taxiCheckService.getCustomerFromCard(loginRequest);
    if (response.response.errorNumber == '0') {
      successMessage = "";
      recipientName = '${response.response.data.userFirstName} ${response.response.data.userLastName}';
      status = true;
    } else {
      if (response.response.message is LinkedHashMap) {
        errorMessage = response.response.message["#cdata-section"];
      } else {
        errorMessage = response.response.message;
      }

      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

  Future<bool> sendTaxiCheck() async {
    print('sendTaxiCheck');
    bool status = false;
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    taxiCheckRequest.data.api = 'TransactionAddNewCashBackBought';
    taxiCheckRequest.data.buyerUserPhoneNumber = loginResponse.response.userPhoneNumber;
    taxiCheckRequest.data.buyerUserPhoneCountry = loginResponse.response.userPhoneCountry;
    taxiCheckRequest.data.buyerUserPinCode = userPincode;
    taxiCheckRequest.data.beneficiaryUserPhoneCountry = loginResponse.response.userPhoneCountry;
    taxiCheckRequest.data.partnerPhoneCountry = loginResponse.response.userPhoneCountry;
    taxiCheckRequest.data.partnerPhoneNumber = kPartnerPhoneNumber;
    taxiCheckRequest.data.applicationVersion = kVersion;
    taxiCheckRequest.data.applicationToken = kApplicationToken;
    taxiCheckRequest.data.commonApiVersion = kAppVersion;
    taxiCheckRequest.data.commonApiLanguage = loginResponse.response.data.userLanguage;
    LoginResponse response = await taxiCheckService.sendTaxiCheck(taxiCheckRequest);

    if (response.response.errorNumber == '0') {
      successMessage =
          '${AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('payment_sent_successfully_to')} $recipientName';
      status = true;
    } else {
      if (response.response.message is LinkedHashMap) {
        errorMessage = response.response.message["#cdata-section"];
      } else {
        errorMessage = response.response.message;
      }

      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

  Future<bool> addRecipient() async {
    bool status = false;
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    user.data.api = 'UserAddNew';
    user.data.userCountry = loginResponse.response.data.userCountry;
    user.data.userLanguage = loginResponse.response.data.userLanguage;
    user.data.userUniversalKey = loginResponse.response.userPhoneNumber;
    user.data.userPhoneNumber = receipientPhone;
    user.data.userPhoneCountry = loginResponse.response.userPhoneCountry;
    user.data.applicationVersion = kVersion;
    user.data.commonApiLanguage = kApiLanguage;
    user.data.commonApiVersion = kAppVersion;
    user.data.applicationToken = kApplicationToken;
    print(user.data.userUniversalKey);
    LoginResponse response = await taxiCheckService.addRecipient(user);

    if (response.response.errorNumber == '0') {
      successMessage =
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('user_added_successfully');
      status = true;
    } else {
      if (response.response.message is LinkedHashMap) {
        errorMessage = response.response.message["#cdata-section"];
      } else {
        errorMessage = response.response.message;
      }

      status = false;
    }
    return status;
  }
}
