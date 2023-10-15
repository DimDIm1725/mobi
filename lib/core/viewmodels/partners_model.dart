import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobiwoom/core/models/requests/login.dart' as requestLogin;
import 'package:mobiwoom/core/models/requests/partner.dart' as partnerReq;
import 'package:mobiwoom/core/models/responses/login.dart' as loginRes;
import 'package:mobiwoom/core/models/responses/partner.dart' as partnerResponse;
import 'package:mobiwoom/core/services/partners_service.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/map_marker.dart';
import 'package:mobiwoom/ui/views/partners/partner_detail_view.dart';

class PartnersModel extends BaseModel {
  bool gpsEnabled = false;
  PartnersService _partnersService = locator<PartnersService>();
  loginRes.Data activitiesList = loginRes.Data();
  partnerResponse.PartnerResponse partnersList;

  /* partnerResponse.PartnerResponse pastPartnersList;*/
  GoogleMapController controller;

  // CameraPosition kGooglePlex;
  Set<Marker> markers = Set();
  Map<String, BitmapDescriptor> iconMap = {};
  Map<String, String> webIconMap = {};

//  bool partnersCame = false;
//  LatLng lastLocationCalledForApi;

  PartnersModel();

  // double currentZoom = 17;

  Future<bool> getAllActivities() async {
    bool status = false;
    //  setState(ViewState.Busy);
    loginRes.LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
        api: 'ActivitiesList',
        userBrowserType: getAccountBrowserType(),
        language: loginResponse.response.data.userLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        applicationVersion: kVersion,
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        applicationToken: kApplicationToken,
      ),
    );
    loginRes.LoginResponse response = await _partnersService.getAllActivities(loginRequest);
    if (response.response.errorNumber == '0') {
      successMessage = "";
      activitiesList = response.response.data;
      status = true;
    } else {
      if (response.response.message is LinkedHashMap) {
        errorMessage = response.response.message["#cdata-section"];
      } else {
        errorMessage = response.response.message;
      }

      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

  Future<bool> getAllPartnersByGeoLocation(LatLng locationData) async {
    //  print("getAllPartnersByGeoLocation");
    setState(ViewState.Busy);
    // setState(ViewState.Busy);
    //   Position locationData = await getCurrentLocation();
    //  kGpsEnabled = locationData != null;
    /* print("location Data ");
    print(locationData);
    if (locationData == null) {
      errorMessage = (AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('location_service_required') + '\n' +
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('partner_model_location_required'));
      setState(ViewState.Idle);
      return false;
    }*/
    bool status = false;
    kGooglePlex = CameraPosition(
      target: LatLng(locationData.latitude, locationData.longitude),
      zoom: currentZoom,
    );
    //  print("Zoom from partners = " + kGooglePlex.zoom.toString());
    loginRes.LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    partnerReq.PartnerRequest request = new partnerReq.PartnerRequest(
      data: partnerReq.Data(
        api: 'AvailablePartnersListByGeoLocation',
        userLatitude: locationData.latitude.toString(),
        userLongitude: locationData.longitude.toString(),
        userPhoneNumber: loginResponse.response.userPhoneNumber,
        language: loginResponse.response.data.userLanguage,
        commonApiLanguage: kApiLanguage,
        commonApiVersion: kAppVersion,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    partnersList = await _partnersService.getAllPartnersByGeoLocation(request);
    //  lastLocationCalledForApi = locationData;
    setState(ViewState.Idle);
    if (partnersList.response.errorNumber == '0') {
      if (partnersList.response.data == null || partnersList.response.data.row.isEmpty) {
        errorMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
            .translate('partners_view_no_partner_available');
        status = false;
      } else {
        successMessage = "";
        status = true;
      }
    } else {
      if (partnersList.response.message is LinkedHashMap) {
        errorMessage = partnersList.response.message["#cdata-section"];
      } else {
        errorMessage = partnersList.response.message;
      }
      status = false;
    }
    //   partnersCame = status;
    return status;
  }

  Future<ImageInfo> loadImage(String fileName) {
    ImageProvider imageProvider = AssetImage(fileName);
    final Completer completer = Completer<ImageInfo>();
    final ImageStream stream = imageProvider.resolve(const ImageConfiguration());
    final listener = ImageStreamListener((ImageInfo info, bool synchronousCall) {
      if (!completer.isCompleted) {
        completer.complete(info);
      }
    });
    stream.addListener(listener);
    return completer.future;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    if (kIsWeb) {
      return null;
    } else {
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
    }
  }

  Future<Uint8List> createCustomMarkerBitmap(int markerNumber, String imageURL) async {
    int markerWidth = 10;
    // if (kIsWeb) markerWidth= 30; else markerWidth = 100;
    PictureRecorder recorder = new PictureRecorder();
    Canvas c = Canvas(recorder);

    final data1 = await rootBundle.load(imageURL);
    var markerImage = await decodeImageFromList(data1.buffer.asUint8List());
    c.drawImageRect(markerImage, Rect.fromLTRB(0.0, 0.0, markerImage.width.toDouble(), markerImage.height.toDouble()),
        Rect.fromLTRB(0.0, 0.0, markerWidth.toDouble(), markerWidth.toDouble()), Paint());

    var p = recorder.endRecording();
    ByteData pngBytes = await (await p.toImage(markerWidth, markerWidth)).toByteData(format: ImageByteFormat.png);
    Uint8List data = Uint8List.view(pngBytes.buffer);
    return data;
  }

  Future<List<MapMarker>> generateMarkers(List<partnerResponse.Row> partners, BuildContext context) async {
    //   print("Generate Markers");
    final List<MapMarker> markers = [];

    for (var element in partners) {
      BitmapDescriptor bitmapIcon;
      if (kIsWeb) {
        bitmapIcon = null;
      } else {
        try {
          if (iconMap.containsKey(element.activityId)) {
            bitmapIcon = iconMap[element.activityId];
          } else {
            Uint8List icon = await getBytesFromAsset('images/mapicons/${element.activityId}.png', 110);
            bitmapIcon = BitmapDescriptor.fromBytes(icon);
            iconMap.putIfAbsent(element.activityId, () => bitmapIcon);
          }
        } catch (e) {
          print(e);
        }
      }

      //    print("assets loaded");

      LatLng location = LatLng(double.parse(element.partnerLatitude), double.parse(element.partnerLongitude));
      markers.add(MapMarker(
        onTap: () {
          inParkingSession = true;
          _settingModalBottomSheet(context, element);
        },
        id: element.partnerId,
        position: location,
        icon: bitmapIcon,
      ));
    }
    return markers;
  }

  void _settingModalBottomSheet(context, partnerResponse.Row partnerDetail) {
    showModalBottomSheet(
        context: context,
        backgroundColor: MobiTheme.lightBlue,
        isDismissible: true,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 1 / 2,
            padding: EdgeInsets.only(left: 30.0, right: 16.0, top: 10.0),
            child: SingleChildScrollView(child: PartnerInfoWidget(partnerDetail)),
          );
        }).whenComplete(() {
      inParkingSession = false;
    });
  }

//  getAllSavedCards() async {
//    setState(ViewState.Busy);
//    String appVersion = await getAppVersion();
//    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
//
//    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
//      data: requestLogin.Data(
//        api: 'UserCreditCardsList',
//        userUniversalKey: loginResponse.response.userPhoneNumber,
//        userBrowserType: getAccountBrowserType(),
//        language: loginResponse.response.data.userLanguage,
//        userPhoneCountry: loginResponse.response.userPhoneCountry,
//        applicationVersion: appVersion,
//        applicationToken: kApplicationToken,
//      ),
//    );
//    card = await cardService.getAllSavedCards(loginRequest);
//    mainCard = card.response.data?.row
//        ?.firstWhere((element) => element.main == true, orElse: () => null);
//    setState(ViewState.Idle);
//  }
//
//  Future<bool> getCustomerFromCard(String number) async {
//    bool status = false;
//    setState(ViewState.Busy);
//    String appVersion = await getAppVersion();
//    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
//      data: requestLogin.Data(
//        api: 'UserParseLite',
//        userUniversalKey: number,
//        userBrowserType: getAccountBrowserType(),
//        language: loginResponse.response.data.userLanguage,
//        userPhoneCountry: loginResponse.response.userPhoneCountry,
//        applicationVersion: appVersion,
//        applicationToken: kApplicationToken,
//      ),
//    );
//    LoginResponse response =
//        await taxiCheckService.getCustomerFromCard(loginRequest);
//    if (response.response.errorNumber == '0') {
//      successMessage = "";
//      recipientName =
//          '${response.response.data.userFirstName} ${response.response.data.userLastName}';
//      status = true;
//    } else {
//      if (response.response.message is LinkedHashMap) {
//        errorMessage = response.response.message["#cdata-section"];
//      } else {
//        errorMessage = response.response.message;
//      }
//
//      status = false;
//    }
//    setState(ViewState.Idle);
//    return status;
//  }
//
//  Future<bool> sendTaxiCheck() async {
//    bool status = false;
//    setState(ViewState.Busy);
//    String appVersion = await getAppVersion();
//    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
//    String userPincode = await SharedPrefUtil.getUserPincode();
//    taxiCheckRequest.data.api = 'TransactionAddNewCashBackBought';
//    taxiCheckRequest.data.buyerUserPhoneNumber =
//        loginResponse.response.userPhoneNumber;
//    taxiCheckRequest.data.buyerUserPhoneCountry = 'FR';
//    taxiCheckRequest.data.buyerUserPinCode = userPincode;
//    taxiCheckRequest.data.beneficiaryUserPhoneCountry = 'FR';
//    taxiCheckRequest.data.partnerPhoneCountry = 'FR';
//    taxiCheckRequest.data.partnerPhoneNumber = kPartnerPhoneNumber;
//    taxiCheckRequest.data.applicationVersion = appVersion;
//    taxiCheckRequest.data.applicationToken = kApplicationToken;
//    LoginResponse response =
//        await taxiCheckService.sendTaxiCheck(taxiCheckRequest);
//
//    if (response.response.errorNumber == '0') {
//      successMessage = "Payment sent successfully to $recipientName";
//      status = true;
//    } else {
//      if (response.response.message is LinkedHashMap) {
//        errorMessage = response.response.message["#cdata-section"];
//      } else {
//        errorMessage = response.response.message;
//      }
//
//      status = false;
//    }
//    setState(ViewState.Idle);
//    return status;
//  }
//
//  Future<bool> addRecipient() async {
//    bool status = false;
//    setState(ViewState.Busy);
//    String appVersion = await getAppVersion();
//    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
//    String userPincode = await SharedPrefUtil.getUserPincode();
//    user.data.api = 'UserAddNew';
//    user.data.userCountry = 'FR';
//    user.data.userLanguage = 'FR';
//    //user.data.userUniversalKey = loginResponse.response.userPhoneNumber;
//    user.data.userPhoneCountry = 'FR';
//    user.data.applicationVersion = appVersion;
//    user.data.applicationToken = kApplicationToken;
//    print(user.data.userUniversalKey);
//    LoginResponse response = await taxiCheckService.addRecipient(user);
//
//    if (response.response.errorNumber == '0') {
//      successMessage = "User Added successfully";
//      status = true;
//    } else {
//      if (response.response.message is LinkedHashMap) {
//        errorMessage = response.response.message["#cdata-section"];
//      } else {
//        errorMessage = response.response.message;
//      }
//
//      status = false;
//    }
//    setState(ViewState.Idle);
//    return status;
//  }

/* double calculateGPSDistance(LatLng target) {
    if (lastLocationCalledForApi == null) {
      return 0;
    }
    double lat1 = target.latitude;
    double lon1 = target.longitude;
    double lat2 = lastLocationCalledForApi.latitude;
    double lon2 = lastLocationCalledForApi.longitude;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }*/
}
