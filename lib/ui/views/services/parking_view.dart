import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:mobiwoom/core/models/requests/parkingStart.dart'
    as parkingStartReq;
import 'package:mobiwoom/core/models/requests/ticket_machine.dart' as tktReq;
import 'package:mobiwoom/core/models/responses/ticket_machine.dart'
    as ticketMachinesResponse;
import 'package:mobiwoom/core/utils/constants.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/card_model.dart';
import 'package:mobiwoom/core/viewmodels/parking_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/views/account/3d_secure_bank_view.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/views/services/ticketMachine_detail_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/locator.dart';
import '../../widgets/custom_widgets.dart';
import 'package:mobiwoom/core/utils/app_config.dart';

String resultingCreationDateFormat = 'HH:mm\ndd/MM/yyyy';
String incomingCreationDateFormat = 'yyyy/MM/dd HH:mm';

class ParkingView extends StatefulWidget {
  ticketMachinesResponse.Row ticketMachineDetail;
  ParkingModel parentParkingModel;

  @override
  _ParkingViewState createState() => _ParkingViewState();

  ParkingView({this.ticketMachineDetail, this.parentParkingModel});
}

GoogleMapsPlaces _places = GoogleMapsPlaces(
  apiKey: kGooglePlacesApiKey,
  baseUrl: kIsWeb
      ? 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api'
      : null,
);

class _ParkingViewState extends State<ParkingView> {
  @override
  Widget build(BuildContext context) {
    return ParkingWidget(
        ticketMachineDetail: widget.ticketMachineDetail,
        parentParkingModel: widget.parentParkingModel);
  }
}

class ParkingWidget extends StatefulWidget {
  ticketMachinesResponse.Row ticketMachineDetail;
  ParkingModel parentParkingModel;

  ParkingWidget({this.ticketMachineDetail, this.parentParkingModel});

  @override
  _ParkingWidgetState createState() => _ParkingWidgetState();
}

