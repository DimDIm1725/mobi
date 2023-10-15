import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/models/requests/license.dart' as licenseReq;
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/license_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../shared/app_theme.dart';

class LicencePlateView extends StatefulWidget {
  @override
  _LicencePlateViewState createState() => _LicencePlateViewState();
}

class _LicencePlateViewState extends State<LicencePlateView> {
  @override
  Widget build(BuildContext context) {
    return LicenseWidget();
  }
}

class LicenseWidget extends StatefulWidget {
  @override
  _LicenseWidgetState createState() => _LicenseWidgetState();
}

class _LicenseWidgetState extends State<LicenseWidget> {
  int selectedCard = -1;
  bool showSetAsMainCardButton = false;
  bool alreadyShowed = false;

  _delete(LicenseModel model) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(AppLocalizations.of(context)
                .translate('delete_licence_plate_question_mark')),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context).translate('cancel')),
              ),
              new FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  showSetAsMainCardButton = false;
                  await model.deleteLicensePlate(
                      model.license.response.data?.row[selectedCard]?.carPlate);
                  selectedCard = -1;
                  await model.getAllSavedLicenses();
                },
                child: Text(AppLocalizations.of(context).translate('confirm')),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LicenseModel>(onModelReady: (model) {
      model.getAllSavedLicenses();
    }, builder: (context, model, child) {
      if (model.license == null) {
        return MobiAppBar(child: MobiLoader());
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          if (!alreadyShowed &&
              (model.license?.response?.data?.row?.length ?? 0) == 0) {
            print(model.license);
            alreadyShowed = true;
            await Navigator.pushNamed(context, "addLicense");
            selectedCard = -1;
            showSetAsMainCardButton = false;
            model.getAllSavedLicenses();
          }
        });
        return MobiAppBar(
          actions: [
            MobiAction(
              icon: Icons.delete,
              onPressed: selectedCard != -1
                  ? () async {
                      _delete(model);
                    }
                  : null,
            ),
            MobiAction(
              icon: Icons.add_circle_outline,
              onPressed: () async {
                await Navigator.pushNamed(context, "addLicense");
                selectedCard = -1;
                showSetAsMainCardButton = false;
                model.getAllSavedLicenses();
              },
            )
          ],
          child: ModalProgressHUD(
            inAsyncCall: model.state == ViewState.Busy,
            child: Consumer<DrawerAndToolbar>(
              builder: (context, indexData, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Text(
                      (model.license.response.data?.row?.length ?? 0) > 0
                          ? AppLocalizations.of(context)
                              .translate('main_carplate_symbol')
                          : AppLocalizations.of(context)
                              .translate('licence_plate_not_registered'),
                      style: MobiTheme.text16BoldWhite,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => Divider(
                        indent: 72,
                        height: 4,
                      ),
                      itemCount: model.license.response.data?.row?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: new BoxDecoration(
                              color: selectedCard == index
                                  ? MobiTheme.green
                                  : null),
                          child: ListTile(
                            title: Text(
                                "${AppLocalizations.of(context).translate('plate')} ${model.license.response.data?.row[index].carPlate}",
                                style: MobiTheme.text16BoldWhite),
                            subtitle: Text(
                                "${AppLocalizations.of(context).translate('vehicle')} ${model.license.response.data?.row[index].tag}",
                                style: MobiTheme.text16BoldWhite),
                            trailing: Visibility(
                              visible: model.license.response.data?.row[index]
                                      ?.main ==
                                  'True',
                              child: Icon(
                                Icons.local_parking,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedCard == index) {
                                  selectedCard = -1;
                                } else {
                                  selectedCard = index;
                                  showSetAsMainCardButton = model.license
                                          .response.data?.row[index]?.main !=
                                      'True';
                                }
                              });
                            },
                            selected: selectedCard == index,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Visibility(
                    visible: showSetAsMainCardButton,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: MobiButton(
                        padding: const EdgeInsets.all(16),
                        onPressed: () async {
                          showSetAsMainCardButton = false;
                          await model.setAsMainCard(model.license.response.data
                              ?.row[selectedCard]?.carPlate);
                          selectedCard = -1;
                          model.getAllSavedLicenses();
                        },
                        text: AppLocalizations.of(context)
                            .translate('set_default_plate'),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      }
    });
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
                AppLocalizations.of(context).translate('add_license_plate')),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context).translate(
                        'add_license_view_enter_licence_plate_correctly'),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MobiTextFormField(
                    label: AppLocalizations.of(context)
                        .translate('license_plate_number'),
                    onChanged: (newText) {
                      model.licenseRequest.data.carPlate = newText;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  MobiTextFormField(
                    label:
                        AppLocalizations.of(context).translate('vehicle_model'),
                    onChanged: (newText) {
                      model.licenseRequest.data.tag = newText;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(AppLocalizations.of(context).translate('main_plate')),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        onChanged: (bool value) {
                          model.licenseRequest.data.main = value.toString();
                          model.setState(ViewState.Idle);
                        },
                        value: model.licenseRequest.data.main == 'true',
                      ),
                      Text(AppLocalizations.of(context)
                          .translate('default_parking_meter_plate')),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  MobiButton(
                    text: AppLocalizations.of(context).translate('save'),
                    padding: EdgeInsets.all(10),
                    onPressed: () {
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
                    color: Colors.redAccent,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
