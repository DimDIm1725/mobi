import 'package:get_it/get_it.dart';
import 'package:mobiwoom/core/models/requests/taxi_check.dart';
import 'package:mobiwoom/core/models/requests/transfer_cashback.dart';
import 'package:mobiwoom/core/models/requests/user.dart' as userReq;
import 'package:mobiwoom/core/models/responses/add_cashback.dart';
import 'package:mobiwoom/core/models/responses/cashback.dart';
import 'package:mobiwoom/core/models/responses/transactions.dart';
import 'package:mobiwoom/core/models/responses/contact_less_card.dart';
import 'package:mobiwoom/core/models/user.dart';
import 'package:mobiwoom/core/services/api.dart';
//import 'package:mobiwoom/core/services/api_xml.dart';
import 'package:mobiwoom/core/services/authentication_service.dart';
import 'package:mobiwoom/core/services/biometrics_service.dart';
import 'package:mobiwoom/core/services/card_service.dart';
import 'package:mobiwoom/core/services/cashback_service.dart';
import 'package:mobiwoom/core/services/contactless_card_service.dart';
import 'package:mobiwoom/core/services/license_service.dart';
import 'package:mobiwoom/core/services/notification_repository.dart';
import 'package:mobiwoom/core/services/parking_service.dart';
import 'package:mobiwoom/core/services/partners_service.dart';
import 'package:mobiwoom/core/services/pincode_service.dart';
import 'package:mobiwoom/core/services/profile_service.dart';
import 'package:mobiwoom/core/services/taxi_check_service.dart';
import 'package:mobiwoom/core/services/transactions_service.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/viewmodels/card_model.dart';
import 'package:mobiwoom/core/viewmodels/cashback_model.dart';
import 'package:mobiwoom/core/viewmodels/contact_less_card_model.dart';
import 'package:mobiwoom/core/viewmodels/home_model.dart';
import 'package:mobiwoom/core/viewmodels/license_model.dart';
import 'package:mobiwoom/core/viewmodels/login_model.dart';
import 'package:mobiwoom/core/viewmodels/parking_model.dart';
import 'package:mobiwoom/core/viewmodels/partners_model.dart';
//import 'package:mobiwoom/core/viewmodels/transactions_history.dart';
import 'package:mobiwoom/core/viewmodels/pincode_model.dart';
import 'package:mobiwoom/core/viewmodels/profile_model.dart';
import 'package:mobiwoom/core/viewmodels/taxi_check_model.dart';
import 'package:mobiwoom/core/viewmodels/facebook_model.dart';
import 'package:mobiwoom/core/viewmodels/transactions_model.dart';
import 'package:mobiwoom/ui/views/account/3d_secure_bank_view.dart';
//import 'package:mobiwoom/ui/views/account/add_card_view.dart';
import 'package:mobiwoom/ui/views/account/add_license_view.dart';
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
import 'package:mobiwoom/ui/views/login/enter_email_view.dart';
import 'package:mobiwoom/ui/views/login/lost_pincode_view.dart';
import 'package:mobiwoom/ui/views/login/tcu_view.dart';
import 'package:mobiwoom/ui/views/notification_view.dart';
import 'package:mobiwoom/ui/views/partners/partner_detail_view.dart';
import 'package:mobiwoom/ui/views/partners/partners_map_view.dart';
import 'package:mobiwoom/ui/views/partners/partners_view.dart';
import 'package:mobiwoom/ui/views/services/parking_view.dart';
import 'package:mobiwoom/ui/views/services/taxi_check_view.dart';
import 'package:mobiwoom/core/services/ticketMachines_service.dart';
import 'package:mobiwoom/ui/views/sponsorship/sponsorships.dart';
import 'package:mobiwoom/ui/views/services/parking_map_view.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => NotificationService());
  locator.registerFactory(() => ProfileService());
  locator.registerFactory(() => CardService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => Api());
 // locator.registerLazySingleton(() => ApiXml());
  locator.registerFactory(() => LoginModel());
  locator.registerFactory(() => ProfileModel());
  locator.registerFactory(() => ContactLessCardModel());
  locator.registerFactory(() => ContactLessCardService());
  locator.registerFactory(() => ContactLessCardView());
  locator.registerFactory(() => ContactLessCard());
  locator.registerFactory(() => LicenseModel());
  locator.registerFactory(() => LicenseService());
  locator.registerFactory(() => LicencePlateView());
  locator.registerFactory(() => AddLicenseView());
  locator.registerFactory(() => ChangePinView());
  locator.registerFactory(() => PincodeService());
  locator.registerFactory(() => PincodeModel());
  locator.registerFactory(() => ParkingView());
  locator.registerFactory(() => ParkingMapView());
  locator.registerFactory(() => ParkingModel());
  locator.registerFactory(() => ParkingService());

  locator.registerFactory(() => TaxiCheckModel());
  locator.registerFactory(() => TaxiCheckRequest());
  locator.registerFactory(() => TaxiCheckService());
  locator.registerFactory(() => TaxiCheckView());

  locator.registerFactory(() => CardModel());
  locator.registerFactory(() => SavedCardView());
 // locator.registerFactory(() => AddCardView());
  locator.registerFactory(() => NotificationView());
  locator.registerFactory(() => FacebookModel());
  locator.registerFactory(() => ProfileView());
  locator.registerFactory(() => User());
  locator.registerFactory(() => userReq.User());

  locator.registerFactory(() => PartnersListView());
  locator.registerFactory(() => PartnersMapView());
  locator.registerFactory(() => PartnersModel());
  // locator.registerFactory(() => TicketMachinesModel());
  locator.registerFactory(() => TicketMachinesService());
  locator.registerFactory(() => PartnersService());
  locator.registerFactory(() => PartnerDetailView());

  locator.registerFactory(() => CashBackView());
  locator.registerFactory(() => AddCashBackView());
  locator.registerFactory(() => OfferCashBackView());
  locator.registerFactory(() => CashBack());
  locator.registerFactory(() => CashBackService());
  locator.registerFactory(() => CashBackModel());
  locator.registerFactory(() => AddCashBack());
  locator.registerFactory(() => TransferCashBack());
  locator.registerFactory(() => ContactUsView());

  locator.registerFactory(() => SponsorshipView());
  locator.registerFactory(() => LostPincodeScreen());
  locator.registerLazySingleton(() => Application());
  locator.registerFactory(() => TermsAndConditionsScreen());
  locator.registerFactory(() => EnterEmailScreen());
  locator.registerFactory(() => BioMetricService());
  locator.registerFactory(() => HomeModel());

 // locator.registerFactory(() => SavedCardFromBankView());
  locator.registerFactory(() => ThreeDSecureBankView());
  locator.registerFactory(() => TransactionsHistoryView());
  locator.registerFactory(() => Transactions());
  locator.registerFactory(() => TransactionsService());
  locator.registerFactory(() => TransactionsHistoryModel());
}
