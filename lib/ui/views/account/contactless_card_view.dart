import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/models/requests/contact_less_card.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/contact_less_card_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

final colors = [
  MobiTheme.nearlyBlue,
  MobiTheme.red,
  MobiTheme.yellow,
  MobiTheme.green,
  MobiTheme.purple,
];

class ContactLessCardView extends StatefulWidget {
  @override
  _ContactLessCardViewState createState() => _ContactLessCardViewState();
}

class _ContactLessCardViewState extends State<ContactLessCardView> {
  @override
  Widget build(BuildContext context) {
    return ContactLessCardWidget();
  }
}

class ContactLessCardWidget extends StatefulWidget {
  @override
  _ContactLessCardWidgetState createState() => _ContactLessCardWidgetState();
}

class _ContactLessCardWidgetState extends State<ContactLessCardWidget> {
  int selectedCard = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ContactLessCardModel>(onModelReady: (model) {
      model.getAllContactLessCards();
    }, builder: (context, model, child) {
      if (model.cardRequest == null) {
        model.cardRequest = ContactLessCardRequest(data: Data());
      }
      return MobiAppBar(
        actions: [
          MobiAction(
            icon: Icons.delete,
            onPressed: selectedCard != -1
                ? () async {
                    confirmAndDeleteCard(context, model, selectedCard);
                  }
                : null,
          ),
          MobiAction(
              icon: Icons.add_circle_outline,
              onPressed: () {
                showAddCardDialog(context, model);
              })
        ],
        child: ModalProgressHUD(
          inAsyncCall: model.state == ViewState.Busy,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Consumer<DrawerAndToolbar>(
            builder: (context, indexData, _) =>
                (model.card?.response?.data?.row?.length ?? 0) != 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('bonjourcard_text'),
                              style: MobiTheme.text16BoldWhite,
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              physics: ClampingScrollPhysics(),
                              separatorBuilder: (_, __) => Divider(
                                indent: 72,
                                height: 4,
                              ),
                              itemCount:
                                  model.card.response.data?.row?.length ?? 0,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  //  tileColor: MobiTheme.nearlyBlue,
                                  selectedTileColor: MobiTheme.green,
                                  leading: Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colors[index % colors.length],
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                      child: SizedBox(
                                        height: 48,
                                        width: 48,
                                        child: Center(
                                          child: Text(
                                            model.card.response.data?.row[index]
                                                .partnerCompanyName
                                                .substring(0, 1),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    elevation: 8,
                                    shadowColor: colors[index % colors.length],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(48)),
                                  ),
                                  title: Text(
                                      model.card.response.data?.row[index]
                                          .partnerCompanyName,
                                      style: MobiTheme.text16BoldWhite),
                                  subtitle: Text(
                                      '${model.card.response.data?.row[index].userAccessKey}',
                                      style: MobiTheme.text16BoldWhite),
                                  onTap: () {
                                    setState(() {
                                      if (selectedCard == index) {
                                        selectedCard = -1;
                                      } else {
                                        selectedCard = index;
                                      }
                                    });
                                  },
                                  selected: selectedCard == index,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.credit_card,
                                size: 72,
                                color: MobiTheme.colorIcon,
                              ),
                              SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('no_cards_found'),
                                style: MobiTheme.text16BoldWhite,
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

  void confirmAndDeleteCard(
      BuildContext context, ContactLessCardModel model, int index) {
    String userAccessKey = model.card.response.data?.row[index].userAccessKey;
    showDialog(
        context: context,
        child: ModalProgressHUD(
          inAsyncCall: model.modalState == ViewState.Busy,
          child: AlertDialog(
            title: Text(AppLocalizations.of(context)
                .translate('delete_card_lowercase')),
            actions: [
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('cancel')),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(AppLocalizations.of(context).translate('save')),
                onPressed: () {
                  BotToast.showLoading();
                  model.deleteContactLessCard(userAccessKey).then((value) {
                    BotToast.closeAllLoading();
                    BotToast.showText(
                        contentPadding: EdgeInsets.all(16),
                        //  animationDuration: Duration(seconds: 2),
                        duration: Duration(seconds: 4),
                        contentColor:
                            value ? Colors.greenAccent : Colors.redAccent,
                        text:
                            value ? model.successMessage : model.errorMessage);
                    if (value) {
                      selectedCard = -1;
                      Navigator.pop(context);
                      model.getAllContactLessCards();
                    }
                  });
                },
              )
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '$userAccessKey ?',
                ), // check once
              ],
            ),
          ),
        ));
  }

  void showAddCardDialog(BuildContext context, ContactLessCardModel model) {
    showDialog(
      context: context,
      child: ModalProgressHUD(
        inAsyncCall: model.modalState == ViewState.Busy,
        child: AlertDialog(
          title: Text(AppLocalizations.of(context).translate('add_a_card')),
          actions: [
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('cancel'),
                  style: TextStyle(color: MobiTheme.colorCompanion)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(AppLocalizations.of(context).translate('add_card'),
                  style: TextStyle(color: MobiTheme.colorCompanion)),
              onPressed: () {
                BotToast.showLoading();
                model.addContactLessCard().then((value) {
                  BotToast.closeAllLoading();
                  BotToast.showText(
                      contentPadding: EdgeInsets.all(16),
                      //  animationDuration: Duration(seconds: 2),
                      duration: Duration(seconds: 4),
                      contentColor:
                          value ? Colors.greenAccent : Colors.redAccent,
                      text: value ? model.successMessage : model.errorMessage);
                  if (value) {
                    Navigator.pop(context);
                    model.getAllContactLessCards();
                  }
                });
              },
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(AppLocalizations.of(context).translate('add_card_number')),
              SizedBox(height: 16),
              IInputField2(
                hint: AppLocalizations.of(context)
                    .translate('card_digit_display'),
                icon: Icons.card_membership,
                colorIcon: MobiTheme.colorIcon,
                type: TextInputType.number,
                colorDefaultText: Colors.white,
                onChangeText: (newText) {
                  model.cardRequest.data.userAccessKey = newText;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
