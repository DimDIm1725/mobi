import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/partner.dart';
import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/locator.dart';

class PartnersService {
  Api _api = locator<Api>();

  getAllActivities(LoginRequest request) async {
    return await _api.getAllActivities(request);
  }

  getAllPartnersByGeoLocation(PartnerRequest request) async {
    return await _api.getAllPartnersByGeoLocation(request);
  }
}
