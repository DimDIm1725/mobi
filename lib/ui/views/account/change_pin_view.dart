import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/models/requests/pincode.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/pincode_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';

class ChangePinView extends StatefulWidget {
  @override
  _ChangePinViewState createState() => _ChangePinViewState();
}

class _ChangePinViewState extends State<ChangePinView> {
  @override
  Widget build(BuildContext context) {
    return ChangePinWidget();
  }
}

class ChangePinWidget extends StatefulWidget {
  @override
  _ChangePinWidgetState createState() => _ChangePinWidgetState();
}

class _ChangePinWidgetState extends State<ChangePinWidget> {
  @override
  Widget build(BuildContext context) {
    return BaseView<PincodeModel>(onModelReady: (model) {
      model.pincodeRequest = PincodeRequest(
        data:
            Data(userNewPinCode: "", userOldPinCode: "", confirmNewPincode: ""),
      );
    }, builder: (context, model, child) {
      return MobiAppBar(
        /*  actions: [
          MobiAction(
            icon: Icons.save,
            onPressed: () async {
              model.changePincode().then((value) {
                BotToast.showText(
                    contentPadding: EdgeInsets.all(16),
                  //  animationDuration: Duration(seconds: 2),
                    duration: Duration(seconds: 4),
                    contentColor: value ? Colors.greenAccent : Colors.redAccent,
                    text: value ? model.successMessage : model.errorMessage);
                if (value) {
                  clearCache();
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'login');
                }
              });
            },
          )
        ],*/
        child: ModalProgressHUD(
          inAsyncCall: model.state == ViewState.Busy,
          child: Consumer<DrawerAndToolbar>(
            builder: (context, indexData, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)
                        .translate('change_pin_view_password_change_form'),
                    style: MobiTheme.text16BoldWhite,
                  ),
                  SizedBox(height: 16),
                  IInputField2(
                    hint: AppLocalizations.of(context).translate('current_pin'),
                    maxLength: 6,
                    type: TextInputType.number,
                    colorDefaultText: Colors.white,
                    onChangeText: (newText) {
                      model.pincodeRequest.data.userOldPinCode = newText;
                    },
                  ),
                  SizedBox(height: 16),
                  IInputField2(
                    hint: AppLocalizations.of(context).translate('new_pin'),
                    maxLength: 6,
                    type: TextInputType.number,
                    colorDefaultText: Colors.white,
                    onChangeText: (newText) {
                      model.pincodeRequest.data.userNewPinCode = newText;
                    },
                  ),
                  SizedBox(height: 16),
                  IInputField2(
                    hint: AppLocalizations.of(context)
                        .translate('confirm_new_pin'),
                    maxLength: 6,
                    type: TextInputType.number,
                    colorDefaultText: Colors.white,
                    onChangeText: (newText) {
                      model.pincodeRequest.data.confirmNewPincode = newText;
                    },
                  ),
                  SizedBox(height: 30),
                  IButton3(
                    pressButton: () {
                      model.changePincode().then((value) {
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
                          clearCache();
                          Navigator.pop(context);
                          Navigator.pushNamed(context, 'login');
                        }
                      });
                    },
                    text: AppLocalizations.of(context).translate('save'),
                    color: MobiTheme.colorCompanion,
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
