import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/sponsor_user.dart';
import 'package:mobiwoom/core/models/requests/user.dart';
import 'package:mobiwoom/core/models/user.dart' as user;
import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/locator.dart';

class ProfileService {
  Api _api = locator<Api>();

  Future<user.User> getUser(LoginRequest loginRequest) async {
    return await _api.getUser(loginRequest);
  }

  updateUser(User userReq) async {
    return await _api.updateUser(userReq);
  }

  sponsorUser(SponsorUser user) async {
    return await _api.sponsorUser(user);
  }
}
