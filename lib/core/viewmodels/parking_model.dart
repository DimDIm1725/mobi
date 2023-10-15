import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:expressions/expressions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobiwoom/core/models/requests/login.dart' as loginReq;
import 'package:mobiwoom/core/models/requests/parkingStart.dart' as parkingStartReq;
import 'package:mobiwoom/core/models/requests/parkingStop.dart' as parkingStopReq;
import 'package:mobiwoom/core/models/requests/ticket_machine.dart' as ticketMachinesReq;
import 'package:mobiwoom/core/models/responses/license.dart' as licenseRes;
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/models/responses/parkingStart.dart';
import 'package:mobiwoom/core/models/responses/parkingStop.dart';
import 'package:mobiwoom/core/models/responses/ticket_machine.dart' as tktResponse;
import 'package:mobiwoom/core/models/responses/ticket_machine.dart' as ticketMachinesResponse;
import 'package:mobiwoom/core/services/license_service.dart';
import 'package:mobiwoom/core/services/parking_service.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/map_marker.dart';
import 'package:mobiwoom/ui/views/services/parking_view.dart';

class ParkingModel extends BaseModel {
  // bool gpsEnabled = true;

  bool isParkingMetersAvailable = true;
  bool isCreditCardAvailable = true;
  int parkingDurationRemaining = 0;
  tktResponse.Row selectedParkingMeter = null;
  Expression _expressionForFormula = null;
  double estimatedParkingCharges = 0.0;
  parkingStartReq.ParkingStartRequest parkingStartRequest = parkingStartReq.ParkingStartRequest();
  parkingStopReq.ParkingStopRequest parkingStopRequest = parkingStopReq.ParkingStopRequest();
  ticketMachinesReq.TicketMachineRequest ticketMachineRequest = ticketMachinesReq.TicketMachineRequest();
  ParkingService _parkingService = locator<ParkingService>();
  LicenseService _licenseService = locator<LicenseService>();
  tktResponse.TicketMachineResponse ticketMachineResponse;
  List<DropdownMenuItem<dynamic>> _parkingMeterDropdownMenuItemList = [];
  List<DropdownMenuItem<dynamic>> _vehiclePlateDropdownMenuItemList = [];
  licenseRes.LicenseResponse licenseResponse;
  licenseRes.Row activeParkingLicensePlate;
  GoogleMapController controller;

  // CameraPosition kGooglePlex;
  Set<Marker> markers = Set();
  Map<String, BitmapDescriptor> iconMap = {};
  Map<String, String> webIconMap = {};
  bool partnersCame = false;

//  Position lastCalledLocation;
//  Position lastCalledGPSLocation;
  // currentZoom = 17;

  static const MAX_LIST_VALUES = 4;

  List<DropdownMenuItem<dynamic>> get parkingMeterDropdownMenuItemList => _parkingMeterDropdownMenuItemList;

  set parkingMeterDropdownMenuItemList(List<DropdownMenuItem<dynamic>> value) {
    _parkingMeterDropdownMenuItemList = value;
  }

  List<DropdownMenuItem<dynamic>> get vehiclePlateDropdownMenuItemList => _vehiclePlateDropdownMenuItemList;

  set vehiclePlateDropdownMenuItemList(List<DropdownMenuItem<dynamic>> value) {
    _vehiclePlateDropdownMenuItemList = value;
  }

  init() {
    parkingStartRequest = parkingStartReq.ParkingStartRequest(data: parkingStartReq.Data(duration: 0.0));
    parkingStopRequest = parkingStopReq.ParkingStopRequest(data: parkingStopReq.Data(duration: 0.0));
  }

  /*Future<bool> getAllTicketMachinesCurrentLocation() async {
    Position locationData = await getCurrentLocation();
    if (locationData == null) {
      errorMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('partner_model_location_required');
      setState(ViewState.Idle);
      return false;
    }
    lastCalledGPSLocation = locationData;
    return getAllTicketMachinesForLocation(locationData);
  }*/

