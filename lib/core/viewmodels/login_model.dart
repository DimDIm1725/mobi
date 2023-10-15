import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mobiwoom/core/models/requests/base_request.dart' as base;
import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/user.dart' as usr;
import 'package:mobiwoom/core/models/responses/license.dart' as licenseRes;
import 'package:mobiwoom/core/models/responses/login.dart' as loginResp;
import 'package:mobiwoom/core/models/responses/payline.dart' as pay;
import 'package:mobiwoom/core/services/authentication_service.dart';
import 'package:mobiwoom/core/services/biometrics_service.dart';
import 'package:mobiwoom/core/services/license_service.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/constants.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:geolocator/geolocator.dart';

class LoginModel extends BaseModel {
  licenseRes.Row activeParkingLicensePlate = null;
  licenseRes.LicenseResponse licenseResponse;
  LicenseService _licenseService = locator<LicenseService>();

//  loc.Position _locationData;
  // Regex to check phone email
  RegExp _emailRegExp = RegExp(
    r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",
    caseSensitive: false,
    multiLine: true,
  );

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final BioMetricService _bioMetricService = locator<BioMetricService>();
  final usr.Data registerUser = new usr.Data();

  Future<bool> login(String phoneNumber, String pincode) async {
    if (phoneNumber == null || phoneNumber == "") {
      errorMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('Value_entered_not_a_number');
      setState(ViewState.Idle);
      return false;
    }

    if (pincode == null || pincode == "" || pincode.length < 6) {
      errorMessage =
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('pincode_not_valid');
      setState(ViewState.Idle);
      return false;
    }
    Position locationData;
    setState(ViewState.Busy);
    locationData = await getCurrentLocation();

    if (locationData != null) {
      kGpsEnabled = true;
      print('gps' +  kGpsEnabled.toString());
    } else {
      kGpsEnabled = false;
    }
    //kGpsEnabled = locationData != null;

    String lat='';
    String lon='';
    if (kGpsEnabled) {
      SharedPrefUtil.setLatLocationData(locationData.latitude);
      SharedPrefUtil.setLonLocationData(locationData.longitude);
      lat = SharedPrefUtil.getLatLocationData().toString();
      lon = SharedPrefUtil.getLonLocationData().toString();
    }

    //  String appVersion = await getAppVersion();
    LoginRequest loginRequest = new LoginRequest(
      data: Data(
        api: 'UserLogin',
        userUniversalKey: phoneNumber,
        userPinCode: pincode,
        userBrowserType: getAccountBrowserType(),
        language: SharedPrefUtil.getUserLanguage().toUpperCase(),
        accountPhoneCellularType: kIsWeb
            ? ''
            : Platform.isAndroid
                ? "android"
                : Platform.isIOS
                    ? "ios"
                    : '',
        accountPhonePushCode: !kIsWeb ? SharedPrefUtil.getFCMToken() : '',
        accountBrowserPushKey: kIsWeb ? SharedPrefUtil.getFCMToken() : '',
        accountBrowserPushEndPoint: kIsWeb ? kBrowserPushEndPoint : '',
        accountBrowserPushAuthentication: kIsWeb ? kBrowserPushAuthentication : '',
        userLatitude: !kGpsEnabled ? '' : lat,
        userLongitude: !kGpsEnabled ? '' : lon,
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        userPhoneCountry: SharedPrefUtil.getUserCountryCode().toUpperCase(),
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    print(loginRequest.toJson());
    var loginResponse = await _authenticationService.login(loginRequest);
    setState(ViewState.Idle);
    if (loginResponse != null && loginResponse.response.errorNumber == '0') {
      SharedPrefUtil.setCurrentUser(loginResponse);
      return true;
    } else {
      errorMessage = loginResponse.response.message;
      return false;
    }
  }

  Future<bool> sendPincode(String phoneNumber) async {
    setState(ViewState.Busy);

    if (phoneNumber == null) {
      errorMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('Value_entered_not_a_number');
      setState(ViewState.Idle);
      return false;
    }
    base.BaseRequest baseRequest = new base.BaseRequest(
      data: base.Data(
        api: 'UserPinCodeGet',
        userPhoneNumber: phoneNumber,
        messageByEmail: false,
        userPhoneCountry: SharedPrefUtil.getUserLanguage().toUpperCase(),
        commonApiVersion: kAppVersion,
        commonApiLanguage: 'FR',
        commonApplicationVersion: kVersion,
        commonApplicationToken: kApplicationToken,
      ),
    );
    var loginResponse = await _authenticationService.sendPincode(baseRequest);
    setState(ViewState.Idle);
    if (loginResponse != null && loginResponse.response.errorNumber == '0') {
      return true;
    } else {
      errorMessage = loginResponse.response.message;
      return false;
    }
  }

  String getValidationMessage() {
    String response = "";
    if (registerUser.userPhoneNumber == null || registerUser.userPhoneNumber.isEmpty) {
      response +=
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('phone_number_mandatory');
    }
    if (registerUser.userFirstName == null || registerUser.userFirstName.isEmpty) {
      response +=
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('first_name_mandatory');
    }

    if (registerUser.userLastName == null || registerUser.userLastName.isEmpty) {
      response +=
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('last_name_mandatory');
    }

    if (registerUser.userEmail == null || registerUser.userEmail.isEmpty) {
      response += AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('email_mandatory');
    } else if (!_emailRegExp.hasMatch(registerUser.userEmail)) {
      response += AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('invalid_email');
    }
    if (response.isNotEmpty) {
      response = response.substring(0, response.length - 1);
    }
    return response;
  }

  Future<bool> register() async {
    registerUser.api = "UserAddNew";
    registerUser.userUniversalKey = registerUser.userPhoneNumber;
    registerUser.userPhoneCountry = SharedPrefUtil.getUserCountryCode();
    registerUser.userCountry = SharedPrefUtil.getUserCountryCode();
    // registerUser.userLanguage = SharedPrefUtil.getUserLanguage();
    registerUser.userLanguage = "FR";
    registerUser.userSignature = true;
    registerUser.messageBySMS = false;
    registerUser.applicationVersion = kVersion;
    registerUser.commonApiLanguage = kApiLanguage;
    registerUser.commonApiVersion = kAppVersion;
    registerUser.applicationToken = kApplicationToken;

    usr.User userRequest = new usr.User(data: registerUser);
    var loginResponse = await _authenticationService.registerUser(userRequest);
    setState(ViewState.Idle);
    if (loginResponse != null && loginResponse.response.errorNumber == '0') {
      return true;
    } else {
      errorMessage = loginResponse.response.message;
      return false;
    }
  }

  Future<bool> acceptTCUForUser(loginResp.LoginResponse loginResponse) async {
    //  print(loginResponse.response.data.userPhoneNumber);
    LoginRequest loginRequest = new LoginRequest(
      data: Data(
        api: 'UserSignatureSet',
        userUniversalKey: loginResponse.response.userPhoneNumber,
        userBrowserType: 'Mobile',
        language: loginResponse.response.data.userLanguage,
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    var loginResponseForTCU = await _authenticationService.acceptTCUForUser(loginRequest);
    setState(ViewState.Idle);
    if (loginResponseForTCU != null && loginResponseForTCU.response.errorNumber == '0') {
      return true;
    } else {
      errorMessage = loginResponse.response.message;
      return false;
    }
  }

  Future<bool> setEmailForUser(loginResp.LoginResponse loginResponse) async {
    LoginRequest loginRequest = new LoginRequest(
      data: Data(
        api: 'UserEMailSet',
        userUniversalKey: loginResponse.response.userPhoneNumber,
        userBrowserType: 'Mobile',
        userEmail: loginResponse.response.data.userEMail,
        language: loginResponse.response.data.userLanguage,
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    var loginResponseForUpdateEmail = await _authenticationService.setEmailForUser(loginRequest);
    setState(ViewState.Idle);
    if (loginResponseForUpdateEmail != null && loginResponseForUpdateEmail.response.errorNumber == '0') {
      return true;
    } else {
      errorMessage = loginResponse.response.message;
      return false;
    }
  }

  Future<bool> isBiometricAvailable() {
    return _bioMetricService.isBiometricAvailable();
  }

  Future<bool> authenticateUsingBiometric() {
    return _bioMetricService.authenticate();
  }

  Future<bool> getParkingStatus(loginResp.LoginResponse loginResponse) async {
    bool status = false;
    setState(ViewState.Busy);
    String userPincode = await SharedPrefUtil.getUserPincode();
    LoginRequest loginRequest = new LoginRequest(
        data: Data(
      api: 'CarPlatesList',
      userUniversalKey: loginResponse.response.userPhoneNumber,
      userBrowserType: getAccountBrowserType(),
      language: loginResponse.response.data.userLanguage,
      userPinCode: userPincode,
      userPhoneCountry: loginResponse.response.userPhoneCountry,
      commonApiVersion: kAppVersion,
      commonApiLanguage: kApiLanguage,
      applicationVersion: kVersion,
      applicationToken: kApplicationToken,
    ));
    licenseResponse = await _licenseService.getAllSavedLicenses(loginRequest);

    if (licenseResponse.response.errorNumber == '0' &&
        licenseResponse.response.data.row[0].ticketMachineName.isNotEmpty &&
        licenseResponse.response.data.row[0].ticketMachineName != '') {
      status = true;
    } else {
      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

  Future<bool> getApplicationStartData() async {
    loginResp.LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    bool status = false;
    setState(ViewState.Busy);
    String userPincode = await SharedPrefUtil.getUserPincode();
    LoginRequest loginRequest = new LoginRequest(
        data: Data(
      api: 'ApplicationStartUp',
      userUniversalKey: loginResponse.response.userPhoneNumber,
      userBrowserType: getAccountBrowserType(),
      language: loginResponse.response.data.userLanguage,
      userPinCode: userPincode,
      userPhoneCountry: loginResponse.response.userPhoneCountry,
      commonApiVersion: kAppVersion,
      commonApiLanguage: kApiLanguage,
      applicationVersion: kVersion,
      applicationToken: kApplicationToken,
    ));
    pay.PaylineData paylineData = await _authenticationService.getApplicationStartData(loginRequest);
    SharedPrefUtil.setPaylineData(paylineData);
    if (paylineData.response.errorNumber == '0') {
      status = true;
    } else {
      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

/* Future<bool> populateLicensePlates() async {
    print("Populate LICENSE PLATE");
    setState(ViewState.Busy);
    // await getAllTicketMachinesForLocation();
    activeParkingLicensePlate = null;
    bool status = await getAllSavedLicenses();
    if (status) {
      List<licenseRes.Row> list = licenseResponse.response?.data?.row;
      if (list != null && list.isNotEmpty) {
        for (licenseRes.Row item in list) {
          if (item.stopDateTime.isNotEmpty) {
            print("ACTIVE PLATE FOUND");
            activeParkingLicensePlate = item;
          }
        }
        if (parkingRequest.data?.userCarPlate != null) {
          //getParkingAreasList();
        } else {
          _vehiclePlateDropdownMenuItemList = [];
          for (var item in list) {
            try {
              if (item.main == 'True') {
                parkingRequest.data?.userCarPlate = item.carPlate;
                getParkingAreasList();
              }
              _vehiclePlateDropdownMenuItemList.add(
                DropdownMenuItem(
                  child: Text(
                    '${item.tag} : ${item.carPlate}',
                    overflow: TextOverflow.visible,
                  ),
                  value: item.carPlate,
                ),
              );
            } catch (e) {
              print(e);
              setState(ViewState.Idle);
            }
          }
        }
      }
      setState(ViewState.Idle);
      return status;
    }
  }*/
}
