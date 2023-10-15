import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/main.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

Future<String> getAppVersion() async {
  if (kIsWeb) {
    return "web";
  } else {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}

void getAppInfo() async {
  if (kIsWeb) {
    kVersion = "7.0.0";
  } else {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    kVersion = packageInfo.version;
    kAppID = packageInfo.buildNumber;
  }
}

isLargeScreen(context) {
  return kIsWeb && MediaQuery.of(context).size.width > 800;
}

double getLargeScreenWidth(context) {
  return MediaQuery.of(context).size.width * 0.5;
}

//Future<LoginResponse> SharedPrefUtil.getCurrentUser() async {
//  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//  String loginResponseStr = sharedPreferences.get(kPrefUser);
//  if (loginResponseStr != null) {
//    return LoginResponse.fromJson(jsonDecode(loginResponseStr));
//  } else {
//    return null;
//  }
//}

/*String getCommonApiVersion() {
  return '5.0';
}*/

String getAccountBrowserType() {
  return kIsWeb ? "Desktop" : "Mobile";
}

String getProcessToken() {
  String processToken = SharedPrefUtil.getProcessToken();
  print("getProcessToken $processToken");
  var random = new Random();
  double db = random.nextDouble() * 9999999999999;
  return processToken ?? db.round().toString();
}

void setProcessToken(String processToken) {
  print("setProcessToken $processToken");
  if (processToken != null && processToken.isNotEmpty) {
    SharedPrefUtil.setProcessToken(processToken);
  }
}

Future<void> clearCache() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove(kPrefUserPinCode);
  sharedPreferences.remove(kPrefUser);
}

Future<Position> getCurrentLocation() async {
  bool _serviceEnabled;
  LocationPermission permission;
  Position _locationData;
  kGpstest = false;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      /* if (turningGPSONPermissionGiven) {
      permission = await Geolocator.requestPermission();
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        turningGPSONPermissionGiven = false;
        return null;
      }
    } else {*/
      return null;
      // }
    }

    permission = await Geolocator.checkPermission();
    /* if (permission == LocationPermission.deniedForever) {
    return null;
  }*/
  if (!kIsWeb) {
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return null;
      }
    }
  }

    // TODO Patch before to update to geolocator 7.0
    await Geolocator.getCurrentPosition().then((value) {
      _locationData = value;
      kGpsEnabled = true;;
    }).catchError((e) {});

    if (_locationData != null) {
      return _locationData;
    } else {
      return null;
    }

//  kGpsEnabled = _locationData != null;
 //print('location = ' + _locationData.toString());
 // return _locationData;
}

void showErrorMessage(String message) {
  BotToast.showText(
      //   animationDuration: Duration(seconds: 2),
      duration: Duration(seconds: 4),
      contentColor: Colors.redAccent,
      text: message);
}

void showSuccessMessage(String message) {
  BotToast.showText(
      //  animationDuration: Duration(seconds: 2),
      duration: Duration(seconds: 4),
      contentColor: Colors.greenAccent,
      text: message);
}

logoutUser({BuildContext context, ActivityMonitor value}) async {
  SharedPrefUtil.clearSharedPrefsAndRetainSomeValues();
  if (context != null) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      'login',
      (Route<dynamic> route) => false,
    );
  }

  if (value != null) {
    value.activityHappened = false;
  }
}