  Future<bool> getAllTicketMachinesForLocation(LatLng locationData) async {
    setState(ViewState.Busy);
    bool status = false;
    if (locationData == null) {
      errorMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('partner_model_location_required');
      setState(ViewState.Idle);
      return status;
    }
    //  lastCalledGPSLocation = locationData;
    ticketMachineRequest = ticketMachinesReq.TicketMachineRequest(data: ticketMachinesReq.Data());

    //  lastCalledLocation = locationData;
    //  kGpsEnabled = locationData != null;
    //  print("location Data ");
    //  print(locationData);
    //  gpsEnabled = locationData != null;
    kGooglePlex = CameraPosition(
      target: LatLng(locationData.latitude, locationData.longitude),
      zoom: currentZoom,
    );
    //  print("Zoom from Tickets = " + kGooglePlex.zoom.toString());
    //  LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    //  String userPincode = await SharedPrefUtil.getUserPincode();
    ticketMachineRequest = new ticketMachinesReq.TicketMachineRequest(
      data: ticketMachinesReq.Data(
        api: 'TicketMachinesList',
        userLatitude: locationData.latitude.toString(),
        userLongitude: locationData.longitude.toString(),
        //   userPhoneNumber: loginResponse.response.userPhoneNumber,
        //   language: loginResponse.response.data.userLanguage,
        commonApiLanguage: kApiLanguage,
        commonApiVersion: kAppVersion,
        //   userPhoneCountry: loginResponse.response.userPhoneCountry,
        applicationVersion: kVersion,
        commonApplicationToken: kApplicationToken,
      ),
    );
    ticketMachineResponse = await _parkingService.getAllTicketMachinesForLocation(ticketMachineRequest);
    if (ticketMachineResponse.response.errorNumber == '0') {
      if (ticketMachineResponse.response.data == null || ticketMachineResponse.response.data.row.isEmpty) {
        errorMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
            .translate('no_ticketmachines_available');
        status = false;
      } else {
        successMessage = "";
        status = true;
        setState(ViewState.Idle);
      }
    } else {
      if (ticketMachineResponse.response.message is LinkedHashMap) {
        errorMessage = ticketMachineResponse.response.message["#cdata-section"];
      } else {
        errorMessage = ticketMachineResponse.response.message;
      } //
      //    errorMessage = ticketMachineResponse.response.message;
      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

  Future<bool> getAllSavedLicenses() async {
    bool status = false;
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    loginReq.LoginRequest request = loginReq.LoginRequest(
        data: loginReq.Data(
      api: 'CarPlatesList',
      userUniversalKey: loginResponse.response.userPhoneNumber,
      userBrowserType: getAccountBrowserType(),
      language: loginResponse.response.data.userLanguage,
      userPinCode: userPincode,
      userPhoneCountry: loginResponse.response.userPhoneCountry,
      commonApiVersion: kAppVersion,
      commonApiLanguage: kApiLanguage,
      applicationVersion: kVersion,
      applicationToken: kApplicationToken,
    ));
    licenseResponse = await _licenseService.getAllSavedLicenses(request);

    if (licenseResponse.response.errorNumber == '0') {
      successMessage =
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('fetch_success');
      status = true;
    } else {
      if (licenseResponse.response.message is LinkedHashMap) {
        errorMessage = licenseResponse.response.message["#cdata-section"];
      } else {
        errorMessage = licenseResponse.response.message;
      }

      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

  setParkingFeesFormulaExpression(String expression) {
    expression = expression
        .replaceAll("; } else if ", " : ")
        .replaceAll("; } else {", " : ")
        .replaceAll("{", "?")
        .replaceAll("; }", "")
        .replaceAll("if", "");
    print(expression);
    _expressionForFormula = Expression.parse(expression.trim());
  }

  double getEstimatedParkingFeesForDuration(double duration) {
    if (_expressionForFormula != null) {
      var context = {"Duration": duration.toInt()};
      final evaluator = const ExpressionEvaluator();
      return double.parse(evaluator.eval(_expressionForFormula, context).toString()) / 100;
    }
  }

  populateParkingLists() async {
    _parkingMeterDropdownMenuItemList = [];
    selectedParkingMeter = null;
    parkingStartRequest.data.duration = null;
    isParkingMetersAvailable = ticketMachineResponse.response.data != null;
    if (ticketMachineResponse.response.data != null) {
      int count = 0;
      List<tktResponse.Row> list = ticketMachineResponse.response.data.row;
      for (var item in list) {
        try {
          String title = item.ticketMachineName +
              " : " +
              item.ticketMachineAddress +
              " - " +
              item.ticketMachineDistance +
              " km" +
              " : " +
              item.pricingAreaName;
          _parkingMeterDropdownMenuItemList.add(
            DropdownMenuItem(
              child: Text(
                title,
                overflow: TextOverflow.visible,
              ),
              value: count,
            ),
          );
          if (count == MAX_LIST_VALUES) {
            break;
          }
        } catch (e) {
          print(e);
        }
        count++;
      }
    }
    setState(ViewState.Idle);
  }

  Future<bool> populateLicensePlates() async {
    print("Populate LICENSE PLATE");
    setState(ViewState.Busy);
    // await getAllTicketMachinesForLocation();
    activeParkingLicensePlate = null;
    bool status = await getAllSavedLicenses();
    if (status) {
      List<licenseRes.Row> list = licenseResponse.response?.data?.row;
      if (list != null && list.isNotEmpty) {
        for (licenseRes.Row item in list) {
          if (item.stopDateTime.isNotEmpty) {
            print("ACTIVE PLATE FOUND");
            activeParkingLicensePlate = item;
          }
        }
        if (parkingStartRequest.data?.userCarPlate != null) {
          //getParkingAreasList();
        } else {
          _vehiclePlateDropdownMenuItemList = [];
          for (var item in list) {
            try {
              if (item.main == 'True') {
                parkingStartRequest.data?.userCarPlate = item.carPlate;
                getParkingAreasList();
              }
              _vehiclePlateDropdownMenuItemList.add(
                DropdownMenuItem(
                  child: Text(
                    '${item.tag} : ${item.carPlate}',
                    overflow: TextOverflow.visible,
                  ),
                  value: item.carPlate,
                ),
              );
            } catch (e) {
              print(e);
              setState(ViewState.Idle);
            }
          }
        }
      }
      setState(ViewState.Idle);
      return status;
    }
  }

  Future<void> getParkingAreasList() async {
    isParkingMetersAvailable = true;
    //await populateParkingLists();
    setParkingMeterDefaults(0);
  }

  Future<bool> startParkingSession() async {
    bool status = false;
    setState(ViewState.Busy);
    LoginResponse user = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    parkingStartRequest.data.api = 'ParkingStart';
    parkingStartRequest.data.userPinCode = userPincode;
    parkingStartRequest.data.userUniversalKey = user.response.userPhoneNumber;
    parkingStartRequest.data.commonApplicationToken = kApplicationToken;
    parkingStartRequest.data.commonApiLanguage = user.response.data.userLanguage;
    parkingStartRequest.data.commonApiVersion = kAppVersion;
    parkingStartRequest.data.applicationVersion = kVersion;

    ParkingStartResponse parkingStartResponse = await _parkingService.startParkingSession(parkingStartRequest);

    if (parkingStartResponse.response.errorNumber == '0') {
      successMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('parking_slot_booked_successfully');
      status = true;
    } else {
      if (parkingStartResponse.response.message is LinkedHashMap) {
        errorMessage = parkingStartResponse.response.message["#cdata-section"];
      } else {
        errorMessage = parkingStartResponse.response.message;
      }

      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

  int getETA() {
    if (activeParkingLicensePlate != null) {
      DateTime stopDateTime = DateFormat('yyyy/MM/dd HH:mm', 'fr_FR').parse(activeParkingLicensePlate.stopDateTime);
      print(stopDateTime);
      DateTime currentDateTime = DateTime.now();
      print(currentDateTime);
      int timeDifferenceInSeconds = stopDateTime.difference(currentDateTime).inSeconds;
      print("timeDifferenceInSeconds " + timeDifferenceInSeconds.toString());
      if (timeDifferenceInSeconds < 0) {
        return 0;
      } else {
        return timeDifferenceInSeconds;
      }
    }
    return 0;
  }

  Future<bool> stopParkingSession() async {
    bool status = false;
    setState(ViewState.Busy);
    LoginResponse user = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    parkingStopRequest.data.api = 'ParkingStop';
    parkingStopRequest.data.userCarPlate = activeParkingLicensePlate.carPlate;
    parkingStopRequest.data.userPinCode = userPincode;
    parkingStopRequest.data.ticketMachineId = activeParkingLicensePlate.ticketMachineName;
    parkingStopRequest.data.userUniversalKey = user.response.userPhoneNumber;
    parkingStopRequest.data.commonApiVersion = kAppVersion;
    parkingStopRequest.data.commonApiLanguage = user.response.data.userLanguage;
    parkingStopRequest.data.commonApplicationToken = kApplicationToken;
    ParkingStopResponse parkingStopResponse = await _parkingService.stopParkingSession(parkingStopRequest);

    if (parkingStopResponse.response.errorNumber == '0') {
      successMessage =
          '${AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('parking_session_stopped_successfully_cost')} ${parkingStopResponse.response?.data?.amount} ${AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('moneySymbol')}';
      status = true;
      inParkingSession = false;
    } else {
      if (parkingStopResponse.response.message is LinkedHashMap) {
        errorMessage = parkingStopResponse.response.message["#cdata-section"];
      } else {
        errorMessage = parkingStopResponse.response.message;
      }

      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

  void setParkingMeterDefaults(int value) {
    // print(model.selectedParkingMeter.pricingAreaName);
    if (selectedParkingMeter != null) {
      setParkingFeesFormulaExpression(selectedParkingMeter.pricingAreaAmountCalculationFormula);
      parkingStartRequest.data.ticketMachineId = selectedParkingMeter.ticketMachineId;
      parkingStartRequest.data.duration = double.parse(selectedParkingMeter.pricingAreaDefaultDuration);
      estimatedParkingCharges = getEstimatedParkingFeesForDuration(parkingStartRequest.data.duration);
    }
    setState(ViewState.Idle);
  }

  Future<List<MapMarker>> generateParkingMarkers(
      List<ticketMachinesResponse.Row> ticketMachines, BuildContext context) async {
    print("generateParkingMarkers");
    final List<MapMarker> markers = [];

    for (var element in ticketMachines) {
      print("TicketMachines ${element.partnerZipCode}");
      BitmapDescriptor bitmapIcon;
      if (kIsWeb) {
        bitmapIcon = null;
      } else {
        try {
          Uint8List icon = await getBytesFromAsset('images/mapicons/parking.png', 110);
          print("icon ${icon.length}");
          bitmapIcon = BitmapDescriptor.fromBytes(icon);
          print(bitmapIcon);
          print("assets loaded");
        } catch (e) {
          print(e);
        }
      }

      LatLng location = LatLng(double.parse(element.ticketMachineLat), double.parse(element.ticketMachineLon));
      print("Location $location");
      markers.add(MapMarker(
        onTap: () {
          inParkingSession = true;
          _settingModalBottomSheet(context, element);
        },
        id: element.ticketMachineId,
        position: location,
        icon: bitmapIcon,
      ));
    }
    print('markers = ' + markers.toString());
    return markers;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    if (kIsWeb) {
      return createCustomMarkerBitmap(1, path);
    } else {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
    }
  }

  Future<Uint8List> createCustomMarkerBitmap(int markerNumber, String imageURL) async {
    int markerWidth = 100;
    print("1");
    // if (kIsWeb) markerWidth= 30; else markerWidth = 100;
    PictureRecorder recorder = new PictureRecorder();
    Canvas c = Canvas(recorder);

    final data1 = await rootBundle.load(imageURL);
    print("2");
    var markerImage = await decodeImageFromList(data1.buffer.asUint8List());
    print("3");
    c.drawImageRect(markerImage, Rect.fromLTRB(0.0, 0.0, markerImage.width.toDouble(), markerImage.height.toDouble()),
        Rect.fromLTRB(0.0, 0.0, markerWidth.toDouble(), markerWidth.toDouble()), Paint());
    print("4");
    TextSpan span = TextSpan(
      style: TextStyle(color: Colors.black, fontSize: markerWidth / 3, fontWeight: FontWeight.bold),
      text: markerNumber.toString(),
    );
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: ui.TextDirection.ltr);
    print("5");
    tp.layout();
    print("6");
    tp.paint(c, Offset(markerNumber > 9 ? markerWidth / 3.5 : markerWidth / 2.5, markerWidth / 5.5));
    print("7");

    var p = recorder.endRecording();
    print("8");
    ByteData pngBytes = await (await p.toImage(markerWidth, markerWidth)).toByteData(format: ImageByteFormat.png);
    print("9");
    Uint8List data = Uint8List.view(pngBytes.buffer);
    print("10");
    return data;
  }

  void _settingModalBottomSheet(context, ticketMachinesResponse.Row ticketMachineDetail) {
    showModalBottomSheet(
        context: context,
        backgroundColor: MobiTheme.lightBlue,
        isDismissible: true,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 1 / 2,
            padding: EdgeInsets.only(left: 30.0, right: 16.0, top: 10.0),
            child: ParkingView(
              ticketMachineDetail: ticketMachineDetail,
              parentParkingModel: this,
            ),
          );
        }).whenComplete(() {
      inParkingSession = false;
    });
  }

/* double calculateDistance(LatLng target) {
    double lat1 = target.latitude;
    double lon1 = target.longitude;
    double lat2 = lastCalledLocation.latitude;
    double lon2 = lastCalledLocation.longitude;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double calculateGPSDistance(LatLng target) {
    if (lastMapPosition == null) {
      return 0;
    }
    double lat1 = target.latitude;
    double lon1 = target.longitude;
    double lat2 = lastCalledGPSLocation.latitude;
    double lon2 = lastCalledGPSLocation.longitude;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }*/
}
