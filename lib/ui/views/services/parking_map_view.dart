import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/cluster_marker.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/card_model.dart';
import 'package:mobiwoom/core/viewmodels/parking_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/map_marker.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/shared/web_map_marker.dart';
import 'package:mobiwoom/ui/views/account/3d_secure_bank_view.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:system_settings/system_settings.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';

String resultingCreationDateFormat = 'HH:mm\ndd/MM/yyyy';
String incomingCreationDateFormat = 'yyyy/MM/dd HH:mm';
// const TOTAL_DISTANCE_FOR_NEW_API_CALL = 5.0;
// const TOTAL_TIME_FOR_NEW_API_CALL = 5; // seconds
Position locationData;
// LatLng lastMapPosition;
bool firstLoading = false;

class ParkingMapView extends StatefulWidget {
  static const routeName = "parkingSession";

  @override
  _ParkingMapViewState createState() => _ParkingMapViewState();
}

class _ParkingMapViewState extends State<ParkingMapView> {
  @override
  Widget build(BuildContext context) {
    return ParkingMapWidget();
  }
}

class ParkingMapWidget extends StatefulWidget {
  @override
  _ParkingMapListWidgetState createState() => _ParkingMapListWidgetState();
}

class _ParkingMapListWidgetState extends State<ParkingMapWidget>
    with WidgetsBindingObserver {
  Fluster<MapMarker> fluster;
  Fluster<WebMapMarker> flusterWeb;
  CardModel cardModel;
  Position location = new Position();

//  LatLng lastMapPosition;
  // StreamSubscription locationListner;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    cardModel = CardModel();
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    if (AppLifecycleState.resumed == state && kGpstest) {
      // TODO add loader before get GPS
      locationData = await getCurrentLocation();
      kGpsEnabled = locationData != null;
      if (kGpsEnabled) {
        kGooglePlex = CameraPosition(
          target: LatLng(locationData.latitude, locationData.longitude),
          zoom: currentZoom,
        );
        lastMapPosition = kGooglePlex.target;
        setState(() {});
      }
    } else {
      //   print("Status not Resumed :" + state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ParkingModel>(onModelReady: (model) async {
      // TODO Check this ?
      model.init();

      if (lastMapPosition == null) {
        locationData = await getCurrentLocation();
        kGpsEnabled = locationData != null;
        if (locationData == null) {
          BotToast.showText(
              contentPadding: EdgeInsets.all(16),
              //   animationDuration: Duration(seconds: 2),
              duration: Duration(seconds: 4),
              contentColor: Colors.redAccent,
              text: (AppLocalizations.of(context)
                      .translate('location_service_required') +
                  '\n' +
                  AppLocalizations.of(context)
                      .translate('no_ticketmachines_available')));
        } else {
          lastMapPosition =
              LatLng(locationData.latitude, locationData.longitude);
        }
      }

      if (lastMapPosition != null) {
        bool status = await model.populateLicensePlates();
        if (!status) {
          BotToast.showText(
              contentPadding: EdgeInsets.all(16),
              //   animationDuration: Duration(seconds: 2),
              duration: Duration(seconds: 4),
              contentColor: Colors.redAccent,
              text: model.errorMessage);
        }
        if (model.activeParkingLicensePlate == null) {
          if (model.licenseResponse.response.data != null) {
            //await model.getAllTicketMachinesForLocation();
            await cardModel.getAllSavedCards();
            if (cardModel.card != null &&
                cardModel.card.response.data != null) {
              bool status =
                  await model.getAllTicketMachinesForLocation(lastMapPosition);
              if (status) firstLoading = true;
              /*   if (!status) {
              model.setState(ViewState.Idle);
              BotToast.showText(
                  contentPadding: EdgeInsets.all(16),
                  //   animationDuration: Duration(seconds: 2),
                  duration: Duration(seconds: 4),
                  textStyle: TextStyle(fontSize: 17, color: Colors.black),
                  contentColor: Colors.redAccent,
                  text: model.errorMessage);
              }*/
            }
          }
        }
      }

      model.setState(ViewState.Idle);

      //  LatLng locData = LatLng(locationGPS.latitude, locationGPS.longitude);

      //  registerLocationListener(model);
    }, builder: (context, model, child) {
      return MobiAppBar(
        child: ModalProgressHUD(
          inAsyncCall: model.state == ViewState.Busy,
          child: Consumer<DrawerAndToolbar>(
            builder: (context, indexData, _) => (model.licenseResponse !=
                        null &&
                    model.licenseResponse.response != null)
                ? (model.licenseResponse.response.data == null
                    ? Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.directions_car,
                                size: 72,
                                color: MobiTheme.colorIcon,
                              ),
                              SizedBox(height: 16),
                              Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Center(
                                      child: Text(
                                    AppLocalizations.of(context).translate(
                                        'licence_plate_not_registered'),
                                    style: MobiTheme.text16BoldWhite,
                                  ))),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: MobiButton(
                                  padding: const EdgeInsets.all(16),
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                        context, "addLicense");
                                    await model.populateLicensePlates();
                                    model.setState(ViewState.Idle);
                                    /*  if (model.licenseResponse.response.data != null) {
                                          bool status = await model.getAllTicketMachinesForLocation(lastMapPosition);
                                          if (!status) {
                                            BotToast.showText(
                                                contentPadding: EdgeInsets.all(16),
                                                //   animationDuration: Duration(seconds: 2),
                                                duration: Duration(seconds: 4),
                                                textStyle: TextStyle(fontSize: 17, color: Colors.black),
                                                contentColor: Colors.redAccent,
                                                text: model.errorMessage);
                                          }
                                        }*/
                                  },
                                  text: AppLocalizations.of(context)
                                      .translate('add_license_plate'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : (model.activeParkingLicensePlate == null // show map here
                        ? ((cardModel.card != null &&
                                cardModel.card.response != null &&
                                cardModel.card.response.data == null)
                            ? Container(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.credit_card,
                                        size: 72,
                                        color: MobiTheme.colorIcon,
                                      ),
                                      SizedBox(height: 16),
                                      Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Center(
                                              child: Text(
                                            AppLocalizations.of(context)
                                                .translate(
                                                    'no_creditcards_found'),
                                            style: MobiTheme.text16BoldWhite,
                                          ))),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: IButton3(
                                          pressButton: () async {
                                            await Navigator.pushNamed(context,
                                                ThreeDSecureBankView.routeName);
                                            model.setState(ViewState.Busy);
                                            await cardModel.getAllSavedCards();
                                            bool status = await model
                                                .getAllTicketMachinesForLocation(
                                                    lastMapPosition);
                                            if (!status) {
                                              BotToast.showText(
                                                  contentPadding:
                                                      EdgeInsets.all(16),
                                                  //   animationDuration: Duration(seconds: 2),
                                                  duration:
                                                      Duration(seconds: 4),
                                                  textStyle: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.black),
                                                  contentColor:
                                                      Colors.redAccent,
                                                  text: model.errorMessage);
                                            }
                                            setState(() {});
                                          },
                                          text: AppLocalizations.of(context)
                                              .translate('add_new_card'),
                                          color: MobiTheme.colorCompanion,
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ParkingMeterMapWidget(model))
                        : ActiveParkingWidget(model)))
                : !kGpsEnabled
                    ? Center(
                        child: RaisedButton(
                          onPressed: () async {
                            SystemSettings.location();
                            /*  locationData = await getCurrentLocation();
                                       kGpsEnabled = locationData != null;

                                       if (kGpsEnabled) {
                                         print("Called From BUILD");
                                         bool status = await model.getAllPartnersByGeoLocation(LatLng(locationData.latitude,locationData.longitude));

                                         if (!status) {
                                           BotToast.showText(
                                               contentPadding: EdgeInsets.all(16),
                                               //   animationDuration: Duration(seconds: 2),
                                               duration: Duration(seconds: 4),
                                               contentColor: Colors.redAccent,
                                               text: model.errorMessage);
                                         }
                                         model.setState(ViewState.Idle);
                                       }*/
                            kGpstest = true;
                          },
                          child: Text(AppLocalizations.of(context)
                              .translate('location_service_required')),
                        ),
                      )
                    : MobiLoader(),
          ),
        ),
      );
    });
  }

