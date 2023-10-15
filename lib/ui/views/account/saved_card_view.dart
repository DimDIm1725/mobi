import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/card_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/views/account/3d_secure_bank_view.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';
import 'package:xml2json/xml2json.dart';
import 'package:xml_parser/xml_parser.dart';

class SavedCardView extends StatefulWidget {
  @override
  _SavedCardViewState createState() => _SavedCardViewState();
}

class _SavedCardViewState extends State<SavedCardView> {
  @override
  Widget build(BuildContext context) {
    return SavedCardWidget();
  }
}

class SavedCardWidget extends StatefulWidget {
  @override
  _SavedCardWidgetState createState() => _SavedCardWidgetState();
}

class _SavedCardWidgetState extends State<SavedCardWidget> {
  int selectedCard = -1;
  int mainCard;
  bool showSetAsMainCardButton = false;

  _delete(CardModel model) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(AppLocalizations.of(context)
                .translate('delete_card_question_mark')),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context).translate('cancel'),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  bool result = await model.deleteCard(
                      model.card.response.data?.row[selectedCard]?.token);

                  BotToast.showText(
                      contentPadding: EdgeInsets.all(16),
                      //  animationDuration: Duration(seconds: 2),
                      duration: Duration(seconds: 4),
                      contentColor:
                          result ? Colors.greenAccent : Colors.redAccent,
                      text: result ? model.successMessage : model.errorMessage);

                  if (result) {
                    selectedCard = -1;
                    showSetAsMainCardButton = false;
                    model.getAllSavedCards();
                  }
                },
                child: Text(
                  AppLocalizations.of(context).translate('confirm'),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CardModel>(onModelReady: (model) {
      // TODO called after Payline ?
      model.getAllSavedCards();
    }, builder: (context, model, child) {
      if (model.card == null) {
        return MobiAppBar(child: MobiLoader());
      } else {
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
                await Navigator.pushNamed(
                    context, ThreeDSecureBankView.routeName);
                // TODO check if needed , as it is called at start view again ?
                model.getAllSavedCards();
              },
            )
          ],
          child: ModalProgressHUD(
            inAsyncCall: model.state == ViewState.Busy,
            child: Consumer<DrawerAndToolbar>(
              builder: (context, indexData, _) => model.card.response.data !=
                      null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('main_parking_card_symbol'),
                            style: MobiTheme.text16BoldWhite,
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            physics: ClampingScrollPhysics(),
                            separatorBuilder: (_, __) =>
                                Divider(indent: 72, color: Colors.white),
                            itemCount:
                                model.card.response.data?.row?.length ?? 0,
                            itemBuilder: (context, index) {
                              var card = model.card.response.data?.row[index];
                              if (card?.main == 'True') {
                                mainCard = index;
                              }

                              return CardListTile(
                                type: card.type,
                                number: card.number,
                                month: card.month,
                                year: card.year,
                                primary: card?.main == 'True',
                                onTap: () {
                                  setState(() {
                                    if (selectedCard == index) {
                                      selectedCard = -1;
                                    } else {
                                      selectedCard = index;
                                      showSetAsMainCardButton =
                                          mainCard != index;
                                    }
                                  });
                                },
                                selected: selectedCard == index,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        Visibility(
                          visible: showSetAsMainCardButton,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: IButton3(
                              pressButton: () async {
                                await model.setAsMainCard(model.card.response
                                    .data?.row[selectedCard]?.token);
                                selectedCard = -1;
                                showSetAsMainCardButton = false;
                                model.getAllSavedCards();
                              },
                              text: AppLocalizations.of(context)
                                  .translate('set_main_card'),
                              color: MobiTheme.colorCompanion,
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
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
                              color: MobiTheme.nearlyBlack,
                            ),
                            SizedBox(height: 16),
                            Padding(
                                padding: EdgeInsets.all(30.0),
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)
                                      .translate('3DSecure_additional_message'),
                                  style: MobiTheme.text16BoldWhite,
                                  textAlign: TextAlign.center,
                                ))),
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)
                                      .translate('no_creditcards_found'),
                                  style: MobiTheme.text16BoldWhite,
                                  textAlign: TextAlign.center,
                                ))),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        );
      }
    });
  }
}

class CardListTile extends StatelessWidget {
  final String type;
  final String number;
  final String month;
  final String year;
  final bool selected;
  final bool primary;
  final Function() onTap;

  CardListTile({
    @required this.type,
    @required this.number,
    @required this.month,
    @required this.year,
    this.selected = false,
    this.primary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          new BoxDecoration(color: this.selected ? MobiTheme.green : null),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white),
              ),
              width: 64,
              height: 40,
              padding: const EdgeInsets.all(8),
              child: Image(
                image: AssetImage(
                  type == 'Visa'
                      ? "images/visa_card.png"
                      : "images/master_card.png",
                ),
              ),
            ),
          ],
        ),
        title: Text(
          number,
          style: MobiTheme.text16BoldWhite,
        ),
        subtitle: Text(
          "$month/$year",
          style: MobiTheme.text16BoldWhite,
        ),
        trailing: Visibility(
          visible: primary,
          child: Icon(Icons.local_parking, color: Colors.white),
        ),
        onTap: onTap,
        selected: selected,
      ),
    );
  }
}
