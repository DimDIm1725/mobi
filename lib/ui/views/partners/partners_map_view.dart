import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/cluster_marker.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/partners_model.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/map_marker.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/shared/web_map_marker.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:system_settings/system_settings.dart';

Position locationData;

class PartnersMapView extends StatefulWidget {
  @override
  _PartnersMapViewState createState() => _PartnersMapViewState();
}

class _PartnersMapViewState extends State<PartnersMapView> {
  @override
  Widget build(BuildContext context) {
    return PartnersListWidget();
  }
}

class PartnersListWidget extends StatefulWidget {
  @override
  _PartnersListWidgetState createState() => _PartnersListWidgetState();
}

class _PartnersListWidgetState extends State<PartnersListWidget> with WidgetsBindingObserver {
  Fluster<MapMarker> fluster;

//  LatLng lastMapPosition;
  Timer timerForIdleDurationOnMap;
  GoogleMap googleMap;
  bool calledFirstTime = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    return BaseView<PartnersModel>(onModelReady: (model) async {
      /*   double lat = SharedPrefUtil.getLatLocationData();
      double lon = SharedPrefUtil.getLonLocationData();
      LatLng locationData = LatLng(lat,lon);*/
      // await model.getAllActivities();
      if (lastMapPosition == null) {
        locationData = await getCurrentLocation();
        kGpsEnabled = locationData != null;
        if (locationData == null) {
          BotToast.showText(
              contentPadding: EdgeInsets.all(16),
              //   animationDuration: Duration(seconds: 2),
              duration: Duration(seconds: 4),
              contentColor: Colors.redAccent,
              text: (AppLocalizations.of(context).translate('location_service_required') +
                  '\n' +
                  AppLocalizations.of(context).translate('partner_model_location_required')));
        } else {
          lastMapPosition = LatLng(locationData.latitude, locationData.longitude);
        }
      }

      if (lastMapPosition != null) {
     //   print("Called From BUILD getAllPartnersByGeoLocation");
        bool status = await model.getAllPartnersByGeoLocation(lastMapPosition);

        if (!status) {
          BotToast.showText(
              contentPadding: EdgeInsets.all(16),
              //   animationDuration: Duration(seconds: 2),
              duration: Duration(seconds: 4),
              contentColor: Colors.redAccent,
              text: model.errorMessage);
        }
      }

      model.setState(ViewState.Idle);
    }, builder: (context, model, child) {
      return MobiAppBar(
        child: ModalProgressHUD(
          inAsyncCall: model.state == ViewState.Busy,
          child: Consumer<DrawerAndToolbar>(builder: (context, indexData, _) {
            return FutureBuilder<List<dynamic>>(
                future: model.generateMarkers(model.partnersList?.response?.data?.row, context),
                builder: (context, snapshot) {
                  /*  if (snapshot.connectionState == ConnectionState.done) {*/
                  return FutureBuilder<List<dynamic>>(
                      future: getMarkers(snapshot.data, model),
                      builder: (context, snapshot) {
                        //   print("model.kGooglePlex != null ${model.kGooglePlex != null}");
                        if (kGooglePlex != null && snapshot != null && snapshot.data != null) {
                       //   print("Get Markers came..");
                       //   print(snapshot?.data?.length);
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
                              print('onCameraIdle');
                              LatLng lastLocationData = lastMapPosition;
                              //   print('last location = ' + LastlocationData.toString());
                              /*  if (timerForIdleDurationOnMap != null &&
                                                timerForIdleDurationOnMap.isActive) {
                                        //      print("Timer found and cancelled");
                                              timerForIdleDurationOnMap.cancel();
                                            }*/

                              //       if (LastlocationData != null /*&& model.calculateGPSDistance(LastlocationData) > 10*/) {
                              timerForIdleDurationOnMap = Timer(Duration(seconds: 2), () async {
                                //        print('camera not moving after 2s');
                                if (lastLocationData != null && !inParkingSession && !calledFirstTime) {
                               //   print('onCameraIdle calling getAllPartnersByGeoLocation');
                                  model.getAllPartnersByGeoLocation(lastLocationData).then((value) {
                                    if (!value) {
                                      BotToast.showText(
                                          contentPadding: EdgeInsets.all(16),
                                          //   animationDuration: Duration(seconds: 2),
                                          duration: Duration(seconds: 4),
                                          contentColor: Colors.redAccent,
                                          text: model.errorMessage);
                                    }
                                    ;
                                    //   setState(() {});
                                  });
                                }

                                if (calledFirstTime) {
                                  calledFirstTime = false;
                                }
                              });
                            },
                            onCameraMove: (CameraPosition cameraposition) {
                              if (timerForIdleDurationOnMap != null) timerForIdleDurationOnMap.cancel();
                              //     print('camera moving ---');
                              lastMapPosition = cameraposition.target;
                              /*    if (model.partnersList.response != null &&
                                                model.partnersList.response.data != null &&
                                                model.partnersList.response.data.row != null) {*/
                              if (currentZoom != cameraposition.zoom) {
                                currentZoom = cameraposition.zoom;
                                //   setState(() {});
                              }
                              //    print("Zoom from Partners on move = " + kGooglePlex.zoom.toString());
                              //   }
                            },
                            markers: snapshot?.data?.toSet(),
                          );
                        } else if (!kGpsEnabled) {
                          return Center(
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
                              child: Text(AppLocalizations.of(context).translate('location_service_required')),
                            ),
                          );
                        } else {
                          return MobiLoader();
                        }
                      });
                  /* } else {
                          return getMap(model);
                        }*/
                  // print("SHowing container");
                  // return Container();
                });
          }
              /*  : kGpsEnabled
                      ? MobiLoader()
                      : Scaffold(
                          body: Center(
                              child: RaisedButton(
                          onPressed: () {
                            SystemSettings.location();
                            kGpstest = true;
                          },
                          child: Text(AppLocalizations.of(context).translate('location_service_required')),
                        )))*/
              ),
        ),
      );
    });
  }

  /*getMap(PartnersModel model) {
    if (googleMap == null) {
      googleMap = kIsWeb
          ? webMap.GoogleMap(
              key: _key,
              initialZoom: kGooglePlex.zoom,
              initialPosition: webMap.GeoCoord(kGooglePlex.target.latitude, kGooglePlex.target.longitude),
              webPreferences: webMap.WebMapPreferences(zoomControl: true),
              mapType: webMap.MapType.roadmap,
            )
          : GoogleMap(
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
              markers:null
            );
    }

    return googleMap;
  }*/

  Future<List<Marker>> getMarkers(List<MapMarker> data, PartnersModel model) {
    //  print("get Markers");
    if (data == null || data.isEmpty) {
      data = [];
    }
    fluster = Fluster<MapMarker>(
        minZoom: 0,
        maxZoom: 17,
        radius: 400,
        extent: 2048,
        nodeSize: 32,
        points: data,
        createCluster: (BaseCluster cluster, double lng, double lat) {
          //   print("Getting cluster Marker");
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
    return Future.wait(fluster.clusters([-180, -85, 180, 85], currentZoom.toInt()).map((cluster) async {
      if (cluster.isCluster) {
        cluster.icon = await getClusterMarker(cluster.pointsSize, Colors.amber, Colors.white, kIsWeb ? 30 : 110);
      }
      return cluster.toMarker();
    }).toList());
  }

  Future<void> handleMarkerClick(PartnersModel model, BaseCluster cluster) async {
    //  print("on marker click");
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
      //  print('not a cluster');
    }
  }

/*  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
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

/*
Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Visibility(
                    visible: model.partnersList != null &&
                        model.partnersList.response.data == null,
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                'Sorry',
                                style: getCustomStyle(context,
                                    color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(color: Colors.blueAccent),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            child: MobiText(
                              text:
                                  'No partner available in currently searched radius',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          model.partnersList?.response?.data?.row?.length ?? 0,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PartnerDetailView.routeName,
                                arguments: model
                                    .partnersList?.response?.data?.row[index]);
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Flexible(
                                          child: Text(
                                            '${model.partnersList.response.data?.row[index].partnerCompanyName}',
                                            style: getCustomStyle(context,
                                                color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Flexible(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: model
                                                            .partnersList
                                                            .response
                                                            .data
                                                            ?.row[index]
                                                            .clusterType ==
                                                        "1"
                                                    ? Colors.green
                                                    : (model
                                                                .partnersList
                                                                .response
                                                                .data
                                                                ?.row[index]
                                                                .clusterType ==
                                                            "2")
                                                        ? Colors.red
                                                        : Colors.yellow,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                '${model.partnersList.response.data?.row[index].clusterName}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration:
                                      BoxDecoration(color: Colors.blueAccent),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                  child: MobiText(
                                    prefixIcon: Icon(Icons.euro_symbol),
                                    text:
                                        'available ${model.partnersList.response.data?.row[index].transactionAvailableAmount} ${model.partnersList.response.data?.row[index].currencySymbol}',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 24),
                                  child: MobiText(
                                    prefixIcon: Icon(Icons.card_giftcard),
                                    text:
                                        'Cashback ${model.partnersList.response.data?.row[index].transactionPercentage} %',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
 */