/*  void registerLocationListener(ParkingModel model) {
    locationListner = location.onLocationChanged.listen((Position currentLocation) {
      LatLng latLng = new LatLng(currentLocation.latitude, currentLocation.longitude);
      double distanceTravelled = model.calculateGPSDistance(latLng);
      print("On Location changed Distance Travelled $distanceTravelled");
      if (distanceTravelled >= TOTAL_DISTANCE_FOR_NEW_API_CALL + 10) {
        Position locationData =
            Position.fromMap({'latitude': currentLocation.latitude, 'longitude': currentLocation.longitude});
        model.lastCalledGPSLocation = locationData;
        model.getAllTicketMachinesForLocation(locationData);
      }
    });
  }*/
/*
  Future<void> unRegisterLocationListener(ParkingModel model) async {
    if (locationListner != null) {
      await locationListner.cancel();
    }
  }*/
}

class ElapsedTimeWidget extends StatefulWidget {
  ParkingModel model;

  ElapsedTimeWidget(this.model);

  @override
  _ElapsedTimeWidgetState createState() => _ElapsedTimeWidgetState();
}

class _ElapsedTimeWidgetState extends State<ElapsedTimeWidget> {
  String ETA = "";
  Timer timer;

  @override
  void initState() {
    getETA();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // executes after build
      if (widget.model.parkingDurationRemaining > 0) {
        widget.model.setState(ViewState.Idle);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: widget.model.parkingDurationRemaining <= 60
                ? Colors.redAccent
                : widget.model.parkingDurationRemaining <= 300
                    ? Colors.orange
                    : Colors.lightGreen,
            borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Text(
              AppLocalizations.of(context).translate('remaining_time'),
              style: getCustomStyle(context, color: Colors.white),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                ETA,
                style:
                    getCustomStyle(context, color: Colors.white, textSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getETA() async {
    widget.model.parkingDurationRemaining = widget.model.getETA();
    if (widget.model.parkingDurationRemaining <= 0) {
      ETA = AppLocalizations.of(
              locator<Application>().navigatorKey.currentContext)
          .translate('time_elapsed');
      widget.model.setState(ViewState.Idle);
    } else {
      timer = new Timer.periodic(Duration(seconds: 1), (timer) {
        int hour = widget.model.parkingDurationRemaining ~/ (60 * 60);
        int minutes = (widget.model.parkingDurationRemaining ~/ (60)) % 60;
        int seconds = (widget.model.parkingDurationRemaining % 60).toInt();
        //   print("PARKING MAP ${widget.model.parkingDurationRemaining}");
        widget.model.parkingDurationRemaining -= 1;
        if (widget.model.parkingDurationRemaining < 0) {
          ETA = AppLocalizations.of(
                  locator<Application>().navigatorKey.currentContext)
              .translate('time_elapsed');
          timer.cancel();
          widget.model.setState(ViewState.Idle);
        } else {
          ETA =
              '${hour.toString().padLeft(2, '0')} h ${minutes.toString().padLeft(2, '0')} m ${seconds.toString().padLeft(2, '0')} s';
          setState(() {});
        }
      });
    }
  }
}

class ActiveParkingWidget extends StatefulWidget {
  ParkingModel model;

  ActiveParkingWidget(this.model);

  @override
  _ActiveParkingWidgetState createState() => _ActiveParkingWidgetState();
}

class _ActiveParkingWidgetState extends State<ActiveParkingWidget> {
  @override
  Widget build(BuildContext context) {
    ParkingModel model = widget.model;
    return SingleChildScrollView(
      // show elapsetime widget
      child: Column(
        children: <Widget>[
          ElapsedTimeWidget(model),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                //  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: MobiTheme.nearlyBlue,
                      ),
                      padding: const EdgeInsets.all(12.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('parking_view_current_parking'),
                        style: getCustomStyle(context, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MobiText(
                        text: model.activeParkingLicensePlate?.carPlate,
                        prefixIcon: Icon(Icons.directions_car),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MobiText(
                        text: model.activeParkingLicensePlate?.pricingAreaName,
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MobiText(
                        text:
                            '${AppLocalizations.of(context).translate('started_at')} : ${model.activeParkingLicensePlate?.startDateTime == null ? '' : DateFormat(resultingCreationDateFormat).format(
                                DateFormat(incomingCreationDateFormat).parse(
                                    model.activeParkingLicensePlate
                                        ?.startDateTime),
                              )}',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MobiText(
                        text:
                            '${AppLocalizations.of(context).translate('ends_at')} : ${model.activeParkingLicensePlate?.stopDateTime == null ? '' : DateFormat(resultingCreationDateFormat).format(
                                DateFormat(incomingCreationDateFormat).parse(
                                    model.activeParkingLicensePlate
                                        ?.stopDateTime),
                              )}',
                        prefixIcon:
                            Icon(Icons.access_time, color: MobiTheme.colorIcon),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MobiButton(
              padding: const EdgeInsets.all(16),
              text: (widget.model.parkingDurationRemaining > 0)
                  ? AppLocalizations.of(context).translate('stop')
                  : AppLocalizations.of(context).translate('ok'),
              color: (widget.model.parkingDurationRemaining > 0)
                  ? Colors.redAccent
                  : Colors.greenAccent,
              onPressed: () async {
                if (widget.model.parkingDurationRemaining > 0) {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context)
                              .translate('parking_view_stop_confirmation')),
                          content: Text(AppLocalizations.of(context)
                              .translate('pay_for_time_consumed')),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(AppLocalizations.of(context)
                                  .translate('cancel')),
                            ),
                            new FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                model.stopParkingSession().then((value) async {
                                  BotToast.showText(
                                      contentPadding: EdgeInsets.all(16),
                                      //   animationDuration: Duration(seconds: 2),
                                      duration: Duration(seconds: 4),
                                      textStyle: TextStyle(
                                          fontSize: 17, color: Colors.black),
                                      contentColor: value
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      text: value
                                          ? model.successMessage
                                          : model.errorMessage);
                                  if (value) {
                                    //    await model.getAllTicketMachinesForLocation();
                                    await model.populateLicensePlates();
                                  }
                                });
                              },
                              child: Text(AppLocalizations.of(context)
                                  .translate('confirm')),
                            ),
                          ],
                        );
                      });
                } else {
                  bool status = await model
                      .getAllTicketMachinesForLocation(lastMapPosition);
                  if (!status) {
                    BotToast.showText(
                        contentPadding: EdgeInsets.all(16),
                        //   animationDuration: Duration(seconds: 2),
                        duration: Duration(seconds: 4),
                        textStyle: TextStyle(fontSize: 17, color: Colors.black),
                        contentColor: Colors.redAccent,
                        text: model.errorMessage);
                  }
                  await widget.model.populateLicensePlates();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class ParkingMeterMapWidget extends StatefulWidget {
  ParkingModel model;

  ParkingMeterMapWidget(this.model);

  @override
  _ParkingMeterMapWidgetState createState() => _ParkingMeterMapWidgetState();
}

class _ParkingMeterMapWidgetState extends State<ParkingMeterMapWidget>
    with WidgetsBindingObserver {
  Fluster<MapMarker> fluster;
  Fluster<WebMapMarker> flusterWeb;
  Timer t;

  @override
  void initState() {
    super.initState();
    //  WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> dispose() async {
    //  WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    if (AppLifecycleState.resumed == state && kGpstest) {
      // TODO add loader before get GPS
      locationData = await getCurrentLocation();
      kGpsEnabled = locationData != null;
      if (kGpsEnabled) {
        kGooglePlex = CameraPosition(
          target: LatLng(locationData.latitude, locationData.longitude),
          zoom: currentZoom,
        );
        lastMapPosition = kGooglePlex.target;
        setState(() {});
      }
    } else {
      //   print("Status not Resumed :" + state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ParkingModel model = widget.model;
    return FutureBuilder<List<dynamic>>(
        future: model.generateParkingMarkers(
            model.ticketMachineResponse?.response?.data?.row, context),
        builder: (context, snapshot) {
          print("Parking Model generateParkingMarkers Came");
          print(snapshot?.data?.length);
          print("Parking Model generateParkingMarkers End");
          /*    if (model.kGooglePlex != null &&
                        snapshot.connectionState == ConnectionState.done &&
                        ((model.ticketMachineResponse.response == null ||
                            model.ticketMachineResponse.response.data == null ||
                            model.ticketMachineResponse.response.data.row == null))) {
                      BotToast.showText(
                          text: AppLocalizations.of(context).translate('partners_view_no_partner_available'));
                    }*/
          /*    if (snapshot.hasData || snapshot.connectionState == ConnectionState.done) {*/
          return FutureBuilder<List<dynamic>>(
              future: getMarkers(snapshot.data, model),
              builder: (context, snapshot) {
                if (kGooglePlex != null &&
                    snapshot.hasData &&
                    snapshot.data != null) {
                  //  print("Get Markers came");
                  return GoogleMap(
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: kGooglePlex,
                    compassEnabled: true,
                    myLocationEnabled: true,
                    tiltGesturesEnabled: false,
                    mapToolbarEnabled: true,
                    myLocationButtonEnabled: true,
                    scrollGesturesEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      model.controller = controller;
                    },
                    onCameraMoveStarted: () {
                      //     print('onCameraMoveStarted');
                    },
                    onCameraIdle: () async {
                      //   print('onCameraIdle');
                      LatLng LastlocationData = lastMapPosition;
                      t = Timer(Duration(seconds: 2), () async {
                        //   print('camera not moving');
                        // TODO test if camera move > ScanningRadius
                        if (LastlocationData != null &&
                            !inParkingSession &&
                            !firstLoading) {
                          //    print('Camera Idle after 2s');
                          /*  Position location = Position.fromMap({
                                        'latitude': LastlocationData.latitude,
                                        'longitude': LastlocationData.longitude
                                      });*/
                          model
                              .getAllTicketMachinesForLocation(LastlocationData)
                              .then((value) {
                            if (!value) {
                              BotToast.showText(
                                  contentPadding: EdgeInsets.all(16),
                                  //   animationDuration: Duration(seconds: 2),
                                  duration: Duration(seconds: 4),
                                  contentColor: Colors.redAccent,
                                  text: model.errorMessage);
                            }
                          });
                        } else
                          firstLoading = false;
                      });
                    },
                    onCameraMove: (CameraPosition cameraposition) {
                      if (t != null) t.cancel();
                      //   print('camera moving ---');
                      lastMapPosition = cameraposition.target;
                      /*  if (model.ticketMachineResponse.response != null &&
                                      model.ticketMachineResponse.response.data != null &&
                                      model.ticketMachineResponse.response.data.row != null) {*/
                      if (currentZoom != cameraposition.zoom) {
                        currentZoom = cameraposition.zoom;
                        //   setState(() {});
                      }
                      //     print("Zoom from Ticket on move = " + kGooglePlex.zoom.toString());
                      //   }
                    },
                    markers: snapshot.data.toSet(),
                  );
                } else if (!kGpsEnabled) {
                  return Scaffold(
                      body: Center(
                          child: RaisedButton(
                    onPressed: () {
                      SystemSettings.location();
                      kGpstest = true;
                    },
                    child: Text(AppLocalizations.of(context)
                        .translate('location_service_required')),
                  )));
                } else {
                  return MobiLoader();
                }
              });
          //  }
          //   return Container();
        });
  }

  Future<List<Marker>> getMarkers(List<MapMarker> data, ParkingModel model) {
    // print("get Markers");
    if (data == null || data.isEmpty) {
      data = [];
    }
    fluster = Fluster<MapMarker>(
        minZoom: 0,
        maxZoom: 17,
        radius: 100,
        extent: 2048,
        nodeSize: 32,
        points: data,
        createCluster: (BaseCluster cluster, double lng, double lat) {
          //  print("Getting cluster Marker");
          return MapMarker(
            onTap: () {
              handleMarkerClick(model, cluster);
            },
            id: cluster.id.toString(),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarker,
            isCluster: cluster.isCluster,
            clusterId: cluster.id,
            pointsSize: cluster.pointsSize,
            childMarkerId: cluster.childMarkerId,
          );
        });
    return Future.wait(fluster.clusters(
        [-180, -85, 180, 85], currentZoom.toInt()).map((cluster) async {
      if (cluster.isCluster) {
        cluster.icon = await getClusterMarker(
            cluster.pointsSize, Colors.amber, Colors.white, kIsWeb ? 30 : 110);
      }
      return cluster.toMarker();
    }).toList());
  }

  Future<void> handleMarkerClick(
      ParkingModel model, BaseCluster cluster) async {
    print("on marker click");
    if (cluster.isCluster) {
      List<LatLng> latlng = [];
      for (MapMarker marker in fluster.children(cluster.id)) {
        latlng.add(LatLng(marker.latitude, marker.longitude));
      }
      //CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(boundsFromLatLngList(latlng), 50);
      // print("zoom-->" + cluster.zoom.toString());
      CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(CameraPosition(
          target: latlng[0], zoom: (cluster.zoom + 2).toDouble()));
      model.controller.animateCamera(cameraUpdate);
    } else {
      print('not a cluster');
    }
  }

/* LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }*/
}

/*class _ParkingMeterMapWidgetState extends State<ParkingMeterMapWidget> with WidgetsBindingObserver {
  Fluster<MapMarker> fluster;
  Fluster<WebMapMarker> flusterWeb;
  GlobalKey<webMap.GoogleMapStateBase> _key = GlobalKey<webMap.GoogleMapStateBase>();
  Timer timerForMapMovement;
  LatLng lastMapPosition;
  Timer t;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print("on dispose called for parking mapview");
    if (widget.model.controller != null) {
      widget.model.controller.dispose();
    }
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    if (AppLifecycleState.resumed == state && kGpstest) {
      locationGPS = await getCurrentLocation();
      kGpsEnabled = locationGPS != null;

      if (kGpsEnabled) {
        setState(() {});
      }
    } else {
      //   print("Status not Resumed :" + state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ParkingModel model = widget.model;
    return FutureBuilder<List<dynamic>>(
        future: kIsWeb
            ? model.generateParkingWebMarkers(model.ticketMachineResponse?.response?.data?.row, context)
            : model.generateParkingMarkers(model.ticketMachineResponse?.response?.data?.row, context),
        builder: (context, snapshot) {
          if (model.kGooglePlex != null &&
              snapshot.connectionState == ConnectionState.done &&
              ((model.ticketMachineResponse != null &&
                  (model.ticketMachineResponse.response == null ||
                      model.ticketMachineResponse.response.data == null ||
                      model.ticketMachineResponse.response.data.row == null)))) {
            BotToast.showText(text: AppLocalizations.of(context).translate('no_ticketmachines_available'));
          }
          if (snapshot.hasData || snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data);
            return FutureBuilder<List<dynamic>>(
                future: kIsWeb ? getWebMarkers(snapshot.data, model) : getMarkers(snapshot.data, model),
                builder: (context, snapshot) {
                  if (snapshot.hasData && model.kGooglePlex != null) {
                    print("Get Markers came");
                    return kIsWeb
                        ? webMap.GoogleMap(
                            markers: snapshot.data.toSet(),
                            key: _key,
                            initialZoom: model.kGooglePlex.zoom,
                            initialPosition:
                                webMap.GeoCoord(model.kGooglePlex.target.latitude, model.kGooglePlex.target.longitude),
                            webPreferences: webMap.WebMapPreferences(zoomControl: true),
                            mapType: webMap.MapType.roadmap,
                          )
                        : GoogleMap(
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            mapType: MapType.normal,
                            initialCameraPosition: model.kGooglePlex,
                            compassEnabled: true,
                            myLocationEnabled: true,
                            tiltGesturesEnabled: false,
                            mapToolbarEnabled: true,
                            myLocationButtonEnabled: true,
                            scrollGesturesEnabled: true,
                            onMapCreated: (GoogleMapController controller) {
                              if (model.controller != null) {
                                model.controller.dispose();
                              }
                              model.controller = controller;
                            },
                            onCameraMove: (cameraPosition) {
                              double distanceTravelled = model.calculateDistance(cameraPosition.target);
                              print("Distance Travelled $distanceTravelled");
                              if (timerForMapMovement != null && timerForMapMovement.isActive) {
                                print("Timer cancelled because of movement");
                                timerForMapMovement.cancel();
                              }
                              if (distanceTravelled >= TOTAL_DISTANCE_FOR_NEW_API_CALL) {
                                Position locationData = Position.fromMap({
                                  'latitude': cameraPosition.target.latitude,
                                  'longitude': cameraPosition.target.longitude
                                });
                                startTimer(model, locationData);
                              }
                              if (model.ticketMachineResponse.response != null &&
                                  model.ticketMachineResponse.response.data != null &&
                                  model.ticketMachineResponse.response.data.row != null) {
                                if (model.currentZoom != cameraPosition.zoom) {
                                  model.currentZoom = cameraPosition.zoom;
                                  print('zoom = ' + model.currentZoom.toString());
                                  setState(() {});
                                }
                              }
                            },
                            markers: snapshot.data.toSet(),
                          );
                  } else if (kGpsEnabled) {
                    return MobiLoader();
                  } else {
                    return Scaffold(
                        body: Center(
                            child: RaisedButton(
                              onPressed: () {
                                SystemSettings.location();
                                kGpstest = true;
                              },
                      child: Text(AppLocalizations.of(context).translate('location_service_required')),
                    )));
                    /*   return Container(
                      child: Center(
                          child: Text(AppLocalizations.of(context).translate(
                              'location_service_required')
                          )
                      ),
                    );*/
                  }
                });
          }
          return Container();
        });
  }

  void startTimer(model, locationData) {
    print("Timer called for new data points");
    timerForMapMovement = Timer(Duration(seconds: TOTAL_TIME_FOR_NEW_API_CALL), () async {
      print("Getting new data points after timeout");
      model.getAllTicketMachinesForLocation(locationData);
    });
  }

  Future<List<Marker>> getMarkers(List<MapMarker> data, ParkingModel model) {
    print("get getMarkers");
    if (data == null || data.isEmpty) {
      data = [];
      print("data is empty");
    }
    fluster = Fluster<MapMarker>(
        minZoom: 0,
        maxZoom: 20,
        radius: 400,
        extent: 2048,
        nodeSize: 32,
        points: data,
        createCluster: (BaseCluster cluster, double lng, double lat) {
          print("Getting cluster Marker");
          return MapMarker(
            onTap: () {
              handleMarkerClick(model, cluster);
            },
            id: cluster.id.toString(),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarker,
            isCluster: cluster.isCluster,
            clusterId: cluster.id,
            pointsSize: cluster.pointsSize,
            childMarkerId: cluster.childMarkerId,
          );
        });
    print("fluster created");
    return Future.wait(
        fluster.clusters([-180, -85, 180, 85], model.currentZoom.toInt()).map((cluster) async {
          if (cluster.isCluster) {
            cluster.icon = await getClusterMarker(cluster.pointsSize, Colors.amber, Colors.white, 110);
          }
          print("RETURN CLUSTER.TOMARKER");
          return cluster.toMarker();
        }).toList(),
        eagerError: false);
  }

  Future<List<webMap.Marker>> getWebMarkers(List<WebMapMarker> data, ParkingModel model) {
    if (data == null || data.isEmpty) {
      data = [];
    }
    List<webMap.Marker> markers = [];
    data.forEach((element) {
      markers.add(element.toWebMarker());
    }); //    print("get Markers");
    return Future<List<webMap.Marker>>.value(markers);
//    flusterWeb = Fluster<WebMapMarker>(
//        minZoom: 0,
//        maxZoom: 17,
//        radius: 0,
//        extent: 2048,
//        nodeSize: 0,
//        points: data,
//        createCluster: (BaseCluster cluster, double lng, double lat) {
//          print("Getting cluster Marker");
//          return WebMapMarker(
//            onTap: (value) {
//              handleMarkerClick(model, cluster);
//            },
//            id: cluster.id.toString(),
//            position: webMap.GeoCoord(lat, lng),
//            isCluster: cluster.isCluster,
//            clusterId: cluster.id,
//            pointsSize: cluster.pointsSize,
//            childMarkerId: cluster.childMarkerId,
//            icon: null,
//          );
//        });
//    return Future.wait(flusterWeb.clusters([-180, -85, 180, 85], model.currentZoom.toInt()).map((cluster) async {
//      if (cluster.isCluster) {
//        print("Is Cluster");
//        // cluster.icon = (await getWebClusterMarker(cluster.pointsSize, Colors.amber, Colors.white, 160)).toString();
//      }
//      return cluster.toWebMarker();
//    }).toList());
  }

  Future<void> handleMarkerClick(ParkingModel model, BaseCluster cluster) async {
    print("on marker click");
    if (cluster.isCluster) {
      List<LatLng> latlng = [];
      for (MapMarker marker in fluster.children(cluster.id)) {
        latlng.add(LatLng(marker.latitude, marker.longitude));
      }
      //CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(boundsFromLatLngList(latlng), 50);
      // print("zoom-->" + cluster.zoom.toString());
      CameraUpdate cameraUpdate =
          CameraUpdate.newCameraPosition(CameraPosition(target: latlng[0], zoom: (cluster.zoom + 2).toDouble()));
      model.controller.animateCamera(cameraUpdate);
    } else {
      print('not a cluster');
    }
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }
}*/
