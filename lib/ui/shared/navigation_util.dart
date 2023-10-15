import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/views/account/change_pin_view.dart';
import 'package:mobiwoom/ui/views/account/contactless_card_view.dart';
import 'package:mobiwoom/ui/views/account/license_plates_view.dart';
import 'package:mobiwoom/ui/views/account/profile_view.dart';
import 'package:mobiwoom/ui/views/account/transactions_history.dart';
import 'package:mobiwoom/ui/views/account/saved_card_view.dart';
import 'package:mobiwoom/ui/views/cashbacks/add_cashback_view.dart';
import 'package:mobiwoom/ui/views/cashbacks/cashback_view.dart';
import 'package:mobiwoom/ui/views/cashbacks/offer_cashback_view.dart';
import 'package:mobiwoom/ui/views/contact_us_view.dart';
import 'package:mobiwoom/ui/views/notification_view.dart';
import 'package:mobiwoom/ui/views/partners/partners_map_view.dart';
import 'package:mobiwoom/ui/views/partners/partners_view.dart';
import 'package:mobiwoom/ui/views/services/parking_view.dart';
import 'package:mobiwoom/ui/views/services/taxi_check_view.dart';
import 'package:mobiwoom/ui/views/sponsorship/sponsorships.dart';
import 'package:mobiwoom/ui/views/services/parking_map_view.dart';

List<Widget> kScreen = [
  locator<NotificationView>(),
  locator<ProfileView>(),
  locator<SavedCardView>(),
  locator<ContactLessCardView>(),
  locator<LicencePlateView>(),
  locator<ChangePinView>(),
  locator<ParkingView>(),
  locator<TaxiCheckView>(),
  locator<PartnersListView>(),
  locator<PartnersMapView>(),
  locator<CashBackView>(),
  locator<AddCashBackView>(),
  locator<OfferCashBackView>(),
  locator<SponsorshipView>(),
  locator<ContactUsView>(),
  locator<ParkingMapView>(),
  locator<TransactionsHistoryView>(),
];
List<String> kScreenTitle = [
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('news'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('profile'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('saved_cards'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('active_hello_cards'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('license_plates'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('change_pin'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('parking'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('offer_taxi_check'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('partners_list'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('partners_map'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('current_transactions'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('add_a_cashback'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('offer_a_cashback'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('sponsorships'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('contact_us'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('parking_map'),
  AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('my_history'),
];

int kNewsScreen = 0;
int kProfileScreen = 1;
int kSavedCardScreen = 2;
int kContactLessCardsScreen = 3;
int kLicensePlatesScreen = 4;
int kChangePinScreen = 5;
int kParkingScreen = 6;
int kTaxiCheckScreen = 7;
int kPartnersListScreen = 8;
int kPartnersMapScreen = 9;
int kCashBackAndCouponScreen = 10;
int kAddCashBackScreen = 11;
int kOfferCashBackScreen = 12;
int kSponsorshipScreen = 13;
int kContactUsScreen = 14;
int kParkingMap = 15;
int kTransacHistory = 16;