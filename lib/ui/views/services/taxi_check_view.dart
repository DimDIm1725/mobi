import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/models/responses/card.dart' as card;
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/taxi_check_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/views/account/3d_secure_bank_view.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';

class TaxiCheckView extends StatefulWidget {
  @override
  _TaxiCheckViewState createState() => _TaxiCheckViewState();
}

class _TaxiCheckViewState extends State<TaxiCheckView> {
  @override
  Widget build(BuildContext context) {
    return TaxiCheckWidget();
  }
}

class TaxiCheckWidget extends StatefulWidget {
  @override
  _TaxiCheckWidgetState createState() => _TaxiCheckWidgetState();
}

class _TaxiCheckWidgetState extends State<TaxiCheckWidget> {
  TextEditingController phoneController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BaseView<TaxiCheckModel>(onModelReady: (model) {
      model.getAllSavedCards().then((value) => model.setState(ViewState.Idle));
    }, builder: (context, model, child) {
      return MobiAppBar(
        /*  actions: model.showErrorMessage || model.recipientName != null
                ? [
                    MobiAction(
                        icon: Icons.person_add,
                        onPressed: () {
                          handleButtonPress(context, model);
                        })
                  ]
                : null,*/
        child: ModalProgressHUD(
          inAsyncCall: model.state == ViewState.Busy,
          child: Consumer<DrawerAndToolbar>(
            builder: (context, indexData, _) {
              print('snapshot came');
              if (model.card != null) {
                if (model.card.response == null ||
                    model.card.response.data == null ||
                    (model.card.response?.data?.row ?? []).isEmpty) {
                  return Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate('please_add_credit_card'),
                            style: MobiTheme.text16BoldWhite,
                          ),
                          SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: IButton3(
                              pressButton: () async {
                                await Navigator.pushNamed(
                                    context, ThreeDSecureBankView.routeName);
                                model.setState(ViewState.Busy);
                                await model.getAllSavedCards();
                                model.setState(ViewState.Idle);
                              },
                              text: AppLocalizations.of(context)
                                  .translate('add_card'),
                              color: MobiTheme.colorCompanion,
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)
                                .translate('taxi_check_title_message'),
                            style: MobiTheme.text16BoldWhite,
                          ),
                          SizedBox(height: 16),
                          MobiDropDown(
                            hint: AppLocalizations.of(context)
                                .translate('select_amount'),
                            prefixIcon: Icon(Icons.euro_symbol,
                                color: MobiTheme.colorIcon),
                            onChanged: (newValue) {
                              model.taxiCheckRequest.data.transactionAmount =
                                  newValue;
                              model.setState(ViewState.Idle);
                            },
                            value:
                                model.taxiCheckRequest.data.transactionAmount,
                            items: model.getAllPriceDropDownValues(),
                          ),
                          SizedBox(height: 16),
                          IInputField2(
                            hint: AppLocalizations.of(context)
                                .translate('recipient_phone'),
                            icon: Icons.phone,
                            maxLength: 10,
                            colorIcon: MobiTheme.colorIcon,
                            type: TextInputType.phone,
                            colorDefaultText: Colors.white,
                            controller: phoneController,
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
                                  'taxi_check_no_member_found_error_message'),
                              style: MobiTheme.text16BoldWhite,
                            ),
                          ),
                          Visibility(
                            visible: model.recipientName != null,
                            child: MobiText(
                              textStyle: MobiTheme.text16BoldWhite,
                              prefixIcon:
                                  Icon(Icons.face, color: MobiTheme.colorIcon),
                              text:
                                  '${AppLocalizations.of(context).translate('member_found')} ${model.recipientName}',
                            ),
                          ),
                          SizedBox(height: 16),
                          IButton3(
                            pressButton: () {
                              handleButtonPress(context, model);
                            },
                            text: AppLocalizations.of(context)
                                .translate('send_taxi'),
                            color: MobiTheme.colorCompanion,
                            textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ],
                      ));
                }
              } else {
                return MobiLoader();
              }
            },
          ),
        ),
      );
    });
  }

  void handleButtonPress(BuildContext context, TaxiCheckModel model) {
    if (model.showErrorMessage) {
      // addNewMember();
      model.user.data.userPhoneNumber =
          model.taxiCheckRequest.data.beneficiaryUserPhoneNumber;
      showAddRecipientDialog(context, model);
    } else if (model.recipientName != null &&
        model.taxiCheckRequest.data.transactionAmount != null) {
      if (model.mainCard != null) {
        model.taxiCheckRequest.data.creditCardToken = model.mainCard.token;
      }
      model.sendTaxiCheck().then((value) {
        if (value) {
          resetView(model);
          model.setState(ViewState.Idle);
        }
        BotToast.showText(
            contentPadding: EdgeInsets.all(16),
            //  animationDuration: Duration(seconds: 2),
            duration: Duration(seconds: 4),
            contentColor: value ? Colors.greenAccent : Colors.redAccent,
            text: value ? model.successMessage : model.errorMessage);
        //  value ? Navigator.pushNamed(context, "/") : null;
      });
    } else {
      BotToast.showText(
          contentPadding: EdgeInsets.all(16),
          //  animationDuration: Duration(seconds: 2),
          duration: Duration(seconds: 4),
          contentColor: Colors.redAccent,
          text: model.recipientName != null
              ? AppLocalizations.of(context).translate('enter_amount')
              : AppLocalizations.of(context).translate('enter_phonenumber'));
    }
  }

  void showAddRecipientDialog(BuildContext context, TaxiCheckModel model) {
    showDialog(
        context: context,
        child: ModalProgressHUD(
          inAsyncCall: model.state == ViewState.Busy,
          child: AlertDialog(
            title: Text(AppLocalizations.of(context)
                .translate('taxi_check_create_account_title')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(AppLocalizations.of(context)
                    .translate('taxi_check_create_account_title2')),
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
                          print("sponsor clicked");
                          BotToast.showLoading();
                          model.addRecipient().then((value) {
                            BotToast.closeAllLoading();
                            BotToast.showText(
                                contentPadding: EdgeInsets.all(16),
                                //    animationDuration: Duration(seconds: 2),
                                duration: Duration(seconds: 4),
                                contentColor: value
                                    ? Colors.greenAccent
                                    : Colors.redAccent,
                                text: value
                                    ? model.successMessage
                                    : model.errorMessage);
                            Navigator.pop(context);
                            if (value) {
                              getUserForPhoneNumber(
                                  model, model.user.data.userPhoneNumber);
                            }
                          });
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void getUserForPhoneNumber(TaxiCheckModel model, newText) {
    model.receipientPhone = newText;
    model.getCustomerFromCard(newText).then(
      (value) {
        if (!value) {
          model.showErrorMessage = true;
          model.setState(ViewState.Idle);
        }
        model.taxiCheckRequest.data.beneficiaryUserPhoneNumber = newText;
      },
    );
  }

  void resetView(TaxiCheckModel model) {
    phoneController.text = "";
    model.taxiCheckRequest.data.transactionAmount = null;
    model.showErrorMessage = false;
    model.recipientName = null;
  }
}
