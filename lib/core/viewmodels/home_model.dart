import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/core/services/biometrics_service.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';

class HomeModel extends BaseModel {
  Api _api = locator<Api>();
  BioMetricService _bioMetricService = locator<BioMetricService>();

  Future<bool> isBiometricAvailable() {
    return _bioMetricService.isBiometricAvailable();
  }

  Future<bool> authenticateUsingBiometric() {
    return _bioMetricService.authenticate();
  }
}
