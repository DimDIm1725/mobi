import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:mobiwoom/core/models/requests/card.dart' as cardReq;
import 'package:mobiwoom/core/models/requests/login.dart' as requestLogin;
import 'package:mobiwoom/core/models/requests/sendToken.dart' as tokenReq;
import 'package:mobiwoom/core/models/responses/base_bank_response.dart';
import 'package:mobiwoom/core/models/responses/card.dart';
import 'package:mobiwoom/core/models/responses/card_bank.dart' as cardBank;
import 'package:mobiwoom/core/models/responses/do_web_payment.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/models/responses/manage_web_wallet.dart';
import 'package:mobiwoom/core/models/responses/new_credit_card.dart';
import 'package:mobiwoom/core/models/responses/payline.dart';
import 'package:mobiwoom/core/models/responses/sendToken.dart';
import 'package:mobiwoom/core/services/card_service.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/credit_card_detector.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:xml2json/xml2json.dart';
import 'package:xml_parser/xml_parser.dart';

class CardModel extends BaseModel {
  CardService cardService = locator<CardService>();
  CardService tokenService = locator<CardService>();
  Card card;
  cardBank.CardBankResponse cardBankResponse;
  DoWebPaymentFromBankResponse doWebPaymentFromBankResponse;
  ManageWebWalletResponse manageWebWalletResponse;
  cardReq.CardRequest cardRequest;
  tokenReq.TokenRequest tokenRequest;

  getAllSavedCards() async {
    print("GET ALL SAVED CARDS");
    setState(ViewState.Busy);
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
    setState(ViewState.Idle);
  }

 /* Future<cardBank.CardBankResponse> getAllSavedCardsFromBank() async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    PaylineData paylineData = await SharedPrefUtil.getPaylineData();
    dynamic data =
        '''<ns1:getCardsRequest xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://impl.ws.payline.experian.com">\n  <ns1:version/>\n  <ns1:contractNumber>${paylineData.response.data.paylineContractNumber}</ns1:contractNumber>\n  <ns1:walletId>${loginResponse.response.userId}</ns1:walletId>\n\n</ns1:getCardsRequest>''';
    XmlDocument xmlDocument = await cardService.getAllSavedCardsFromBank(data);
    Xml2Json myTransformer = Xml2Json();
    String string = xmlDocument.toString();
    string = string.replaceAll("obj:", "");
    string = string.replaceAll("impl:", "");
    string = string.replaceAll("@", "");
    string = string.replaceAll("default", "isDefault");
    myTransformer.parse(string);
    dynamic json = myTransformer.toParker();
    cardBankResponse = cardBank.CardBankResponse.fromJson(jsonDecode(json));
    setState(ViewState.Idle);
    return cardBankResponse;
  }*/

