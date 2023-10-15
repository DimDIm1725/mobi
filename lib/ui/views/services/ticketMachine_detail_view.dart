/*class TicketMachineDetailView extends StatefulWidget {
  ticketMachineRes.Row ticketMachineDetail;
  licenseRes.Row licenseResDetail;

  static const String routeName = "partnerDetailView";

  @override
  _TicketMachineDetailViewState createState() => _TicketMachineDetailViewState(ticketMachineDetail);

  void setTicketMachineDetail(ticketMachineRes.Row TicketMachineDetail) {
    this.ticketMachineDetail = ticketMachineDetail;
  }
}

class _TicketMachineDetailViewState extends State<TicketMachineDetailView> {
  ticketMachineRes.Row ticketMachineDetail;

  _TicketMachineDetailViewState(this.ticketMachineDetail);

  Completer<GoogleMapController> _controller = Completer();
//  CameraPosition _kGooglePlex;
  Set<Marker> markers = Set();
  Set<webMap.Marker> webMapMarkers = Set();
  GlobalKey<webMap.GoogleMapStateBase> _key = GlobalKey<webMap.GoogleMapStateBase>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Consumer<DrawerAndToolbar>(
        builder: (context, indexData, _) => Container(
            color: Color(0xff061f39),
            child: BaseView<TicketMachinesModel>(onModelReady: (model) async {
              LatLng location = LatLng(double.parse(ticketMachineDetail.ticketMachineLat),
                  double.parse(ticketMachineDetail.ticketMachineLon));
              kGooglePlex = CameraPosition(
                target: location,
                zoom: 17,
              );
              markers.add(Marker(markerId: MarkerId("Huzefa"), position: location));
              webMapMarkers.add(webMap.Marker(webMap.GeoCoord(double.parse(ticketMachineDetail.ticketMachineLat),
                  double.parse(ticketMachineDetail.ticketMachineLon))));
            }, builder: (context, model, child) {
              return ModalProgressHUD(
                inAsyncCall: model.state == ViewState.Busy,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(AppLocalizations.of(context).translate('partner_details')),
                  ),
                  body: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 300,
                          child: kIsWeb
                              ? webMap.GoogleMap(
                                  key: _key,
                                  markers: webMapMarkers,
                                  initialPosition:
                                      webMap.GeoCoord(kGooglePlex.target.latitude, kGooglePlex.target.longitude),
                                  initialZoom: 16,
                                  mapType: webMap.MapType.hybrid,
                                )
                              : GoogleMap(
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
                                    if (model.currentZoom != cameraposition.zoom) {
                                      model.currentZoom = cameraposition.zoom;
                                      setState(() {});
                                    }
                                  },
                                  markers: markers,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 16.0, top: 10.0),
                        //    child: SingleChildScrollView(child: TicketMachineInfoWidget(widget.ticketMachineDetail)),
                      ),
                    ],
                  ),
                ),
              );
            })),
      ),
    );
  }
}

class TicketMachineDetailInfoWidget extends StatelessWidget {
  ticketMachineRes.Row ticketMachineDetail;

  TicketMachineDetailInfoWidget(this.ticketMachineDetail);

  @override
  Widget build(BuildContext context) {
    double cashback = 0;
    return ParkingView(ticketMachineDetail: ticketMachineDetail);
    // return SingleChildScrollView(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: <Widget>[
    //       MobiText(
    //           text: ticketMachineDetail.pricingAreaName +
    //               " : à " +
    //               (double.parse(ticketMachineDetail.ticketMachineDistance) * 1000).toString() +
    //               " m",
    //           textStyle: Theme.of(context).textTheme.subtitle1,
    //           prefixIcon: MyIcon(
    //             Icons.wifi_lock_sharp,
    //           )),
    //       SizedBox(
    //         height: 10,
    //       ),
    //       Center(
    //         child: Text(
    //           ticketMachineDetail.ticketMachineAddress +
    //               " - durée max : " +
    //               ticketMachineDetail.pricingAreaDefaultDuration +
    //               " mn",
    //           style: TextStyle(fontSize: 16, color: Colors.grey),
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //       SizedBox(
    //         height: 10,
    //       ),
    //       Expanded(child: ParkingView()),
    //       /*      Padding(
    //         padding: const EdgeInsets.symmetric(
    //           vertical: 4,
    //           horizontal: 16,
    //         ),
    //         child: model.vehiclePlateDropdownMenuItemList.isNotEmpty
    //             ? MobiDropDown(
    //           value: model.parkingRequest?.data?.userCarPlate,
    //           prefixIcon: Icon(Icons.directions_car),
    //           onChanged: (value) {
    //             model.parkingRequest?.data?.userCarPlate = value;
    //             // model.getParkingAreasList();
    //             //model.setState(ViewState.Idle);
    //           },
    //           items: model.vehiclePlateDropdownMenuItemList,
    //           hint: AppLocalizations.of(context).translate('choose_vehicle'),
    //         )
    //             : Container(
    //           child: MobiButton(
    //             padding: const EdgeInsets.all(16),
    //             onPressed: () async {
    //               await Navigator.pushNamed(context, "addLicense");
    //               model.populateLicensePlates();
    //             },
    //             text: AppLocalizations.of(context).translate('add_license_plate'),
    //           ),
    //         ),
    //       ),*/
    //     ],
    //   ),
    // );
  }
}*/

/*class MyIcon extends StatelessWidget {
  IconData icon;

  MyIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.grey[700],
      size: 30,
    );
  }
}*/
