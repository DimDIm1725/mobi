/*class TicketMachinesModel extends BaseModel {
  TicketMachinesService _ticketMachineService = locator<TicketMachinesService>();
  loginRes.Data activitiesList = loginRes.Data();
  ticketMachinesResponse.TicketMachineResponse ticketMachinesList;
  GoogleMapController controller;
 // CameraPosition kGooglePlex;
  Set<Marker> markers = Set();
  Map<String, BitmapDescriptor> iconMap = {};
  Map<String, String> webIconMap = {};
  bool partnersCame = false;
  licenseRes.LicenseResponse licenseResponse;
  licenseRes.Row activeParkingLicensePlate = null;

  TicketMachinesModel();

  double currentZoom = 19;

 /* Future<bool> getAllTicketMachinesForLocation() async {
    print("getAllTicketMachinesForLocation");
    setState(ViewState.Busy);
    Position locationData = await getCurrentLocation();
    print("location Data ");
    print(locationData);
    if (locationData == null) {
    /*  errorMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
          .translate('partner_model_location_required');*/
      setState(ViewState.Idle);
      BotToast.showText(
          contentPadding: EdgeInsets.all(16),
          //  animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 4),
          contentColor: Colors.redAccent,
          text: (AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('location_service_required')
              + '\n' + AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('enter_address')
          )
      );
      return false;
    }
    kGooglePlex = CameraPosition(
      target: LatLng(locationData.latitude, locationData.longitude),
      zoom: currentZoom,
    );
    bool status = false;
    loginRes.LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    ticketMachinesReq.TicketMachineRequest request = new ticketMachinesReq.TicketMachineRequest(
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
    ticketMachinesList = await _ticketMachineService.getAllTicketMachinesForLocation(request);
    if (ticketMachinesList.response.errorNumber == '0') {
      successMessage = "OK";
      status = true;
    } else {
      if (ticketMachinesList.response.message is LinkedHashMap) {
        //   errorMessage = ticketMachinesList.response.message["#cdata-section"];
      } else {
        errorMessage = ticketMachinesList.response.message;
      }

      status = false;
    }
    partnersCame = status;
    setState(ViewState.Idle);
    return status;
  }*/

 /* Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }*/

 /* Future<List<MapMarker>> generateParkingMarkers(
      List<ticketMachinesResponse.Row> ticketMachines, BuildContext context) async {
    print("Generate Markers");
    final List<MapMarker> markers = [];

    for (var element in ticketMachines) {
      BitmapDescriptor bitmapIcon;
      Uint8List icon = await getBytesFromAsset('images/mapicons/parking.png', 110);
      bitmapIcon = BitmapDescriptor.fromBytes(icon);

      print("assets loaded");

      LatLng location = LatLng(double.parse(element.ticketMachineLat), double.parse(element.ticketMachineLon));
      markers.add(MapMarker(
        onTap: () {
          // _settingModalBottomSheet(context, element);
        },
        id: element.ticketMachineId,
        position: location,
        icon: bitmapIcon,
      ));
    }
    return markers;
  }*/

/*  Future<List<WebMapMarker>> generateParkingWebMarkers(
      List<ticketMachinesResponse.Row> ticketMachines, BuildContext context) async {
    print("Generate Web Markers");
    final List<WebMapMarker> markers = [];
    String icon;
    for (var element in ticketMachines) {
      icon = "images/mapicons/parking.png";
      print("assets loaded");
      markers.add(WebMapMarker(
        onTap: (value) {
          //  _settingModalBottomSheet(context, element);
        },
        id: element.ticketMachineId,
        position: webMap.GeoCoord(double.parse(element.ticketMachineLat), double.parse(element.ticketMachineLon)),
        icon: icon,
      ));
    }
    return markers;
  }*/

  /*void populateLicensePlates() {
    setState(ViewState.Busy);
    activeParkingLicensePlate = null;
    _getAllSavedLicenses().then((value) {
      if (value) {
        List<licenseRes.Row> list = licenseResponse.response?.data?.row;
        if (list != null && list.isNotEmpty) {
          for (licenseRes.Row item in list) {
            if (item.stopDateTime.isNotEmpty) {
              activeParkingLicensePlate = item;
            }
          }
          if (parkingRequest.data.userCarPlate != null) {
            getParkingAreasList();
          } else {
            _vehiclePlateDropdownMenuItemList = [];
            for (var item in list) {
              try {
                if (item.main == 'True') {
                  parkingRequest.data.userCarPlate = item.carPlate;
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
              }
            }
          }
        }
      }
    });
  }

  Future<bool> _getAllSavedLicenses() async {
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
  }*/

}*/
