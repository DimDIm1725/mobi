import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
//import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobiwoom/app_language.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/constants.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/firebase_messaging.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/router.dart' as r;
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/models/drawer_toolbar.dart';
import 'ui/shared/app_theme.dart';
import 'ui/shared/localization.dart';

LoginResponse loginResponseMain;
bool turningGPSONPermissionGiven = true;
bool fingerprintSetupPermissionAsked = false;
bool locationPermissionAsked = false;
String kFirstLaunch = '';
Position locationData;
//firebase.App firebaseApp;

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//  print("onlaunch myBackgroundMessageHandler");
  showMessage(message);
  // Or do other work.
}

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPrefUtil =
      await SharedPrefUtil.initializeSharedPreferenceUtil();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  // print('locale start = ' + appLanguage.appLocal.toString());
  int launchCount = SharedPrefUtil.getAppCounter() ?? 0;
  SharedPrefUtil.setAppCounter(launchCount + 1);

  locationData = await getCurrentLocation();
  print('loc' + locationData.toString());
  if (locationData != null) {
    kGpsEnabled = true;
    print('gps' + kGpsEnabled.toString());
  }
  //kGpsEnabled = locationData != null;
  print('gps2' + kGpsEnabled.toString());

  if (kGpsEnabled) {
    SharedPrefUtil.setLatLocationData(locationData.latitude);
    SharedPrefUtil.setLonLocationData(locationData.longitude);
  }

  if (launchCount == 0) {
    kFirstLaunch = 'onBoarding';
  } else {
    kFirstLaunch = 'login';
  }

  String loginResponseStr = sharedPrefUtil.get(kPrefUser);
  if (loginResponseStr != null) {
    await logoutUser();
  }
  runApp(MyApp(appLanguage: appLanguage));
}

class MyApp extends StatefulWidget {
  final AppLanguage appLanguage;

  MyApp({
    this.appLanguage,
  });

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Timer timer;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FBMessaging _messaging;

