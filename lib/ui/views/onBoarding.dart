import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:mobiwoom/ui/views/login/login_view.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:flutter/foundation.dart';


class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoarding> {
  final pages = [
    PageViewModel(
        pageColor: Colors.redAccent,
        iconImageAssetPath: 'assets/png/key.png',
      //  bubble: Image.asset('assets/img1.jpg'),
        body: Text(
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('introText1'),
        ),
        title: Text(
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('introTitle1'),
        ),
        titleTextStyle: TextStyle(fontFamily: 'RobotoCondensed', color: Colors.white),
        bodyTextStyle: TextStyle(fontFamily: 'RobotoCondensed', color: Colors.white),
        mainImage: Image.asset(
          'assets/img1.png',
          height: 300.0,
          width: 300.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: Colors.teal,
      iconImageAssetPath: 'assets/png/wallet.png',
      body: Text(
        AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('introText2'),
      ),
      title: Text(
        AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('introTitle2'),
      ),
      mainImage: Image.asset(
        'assets/img2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'RobotoCondensed', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'RobotoCondensed', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Colors.lightBlue,
      iconImageAssetPath: 'assets/png/banks.png',
      body: Text(
        AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('introText3'),
      ),
      title: Text(
        AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('introTitle3'),
      ),
      mainImage: Image.asset(
        'assets/img3.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'RobotoCondensed', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'RobotoCondensed', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Colors.purple,
      iconImageAssetPath: 'assets/png/shopping_cart.png',
      body: Text(
        AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('introText4'),
      ),
      title: Text(
        AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('introTitle4'),
      ),
      mainImage: Image.asset(
        'assets/img4.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'RobotoCondensed', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'RobotoCondensed', color: Colors.white),
    ),
    PageViewModel(
      pageColor: Colors.indigo,
      iconImageAssetPath: 'assets/png/hotels.png',
      body: Text(
        AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('introText5'),
      ),
      title: Text(
        AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('introTitle5'),
      ),
      mainImage: Image.asset(
        'assets/img5.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'RobotoCondensed', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'RobotoCondensed', color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    BuildContext LastContext = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName, //title of app
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), //ThemeData
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showNextButton: kIsWeb ? true : false,
          showSkipButton: false,
          doneButtonPersist: false,
          skipText: Text(AppLocalizations.of(LastContext).translate('skip')),
          nextText: Text(AppLocalizations.of(LastContext).translate('next')),
          doneText:Text(AppLocalizations.of(LastContext).translate('ok')),
          onTapDoneButton: () {
            Navigator.of(LastContext).push(
              MaterialPageRoute(builder: (_) => LoginView()),
            );
          },
          pageButtonTextStyles: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ), //IntroViewsFlutter
      ), //Builder
    ); //Material App
  }

}