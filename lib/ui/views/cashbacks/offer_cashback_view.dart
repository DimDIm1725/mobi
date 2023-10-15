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

class OfferCashBackView extends StatefulWidget {
  @override
  _OfferCashBackViewState createState() => _OfferCashBackViewState();
}

class _OfferCashBackViewState extends State<OfferCashBackView> {
  @override
  Widget build(BuildContext context) {
    return OfferCashBackWidget();
  }
}

class OfferCashBackWidget extends StatefulWidget {
  @override
  _OfferCashBackWidgetState createState() => _OfferCashBackWidgetState();
}

class _OfferCashBackWidgetState extends State<OfferCashBackWidget> {
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<CashBackModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          return ModalProgressHUD(
            inAsyncCall: model.state == ViewState.Busy,
            child: Consumer<DrawerAndToolbar>(
              builder: (context, indexData, _) => MobiAppBar(
                /*   actions: model.showErrorMessage || model.recipientName != null
                    ? [
                        MobiAction(
                            icon: Icons.person_add,
                            onPressed: () {
                              handleButtonPress(context, model, indexData);
                            })
                      ]
                    : null,*/
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate(
                              'offer_cashback_view_cashback_transfer'),
                          style: MobiTheme.text16BoldWhite,
                        ),
                        SizedBox(height: 16),
                        IInputField2(
                          hint: AppLocalizations.of(context)
                              .translate('hint_username'),
                          icon: Icons.phone,
                          maxLength: 10,
                          colorIcon: MobiTheme.colorIcon,
                          type: TextInputType.phone,
                          colorDefaultText: Colors.white,
                          onChangeText: (newText) {
                            if (newText.toString().length == 10) {
                              getUserForPhoneNumber(model, newText);
                            } else {
                              model.showErrorMessage = false;
                              model.recipientName = null;
                              model.setState(ViewState.Idle);
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        Visibility(
                          visible: model.showErrorMessage,
                          child: Text(
                            AppLocalizations.of(context).translate(
                                'offer_cashback_view_member_not_found'),
                            style: MobiTheme.text16BoldWhite,
                          ),
                        ),
                        Visibility(
                          visible: model.recipientName != null,
                          child: MobiText(
                            textStyle: MobiTheme.text16BoldWhite,
                            prefixIcon: Icon(Icons.face, color:MobiTheme.colorIcon),
                            text:'${AppLocalizations.of(context).translate('member_found')} ${model.recipientName}',
                          ),
                        ),
                        SizedBox(height: 16),
                        IButton3(
                          pressButton: () {
                            handleButtonPress(context, model, indexData);
                          },
                          text: AppLocalizations.of(context)
                              .translate('send_cashbacks'),
                          color: MobiTheme.colorCompanion,
                          textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  void handleButtonPress(
      BuildContext context, CashBackModel model, DrawerAndToolbar indexData) {
    if (model.showErrorMessage) {
      model.user.data.userPhoneNumber =
          model.transferCashBack.data.toUserPhoneNumber;
      showAddRecipientDialog(context, model);
    } else if (model.recipientName != null) {
      model.transferCashBacks().then((value) {
        BotToast.showText(
            contentPadding: EdgeInsets.all(16),
            //  animationDuration: Duration(seconds: 2),
            duration: Duration(seconds: 4),
            contentColor: value ? Colors.greenAccent : Colors.redAccent,
            text: value ? model.successMessage : model.errorMessage);
        if (value) {
          print('changing the current tab');
          indexData.currentIndex = kCashBackAndCouponScreen;
          model.setState(ViewState.Idle);
        }
      });
    } else {
      BotToast.showText(
          contentPadding: EdgeInsets.all(16),
          //  animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 4),
          contentColor: Colors.redAccent,
          text: AppLocalizations.of(context).translate('enter_phonenumber'));
    }
  }

  void showAddRecipientDialog(BuildContext context, CashBackModel model) {
    showDialog(
        context: context,
        child: ModalProgressHUD(
          inAsyncCall: model.state == ViewState.Busy,
          child: AlertDialog(
            title: Text(AppLocalizations.of(context)
                .translate('offer_cashback_view_create_account')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(AppLocalizations.of(context)
                    .translate('offer_cashback_view_complete_form')),
                SizedBox(
                  height: 16,
                ),
                MobiTextFormField(
                  label: AppLocalizations.of(context).translate('first_name'),
                  prefixIcon: Icon(Icons.person),
                  onChanged: (newText) {
                    model.user.data.userFirstName = newText;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                MobiTextFormField(
                  label: AppLocalizations.of(context).translate('last_name'),
                  prefixIcon: Icon(Icons.person),
                  onChanged: (newText) {
                    model.user.data.userLastName = newText;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MobiButton(
                        text: AppLocalizations.of(context).translate('cancel'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: MobiTheme.negativeColor,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MobiButton(
                        text: AppLocalizations.of(context).translate('ok'),
                        onPressed: () {
                          Navigator.pop(context);
                          model.addRecipient().then((value) {
                            BotToast.showText(
                                contentPadding: EdgeInsets.all(16),
                                //   animationDuration: Duration(seconds: 2),
                                duration: Duration(seconds: 4),
                                contentColor: value
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                text: value
                                    ? model.successMessage
                                    : model.errorMessage);

                            if (value) {
                              getUserForPhoneNumber(
                                  model, model.user.data.userPhoneNumber);
                            }
                          });
                        },
                        color: MobiTheme.nearlyBlue,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void getUserForPhoneNumber(CashBackModel model, newText) {
    model.getCustomerFromCard(newText).then(
      (value) {
        if (!value) {
          model.showErrorMessage = true;
          model.setState(ViewState.Idle);
        }
        model.transferCashBack.data.toUserPhoneNumber = newText;
      },
    );
  }
}
