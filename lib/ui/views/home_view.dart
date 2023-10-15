import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/home_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/main.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/navigation_util.dart';
import 'package:mobiwoom/ui/views/account/profile_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Timer timer;
  BuildContext mContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerAndToolbar>(
      builder: (context, indexData, _) {
        print("Index =  " + indexData.currentIndex.toString());
        mContext = context;
        if (!kIsWeb && !SharedPrefUtil.isFingerprintSetupDone() && !fingerprintSetupPermissionAsked) {
          HomeModel model = locator<HomeModel>();
          fingerprintSetupPermissionAsked = true;
          model.isBiometricAvailable().then((value) {
            if (value) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context).translate('fingerprint_login_heading')),
                      content: Text(AppLocalizations.of(context).translate('fingerprint_login_message')),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            model.authenticateUsingBiometric().then((value) async {
                              if (value) {
                                //Auth success
                                SharedPrefUtil.setFingerprintSetup();
                                await SharedPrefUtil.setFingerPrintPassword(await SharedPrefUtil.getUserPincode());
                                await SharedPrefUtil.setFingerPrintUsername(SharedPrefUtil.getUserPhone());
                                BotToast.showText(
                                    contentPadding: EdgeInsets.all(16),
                                    contentColor: Colors.greenAccent,
                                    duration: Duration(seconds: 4),
                                    text: AppLocalizations.of(mContext).translate('biometric_setup_success')
                                    //    text: 'success'
                                    );
                              } else {
                                BotToast.showText(
                                  contentPadding: EdgeInsets.all(16),
                                  // animationDuration: Duration(seconds: 2),
                                  duration: Duration(seconds: 4),
                                  contentColor: Colors.redAccent,
                                  text: AppLocalizations.of(context).translate('biometric_failed'),
                                );
                              }
                            });
                          },
                          child: Text(AppLocalizations.of(context).translate('yes')),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            BotToast.showText(
                              contentPadding: EdgeInsets.all(16),
                              // animationDuration: Duration(seconds: 2),
                              duration: Duration(seconds: 4),
                              contentColor: Colors.redAccent,
                              text: AppLocalizations.of(context).translate('biometric_failed'),
                            );
                          },
                          child: Text(AppLocalizations.of(context).translate('no')),
                        )
                      ],
                    );
                  });
            }
          });
        }
        return Consumer<ActivityMonitor>(
          builder: (BuildContext context1, ActivityMonitor value, Widget child) {
            print("Activity happened ${value.activityHappened}");
            if (value.activityHappened) {
              endTimer();
              startTimer(context, value);
              print("Ask confirmation");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                askConfirmationToLogOut(context, value);
              });
            }
            if (indexData.currentIndex == kProfileScreen) {
              ProfileView profileView = (kScreen[indexData.currentIndex] as ProfileView);
              profileView.setIsIndependent(false);
              kScreen[indexData.currentIndex] = profileView;
            }

            return kScreen[indexData.currentIndex];
          },
        );
      },
    );
  }

  askConfirmationToLogOut(BuildContext context, ActivityMonitor value) {
    print("Show Dialog");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).translate('logout')),
            content: Text(AppLocalizations.of(context).translate('confirm_stay_logged_in')),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  endTimer();
                  Navigator.pop(context);
                  logoutUser(context: context, value: value);
                },
                child: Text(AppLocalizations.of(context).translate('no')),
              ),
              FlatButton(
                onPressed: () async {
                  endTimer();
                  if (value != null) {
                    value.activityHappened = false;
                  }
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context).translate('yes')),
              ),
            ],
          );
        });
    print("Dialog Shown");
  }

  startTimer(BuildContext context, ActivityMonitor value) async {
  //  print("startTimer");
    timer = Timer(Duration(seconds: 30), () async {
      print("timerReached");
      logoutUser(context: context, value: value);
    });
  }

  endTimer() {
  //  print("End timer");
    if (timer != null) {
      timer.cancel();
    }
  }
}
