import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/models/responses/payline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static SharedPreferences _sp;
  static const String _KEY_USERNAME = "username";
  static const String _KEY_USER_PINCODE = "userPincode";
  static const String _KEY_PAYLINE_DATA = "paylineData";
  static const String _KEY_USER = "User";
  static const String _KEY_PROCESS_TOKEN = "Token";
  static const String _FCM_TOKEN = "FCMTOKEN";
  static const String _FINGERPRINT = "fingerprint";
  static const String _FINGERPRINT_USERNAME = "fingerprintUsername";
  static const String _FINGERPRINT_PASSWORD = "fingerprintPassword";
  static const String _USER_LANGUAGE = "_languageCode";
  static const String _USER_COUNTRYCODE = "_countryCode";
  static const String _LAUNCH_COUNTER = "_counter";
  static const String _LAT_DATA = "_lat_locationData";
  static const String _LON_DATA = "_lon_locationData";

  static initializeSharedPreferenceUtil() async {
    _sp = await SharedPreferences.getInstance();
    return _sp;
  }

  static void setLatLocationData(double lat) {
    _sp.setDouble(_LAT_DATA, lat);
  }

  static double getLatLocationData() {
    return _sp.getDouble(_LAT_DATA);
  }

  static void setLonLocationData(double lon) {
    _sp.setDouble(_LON_DATA, lon);
  }

  static double getLonLocationData() {
    return _sp.getDouble(_LON_DATA);
  }

  static void setAppCounter(int counter) {
    _sp.setInt(_LAUNCH_COUNTER, counter);
  }

  static int getAppCounter() {
    return _sp.getInt(_LAUNCH_COUNTER);
  }

  static void setUserLanguage(String language) {
    _sp.setString(_USER_LANGUAGE, language);
  }

  static String getUserLanguage() {
    return _sp.getString(_USER_LANGUAGE) == null ? "fr" : _sp.getString(_USER_LANGUAGE);
  }

  static void setUserCountryCode(String language) {
    _sp.setString(_USER_COUNTRYCODE, language);
  }

  static String getUserCountryCode() {
    return _sp.getString(_USER_COUNTRYCODE) == null ? "FR" : _sp.getString(_USER_COUNTRYCODE);
  }

  static void setUserPhone(String phone) {
    _sp.setString(_KEY_USERNAME, phone);
  }

  static String getUserPhone() {
    return _sp.getString(_KEY_USERNAME);
  }

  static LoginResponse getCurrentUser() {
    if (_sp.getString(_KEY_USER) == null) {
      return null;
    }
    return LoginResponse.fromJson(jsonDecode(_sp.getString(_KEY_USER)));
  }

  static void setCurrentUser(LoginResponse user) {
    _sp.setString(_KEY_USER, user != null ? user.toJSONString() : null);
  }

  static String getProcessToken() {
    return _sp.getString(_KEY_PROCESS_TOKEN);
  }

  static void setProcessToken(String processToken) {
    _sp.setString(_KEY_PROCESS_TOKEN, processToken);
  }

  static void setFCMToken(String token) {
    _sp.setString(_FCM_TOKEN, token);
  }

  static String getFCMToken() {
    return _sp.getString(_FCM_TOKEN);
  }

  static bool isFingerprintSetupDone() {
    return _sp.getBool(_FINGERPRINT) ?? false;
  }

  static void setFingerprintSetup() {
    _sp.setBool(_FINGERPRINT, true);
  }

  static String getFingerPrintUsername() {
    return _sp.getString(_FINGERPRINT_USERNAME);
  }

  static void setFingerPrintUsername(String username) {
    _sp.setString(_FINGERPRINT_USERNAME, username);
  }

  static Future<String> getFingerPassword() async {
    final storage = FlutterSecureStorage();
    String userPincode = await storage.read(key: _FINGERPRINT_PASSWORD);
    return userPincode;
  }

  static void setFingerPrintPassword(String pincode) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: _FINGERPRINT_PASSWORD, value: pincode);
  }

  static Future<String> getUserPincode() async {
    if (kIsWeb) {
      return _sp.getString(_KEY_USER_PINCODE);
    } else {
      final storage = FlutterSecureStorage();
      String userPincode = await storage.read(key: _KEY_USER_PINCODE);
      return userPincode;
    }
  }

  static Future<void> removeUserPincode() async {
    if (kIsWeb) {
      return _sp.remove(_KEY_USER_PINCODE);
    } else {
      final storage = FlutterSecureStorage();
      await storage.delete(key: _KEY_USER_PINCODE);
    }
  }

  static Future<void> setUserPincode(String pincode) async {
    if (kIsWeb) {
      await _sp.setString(_KEY_USER_PINCODE, pincode);
    } else {
      final storage = FlutterSecureStorage();
      await storage.write(key: _KEY_USER_PINCODE, value: pincode);
    }
  }

  static void clearSharedPrefsAndRetainSomeValues() {
   // print('clearSharedPrefsAndRetainSomeValues');
    String phoneNumber = getUserPhone();
    String countryCode = getUserCountryCode();
    bool isFingerPrintSetupDone = isFingerprintSetupDone();
    removeUserPincode();
    removePaylineData();
    //   _sp.clear();
    setUserPhone(phoneNumber);
    setUserCountryCode(countryCode);
    isFingerPrintSetupDone ? setFingerprintSetup() : null;
  }

  static Future<void> setPaylineData(PaylineData paylineData) async {
    if (kIsWeb) {
      await _sp.setString(_KEY_PAYLINE_DATA, paylineData.toJSONString());
    } else {
      final storage = FlutterSecureStorage();
      await storage.write(key: _KEY_PAYLINE_DATA, value: paylineData.toJSONString());
    }
  }

  static Future<PaylineData> getPaylineData() async {
    if (kIsWeb) {
      return PaylineData.fromJson(jsonDecode(_sp.getString(_KEY_PAYLINE_DATA)));
    } else {
      final storage = FlutterSecureStorage();
   //   print(await storage.read(key: _KEY_PAYLINE_DATA));
   //   print(jsonDecode(await storage.read(key: _KEY_PAYLINE_DATA)));
      return PaylineData.fromJson(jsonDecode(await storage.read(key: _KEY_PAYLINE_DATA)));
    }
  }

  static Future<void> removePaylineData() async {
    if (kIsWeb) {
      return _sp.remove(_KEY_PAYLINE_DATA);
    } else {
      final storage = FlutterSecureStorage();
      await storage.delete(key: _KEY_PAYLINE_DATA);
    }
  }
}
