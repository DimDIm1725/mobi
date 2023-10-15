import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/services/biometrics_service.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/navigation_util.dart';
import 'package:provider/provider.dart';

class MobiDrawer extends StatefulWidget {
  @override
  _MobiDrawerState createState() => _MobiDrawerState();
}

class _MobiDrawerState extends State<MobiDrawer> {
  String username = "";
  BioMetricService bioMetricService = locator<BioMetricService>();
  @override
  void initState() {
    setState(() {
      username = SharedPrefUtil.getCurrentUser().response.data.userFirstName;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<DrawerAndToolbar>(
        builder: (context, indexData, _) => Container(
          color: MobiTheme.lightGreen,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${AppLocalizations.of(context).translate('hello')} $username",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          /*      IconButton(
                            icon: Icon(Icons.settings, color: Colors.white),
                            onPressed: () {},
                          ),*/
                          IconButton(
                            icon: Icon(Icons.help, color: Colors.white),
                            onPressed: () async {
                              indexData.currentIndex = kContactUsScreen;
                              Navigator.pop(context);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.exit_to_app, color: Colors.white),
                            onPressed: () async {
                              await logoutUser(context: context);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: MobiTheme.colorPrimary,
                ),
              ),
              ListTile(
                leading: Icon(Icons.art_track, color: Colors.black),
                title: Text(AppLocalizations.of(context).translate('news')),
                onTap: () {
                  indexData.currentIndex = kNewsScreen;
                  Navigator.pop(context);
                },
              ),
              ExpansionTile(
                leading: Icon(Icons.person, color: Colors.black),
                title: Text(
                  AppLocalizations.of(context).translate('my_account'),
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('my_information'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kProfileScreen;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.receipt),
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('current_transactions'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kCashBackAndCouponScreen;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  /*   Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.assignment_outlined),
                      title: Text(
                        AppLocalizations.of(context).translate('my_history'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kTransacHistory;
                        Navigator.pop(context);
                      },
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.payment),
                      title: Text(
                        AppLocalizations.of(context).translate('payment_card'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kSavedCardScreen;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.card_membership),
                      title: Text(
                        AppLocalizations.of(context).translate('hello_card'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kContactLessCardsScreen;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.directions_car),
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('licence_plates'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kLicensePlatesScreen;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.lock),
                      title: Text(
                        AppLocalizations.of(context).translate('pin_code'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kChangePinScreen;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  FutureBuilder<bool>(
                      future: bioMetricService.isBiometricAvailable(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: ListTile(
                              leading: Icon(Icons.fingerprint),
                              title: Text(
                                AppLocalizations.of(context)
                                    .translate('fingerprint'),
                              ),
                              onTap: () {
                                bioMetricService
                                    .authenticate()
                                    .then((value) async {
                                  if (value) {
                                    //Auth success
                                    SharedPrefUtil.setFingerprintSetup();
                                    await SharedPrefUtil.setFingerPrintPassword(
                                        await SharedPrefUtil.getUserPincode());
                                    await SharedPrefUtil.setFingerPrintUsername(
                                        SharedPrefUtil.getUserPhone());
                                    BotToast.showText(
                                        contentPadding: EdgeInsets.all(16),
                                        contentColor: Colors.greenAccent,
                                        duration: Duration(seconds: 4),
                                        text: AppLocalizations.of(context)
                                            .translate(
                                                'biometric_setup_success'));
                                  } else {
                                    BotToast.showText(
                                      contentPadding: EdgeInsets.all(16),
                                      // animationDuration: Duration(seconds: 2),
                                      duration: Duration(seconds: 4),
                                      contentColor: Colors.redAccent,
                                      text: AppLocalizations.of(context)
                                          .translate('biometric_failed'),
                                    );
                                  }
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      })
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.room_service, color: Colors.black),
                title: Text(
                  AppLocalizations.of(context).translate('services'),
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 16),
                  //   child: ListTile(
                  //     leading: Icon(Icons.directions_car),
                  //     title: Text(
                  //       AppLocalizations.of(context).translate('street_parking'),
                  //     ),
                  //     onTap: () {
                  //       indexData.currentIndex = kParkingScreen;
                  //       Navigator.pop(context);
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.directions_car),
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('street_parking'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kParkingMap;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.local_taxi),
                      title: Text(
                        AppLocalizations.of(context).translate('taxi_voucher'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kTaxiCheckScreen;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.redeem),
                      title: Text(
                          AppLocalizations.of(context).translate('redeem')),
                      onTap: () {
                        indexData.currentIndex = kOfferCashBackScreen;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.attach_money),
                      title: Text(AppLocalizations.of(context)
                          .translate('add_a_cashback')),
                      onTap: () {
                        indexData.currentIndex = kAddCashBackScreen;
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.store_mall_directory, color: Colors.black),
                title: Text(
                  AppLocalizations.of(context).translate('partners'),
                  style: TextStyle(color: Colors.black),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.list),
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('list_of_partners'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kPartnersListScreen;
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      leading: Icon(Icons.map),
                      title: Text(
                        AppLocalizations.of(context)
                            .translate('map_of_partners'),
                      ),
                      onTap: () {
                        indexData.currentIndex = kPartnersMapScreen;
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
              ListTile(
                leading: Icon(Icons.people, color: Colors.black),
                title: Text(
                    AppLocalizations.of(context).translate('sponsorships')),
                onTap: () {
                  indexData.currentIndex = kSponsorshipScreen;
                  Navigator.pop(context);
                },
              ),
              Container(
                //       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                child: Center(
                  child: Container(
                    height: 50,
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/logo.png"),
                      fit: BoxFit.fitHeight),
                  // color: MobiTheme.colorPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobiDrawerForWeb extends StatefulWidget {
  @override
  _MobiDrawerForWebState createState() => _MobiDrawerForWebState();
}

class _MobiDrawerForWebState extends State<MobiDrawerForWeb> {
  String username = "";
  BioMetricService bioMetricService = locator<BioMetricService>();
  @override
  void initState() {
    setState(() {
      username = SharedPrefUtil.getCurrentUser().response.data.userFirstName;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawerAndToolbar>(
      builder: (context, indexData, _) => Container(
        width: 270,
        color: MobiTheme.lightGreen,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Center(
              child: Container(
                padding: EdgeInsets.all(40),
                color: MobiTheme.colorPrimary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${AppLocalizations.of(context).translate('hello')} $username",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /*      IconButton(
                          icon: Icon(Icons.settings, color: Colors.white),
                          onPressed: () {},
                        ),*/
                        IconButton(
                          icon: Icon(Icons.help, color: Colors.white),
                          onPressed: () async {
                            indexData.currentIndex = kContactUsScreen;
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.exit_to_app, color: Colors.white),
                          onPressed: () async {
                            await logoutUser(context: context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.art_track, color: Colors.black),
              title: Text(AppLocalizations.of(context).translate('news')),
              onTap: () {
                indexData.currentIndex = kNewsScreen;
              },
            ),
            ExpansionTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text(
                AppLocalizations.of(context).translate('my_account'),
                style: TextStyle(color: Colors.black),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      AppLocalizations.of(context).translate('my_information'),
                    ),
                    onTap: () {
                      indexData.currentIndex = kProfileScreen;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.receipt),
                    title: Text(
                      AppLocalizations.of(context)
                          .translate('current_transactions'),
                    ),
                    onTap: () {
                      indexData.currentIndex = kCashBackAndCouponScreen;
                      //   Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.payment),
                    title: Text(
                      AppLocalizations.of(context).translate('payment_card'),
                    ),
                    onTap: () {
                      indexData.currentIndex = kSavedCardScreen;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.card_membership),
                    title: Text(
                      AppLocalizations.of(context).translate('hello_card'),
                    ),
                    onTap: () {
                      indexData.currentIndex = kContactLessCardsScreen;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text(
                      AppLocalizations.of(context).translate('licence_plates'),
                    ),
                    onTap: () {
                      indexData.currentIndex = kLicensePlatesScreen;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text(
                      AppLocalizations.of(context).translate('pin_code'),
                    ),
                    onTap: () {
                      indexData.currentIndex = kChangePinScreen;
                    },
                  ),
                ),
                FutureBuilder<bool>(
                    future: bioMetricService.isBiometricAvailable(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: ListTile(
                            leading: Icon(Icons.fingerprint),
                            title: Text(
                              AppLocalizations.of(context)
                                  .translate('fingerprint'),
                            ),
                            onTap: () {
                              bioMetricService
                                  .authenticate()
                                  .then((value) async {
                                if (value) {
                                  //Auth success
                                  SharedPrefUtil.setFingerprintSetup();
                                  await SharedPrefUtil.setFingerPrintPassword(
                                      await SharedPrefUtil.getUserPincode());
                                  await SharedPrefUtil.setFingerPrintUsername(
                                      SharedPrefUtil.getUserPhone());
                                  BotToast.showText(
                                      contentPadding: EdgeInsets.all(16),
                                      contentColor: Colors.greenAccent,
                                      duration: Duration(seconds: 4),
                                      text: AppLocalizations.of(context)
                                          .translate(
                                              'biometric_setup_success'));
                                } else {
                                  BotToast.showText(
                                    contentPadding: EdgeInsets.all(16),
                                    // animationDuration: Duration(seconds: 2),
                                    duration: Duration(seconds: 4),
                                    contentColor: Colors.redAccent,
                                    text: AppLocalizations.of(context)
                                        .translate('biometric_failed'),
                                  );
                                }
                              });
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.room_service, color: Colors.black),
              title: Text(
                AppLocalizations.of(context).translate('services'),
                style: TextStyle(color: Colors.black),
              ),
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.only(left: 16),
                //   child: ListTile(
                //     leading: Icon(Icons.directions_car),
                //     title: Text(
                //       AppLocalizations.of(context).translate('street_parking'),
                //     ),
                //     onTap: () {
                //       indexData.currentIndex = kParkingScreen;
                //
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text(
                      AppLocalizations.of(context).translate('street_parking'),
                    ),
                    onTap: () {
                      indexData.currentIndex = kParkingMap;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.local_taxi),
                    title: Text(
                      AppLocalizations.of(context).translate('taxi_voucher'),
                    ),
                    onTap: () {
                      indexData.currentIndex = kTaxiCheckScreen;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text(AppLocalizations.of(context)
                        .translate('add_a_cashback')),
                    onTap: () {
                      indexData.currentIndex = kAddCashBackScreen;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.redeem),
                    title:
                        Text(AppLocalizations.of(context).translate('redeem')),
                    onTap: () {
                      indexData.currentIndex = kOfferCashBackScreen;
                    },
                  ),
                )
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.store_mall_directory, color: Colors.black),
              title: Text(
                AppLocalizations.of(context).translate('partners'),
                style: TextStyle(color: Colors.black),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.list),
                    title: Text(
                      AppLocalizations.of(context)
                          .translate('list_of_partners'),
                    ),
                    onTap: () {
                      indexData.currentIndex = kPartnersListScreen;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    leading: Icon(Icons.map),
                    title: Text(
                      AppLocalizations.of(context).translate('map_of_partners'),
                    ),
                    onTap: () {
                      indexData.currentIndex = kPartnersMapScreen;
                    },
                  ),
                )
              ],
            ),
            ListTile(
              leading: Icon(Icons.people, color: Colors.black),
              title:
                  Text(AppLocalizations.of(context).translate('sponsorships')),
              onTap: () {
                indexData.currentIndex = kSponsorshipScreen;
              },
            ),
            Container(
              //       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              child: Center(
                child: Container(
                  height: 50,
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/logo.png"),
                    fit: BoxFit.fitHeight),
                // color: MobiTheme.colorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
