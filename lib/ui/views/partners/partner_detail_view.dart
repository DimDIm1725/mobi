import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobiwoom/core/models/responses/partner.dart' as partnerRes;
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/partners_model.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';

class PartnerDetailView extends StatefulWidget {
  partnerRes.Row partnerDetail;

  static const String routeName = "partnerDetailView";

  @override
  _PartnerDetailViewState createState() =>
      _PartnerDetailViewState(partnerDetail);

  void setPartnerDetail(partnerRes.Row partnerDetail) {
    this.partnerDetail = partnerDetail;
  }
}

class _PartnerDetailViewState extends State<PartnerDetailView> {
  partnerRes.Row partnerDetail;

  _PartnerDetailViewState(this.partnerDetail);

  Completer<GoogleMapController> _controller = Completer();
  // CameraPosition _kGooglePlex;
  Set<Marker> markers = Set();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
          color: Color(0xff061f39),
          child: BaseView<PartnersModel>(onModelReady: (model) async {
            LatLng location = LatLng(
                double.parse(partnerDetail.partnerLatitude),
                double.parse(partnerDetail.partnerLongitude));
            kGooglePlex = CameraPosition(
              target: location,
              zoom: currentZoom,
            );
            //   markers.add(Marker(markerId: MarkerId("Huzefa"), position: location));
          }, builder: (context, model, child) {
            return ModalProgressHUD(
              inAsyncCall: model.state == ViewState.Busy,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)
                      .translate('partner_details')),
                ),
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 300,
                        child: GoogleMap(
                          zoomGesturesEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition: kGooglePlex,
                          compassEnabled: true,
                          myLocationEnabled: true,
                          tiltGesturesEnabled: true,
                          mapToolbarEnabled: true,
                          myLocationButtonEnabled: true,
                          scrollGesturesEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            //  _controller.complete(controller);
                            model.controller = controller;
                          },
                          onCameraMove: (cameraposition) {
                            if (currentZoom != cameraposition.zoom) {
                              currentZoom = cameraposition.zoom;
                              setState(() {});
                            }
                            //   print("Zoom from details = " + kGooglePlex.zoom.toString());
                          },
                          markers: markers,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 16.0, top: 10.0),
                      child: SingleChildScrollView(
                          child: PartnerInfoWidget(widget.partnerDetail)),
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }
}

class PartnerInfoWidget extends StatelessWidget {
  partnerRes.Row partnerDetail;

  PartnerInfoWidget(this.partnerDetail);

  @override
  Widget build(BuildContext context) {
    double cashback = 0;
    try {
      cashback = double.parse(partnerDetail.transactionPercentage);
    } catch (e) {
      print(e);
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MobiText(
              text: partnerDetail.partnerCompanyName,
              textStyle: Theme.of(context).textTheme.subtitle1,
              prefixIcon: MyIcon(
                Icons.store_mall_directory,
              )),
          SizedBox(
            height: 16,
          ),
          MobiText(
            text: partnerDetail.partnerAddress,
            textStyle: Theme.of(context).textTheme.subtitle1,
            prefixIcon: MyIcon(
              Icons.location_on,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          MobiText(
            onTap: () => launch("tel://${partnerDetail.partnerPhoneNumber}"),
            text: partnerDetail.partnerPhoneNumber,
            textStyle: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.blueAccent),
            prefixIcon: MyIcon(
              Icons.phone,
            ),
          ),
          Visibility(
            visible: cashback != 0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                MobiText(
                  text:
                      '${AppLocalizations.of(context).translate('cashback')} ${partnerDetail.transactionPercentage}%',
                  textStyle: Theme.of(context).textTheme.subtitle1,
                  prefixIcon: MyIcon(
                    Icons.card_giftcard,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: partnerDetail.partnerAdditionalInformation != null &&
                partnerDetail.partnerAdditionalInformation.isNotEmpty,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                MobiText(
                  text:
                      '${AppLocalizations.of(context).translate('additional_info')} ${partnerDetail.partnerAdditionalInformation}',
                  textStyle: Theme.of(context).textTheme.subtitle1,
                  prefixIcon: MyIcon(
                    Icons.info,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          MobiText(
            text:
                '${AppLocalizations.of(context).translate('cercle')} ${partnerDetail.clusterName}',
            textStyle: Theme.of(context).textTheme.subtitle1,
            prefixIcon: MyIcon(
              Icons.label,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            child: Container(
              color: Colors.grey[400],
            ),
            height: 1,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              AppLocalizations.of(context).translate('sponsorship'),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              AppLocalizations.of(context)
                  .translate('partner_detail_view_sponsorship_advantages'),
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          MobiText(
            text:
                '${AppLocalizations.of(context).translate('you')} ${partnerDetail.partnerVoucherValueSponsor} ${partnerDetail.currencySymbol}',
            textStyle: Theme.of(context).textTheme.subtitle1,
            prefixIcon: MyIcon(
              Icons.label,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          MobiText(
            text:
                '${AppLocalizations.of(context).translate('your_child')} ${partnerDetail.partnerVoucherValueSponsored} ${partnerDetail.currencySymbol}',
            textStyle: Theme.of(context).textTheme.subtitle1,
            prefixIcon: MyIcon(
              Icons.label,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

class MyIcon extends StatelessWidget {
  IconData icon;

  MyIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: MobiTheme.colorIcon,
      size: 30,
    );
  }
}