 /* Future<ManageWebWalletResponse> getTokenFromBank() async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    PaylineData paylineData = await SharedPrefUtil.getPaylineData();
    dynamic data =
        '''<ns1:manageWebWalletRequest xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://impl.ws.payline.experian.com" xmlns:ns2="http://obj.ws.payline.experian.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <ns1:version>${paylineData.response.data.paylineVersion}</ns1:version>
    <ns1:contractNumber>${paylineData.response.data.paylineContractNumber}</ns1:contractNumber>
    <ns1:selectedContractList>
    <ns2:selectedContract>${paylineData.response.data.paylineContractNumber}</ns2:selectedContract>
    </ns1:selectedContractList>
    <ns1:updatePersonalDetails>0</ns1:updatePersonalDetails>
    <ns1:buyer>
    <ns2:title>4</ns2:title>
    <ns2:lastName>${loginResponse.response.data.userLastName ?? "Unknown"}</ns2:lastName>
    <ns2:firstName>${loginResponse.response.data.userFirstName ?? "Unknown"}</ns2:firstName>
    <ns2:email>${loginResponse.response.data.userEMail ?? "Unknown"}</ns2:email>
    <ns2:shippingAdress>
    <ns2:title xsi:nil="true"/>
    <ns2:name xsi:nil="true"/>
    <ns2:firstName xsi:nil="true"/>
    <ns2:lastName xsi:nil="true"/>
    <ns2:street1 xsi:nil="true"/>
    <ns2:street2 xsi:nil="true"/>
    <ns2:streetNumber xsi:nil="true"/>
    <ns2:cityName xsi:nil="true"/>
    <ns2:zipCode xsi:nil="true"/>
    <ns2:country xsi:nil="true"/>
    <ns2:phone xsi:nil="true"/>
    <ns2:state xsi:nil="true"/>
    <ns2:county xsi:nil="true"/>
    <ns2:phoneType xsi:nil="true"/>
    <ns2:addressCreateDate xsi:nil="true"/>
    <ns2:email xsi:nil="true"/>
    </ns2:shippingAdress>
    <ns2:billingAddress>
    <ns2:title xsi:nil="true"/>
    <ns2:name xsi:nil="true"/>
    <ns2:firstName xsi:nil="true"/>
    <ns2:lastName xsi:nil="true"/>
    <ns2:street1 xsi:nil="true"/>
    <ns2:street2 xsi:nil="true"/>
    <ns2:streetNumber xsi:nil="true"/>
    <ns2:cityName xsi:nil="true"/>
    <ns2:zipCode xsi:nil="true"/>
    <ns2:country xsi:nil="true"/>
    <ns2:phone xsi:nil="true"/>
    <ns2:state xsi:nil="true"/>
    <ns2:county xsi:nil="true"/>
    <ns2:phoneType>0</ns2:phoneType>
    <ns2:addressCreateDate xsi:nil="true"/>
    <ns2:email xsi:nil="true"/>
    </ns2:billingAddress>
    <ns2:accountCreateDate xsi:nil="true"/>
    <ns2:accountAverageAmount xsi:nil="true"/>
    <ns2:accountOrderCount xsi:nil="true"/>
    <ns2:walletId>${loginResponse.response.userId}</ns2:walletId>
    <ns2:walletDisplayed xsi:nil="true"/>
    <ns2:walletSecured xsi:nil="true"/>
    <ns2:walletCardInd xsi:nil="true"/>
    <ns2:ip>82.64.127.166</ns2:ip>
    <ns2:mobilePhone xsi:nil="true"/>
    <ns2:customerId xsi:nil="true"/>
    <ns2:legalStatus>1</ns2:legalStatus>
    <ns2:legalDocument>1</ns2:legalDocument>
    <ns2:birthDate xsi:nil="true"/>
    <ns2:fingerprintID xsi:nil="true"/>
    <ns2:deviceFingerprint xsi:nil="true"/>
    <ns2:isBot xsi:nil="true"/>
    <ns2:isIncognito xsi:nil="true"/>
    <ns2:isBehindProxy xsi:nil="true"/>
    <ns2:isFromTor xsi:nil="true"/>
    <ns2:isEmulator xsi:nil="true"/>
    <ns2:isRooted xsi:nil="true"/>
    <ns2:hasTimezoneMismatch xsi:nil="true"/>
    <ns2:loyaltyMemberType xsi:nil="true"/>
    <ns2:buyerExtended xsi:nil="true"/>
    <ns2:merchantAuthentication>
    <ns2:method xsi:nil="true"/>
    <ns2:date xsi:nil="true"/>
    </ns2:merchantAuthentication>
    </ns1:buyer>
    <ns1:owner>
    <ns2:lastName>Di Bernardi</ns2:lastName>
    <ns2:firstName>Sandro</ns2:firstName>
    <ns2:billingAddress>
    <ns2:street xsi:nil="true"/>
    <ns2:cityName xsi:nil="true"/>
    <ns2:zipCode xsi:nil="true"/>
    <ns2:country xsi:nil="true"/>
    <ns2:phone xsi:nil="true"/>
    </ns2:billingAddress>
    <ns2:issueCardDate>0120</ns2:issueCardDate>
    </ns1:owner>
    <ns1:languageCode xsi:nil="true"/>
    <ns1:customPaymentPageCode xsi:nil="true"/>
    <ns1:securityMode xsi:nil="true"/>
    <ns1:returnURL>https://payline.mobiwoom.com/examples/demos/wallet.php?e=getWebWallet</ns1:returnURL>
    <ns1:cancelURL>https://payline.mobiwoom.com/examples/demos/wallet.php?e=getWebWallet</ns1:cancelURL>
    <ns1:notificationURL>https://payline.mobiwoom.com/receive_form.php</ns1:notificationURL>
    <ns1:privateDataList/>
    <ns1:customPaymentTemplateURL xsi:nil="true"/>
    <ns1:contractNumberWalletList xsi:nil="true"/>
    <ns1:merchantName>MOBIWOOM</ns1:merchantName>
    <ns1:threeDSInfo>
    <ns2:challengeInd xsi:nil="true"/>
    <ns2:threeDSReqPriorAuthData xsi:nil="true"/>
    <ns2:threeDSReqPriorAuthMethod xsi:nil="true"/>
    <ns2:threeDSReqPriorAuthTimestamp xsi:nil="true"/>
    <ns2:browser>
    <ns2:acceptHeader xsi:nil="true"/>
    <ns2:javaEnabled xsi:nil="true"/>
    <ns2:javascriptEnabled xsi:nil="true"/>
    <ns2:language xsi:nil="true"/>
    <ns2:colorDepth xsi:nil="true"/>
    <ns2:screenHeight xsi:nil="true"/>
    <ns2:screenWidth xsi:nil="true"/>
    <ns2:timeZoneOffset xsi:nil="true"/>
    <ns2:userAgent xsi:nil="true"/>
    </ns2:browser>
    <ns2:sdk>
    <ns2:deviceRenderingOptionsIF xsi:nil="true"/>
    <ns2:deviceRenderOptionsUI xsi:nil="true"/>
    <ns2:appID xsi:nil="true"/>
    <ns2:ephemPubKey xsi:nil="true"/>
    <ns2:maxTimeout xsi:nil="true"/>
    <ns2:referenceNumber xsi:nil="true"/>
    <ns2:transID xsi:nil="true"/>
    </ns2:sdk>
    <ns2:threeDSMethodNotificationURL xsi:nil="true"/>
    <ns2:threeDSMethodResult xsi:nil="true"/>
    <ns2:challengeWindowSize xsi:nil="true"/>
    </ns1:threeDSInfo>
    </ns1:manageWebWalletRequest>''';
    XmlDocument xmlDocument = await cardService.getTokenFromBank(data);
    Xml2Json myTransformer = Xml2Json();
    String string = xmlDocument.toString();
    string = string.replaceAll("obj:", "");
    string = string.replaceAll("impl:", "");
    string = string.replaceAll("@", "");
    string = string.replaceAll("default", "isDefault");
    myTransformer.parse(string);
    dynamic json = myTransformer.toParker();
    manageWebWalletResponse = ManageWebWalletResponse.fromJson(jsonDecode(json));
    setState(ViewState.Idle);
    return manageWebWalletResponse;
  }*/

