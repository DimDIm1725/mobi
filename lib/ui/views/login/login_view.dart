import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/app_language.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/login_model.dart';
import 'package:mobiwoom/firebase_messaging.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/navigation_util.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/views/login/enter_email_view.dart';
import 'package:mobiwoom/ui/views/login/lost_pincode_view.dart';
import 'package:mobiwoom/ui/views/login/tcu_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:mobiwoom/ui/widgets/ibackground4.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';
import 'package:mobiwoom/ui/widgets/iinputField2Password.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/utils.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var windowWidth = MediaQuery.of(context).size.width;
    return BaseView<LoginModel>(
      onModelReady: (model) {},
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: MobiTheme.colorPrimary),
              // child:IBackground4(
              //     width: windowWidth, colorsGradient: MobiTheme.colorsGradient, color:MobiTheme.colorPrimary),
            ),
            Center(
              child: Container(
                width: isLargeScreen(context)
                    ? getLargeScreenWidth(context)
                    : screenSize.width,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[LoginForm()]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  LoginModel model;

  @override
  void initState() {
    super.initState();
    phoneNumberController.text = SharedPrefUtil.getUserPhone();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (model != null && SharedPrefUtil.isFingerprintSetupDone()) {
        loginUsingFingerPrint(model);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      onModelReady: (model) {
        this.model = model;
        model.state == ViewState.Busy
            ? BotToast.showLoading()
            : BotToast.closeAllLoading();
      },
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Image(image: AssetImage('images/logo.png')),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 3,
                      child: CountryCodePicker(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                        onChanged: (value) async {
                          var appLanguage =
                              Provider.of<AppLanguage>(context, listen: false);
                          await appLanguage
                              .changeLanguage(Locale(value.code.toLowerCase()));
                        },
                        initialSelection: SharedPrefUtil.getUserCountryCode(),
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        showFlagMain: false,
                        alignLeft: false,
                        dialogSize: Size(280.0, 280.0),
                        boxDecoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(24)),
                        textStyle: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                        hideMainText: false,
                        countryFilter: ['BE', 'FR', 'LU', 'DE', 'GB'],
                        hideSearch: true,
                      ),
                    ),
                    Flexible(
                      flex: 9,
                      child: IInputField2(
                        hint: AppLocalizations.of(context)
                            .translate('hint_username'),
                        icon: Icons.phone,
                        colorIcon: MobiTheme.colorIcon,
                        type: TextInputType.phone,
                        colorDefaultText: Colors.white,
                        controller: phoneNumberController,
                        onChangeText: (value) {
                          SharedPrefUtil.setUserPhone(value);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                IInputField2Password(
                    hint:
                        AppLocalizations.of(context).translate('hint_password'),
                    icon: Icons.vpn_key,
                    colorDefaultText: Colors.white,
                    controller: pinCodeController,
                    colorIcon: MobiTheme.colorIcon,
                    type: TextInputType.number),
                SizedBox(height: 20),
                IButton3(
                  pressButton: () async {
                    loginUser(model);
                  },
                  text: AppLocalizations.of(context).translate('sign_in'),
                  color: MobiTheme.colorCompanion,
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                InkWell(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                      phoneNumberController.text =
                          SharedPrefUtil.getUserPhone();
                      setState(() {});
                    }, // needed
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
                      child: Text(
                          AppLocalizations.of(context).translate(
                              'login_view_register'), // ""Don't have an account? Create",",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    )),
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, LostPincodeScreen.routeName);
                    }, // needed
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 0),
                      child: Text(
                          AppLocalizations.of(context).translate(
                              'lost_pincode'), // ""Don't have an account? Create",",
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  loginUsingFingerPrint(LoginModel model) async {
    model.authenticateUsingBiometric().then((value) async {
      if (value) {
        //Auth success
        SharedPrefUtil.getFingerPassword().then((password) {
          phoneNumberController.text = SharedPrefUtil.getFingerPrintUsername();
          pinCodeController.text = password;
          loginUser(model, withBiometric: true);
        });
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
  }

  Future<void> loginUser(LoginModel model, {bool withBiometric = false}) async {
    BotToast.showLoading();
    String token = "";
    if (kIsWeb) {
      token = await askPermissionAndGetAccessToken();
    } else {
      token = await FirebaseMessaging().getToken();
    }

    if (token != null) SharedPrefUtil.setFCMToken(token);
    bool response = await model.login(
      phoneNumberController.text,
      pinCodeController.text,
    );
    BotToast.closeAllLoading();
    print("Login status");
    print("response $response");
    if (response) {
      await SharedPrefUtil.setUserPincode(pinCodeController.text);
      if (withBiometric) {
        SharedPrefUtil.setFingerprintSetup();
        await SharedPrefUtil.setFingerPrintPassword(pinCodeController.text);
        await SharedPrefUtil.setFingerPrintUsername(phoneNumberController.text);
      }
      LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
      List versionServer = loginResponse.response.userVersion.split('.');
      print("versionServer $versionServer");
      List versionApp = kVersion.split('.');
      print("versionApp $versionApp");
      bool startDataResponse = await model.getApplicationStartData();
      if (!kIsWeb && int.parse(versionServer[0]) > int.parse(versionApp[0])) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context).translate('alert')),
                content: Text(
                    AppLocalizations.of(context).translate('updateRequired')),
                actions: [
                  FlatButton(
                    onPressed: () {
                      _launchUpdate();
                      SharedPrefUtil.setCurrentUser(null);
                      clearCache();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'login');
                    },
                    child: Text(AppLocalizations.of(context).translate('ok'),
                        style: TextStyle(fontSize: 20.0)),
                  )
                ],
              );
            });
      } else if (!kIsWeb &&
          int.parse(versionServer[0]) == int.parse(versionApp[0]) &&
          int.parse(versionServer[1]) > int.parse(versionApp[1])) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context).translate('alert')),
                content: Text(AppLocalizations.of(context).translate('update')),
                actions: [
                  FlatButton(
                    onPressed: () {
                      if (loginResponse.response.data.userSignature ==
                          'False') {
                        SharedPrefUtil.setCurrentUser(null);
                        Navigator.popAndPushNamed(
                          context,
                          TermsAndConditionsScreen.routeName,
                          arguments: loginResponse,
                        );
                      } else if (loginResponse.response.data.userEMail ==
                              null ||
                          loginResponse.response.data.userEMail.isEmpty) {
                        SharedPrefUtil.setCurrentUser(null);
                        Navigator.popAndPushNamed(
                          context,
                          EnterEmailScreen.routeName,
                          arguments: loginResponse,
                        );
                      } else {
                        if (int.parse(loginResponse
                                .response.data.userTicketMachinesCountInUse) >
                            0) {
                          Provider.of<DrawerAndToolbar>(context, listen: false)
                              .currentIndex = kParkingMap;
                          Navigator.popAndPushNamed(context, "/");
                        } else {
                          Provider.of<DrawerAndToolbar>(context, listen: false)
                              .currentIndex = kNewsScreen;
                          Navigator.popAndPushNamed(context, "/");
                        }
                      }
                    },
                    child: Text(AppLocalizations.of(context).translate('later'),
                        style: TextStyle(fontSize: 20.0)),
                  ),
                  FlatButton(
                    onPressed: () {
                      _launchUpdate();
                      SharedPrefUtil.setCurrentUser(null);
                      clearCache();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'login');
                    },
                    child: Text(AppLocalizations.of(context).translate('ok'),
                        style: TextStyle(fontSize: 20.0)),
                  )
                ],
              );
            });
      } else {
        if (loginResponse.response.data.userSignature == 'False') {
          SharedPrefUtil.setCurrentUser(null);
          Navigator.popAndPushNamed(
            context,
            TermsAndConditionsScreen.routeName,
            arguments: loginResponse,
          );
        } else if (loginResponse.response.data.userEMail == null ||
            loginResponse.response.data.userEMail.isEmpty) {
          SharedPrefUtil.setCurrentUser(null);
          Navigator.popAndPushNamed(
            context,
            EnterEmailScreen.routeName,
            arguments: loginResponse,
          );
        } else {
          if (int.parse(
                  loginResponse.response.data.userTicketMachinesCountInUse) >
              0) {
            Provider.of<DrawerAndToolbar>(context, listen: false).currentIndex =
                kParkingMap;
            Navigator.popAndPushNamed(context, "/");
          } else {
            Provider.of<DrawerAndToolbar>(context, listen: false).currentIndex =
                kNewsScreen;
            Navigator.popAndPushNamed(context, "/");
          }
        }
      }
    } else {
      pinCodeController.text = '';
      BotToast.showText(
        contentPadding: EdgeInsets.all(16),
        // animationDuration: Duration(seconds: 2),
        duration: Duration(seconds: 4),
        contentColor: Colors.redAccent,
        text: model.errorMessage,
      );
    }
  }
}

_launchUpdate() async {
  String url = '';
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/apps/details?id=com.mobiwoom.carte';
    } else if (Platform.isIOS) {
      url = 'https://apps.apple.com/us/app/carte-bonjour/id742161961';
    } else
      return null;
  }

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class FlagDropDown extends StatelessWidget {
  String countryCode, countryName;

  FlagDropDown({this.countryCode, this.countryName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Flag(
            countryCode,
            height: 30,
          ),
        ),
        // Expanded(
        //   child: SizedBox(
        //     width: 20,
        //   ),
        // ),
        // Expanded(
        //   child: Text(
        //     countryName,
        //     overflow: TextOverflow.visible,
        //     style: TextStyle(
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

Future<String> askPermissionAndGetAccessToken() async {
  FBMessaging _messaging = FBMessaging.instance;
  bool perm = await _messaging.requestPermission();
  if (perm) {
    _messaging.getToken().then((value) {
      print("FCM TOKEN $value");
      SharedPrefUtil.setFCMToken(value);
    });
    return _messaging.getToken();
  } else {
    print("FCM TOKEN refused");
    return null;
  }
  // return _messaging.getToken();
  // FCMService fcmService = FCMService();
  // await fcmService.requestPermissionAndGetToken();
}
