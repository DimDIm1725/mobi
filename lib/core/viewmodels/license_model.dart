import 'dart:collection';

import 'package:mobiwoom/core/models/requests/license.dart';
import 'package:mobiwoom/core/models/requests/login.dart' as loginReq;
import 'package:mobiwoom/core/models/responses/license.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/services/license_service.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/localization.dart';

class LicenseModel extends BaseModel {
  LicenseService licenseService = locator<LicenseService>();
  LicenseResponse license;
  loginReq.LoginRequest request;
  LicenseRequest licenseRequest;

  getAllSavedLicenses() async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    request = loginReq.LoginRequest(
        data: loginReq.Data(
      api: 'CarPlatesList',
      userUniversalKey: loginResponse.response.userPhoneNumber,
      userBrowserType: getAccountBrowserType(),
      language: loginResponse.response.data.userLanguage,
      userPinCode: userPincode,
      userPhoneCountry: loginResponse.response.userPhoneCountry,
      applicationVersion: kVersion,
      commonApiLanguage: kApiLanguage,
      commonApiVersion: kAppVersion,
      applicationToken: kApplicationToken,
    ));
    license = await licenseService.getAllSavedLicenses(request);
    setState(ViewState.Idle);
  }

  setAsMainCard(carPlate) async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    request = loginReq.LoginRequest(
        data: loginReq.Data(
      api: 'CarPlateMainSet',
      userUniversalKey: loginResponse.response.userPhoneNumber,
      userBrowserType: getAccountBrowserType(),
      language: loginResponse.response.data.userLanguage,
      userPinCode: userPincode,
      commonApiLanguage: kApiLanguage,
      commonApiVersion: kAppVersion,
      carPlate: carPlate,
      userPhoneCountry: loginResponse.response.userPhoneCountry,
      applicationVersion: kVersion,
      applicationToken: kApplicationToken,
    ));
    await licenseService.setAsMainPlate(request);
    setState(ViewState.Idle);
  }

  deleteLicensePlate(String carPlate) async {
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    request = loginReq.LoginRequest(
        data: loginReq.Data(
      api: 'CarPlateDelete',
      userUniversalKey: loginResponse.response.userPhoneNumber,
      userBrowserType: getAccountBrowserType(),
      language: loginResponse.response.data.userLanguage,
      userPinCode: userPincode,
      carPlate: carPlate,
      commonApiLanguage: kApiLanguage,
      commonApiVersion: kAppVersion,
      userPhoneCountry: loginResponse.response.userPhoneCountry,
      applicationVersion: kVersion,
      applicationToken: kApplicationToken,
    ));
    await licenseService.deleteLicensePlate(request);
    setState(ViewState.Idle);
  }

  Future<bool> addLicensePlate() async {
    bool status = false;
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    licenseRequest.data.api = 'CarPlateAddNew';
    licenseRequest.data.userUniversalKey = loginResponse.response.userPhoneNumber;
    licenseRequest.data.userPinCode = userPincode;
    licenseRequest.data.applicationVersion = kVersion;
    licenseRequest.data.applicationToken = kApplicationToken;
    licenseRequest.data.commonApiLanguage = kApiLanguage;
    licenseRequest.data.commonApiVersion = kAppVersion;
    LoginResponse response = await licenseService.addLicensePlate(licenseRequest);

    if (response.response.errorNumber == '0') {
      successMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('license_added_successfully');
      status = true;
    } else {
      errorMessage =
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('license_added_error');
      /*  if (response.response.message is LinkedHashMap) {
        errorMessage = response.response.message["#cdata-section"];
      } else {
        errorMessage = response.response.message;
      }*/

      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }
}