  setAsMainCard(String cardToken) async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
          api: 'UserCreditCardMainSet',
          userUniversalKey: loginResponse.response.userPhoneNumber,
          userBrowserType: getAccountBrowserType(),
          language: loginResponse.response.data.userLanguage,
          userPhoneCountry: loginResponse.response.userPhoneCountry,
          applicationVersion: kVersion,
          commonApiVersion: kAppVersion,
          commonApiLanguage: kApiLanguage,
          applicationToken: kApplicationToken,
          creditCardToken: cardToken),
    );
    await cardService.setAsMainCard(loginRequest);
    setState(ViewState.Idle);
  }

  Future<bool> deleteCard(String token) async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
          api: 'UserCreditCardDelete',
          userUniversalKey: loginResponse.response.userPhoneNumber,
          userBrowserType: getAccountBrowserType(),
          userPinCode: userPincode,
          language: loginResponse.response.data.userLanguage,
          userPhoneCountry: loginResponse.response.userPhoneCountry,
          applicationVersion: kVersion,
          commonApiVersion: kAppVersion,
          commonApiLanguage: kApiLanguage,
          applicationToken: kApplicationToken,
          creditCardToken: token),
    );
    Card cardResponse = await cardService.deleteCard(loginRequest);
    setState(ViewState.Idle);
    if (cardResponse.response.errorNumber == '0') {
      successMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('card_deleted_successfully');
      return true;
    } else {
      errorMessage = cardResponse.response.message;
      return false;
      // show error message here
    }
  }

 /* Future<bool> deleteCardFromBank(String token, String selectedCardIndex) async {
    setState(ViewState.Busy);
    BaseBankResponse baseBankResponse = await cardService.deleteCardFromBank(token, selectedCardIndex);
    setState(ViewState.Idle);
    if (baseBankResponse != null && baseBankResponse.manageWallet?.actionStatus == 1) {
      successMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('card_deleted_successfully');
      return true;
    } else {
      errorMessage = "Card Deletion failed";
      return false;
      // show error message here
    }
  }*/

 /* Future<bool> setMainCardFromBank(String token, String selectedCardIndex) async {
    setState(ViewState.Busy);
    BaseBankResponse baseBankResponse = await cardService.setMainCardFromBank(token, selectedCardIndex);
    setState(ViewState.Idle);
    if (baseBankResponse != null && baseBankResponse.manageWallet?.actionStatus == 1) {
      successMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('card_deleted_successfully');
      return true;
    } else {
      errorMessage = "Card Deletion failed";
      return false;
      // show error message here
    }
  }*/

 /* Future<bool> activateToken(String url) async {
    setState(ViewState.Busy);
    dynamic response = await cardService.activateToken(url);
    setState(ViewState.Idle);
    if (response != null) {
      successMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('card_deleted_successfully');
      return true;
    } else {
      errorMessage = "Card Deletion failed";
      return false;
      // show error message here
    }
  }*/

 /* Future<bool> deleteBankCard(String token) async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
          api: 'UserCreditCardDelete',
          userUniversalKey: loginResponse.response.userPhoneNumber,
          userBrowserType: getAccountBrowserType(),
          userPinCode: userPincode,
          language: loginResponse.response.data.userLanguage,
          userPhoneCountry: loginResponse.response.userPhoneCountry,
          applicationVersion: kVersion,
          commonApiVersion: kAppVersion,
          commonApiLanguage: kApiLanguage,
          applicationToken: kApplicationToken,
          creditCardToken: token),
    );
    Card cardResponse = await cardService.deleteCard(loginRequest);
    setState(ViewState.Idle);
    if (cardResponse.response.errorNumber == '0') {
      successMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('card_deleted_successfully');
      return true;
    } else {
      errorMessage = cardResponse.response.message;
      return false;
      // show error message here
    }
  }*/

  Future<NewCreditCardResponse> addCard() async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
  //  String userPincode = await SharedPrefUtil.getUserPincode();
    cardRequest = cardReq.CardRequest(data: cardReq.Data(code: '', number: '', holderName: '', main: 'true'));
    cardRequest.data.api = 'CreditCardEnrollmentRequest';
    cardRequest.data.userUniversalKey = loginResponse.response.userPhoneNumber;
    cardRequest.data.userPhoneCountry = loginResponse.response.userPhoneCountry;
    cardRequest.data.applicationVersion = kVersion;
    cardRequest.data.applicationToken = kApplicationToken;
    cardRequest.data.commonApiVersion = kAppVersion;
    cardRequest.data.commonApiLanguage = kApiLanguage;
    NewCreditCardResponse cardResponse = await cardService.addCard(cardRequest);
    if (cardResponse.response.errorNumber == '0') {
      successMessage =
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('card_added_successfully');
    } else {
      if (cardResponse.response.message is LinkedHashMap) {
        errorMessage = cardResponse.response.message["#cdata-section"];
      } else {
        errorMessage = cardResponse.response.message;
      }
      cardResponse = NewCreditCardResponse.withError(errorMessage);
    }
    return cardResponse;
  }

 /* Future<DoWebPaymentFromBankResponse> addBankCard(String returnUrl, String cancelUrl) async {
    setState(ViewState.Busy);
    DateTime dateTimeNow = DateTime.now();
    String date = DateFormat('dd/MM/yyy HH:mm').format(dateTimeNow);
    String deliveryExpectedDate = DateFormat('dd/MM/yyy').format(dateTimeNow);
    int amount = 0;
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    PaylineData paylineData = await SharedPrefUtil.getPaylineData();
    String reference = "AC-${loginResponse.response.userId}-${dateTimeNow.millisecondsSinceEpoch}-MW";
    dynamic data =
        '''<ns1:doWebPaymentRequest xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://impl.ws.payline.experian.com" xmlns:ns2="http://obj.ws.payline.experian.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<ns1:version>${paylineData.response.data.paylineVersion}</ns1:version>
	<ns1:payment>
		<ns2:amount>$amount</ns2:amount>
		<ns2:currency>978</ns2:currency>
		<ns2:action>128</ns2:action>
		<ns2:mode>CPT</ns2:mode>
		<ns2:contractNumber>${paylineData.response.data.paylineContractNumber}</ns2:contractNumber>
		<ns2:differedActionDate xsi:nil="true"/>
		<ns2:method xsi:nil="true"/>
		<ns2:softDescriptor xsi:nil="true"/>
		<ns2:cardBrand xsi:nil="true"/>
		<ns2:registrationToken xsi:nil="true"/>
		<ns2:cumulatedAmount>0</ns2:cumulatedAmount>
	</ns1:payment>
	<ns1:returnURL>$returnUrl</ns1:returnURL>
	<ns1:cancelURL>$cancelUrl</ns1:cancelURL>
	<ns1:order>
		<ns2:ref>$reference</ns2:ref>
		<ns2:origin xsi:nil="true"/>
		<ns2:country xsi:nil="true"/>
		<ns2:taxes xsi:nil="true"/>
		<ns2:amount>$amount</ns2:amount>
		<ns2:currency>978</ns2:currency>
		<ns2:date>$date</ns2:date>
		<ns2:details/>
		<ns2:deliveryTime xsi:nil="true"/>
		<ns2:deliveryMode xsi:nil="true"/>
		<ns2:deliveryExpectedDate>$deliveryExpectedDate</ns2:deliveryExpectedDate>
		<ns2:deliveryExpectedDelay>4</ns2:deliveryExpectedDelay>
		<ns2:deliveryCharge xsi:nil="true"/>
		<ns2:discountAmount xsi:nil="true"/>
		<ns2:otaPackageType xsi:nil="true"/>
		<ns2:otaDestinationCountry xsi:nil="true"/>
		<ns2:bookingReference xsi:nil="true"/>
		<ns2:orderDetail xsi:nil="true"/>
		<ns2:orderExtended xsi:nil="true"/>
		<ns2:orderOTA xsi:nil="true"/>
	</ns1:order>
	<ns1:notificationURL xsi:nil="true"/>
	<ns1:selectedContractList>
		<ns2:selectedContract>${paylineData.response.data.paylineContractNumber}</ns2:selectedContract>
	</ns1:selectedContractList>
	<ns1:secondSelectedContractList xsi:nil="true"/>
	<ns1:privateDataList/>
	<ns1:languageCode xsi:nil="true"/>
	<!--ns1:customPaymentPageCode>TEMPLATE_7LYgYdrmdt6</ns1:customPaymentPageCode-->
	<ns1:customPaymentPageCode>TEMPLATE_xVRUOUwbVtR</ns1:customPaymentPageCode>
	<ns1:buyer>
		<ns2:title>4</ns2:title>
		<ns2:lastName>${loginResponse.response.data.userLastName ?? "Unknown"}</ns2:lastName>
		<ns2:firstName> ${loginResponse.response.data.userFirstName ?? "Unknown"}</ns2:firstName>
		<ns2:email>${loginResponse.response.data.userEMail}</ns2:email>
		<ns2:shippingAdress>
			<ns2:title xsi:nil="true"/><ns2:name xsi:nil="true"/>
			<ns2:firstName xsi:nil="true"/>
			<ns2:lastName xsi:nil="true"/>
			<ns2:street1 xsi:nil="true"/>
			<ns2:street2 xsi:nil="true"/>
			<ns2:streetNumber xsi:nil="true"/>
			<ns2:cityName xsi:nil="true"/>
			<ns2:zipCode xsi:nil="true"/>
			<ns2:country xsi:nil="true"/>
			<ns2:phone xsi:nil="true"/>
			<ns2:state xsi:nil="true"/>
			<ns2:county xsi:nil="true"/>
			<ns2:phoneType xsi:nil="true"/>
			<ns2:addressCreateDate xsi:nil="true"/>
			<ns2:email xsi:nil="true"/>
			</ns2:shippingAdress><ns2:billingAddress>
			<ns2:title xsi:nil="true"/>
			<ns2:name xsi:nil="true"/>
			<ns2:firstName xsi:nil="true"/>
			<ns2:lastName xsi:nil="true"/>
			<ns2:street1 xsi:nil="true"/>
			<ns2:street2 xsi:nil="true"/>
			<ns2:streetNumber xsi:nil="true"/>
			<ns2:cityName xsi:nil="true"/>
			<ns2:zipCode xsi:nil="true"/>
			<ns2:country xsi:nil="true"/>
			<ns2:phone xsi:nil="true"/>
			<ns2:state xsi:nil="true"/>
			<ns2:county xsi:nil="true"/>
			<ns2:phoneType>0</ns2:phoneType>
			<ns2:addressCreateDate xsi:nil="true"/>
			<ns2:email xsi:nil="true"/>
		</ns2:billingAddress>
		<ns2:accountCreateDate xsi:nil="true"/>
		<ns2:accountAverageAmount xsi:nil="true"/>
		<ns2:accountOrderCount xsi:nil="true"/>
		<ns2:walletId>${loginResponse.response.userId}</ns2:walletId>
		<ns2:walletDisplayed>none</ns2:walletDisplayed>
		<ns2:walletSecured xsi:nil="true"/>
		<ns2:walletCardInd xsi:nil="true"/>
		<ns2:ip>82.64.127.166</ns2:ip>
		<ns2:mobilePhone xsi:nil="true"/>
		<ns2:customerId xsi:nil="true"/>
		<ns2:legalStatus xsi:nil="true"/>
		<ns2:legalDocument>1</ns2:legalDocument>
		<ns2:birthDate xsi:nil="true"/>
		<ns2:fingerprintID xsi:nil="true"/>
		<ns2:deviceFingerprint xsi:nil="true"/>
		<ns2:isBot xsi:nil="true"/>
		<ns2:isIncognito xsi:nil="true"/>
		<ns2:isBehindProxy xsi:nil="true"/>
		<ns2:isFromTor xsi:nil="true"/>
		<ns2:isEmulator xsi:nil="true"/>
		<ns2:isRooted xsi:nil="true"/>
		<ns2:hasTimezoneMismatch xsi:nil="true"/>
		<ns2:loyaltyMemberType xsi:nil="true"/>
		<ns2:buyerExtended xsi:nil="true"/>
		<ns2:merchantAuthentication>
			<ns2:method xsi:nil="true"/>
			<ns2:date xsi:nil="true"/>
		</ns2:merchantAuthentication>
	</ns1:buyer>
	<ns1:owner>
		<ns2:lastName xsi:nil="true"/>
		<ns2:firstName xsi:nil="true"/>
		<ns2:billingAddress>
			<ns2:street xsi:nil="true"/>
			<ns2:cityName xsi:nil="true"/>
			<ns2:zipCode xsi:nil="true"/>
			<ns2:country xsi:nil="true"/>
			<ns2:phone xsi:nil="true"/>
		</ns2:billingAddress>
		<ns2:issueCardDate>0120</ns2:issueCardDate>
	</ns1:owner>
	<ns1:securityMode xsi:nil="true"/>
	<ns1:recurring>
		<ns2:firstAmount>0</ns2:firstAmount>
		<ns2:billingRank>1</ns2:billingRank>
  </ns1:recurring>
  <ns1:customPaymentTemplateURL></ns1:customPaymentTemplateURL>
	<ns1:contractNumberWalletList xsi:nil="true"/>
	<ns1:merchantName>BONJOURCARD</ns1:merchantName>
	<ns1:subMerchant><ns2:subMerchantId/>
		<ns2:subMerchantName xsi:nil="true"/>
		<ns2:subMerchantMCC/>
		<ns2:subMerchantSIRET xsi:nil="true"/>
		<ns2:subMerchantTaxCode xsi:nil="true"/>
		<ns2:subMerchantStreet xsi:nil="true"/>
		<ns2:subMerchantCity xsi:nil="true"/>
		<ns2:subMerchantZipCode xsi:nil="true"/>
		<ns2:subMerchantCountry xsi:nil="true"/>
		<ns2:subMerchantState xsi:nil="true"/>
		<ns2:subMerchantEmailAddress xsi:nil="true"/>
		<ns2:subMerchantPhoneNumber xsi:nil="true"/>
	</ns1:subMerchant><ns1:miscData/>
	<ns1:asynchronousRetryTimeout/>
	<ns1:threeDSInfo>
		<ns2:challengeInd>04</ns2:challengeInd>
		<ns2:threeDSReqPriorAuthData xsi:nil="true"/>
		<ns2:threeDSReqPriorAuthMethod xsi:nil="true"/>
		<ns2:threeDSReqPriorAuthTimestamp xsi:nil="true"/>
		<ns2:browser>
			<ns2:acceptHeader xsi:nil="true"/>
			<ns2:javaEnabled xsi:nil="true"/>
			<ns2:javascriptEnabled xsi:nil="true"/>
			<ns2:language xsi:nil="true"/>
			<ns2:colorDepth xsi:nil="true"/>
			<ns2:screenHeight xsi:nil="true"/>
			<ns2:screenWidth xsi:nil="true"/>
			<ns2:timeZoneOffset xsi:nil="true"/>
			<ns2:userAgent xsi:nil="true"/>
			</ns2:browser><ns2:sdk>
			<ns2:deviceRenderingOptionsIF xsi:nil="true"/>
			<ns2:deviceRenderOptionsUI xsi:nil="true"/>
			<ns2:appID xsi:nil="true"/>
			<ns2:ephemPubKey xsi:nil="true"/>
			<ns2:maxTimeout xsi:nil="true"/>
			<ns2:referenceNumber xsi:nil="true"/>
			<ns2:transID xsi:nil="true"/>
		</ns2:sdk>
		<ns2:threeDSMethodNotificationURL>https://payline.mobiwoom.com/receive_form.php</ns2:threeDSMethodNotificationURL>
		<ns2:threeDSMethodResult>I</ns2:threeDSMethodResult>
		<ns2:challengeWindowSize xsi:nil="true"/>
	</ns1:threeDSInfo><ns1:merchantScore xsi:nil="true"/>
</ns1:doWebPaymentRequest>
''';
    XmlDocument xmlDocument = await cardService.addBankCard(data);
    Xml2Json myTransformer = Xml2Json();
    String string = xmlDocument.toString();
    string = string.replaceAll("obj:", "");
    string = string.replaceAll("impl:", "");
    string = string.replaceAll("@", "");
    string = string.replaceAll("default", "isDefault");
    myTransformer.parse(string);
    dynamic json = myTransformer.toParker();
    print(json);
    DoWebPaymentFromBankResponse doWebPaymentResponse = DoWebPaymentFromBankResponse.fromJson(jsonDecode(json));
    setState(ViewState.Idle);
    return doWebPaymentResponse;
  }*/

 Future<TokenResponse> sendToken(String token) async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    tokenRequest = tokenReq.TokenRequest(data: tokenReq.Data());
    tokenRequest.data.api = 'CreditCardEnrollmentControl';
    tokenRequest.data.token = token;
    tokenRequest.data.userUniversalKey = loginResponse.response.userPhoneNumber;
    tokenRequest.data.userPhoneCountry = loginResponse.response.userPhoneCountry;
    tokenRequest.data.applicationVersion = kVersion;
    tokenRequest.data.applicationToken = kApplicationToken;
    tokenRequest.data.commonApiVersion = kAppVersion;
    tokenRequest.data.commonApiLanguage = kApiLanguage;
    TokenResponse tokenResponse = await tokenService.sendToken(tokenRequest);
    if (tokenResponse.response.errorNumber == '0') {
      successMessage =
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('card_added_successfully');
    } else {
      if (tokenResponse.response.message is LinkedHashMap) {
        errorMessage = tokenResponse.response.message["#cdata-section"];
      } else {
        errorMessage = tokenResponse.response.message;
      }
      tokenResponse = TokenResponse.withError(errorMessage);
    }
   // setState(ViewState.Idle);
    return tokenResponse;
  }

/*  Future<TokenResponse> sendToken(token) async {
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();

    tokenReq.TokenRequest tokenRequest = new tokenReq.TokenRequest(
      data: tokenReq.Data(
        api: 'CreditCardEnrollmentControl',
        userUniversalKey: loginResponse.response.userPhoneNumber,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        token: token,
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    card = await cardService.sendToken(tokenRequest);
    return card;
  }*/

}
