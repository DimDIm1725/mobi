import 'package:mobiwoom/core/models/requests/base_request.dart';
import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/user.dart';
import 'package:mobiwoom/core/models/responses/login.dart';

import '../../locator.dart';
import 'api.dart';

class AuthenticationService {
  // Inject our Api
  Api _api = locator<Api>();

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    return await _api.login(loginRequest);
  }

  Future<LoginResponse> sendPincode(BaseRequest baseRequest) async {
    return await _api.sendPincode(baseRequest);
  }

  Future<LoginResponse> registerUser(User userRequest) async {
    return await _api.registerUser(userRequest);
  }

  Future<LoginResponse> acceptTCUForUser(LoginRequest loginRequest) async {
    return await _api.acceptTCUForUser(loginRequest);
  }

  setEmailForUser(LoginRequest loginRequest) async {
    return await _api.setEmailForUser(loginRequest);
  }

  getApplicationStartData(LoginRequest loginRequest) async {
    return await _api.getApplicationStartData(loginRequest);
  }
}