class _ParkingWidgetState extends State<ParkingWidget> {
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<ParkingModel>(onModelReady: (model) async {
      model.ticketMachineRequest =
          tktReq.TicketMachineRequest(data: tktReq.Data());
      model.parkingStartRequest = parkingStartReq.ParkingStartRequest(
          data: parkingStartReq.Data(duration: 0.0));
      model.ticketMachineRequest.data.userLatitude =
          widget.ticketMachineDetail.ticketMachineLat;
      model.ticketMachineRequest.data.userLongitude =
          widget.ticketMachineDetail.ticketMachineLon;
      _addressController.text = widget.ticketMachineDetail.ticketMachineAddress;
      model.selectedParkingMeter = widget.ticketMachineDetail;
      model.populateLicensePlates();
      //setParkingMeterDefaults(model, 0);
      // CardModel cardModel = new CardModel();
      // await cardModel.getAllSavedCards();
      // await cardModel.getAllSavedCards();
      // if (cardModel.card == null) {
      //   print("cardModel.card == null");
      // } else {
      //   print("Huzefa");
      //   print(cardModel.card.toJson());
      //   if (cardModel.card.response.data?.row?.length > 0) {
      //     print("cardModel.card.response.data?.row?.length > 0");
      //     for (var card in cardModel.card.response.data?.row) {
      //       if (card?.main == 'True') {
      //         print(card?.main == 'True');
      //         model.parkingRequest.data.creditCardToken = card?.token;
      //       }
      //     }
      //   }
      // }
    }, builder: (context, model, child) {
      return ModalProgressHUD(
        inAsyncCall: model.state == ViewState.Busy,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: model.activeParkingLicensePlate == null,
                child: Column(
                  children: <Widget>[
                    MobiText(
                        text: widget.ticketMachineDetail.pricingAreaName +
                            " - durée max : " +
                            widget.ticketMachineDetail
                                .pricingAreaDefaultDuration +
                            " mn" +
                            "\nHorodateur à " +
                            (double.parse(widget.ticketMachineDetail
                                        .ticketMachineDistance) *
                                    1000)
                                .toString() +
                            " mètres",
                        textStyle: MobiTheme.text16Black,
                        prefixIcon: Icon(
                          Icons.wifi_lock_sharp,
                          color: MobiTheme.colorIcon,
                          size: 30,
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ),
                      child: model.vehiclePlateDropdownMenuItemList.isNotEmpty
                          ? MobiDropDown(
                              value:
                                  model.parkingStartRequest?.data?.userCarPlate,
                              prefixIcon: Icon(Icons.directions_car,
                                  color: MobiTheme.colorIcon),
                              onChanged: (value) {
                                model.parkingStartRequest?.data?.userCarPlate =
                                    value;
                              },
                              textColor: Colors.white,
                              items: model.vehiclePlateDropdownMenuItemList,
                              // hint: AppLocalizations.of(context).translate('choose_vehicle'),
                            )
                          : Container(
                              child: MobiButton(
                                padding: const EdgeInsets.all(16),
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                      context, "addLicense");
                                  model.populateLicensePlates();
                                },
                                text: AppLocalizations.of(context)
                                    .translate('add_license_plate'),
                              ),
                            ),
                    ),
                    SizedBox(height: 5),
                    Visibility(
                      visible: model.isCreditCardAvailable,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.timer,
                                    size: 32, color: MobiTheme.colorIcon),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: MobiTheme.colorCompanion,
                                    inactiveTrackColor: Colors.green[100],
                                    trackShape: RoundedRectSliderTrackShape(),
                                    trackHeight: 5.0,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 20.0),
                                    thumbColor: MobiTheme.colorCompanion,
                                    overlayColor: Colors.green.withAlpha(32),
                                    overlayShape: RoundSliderOverlayShape(
                                        overlayRadius: 28.0),
                                    tickMarkShape: RoundSliderTickMarkShape(),
                                    activeTickMarkColor:
                                        MobiTheme.colorCompanion,
                                    inactiveTickMarkColor: Colors.green[100],
                                    valueIndicatorShape:
                                        PaddleSliderValueIndicatorShape(),
                                    valueIndicatorColor:
                                        MobiTheme.colorCompanion,
                                    valueIndicatorTextStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Slider(
                                    label: model
                                        .parkingStartRequest?.data?.duration
                                        ?.toInt()
                                        .toString(),
                                    value: model.parkingStartRequest.data
                                            ?.duration ??
                                        0,
                                    onChanged: (double value) {
                                      model.estimatedParkingCharges = model
                                          .getEstimatedParkingFeesForDuration(
                                              value);
                                      model.parkingStartRequest.data?.duration =
                                          value.toInt().toDouble();
                                      model.setState(ViewState.Idle);
                                    },
                                    max: model.selectedParkingMeter != null
                                        ? double.parse(model
                                            .selectedParkingMeter
                                            .pricingAreaDefaultDuration)
                                        : 0,
                                    min: 0,
                                    divisions:
                                        model.selectedParkingMeter != null
                                            ? int.parse(model
                                                .selectedParkingMeter
                                                .pricingAreaMaxDuration)
                                            : 1,
                                  ),
                                ),
                                Text(model.parkingStartRequest?.data?.duration
                                        ?.toInt()
                                        .toString() +
                                    ' mn'),
                              ],
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '${AppLocalizations.of(context).translate('estimated_total_cost')} ${model.estimatedParkingCharges.toStringAsFixed(2)} €',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          SizedBox(height: 16),
                          Visibility(
                            visible: model.parkingStartRequest.data?.duration !=
                                    null &&
                                (model.parkingStartRequest.data?.duration ??
                                        0) >
                                    0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 16,
                              ),
                              child: MobiButton(
                                padding: const EdgeInsets.all(16),
                                text: AppLocalizations.of(context)
                                    .translate('start'),
                                onPressed: () {
                                  if (model.parkingStartRequest.data
                                          .creditCardToken ==
                                      null) {
                                    showErrorMessage(
                                      AppLocalizations.of(context).translate(
                                        'parking_view_add_credit_card',
                                      ),
                                    );
                                    return;
                                  }

                                  if (model.parkingStartRequest?.data
                                          ?.userCarPlate ==
                                      null) {
                                    showErrorMessage(
                                      AppLocalizations.of(context).translate(
                                        'parking_view_add_vehicle',
                                      ),
                                    );
                                    return;
                                  }

                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text(AppLocalizations.of(
                                                  context)
                                              .translate(
                                                  'parking_view_start_confirmation')),
                                          content: Text(model
                                              .selectedParkingMeter
                                              .pricingAreaName),
                                          actions: <Widget>[
                                            new FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .translate('cancel')),
                                            ),
                                            new FlatButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                model
                                                    .startParkingSession()
                                                    .then((value) async {
                                                  BotToast.showText(
                                                      contentPadding:
                                                          EdgeInsets.all(16),
                                                      //   animationDuration: Duration(seconds: 2),
                                                      duration:
                                                          Duration(seconds: 4),
                                                      textStyle: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.black),
                                                      contentColor: value
                                                          ? Colors.greenAccent
                                                          : Colors.redAccent,
                                                      text: value
                                                          ? model.successMessage
                                                          : model.errorMessage);
                                                  if (value) {
                                                    widget.parentParkingModel
                                                        .populateLicensePlates();
                                                    Navigator.pop(context);
                                                  }
                                                });
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .translate('confirm'),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                color: Colors.lightGreen,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    CreditCardWidget(model),
                  ],
                ),
              ),
              Visibility(
                visible: model.activeParkingLicensePlate != null,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ElapsedTimeWidget(model),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: MobiTheme.nearlyBlue,
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context).translate(
                                        'parking_view_current_parking'),
                                    style: getCustomStyle(context,
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: MobiText(
                                    text: model
                                        .activeParkingLicensePlate?.carPlate,
                                    prefixIcon: Icon(Icons.directions_car),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: MobiText(
                                    text: model.activeParkingLicensePlate
                                        ?.pricingAreaName,
                                    prefixIcon: Icon(Icons.location_on),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: MobiText(
                                    text:
                                        '${AppLocalizations.of(context).translate('started_at')} : ${model.activeParkingLicensePlate?.startDateTime == null ? '' : DateFormat(resultingCreationDateFormat).format(
                                            DateFormat(
                                                    incomingCreationDateFormat)
                                                .parse(model
                                                    .activeParkingLicensePlate
                                                    ?.startDateTime),
                                          )}',
                                    prefixIcon: Icon(Icons.access_time,
                                        color: MobiTheme.colorIcon),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: MobiText(
                                    text:
                                        '${AppLocalizations.of(context).translate('ends_at')} : ${model.activeParkingLicensePlate?.stopDateTime == null ? '' : DateFormat(resultingCreationDateFormat).format(
                                            DateFormat(
                                                    incomingCreationDateFormat)
                                                .parse(model
                                                    .activeParkingLicensePlate
                                                    ?.stopDateTime),
                                          )}',
                                    prefixIcon: Icon(Icons.access_time,
                                        color: MobiTheme.colorIcon),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: MobiButton(
                          padding: const EdgeInsets.all(16),
                          text: AppLocalizations.of(context).translate('stop'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(AppLocalizations.of(context)
                                        .translate(
                                            'parking_view_stop_confirmation')),
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
                                          model
                                              .stopParkingSession()
                                              .then((value) {
                                            BotToast.showText(
                                                contentPadding:
                                                    EdgeInsets.all(16),
                                                //   animationDuration: Duration(seconds: 2),
                                                duration: Duration(seconds: 4),
                                                textStyle: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black),
                                                contentColor: value
                                                    ? Colors.greenAccent
                                                    : Colors.redAccent,
                                                text: value
                                                    ? model.successMessage
                                                    : model.errorMessage);
                                            if (value) {
                                              model.populateLicensePlates();
                                            }
                                          });
                                        },
                                        child: Text(AppLocalizations.of(context)
                                            .translate('confirm')),
                                      ),
                                    ],
                                  );
                                });
                          },
                          color: Colors.redAccent,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  /* Future<void> getUserLocationAndPopulateAddress(ParkingModel model) async {
    model.setState(ViewState.Busy);
    loc.Position _locationData = await getCurrentLocation();
    if (_locationData != null) {
      PlacesSearchResponse response = await _places.searchNearbyWithRankBy(
          Location(_locationData.latitude, _locationData.longitude), 'distance',
          type: 'establishment');
      model.setState(ViewState.Idle);
      if (response.results.isNotEmpty) {
        _addressController.text = response.results[0].vicinity;
        model.ticketMachineRequest.data.userLatitude = _locationData.latitude.toString();
        model.ticketMachineRequest.data.userLongitude = _locationData.longitude.toString();
        model.populateLicensePlates();
      } else {
        model.setState(ViewState.Idle);
        BotToast.showText(
            contentPadding: EdgeInsets.all(16),
            //   animationDuration: Duration(seconds: 2),
            duration: Duration(seconds: 4),
            contentColor: Colors.redAccent,
            text: AppLocalizations.of(context).translate('unable_to_find_address'));
      }
    } else {
      model.setState(ViewState.Idle);
      BotToast.showText(
          contentPadding: EdgeInsets.all(16),
          //  animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 4),
          contentColor: Colors.redAccent,
          text: (AppLocalizations.of(context).translate('location_service_required') + '\n'
          + AppLocalizations.of(context).translate('enter_address')));
    }
  }*/

  void setParkingMeterDefaults(ParkingModel model, int value) {
    if (model.ticketMachineResponse.response.data?.row[value] != null) {
      model.selectedParkingMeter =
          model.ticketMachineResponse.response.data.row[value];
      // print(model.selectedParkingMeter.pricingAreaName);
      model.setParkingFeesFormulaExpression(
          model.selectedParkingMeter.pricingAreaAmountCalculationFormula);
      model.parkingStartRequest.data.ticketMachineId =
          model.selectedParkingMeter.ticketMachineId;
      model.parkingStartRequest.data.duration =
          double.parse(model.selectedParkingMeter.pricingAreaDefaultDuration);
      model.estimatedParkingCharges = model.getEstimatedParkingFeesForDuration(
          model.parkingStartRequest.data.duration);
    }

    model.setState(ViewState.Idle);
  }
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
  int duration;

  @override
  void initState() {
    getETA();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: duration <= 60
                ? Colors.redAccent
                : duration <= 300
                    ? Colors.orange
                    : Colors.lightGreen,
            borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context).translate('remaining_time'),
              style: getCustomStyle(context, color: Colors.white),
            ),
            SizedBox(
              height: 10,
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
    duration = widget.model.getETA();
    if (duration <= 0) {
      ETA = AppLocalizations.of(
              locator<Application>().navigatorKey.currentContext)
          .translate('time_elapsed');
    } else {
      timer = new Timer.periodic(Duration(seconds: 1), (timer) {
        int hour = (duration / (60 * 60)).toInt();
        int minutes = (duration / (60)).toInt() % 60;
        int seconds = (duration % 60).toInt();
        duration -= 1;
        if (duration < 0) {
          ETA = AppLocalizations.of(
                  locator<Application>().navigatorKey.currentContext)
              .translate('time_elapsed');
          timer.cancel();
          setState(() {});
        } else {
          ETA =
              '${hour.toString().padLeft(2, '0')} h : ${minutes.toString().padLeft(2, '0')} m : ${seconds.toString().padLeft(2, '0')} s';
          setState(() {});
        }
      });
    }
  }
}

