import 'dart:collection';
import 'package:mobiwoom/core/models/requests/pincode.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/services/pincode_service.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/localization.dart';

class PincodeModel extends BaseModel {
  PincodeService _pincodeService = locator<PincodeService>();
  PincodeRequest pincodeRequest;

  Future<bool> changePincode() async {
    bool status = false;
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    pincodeRequest.data.api = 'UserPinCodeSet';
    pincodeRequest.data.userUniversalKey =
        loginResponse.response.userPhoneNumber;
    pincodeRequest.data.language = loginResponse.response.data.userLanguage;
    pincodeRequest.data.userPhoneCountry =
        loginResponse.response.userPhoneCountry;
    pincodeRequest.data.commonApiLanguage =
        loginResponse.response.data.userLanguage;
    pincodeRequest.data.commonApiVersion = kAppVersion;
    pincodeRequest.data.applicationVersion = kVersion;
    pincodeRequest.data.applicationToken = kApplicationToken;

    if (pincodeRequest.data.userNewPinCode.length < 6 ||
        pincodeRequest.data.confirmNewPincode.length < 6 ||
        pincodeRequest.data.userOldPinCode.length < 6) {
      errorMessage = AppLocalizations.of(
              locator<Application>().navigatorKey.currentContext)
          .translate('pincode_length_constraint');
      status = false;
    } else if (pincodeRequest.data.userNewPinCode !=
        pincodeRequest.data.confirmNewPincode) {
      errorMessage = AppLocalizations.of(
              locator<Application>().navigatorKey.currentContext)
          .translate('pincode_mismatch_for_new_pincode');
      status = false;
    } else {
      LoginResponse response =
          await _pincodeService.changePincode(pincodeRequest);

      if (response.response.errorNumber == '0') {
        successMessage = AppLocalizations.of(
                locator<Application>().navigatorKey.currentContext)
            .translate('pincode_changed_successfully');
        status = true;
      } else {
        if (response.response.message is LinkedHashMap) {
          errorMessage = response.response.message["#cdata-section"];
        } else {
          errorMessage = response.response.message;
        }
        status = false;
      }
    }
    setState(ViewState.Idle);
    return status;
  }
}
