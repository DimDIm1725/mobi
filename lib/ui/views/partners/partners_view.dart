import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/partners_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/views/partners/partner_detail_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:system_settings/system_settings.dart';

Position locationData;

class PartnersListView extends StatefulWidget {
  @override
  _PartnersListViewState createState() => _PartnersListViewState();
}

class _PartnersListViewState extends State<PartnersListView> {
  @override
  Widget build(BuildContext context) {
    return PartnersListWidget();
  }
}

class PartnersListWidget extends StatefulWidget {
  @override
  _PartnersListWidgetState createState() => _PartnersListWidgetState();
}

class _PartnersListWidgetState extends State<PartnersListWidget>
    with WidgetsBindingObserver {
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
      if (!kGpsEnabled) {
        BotToast.showText(
            contentPadding: EdgeInsets.all(16),
            //   animationDuration: Duration(seconds: 2),
            duration: Duration(seconds: 4),
            contentColor: Colors.redAccent,
            text: (AppLocalizations.of(context)
                    .translate('location_service_required') +
                '\n' +
                AppLocalizations.of(context)
                    .translate('partner_model_location_required')));
      } else {
        model.setState(ViewState.Busy);
        locationData = await getCurrentLocation();
        kGpsEnabled = locationData != null;
        LatLng locData = LatLng(locationData.latitude, locationData.longitude);
        await model.getAllActivities();
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
                      .translate('partner_model_location_required')));
        } else {
          LatLng locData =
              LatLng(locationData.latitude, locationData.longitude);
          await model.getAllPartnersByGeoLocation(locData);
        }
      }
    }, builder: (context, model, child) {
      return MobiAppBar(
        child: ModalProgressHUD(
          inAsyncCall: model.state == ViewState.Busy,
          child: Consumer<DrawerAndToolbar>(
            builder: (context, indexData, _) {
              if (model.partnersList != null &&
                  model.partnersList.response.data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 72,
                        color: MobiTheme.colorIcon,
                      ),
                      SizedBox(height: 16),
                      Text(AppLocalizations.of(context).translate('sorry'),
                          style: MobiTheme.text16BoldWhite),
                      Text(
                          AppLocalizations.of(context)
                              .translate('partners_view_no_partner_available'),
                          style: MobiTheme.text16BoldWhite),
                    ],
                  ),
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
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: model.partnersList?.response?.data?.row?.length ?? 0,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: MobiTheme.lightBlue,
                          isDismissible: true,
                          builder: (BuildContext bc) {
                            return Container(
                              height:
                                  MediaQuery.of(context).size.height * 1 / 2,
                              padding: EdgeInsets.only(
                                  left: 30.0, right: 16.0, top: 10.0),
                              child: SingleChildScrollView(
                                  child: PartnerInfoWidget(model
                                      .partnersList.response.data.row[index])),
                            );
                          });
                      /*  Navigator.pushNamed(context, PartnerDetailView.routeName,
                          arguments: model.partnersList?.response?.data?.row[index]);*/
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      '${model.partnersList.response.data?.row[index].partnerCompanyName}',
                                      style: MobiTheme.text16BoldWhite,
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
                                              Radius.circular(8))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${model.partnersList.response.data?.row[index].clusterName}',
                                          style: MobiTheme.text16BoldWhite,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            decoration:
                                BoxDecoration(color: MobiTheme.colorCompanion),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 24),
                            child: MobiText(
                              prefixIcon: Icon(Icons.euro_symbol,
                                  color: MobiTheme.colorIcon),
                              text:
                                  '${AppLocalizations.of(context).translate('available')} : ${model.partnersList.response.data?.row[index].transactionAvailableAmount} ${model.partnersList.response.data?.row[index].currencySymbol}',
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 24,
                            ),
                            child: MobiText(
                              prefixIcon: Icon(Icons.card_giftcard,
                                  color: MobiTheme.colorIcon),
                              text:
                                  '${AppLocalizations.of(context).translate('cashback')} ${model.partnersList.response.data?.row[index].transactionPercentage} %',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    });
  }
}
