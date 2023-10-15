import 'package:mobiwoom/core/models/requests/license.dart';
import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/responses/license.dart';
import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/locator.dart';

class LicenseService {
  Api _api = locator<Api>();

  Future<LicenseResponse> getAllSavedLicenses(LoginRequest loginRequest) async {
    return await _api.getAllSavedLicenses(loginRequest);
  }

  setAsMainPlate(LoginRequest request) async {
    return await _api.setAsMainPlate(request);
  }

  deleteLicensePlate(LoginRequest request) async {
    return await _api.deleteLicensePlate(request);
  }

  addLicensePlate(LicenseRequest request) async {
    return await _api.addLicensePlate(request);
  }
}
