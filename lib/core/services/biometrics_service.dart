import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/localization.dart';

class BioMetricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    List<BiometricType> availableBiometrics;
    try {
      if (kIsWeb) {
        return false;
      }
      availableBiometrics = await auth.getAvailableBiometrics();
      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
          return availableBiometrics.contains(BiometricType.face);
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
          return availableBiometrics.contains(BiometricType.fingerprint);
        }
      } else
        return availableBiometrics.indexOf(BiometricType.fingerprint) != -1;
    } on PlatformException catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> authenticate() async {
    IOSAuthMessages iosStrings = IOSAuthMessages(
        cancelButton: AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('cancel'),
        goToSettingsButton:
            AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('settings'),
        goToSettingsDescription:
            AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('setup_touch_id'),
        lockOut:
            AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('reenable_touch_id'));

    AndroidAuthMessages androidStrings = AndroidAuthMessages(
      cancelButton: AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('cancel'),
      goToSettingsButton: AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('settings'),
      signInTitle: AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('sign_in_title'),
      goToSettingsDescription: AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('setup_fingerprint_message'),
    );

    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason:
              AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('scan_to_authenticate'),
          useErrorDialogs: true,
          stickyAuth: true,
          androidAuthStrings: androidStrings,
          iOSAuthStrings: iosStrings);
    } on PlatformException catch (e) {
      print(e);
    }
    return authenticated;
  }
}
