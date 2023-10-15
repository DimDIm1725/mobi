import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/models/responses/partner.dart' as partnerRes;
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/views/account/3d_secure_bank_view.dart';
//import 'package:mobiwoom/ui/views/account/add_card_view.dart';
import 'package:mobiwoom/ui/views/account/add_license_view.dart';
import 'package:mobiwoom/ui/views/account/profile_view.dart';
import 'package:mobiwoom/ui/views/home_view.dart';
import 'package:mobiwoom/ui/views/login/enter_email_view.dart';
import 'package:mobiwoom/ui/views/login/login_view.dart';
import 'package:mobiwoom/ui/views/login/lost_pincode_view.dart';
import 'package:mobiwoom/ui/views/login/tcu_view.dart';
import 'package:mobiwoom/ui/views/partners/partner_detail_view.dart';
import 'package:mobiwoom/ui/views/onBoarding.dart';
import 'package:mobiwoom/ui/views/services/parking_map_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeView());
      case 'onBoarding':
        return MaterialPageRoute(builder: (_) => OnBoarding());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginView());
   //   case 'addCard':
    //    return MaterialPageRoute(builder: (_) => locator<AddCardView>());
      case 'addLicense':
        return MaterialPageRoute(builder: (_) => locator<AddLicenseView>());
      case ThreeDSecureBankView.routeName:
        return MaterialPageRoute(builder: (_) => locator<ThreeDSecureBankView>());
      case LostPincodeScreen.routeName:
        return MaterialPageRoute(builder: (_) => locator<LostPincodeScreen>());
      case ParkingMapView.routeName:
        return MaterialPageRoute(builder: (_) => locator<ParkingMapView>());
      case EnterEmailScreen.routeName:
        LoginResponse loginResponse = settings.arguments;
        EnterEmailScreen emailScreen = locator<EnterEmailScreen>();
        emailScreen.setUser(loginResponse);
        return MaterialPageRoute(builder: (_) => emailScreen);
      case ProfileView.routeName:
        bool isIndependent = settings.arguments;
        ProfileView profileView = locator<ProfileView>();
        profileView.setIsIndependent(isIndependent);
        return MaterialPageRoute(builder: (_) => locator<ProfileView>());

      case TermsAndConditionsScreen.routeName:
        LoginResponse loginResponse = settings.arguments;
        TermsAndConditionsScreen termsAndConditionsScreen = locator<TermsAndConditionsScreen>();
        termsAndConditionsScreen.setUser(loginResponse);
        return MaterialPageRoute(builder: (_) => termsAndConditionsScreen);
      case PartnerDetailView.routeName:
        partnerRes.Row partnerDetail = settings.arguments;
        PartnerDetailView partnerDetailView = locator<PartnerDetailView>();
        partnerDetailView.setPartnerDetail(partnerDetail);
        return MaterialPageRoute(builder: (_) => partnerDetailView);
      default:
        return MaterialPageRoute(builder: (_) => LoginView());
      /*   return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });*/
    }
  }
}