class CreditCardWidget extends StatefulWidget {
  final ParkingModel model;

  CreditCardWidget(this.model);

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  int selectedCard;
  int mainCard;
  bool showSetAsMainCardButton = false;

  @override
  Widget build(BuildContext context) {
    return BaseView<CardModel>(onModelReady: (cardModel) async {
      //await cardModel.getAllSavedCards();
      Future.delayed(const Duration(milliseconds: 500), () async {
        await cardModel.getAllSavedCards(); // hack to fix the auth issue
        if (cardModel.card.response.data == null) {
          widget.model.isCreditCardAvailable = false;
          widget.model.setState(ViewState.Idle);
        } else {
          widget.model.isCreditCardAvailable = true;
          for (var card in cardModel.card.response.data?.row) {
            if (card?.main == 'True') {
              print("widget.model.parkingRequest.data.creditCardToken");
              widget.model.parkingStartRequest.data.creditCardToken =
                  card?.token;
            }
          }
          widget.model.setState(ViewState.Idle);
        }
      });
    }, builder: (context, model, child) {
      if (model.card == null) {
        return MobiLoader();
      } else {
        return ModalProgressHUD(
          inAsyncCall: model.state == ViewState.Busy,
          child: model.card.response.data != null
              ? Container()
              : Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate('no_creditcards_found'),
                      style: MobiTheme.text16BoldWhite,
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MobiButton(
                        padding: const EdgeInsets.all(16),
                        onPressed: () async {
                          await Navigator.pushNamed(
                              context, ThreeDSecureBankView.routeName);
                          await model.getAllSavedCards();
                          if (model.card.response.data == null) {
                            widget.model.isCreditCardAvailable = false;
                            widget.model.setState(ViewState.Idle);
                          } else {
                            widget.model.isCreditCardAvailable = true;
                            for (var card in model.card.response.data?.row) {
                              if (card?.main == 'True') {
                                print(
                                    "widget.model.parkingRequest.data.creditCardToken");
                                widget.model.parkingStartRequest.data
                                    .creditCardToken = card?.token;
                              }
                            }
                            widget.model.setState(ViewState.Idle);
                          }
                        },
                        text: AppLocalizations.of(context)
                            .translate('add_new_card'),
                      ),
                    ),
                  ],
                ),
        );
      }
    });
  }
}
