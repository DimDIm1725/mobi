import 'dart:convert';

import 'package:mobiwoom/core/models/requests/login.dart' as requestLogin;
import 'package:mobiwoom/core/models/requests/sponsor_user.dart' as sponsorUserReq;
import 'package:mobiwoom/core/models/requests/user.dart' as userRequest;
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/models/user.dart' as userResponse;
import 'package:mobiwoom/core/services/profile_service.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/constants.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel extends BaseModel {
  ProfileService profileService = locator<ProfileService>();
  userResponse.User user;
  LoginResponse loginResponse;
  sponsorUserReq.SponsorUser sponsorUserRequest;
  bool changeHappened = false;

  ProfileModel() {
    sponsorUserRequest = new sponsorUserReq.SponsorUser();
    sponsorUserRequest.data = new sponsorUserReq.Data();
  }

  Future<userResponse.User> getUser() async {
    setState(ViewState.Busy);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String loginResponseStr = sharedPreferences.get(kPrefUser);
    if (loginResponseStr != null) {
      loginResponse = LoginResponse.fromJson(jsonDecode(loginResponseStr));
    }
    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
        api: 'UserGet',
        userUniversalKey: loginResponse.response.userPhoneNumber,
        userBrowserType: getAccountBrowserType(),
        language: loginResponse.response.data.userLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        applicationVersion: kVersion,
        commonApiLanguage: kApiLanguage,
        commonApiVersion: kAppVersion,
        applicationToken: kApplicationToken,
      ),
    );
    user = await profileService.getUser(loginRequest);
    setState(ViewState.Idle);
    return user;
  }

  updateUser(context) async {
    bool status;
    setState(ViewState.Busy);
    loginResponse = SharedPrefUtil.getCurrentUser();
    userRequest.User userReq = new userRequest.User(
        data: userRequest.Data(
            api: 'UserUpdate',
            userUniversalKey: loginResponse.response.userPhoneNumber,
            userPhoneCountry: user.response.userPhoneCountry,
            userAddress: user.response.data.userAddress,
            userBirthDay: user.response.data.userBirthDay,
            userCity: user.response.data.userCity,
            userCountry: user.response.data.userCountry,
            userEmail: user.response.data.userEMail,
            userFirstName: user.response.data.userFirstName,
            userGender: user.response.data.userGender,
            userLanguage: user.response.data.userLanguage,
            userLastName: user.response.data.userLastName,
            userPhoneNumber: user.response.userPhoneNumber,
            userZipCode: user.response.data.userZipCode,
            applicationToken: kApplicationToken,
            applicationVersion: kVersion,
            commonApiLanguage: loginResponse.response.data.userLanguage,
            commonApiVersion: kAppVersion));
    LoginResponse response = await profileService.updateUser(userReq);
    if (response.response.errorNumber == '0') {
      successMessage = AppLocalizations.of(context).translate('user_updated_successfully');
      status = true;
    } else {
      errorMessage = response.response.message;
      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

  Future<bool> sponsorUser() async {
    bool status = false;
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    sponsorUserRequest.data.api = 'UserSponsor';
    sponsorUserRequest.data.commonApiLanguage = kApiLanguage;
    sponsorUserRequest.data.commonApiVersion = kAppVersion;
    sponsorUserRequest.data.userCountry = loginResponse.response.data.userCountry;
    sponsorUserRequest.data.userLanguage = loginResponse.response.data.userLanguage;
    sponsorUserRequest.data.sponsorPhoneNumber = loginResponse.response.userPhoneNumber;
    sponsorUserRequest.data.sponsorPhoneCountry = loginResponse.response.data.userCountry;
    sponsorUserRequest.data.userPhoneCountry = kApiLanguage;
    sponsorUserRequest.data.commonApplicationVersion = kVersion;
    sponsorUserRequest.data.commonApplicationToken = kApplicationToken;

    print(sponsorUserRequest.toJson());

    LoginResponse response = await profileService.sponsorUser(sponsorUserRequest);

    if (response.response.errorNumber == '0') {
      successMessage =
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('user_added_successfully');
      status = true;
    } else {
      // TODO add function to get readable user message
      errorMessage = response.response.message;
      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }
}
