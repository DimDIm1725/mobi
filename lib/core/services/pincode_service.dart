import 'package:mobiwoom/core/models/requests/pincode.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/locator.dart';

class PincodeService {
  Api _api = locator<Api>();

  Future<LoginResponse> changePincode(PincodeRequest request) async {
    return await _api.changePincode(request);
  }
}
