import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/cashback_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/shared/navigation_util.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';

String resultingCreationDateFormat = 'dd/MM/yyyy';
String incomingCreationDateFormat = 'yyyy/MM/dd HH:mm:ss';

String resultingDeadlineDateFormat = 'dd/MM/yyyy';
String incomingDeadlineDateFormat = 'yyyy/MM/dd';

class AddCashBackView extends StatefulWidget {
  @override
  _AddCashBackViewState createState() => _AddCashBackViewState();
}

class _AddCashBackViewState extends State<AddCashBackView> {
  @override
  Widget build(BuildContext context) {
    return AddCashBackWidget();
  }
}

class AddCashBackWidget extends StatefulWidget {
  @override
  _AddCashBackWidgetState createState() => _AddCashBackWidgetState();
}

class _AddCashBackWidgetState extends State<AddCashBackWidget> {
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<CashBackModel>(
      onModelReady: (model) async {},
      builder: (context, model, child) {
        return MobiAppBar(
          child: ModalProgressHUD(
            inAsyncCall: model.state == ViewState.Busy,
            child: Consumer<DrawerAndToolbar>(
              builder: (context, indexData, _) => Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        MobiText(
                          textStyle: MobiTheme.text16BoldWhite,
                          text: AppLocalizations.of(context)
                              .translate('add_cashback_view_collect_cashback'),
                        ),
                        SizedBox(height: 16),
                        IInputField2(
                          hint: AppLocalizations.of(context)
                              .translate('code_cashback'),
                          type: TextInputType.phone,
                          colorDefaultText: Colors.white,
                          controller: controller,
                        ),
                        SizedBox(height: 16),
                        IButton3(
                          pressButton: () {
                            if (controller.value.text.isEmpty) {
                              BotToast.showText(
                                  contentColor: Colors.redAccent,
                                  duration: Duration(seconds: 4),
                                  text: AppLocalizations.of(context)
                                      .translate('enter_cashback_code'));
                              return;
                            }
                            model
                                .addNewCashBack(controller.value.text)
                                .then((value) {
                              print(model.errorMessage);
                              BotToast.showText(
                                  contentPadding: EdgeInsets.all(16),
                                  //  animationDuration: Duration(seconds: 2),
                                  duration: Duration(seconds: 4),
                                  contentColor: value
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  text: value
                                      ? model.successMessage
                                      : AppLocalizations.of(context)
                                          .translate('cashbackpending_error'));
                              if (value) {
                                indexData.currentIndex =
                                    kCashBackAndCouponScreen;
                                model.setState(ViewState.Idle);
                              }
                            });
                          },
                          text: AppLocalizations.of(context)
                              .translate('add_code_uppercase'),
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
            ),
          ),
        );
      },
    );
  }
}