  _register() async {
    if (kIsWeb) {
      initializeFirebaseForWeb();
      _messaging = FBMessaging.instance;
      bool perm = await _messaging.requestPermission();
      if (perm) {
        _messaging.getToken().then((value) {
          print("FCM TOKEN $value");
          SharedPrefUtil.setFCMToken(value);
        });
      } else {
        print("FCM TOKEN refused");
      }
    } else {
      intializeFirebase();
      _firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(
              sound: true, badge: true, alert: true, provisional: true));
      _firebaseMessaging.getToken().then((token) {
        SharedPrefUtil.setFCMToken(token);
      });
    }
  }

  @override
  void initState() {
    // kFirstLaunch = setValue().toString();
    _register();
    _configureFirebaseMessaging();
    super.initState();
    getAppInfo();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: ChangeNotifierProvider<DrawerAndToolbar>(
        create: (_) => DrawerAndToolbar(),
        child: ChangeNotifierProvider<AppLanguage>(
          create: (BuildContext context) {
            return widget.appLanguage;
          },
          child: Consumer<AppLanguage>(
            builder:
                (BuildContext context, AppLanguage appLanguage, Widget child) {
              //  print('notified ${appLanguage.appLocal}');
              return ChangeNotifierProvider<ActivityMonitor>(
                create: (BuildContext context) {
                  return ActivityMonitor();
                },
                child: Consumer<ActivityMonitor>(
                  builder: (BuildContext context, ActivityMonitor value,
                      Widget child) {
                    return Listener(
                      onPointerDown: (event) {
                        endTimer();
                        startTimer(value);
                      },
                      child: MaterialApp(
                          title: 'BonjourCard',
                          navigatorObservers: [BotToastNavigatorObserver()],
                          navigatorKey: locator<Application>().navigatorKey,
                          theme: ThemeData(
                            fontFamily: 'RobotoCondensed',
                            primarySwatch: MobiTheme.primarySwatch,
                            scaffoldBackgroundColor: MobiTheme.colorPrimary,
                            primaryIconTheme: Theme.of(context)
                                .primaryIconTheme
                                .copyWith(color: Colors.white),
                            primaryColor: MobiTheme.colorCompanion,
                            accentColor: MobiTheme.colorCompanion,
                            // unselectedWidgetColor:Colors.white,
                            accentIconTheme: Theme.of(context)
                                .accentIconTheme
                                .copyWith(color: Colors.white),
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                            appBarTheme: AppBarTheme(
                              // color: Theme.of(context).scaffoldBackgroundColor,
                              elevation: 0,
                              brightness: Brightness.dark,
                              // iconTheme: IconThemeData(color: Colors.black),
                              textTheme: Theme.of(context).textTheme.copyWith(
                                  headline6: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: Colors.white)),
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              labelStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: null,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                              helperStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: null,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: null,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                              errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: null,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                              errorMaxLines: null,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: false,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              isCollapsed: false,
                              prefixStyle: TextStyle(
                                color: Color(0xdd000000),
                                fontSize: null,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                              suffixStyle: TextStyle(
                                color: Color(0xdd000000),
                                fontSize: null,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                              counterStyle: TextStyle(
                                color: Color(0xdd000000),
                                fontSize: null,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                              filled: true,
                              fillColor: MobiTheme.colorBackground,
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MobiTheme.borderColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade700, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MobiTheme.borderColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: MobiTheme.borderColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                            ),
                            floatingActionButtonTheme:
                                FloatingActionButtonThemeData(
                              foregroundColor: Colors.white,
                            ),
                          ),
                          supportedLocales: [
                            Locale('fr', 'FR'),
                            Locale('en', 'US'),
                            Locale('fr', 'LU'),
                            Locale('de', 'DE'),
                            Locale('en', 'GB'),
                            Locale('be', 'BE'),
                          ],
                          locale: appLanguage.appLocal,
                          localizationsDelegates: [
                            AppLocalizations.delegate,
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                          ],
                          onGenerateRoute: r.Router.generateRoute,
                          initialRoute: kFirstLaunch),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  startTimer(ActivityMonitor value) async {
    //  print("startTimer");
    timer = Timer(Duration(minutes: 10), () async {
      print("timerReached - No Action");
      value.setActivityHappened();
    });
  }

  endTimer() {
    //  print("End timer");
    if (timer != null) {
      timer.cancel();
    }
  }

  void _configureFirebaseMessaging() {
    if (kIsWeb) {
      _messaging.stream.listen((event) {
        print(event);
        print("Message came");
        showMessage(event);
      });
    } else {
      _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            print('on message $message');
            showMessage(message);
            // setState(() => _message = message["notification"]["title"]);
          },
          onResume: (Map<String, dynamic> message) async {
            print('on resume $message');
            showMessage(message);
            // setState(() => _message = message["notification"]["title"]);
          },
          onLaunch: (Map<String, dynamic> message) async {
            print('on launch $message');
            Future.delayed(const Duration(seconds: 2), () {
              showMessage(message);
            });

            // setState(() => _message = message["notification"]["title"]);
          },
          onBackgroundMessage:
              Platform.isIOS ? null : myBackgroundMessageHandler);
    }
  }

  Future<void> initializeFirebaseForWeb() async {
    /*   if (firebase.apps.length > 0) {
       firebaseApp = firebase.apps[0];
     } else {
       firebaseApp = firebase.initializeApp(
           apiKey: kApiKey,
           authDomain: kAuthDomain,
           databaseURL: kDatabaseURL,
           projectId: kProjectId,
           storageBucket: kStorageBucket,
           messagingSenderId: kMessagingSenderId,
           appId: kAppId,
           measurementId: kMeasurementId);
     }*/
  }

  Future<void> intializeFirebase() async {
    if (Firebase.apps.length > 0) {
      app = Firebase.apps[0];
    } else {
      app = await Firebase.initializeApp(options: firebaseOptions);
    }
  }
}

showMessage(Map<String, dynamic> message) {
  String title = "";
  String body = "";
  if (message["title"] != null && message["body"] != null) {
    title = message["title"];
    body = message["body"];
  } else if (message["notification"]["title"] != null &&
      message["notification"]["body"] != null) {
    title = message["notification"]["title"];
    body = message["notification"]["body"];
  } else if (message["data"]["title"] != null &&
      message["data"]["body"] != null) {
    title = message["data"]["title"];
    body = message["data"]["body"];
  } else if (message["data"]["newtitle"] != null &&
      message["data"]["newbody"] != null) {
    title = message["data"]["newtitle"];
    body = message["data"]["newbody"];
  }

  if (title.isNotEmpty && body.isNotEmpty) {
    showDialog(
        context: locator<Application>().navigatorKey.currentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("ok", style: TextStyle(fontSize: 20.0)),
              )
            ],
          );
        });
  }
}

class ActivityMonitor with ChangeNotifier {
  bool activityHappened = false;

  void setActivityHappened() {
    activityHappened = true;
    notifyListeners();
  }
}
