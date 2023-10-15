import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/requests/license.dart' as licenseReq;
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/license_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';

class AddLicenseView extends StatefulWidget {
  @override
  _AddLicenseViewState createState() => _AddLicenseViewState();
}

class _AddLicenseViewState extends State<AddLicenseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Color(0xff061f39),
        child: AddLicenseWidget(),
      ),
    );
  }
}

class AddLicenseWidget extends StatefulWidget {
  @override
  _AddLicenseWidgetState createState() => _AddLicenseWidgetState();
}

enum CardDesignation { Lost, Pro }

class _AddLicenseWidgetState extends State<AddLicenseWidget> {
  var _character;

  @override
  Widget build(BuildContext context) {
    return BaseView<LicenseModel>(onModelReady: (model) {
      model.licenseRequest = licenseReq.LicenseRequest(
          data: licenseReq.Data(carPlate: '', tag: '', main: 'true'));
    }, builder: (context, model, child) {
      return ModalProgressHUD(
        inAsyncCall: model.state == ViewState.Busy,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context).translate('add_license_plate'),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                width: isLargeScreen(context)
                    ? getLargeScreenWidth(context)
                    : MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).translate(
                          'add_license_view_enter_licence_plate_correctly'),
                      style: MobiTheme.text16BoldWhite,
                    ),
                    SizedBox(height: 16),
                    IInputField2(
                      hint: AppLocalizations.of(context)
                          .translate('license_plate_number'),
                      colorDefaultText: Colors.white,
                      onChangeText: (newText) {
                        model.licenseRequest.data.carPlate = newText;
                      },
                    ),
                    SizedBox(height: 16),
                    IInputField2(
                      hint: AppLocalizations.of(context)
                          .translate('vehicle_model'),
                      colorDefaultText: Colors.white,
                      onChangeText: (newText) {
                        model.licenseRequest.data.tag = newText;
                      },
                    ),
                    SizedBox(height: 16),
                    Text(AppLocalizations.of(context).translate('main_plate'), style:MobiTheme.text16BoldWhite),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          onChanged: (bool value) {
                            model.licenseRequest.data.main = value.toString();
                            model.setState(ViewState.Idle);
                          },
                          checkColor: Colors.white,
                          activeColor: MobiTheme.colorIcon,
                          value: model.licenseRequest.data.main == 'true',
                        ),
                        Text(AppLocalizations.of(context)
                            .translate('default_parking_meter_plate'), style:MobiTheme.text16BoldWhite),
                      ],
                    ),
                    SizedBox(height: 16),
                    IButton3(
                      pressButton: () {
                        model.addLicensePlate().then((value) {
                          BotToast.showText(
                              contentPadding: EdgeInsets.all(16),
                              //  animationDuration: Duration(seconds: 2),
                              duration: Duration(seconds: 4),
                              contentColor:
                                  value ? Colors.greenAccent : Colors.redAccent,
                              text: value
                                  ? model.successMessage
                                  : model.errorMessage);
                          if (value) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      text:AppLocalizations.of(context).translate('save'),
                      color: MobiTheme.colorCompanion,
                      textStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color:Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
