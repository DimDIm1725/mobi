import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/models/responses/cashback.dart'
    as cashBackResponse;
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/cashback_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/views/sponsorship/sponsorships.dart';
import 'package:mobiwoom/ui/widgets/drawer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:mobiwoom/core/viewmodels/transactions_model.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:bot_toast/bot_toast.dart';

import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';
import 'package:mobiwoom/ui/widgets/iinputField2Password.dart';
String resultingCreationDateFormat = 'dd/MM/yyyy';
String incomingCreationDateFormat = 'yyyy/MM/dd HH:mm';

String resultingDeadlineDateFormat = 'dd/MM/yyyy';
String incomingDeadlineDateFormat = 'yyyy/MM/dd';

class CashBackView extends StatefulWidget {
  @override
  _CashBackViewState createState() => _CashBackViewState();
}

class _CashBackViewState extends State<CashBackView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Color(0xff061f39),
        child: CashBackAndCouponsWidget(),
      ),
    );
  }
}

class CashBackAndCouponsWidget extends StatefulWidget {
  @override
  _CashBackAndCouponsWidgetState createState() =>
      _CashBackAndCouponsWidgetState();
}

class _CashBackAndCouponsWidgetState extends State<CashBackAndCouponsWidget> {
  @override
  Widget build(BuildContext context) {
    return BaseView<CashBackModel>(
      onModelReady: (model) async {},
      builder: (context, model, child) {
        return Consumer<DrawerAndToolbar>(
          builder: (context, indexData, _) => Scaffold(
            drawer: MobiDrawer(),
            body: model.currentSelectedTab == 0
                ? CashBackWidget()
                : OtherWidget(),
            
            bottomNavigationBar: BottomNavigationBar(
              onTap: (currentIndex) {
                model.currentSelectedTab = currentIndex;
                model.setState(ViewState.Idle);
              },
              selectedItemColor:MobiTheme.colorCompanion,
              currentIndex: model.currentSelectedTab,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.euro_symbol),
                  title: Text(AppLocalizations.of(context)
                      .translate('currentMonth_text')),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_giftcard),
                  title: Text(
                    AppLocalizations.of(context).translate('otherMonths'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class CashBackWidget extends StatefulWidget {
  CashBackWidget();

  @override
  _CashBackWidgetState createState() => _CashBackWidgetState();
}

class _CashBackWidgetState extends State<CashBackWidget> {
  Future<List<cashBackResponse.Row>> cashBacks;

  @override
  Widget build(BuildContext context) {
    return BaseView<CashBackModel>(onModelReady: (model) async {
      cashBacks = model.getCurrentMonthTransactions();
    }, builder: (context, model, child) {
      return MobiAppBar(
        child: ModalProgressHUD(
          color: Theme.of(context).scaffoldBackgroundColor,
          inAsyncCall: model.state == ViewState.Busy,
          child: Consumer<DrawerAndToolbar>(
            builder: (context, indexData, _) =>
                FutureBuilder<List<cashBackResponse.Row>>(
              future: cashBacks,
              builder: (_, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.euro_symbol,
                          size: 72,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)
                              .translate('no_cashback_available'),
                          style: MobiTheme.text16BoldWhite,
                        ),
                      ],
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        SingleStat(
                          label: DateFormat.yMMMM('fr').format(DateTime.now()),
                          value:
                              '(Cliquez sur une transaction pour avoir le détail)',
                          color: MobiTheme.colorCompanion,
                          style: MobiTheme.text16BoldWhite,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) => TransactionListTile(
                            snapshot.data[index],
                            index,
                          ),
                          separatorBuilder: (_, __) =>
                              Divider(indent: 72, color: Colors.white),
                          itemCount: snapshot.data.length,
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      );
    });
  }
}

class OtherWidget extends StatefulWidget {
  OtherWidget();

  @override
  OtherMonthsWidgetState createState() => OtherMonthsWidgetState();
}

class OtherMonthsWidgetState extends State<OtherWidget> {
  double _height;
  double _width;
  TextEditingController _monthDateController = TextEditingController();
  DateTime selectedMonth = DateTime.now();
  String dateTime;
  // String _setDate;

  Future<Null> _selectMonth(BuildContext context) async {
    final DateTime picked = await showMonthPicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedMonth) {
      selectedMonth = picked;
      setState(() {
        selectedMonth = picked;
        //   _monthDateController.text = DateFormat.yMMMM('fr').format(selectedMonth);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    _monthDateController.text = DateFormat.yMMMM('fr').format(selectedMonth);
    return BaseView<TransactionsHistoryModel>(
        onModelReady: (model) async {},
        builder: (context, model, child) {
          return MobiAppBar(
              child: ModalProgressHUD(
            color: Theme.of(context).scaffoldBackgroundColor,
            inAsyncCall: model.state == ViewState.Busy,
            child: Consumer<DrawerAndToolbar>(
              builder: (context, indexData, _) => Scaffold(
                body: SingleChildScrollView(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: <Widget>[
                      SingleStat(
                          label: AppLocalizations.of(context)
                              .translate('enter_range_date'),
                          value: '',
                          color: MobiTheme.colorCompanion,
                          style: Theme.of(context).textTheme.subtitle2),
                      SizedBox(height: 30),
                      Text(
                        'sélectionnez votre mois',
                        style: MobiTheme.text16BoldWhite,
                      ),
                      InkWell(
                        onTap: () {
                          _selectMonth(context);
                        },
                        child: Container(
                          width: _width / 1.7,
                          height: _height / 9,
                          margin: EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          decoration:
                              BoxDecoration(color: MobiTheme.colorPrimary),
                          child: TextFormField(
                            style: TextStyle(fontSize: 40, color: Colors.white),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _monthDateController,
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(top: 0.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      IButton3(
                        pressButton: () {
                          model
                              .getTransactionsFile(selectedMonth)
                              .then((value) {
                            BotToast.showText(
                                contentPadding: EdgeInsets.all(16),
                                //  animationDuration: Duration(seconds: 2),
                                duration: Duration(seconds: 4),
                                contentColor: value
                                    ?MobiTheme.colorCompanion
                                    :MobiTheme.colorCompanion,
                                text: value
                                    ? model.successMessage
                                    : model.errorMessage);
                          });
                        },
                        text: AppLocalizations.of(context).translate('save'),
                        color: MobiTheme.colorCompanion,
                        textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ])),
              ),
            ),
          ));
        });
  }
}

class TransactionListTile extends StatelessWidget {
  final colors = [
    MobiTheme.nearlyBlue,
    MobiTheme.red,
    MobiTheme.yellow,
    MobiTheme.green,
    MobiTheme.purple,
  ];

  final cashBackResponse.Row cashback;
  final int index;

  TransactionListTile(this.cashback, this.index);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      leading: Card(
        child: Container(
          decoration: BoxDecoration(
            color: double.parse(cashback.sumCredit) > 0
                ? MobiTheme.colorCompanion
                : double.parse(cashback.sumDebit) > 0
                    ? MobiTheme.colorCompanion
                    : null,
            borderRadius: BorderRadius.circular(48),
          ),
          child: SizedBox(
            height: 48,
            width: 48,
            child: Icon(Icons.euro_symbol_sharp, color: Colors.white),
          ),
        ),
        elevation: 8,
        shadowColor: colors[index % colors.length],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
      ),
      title: Text(
        cashback.partnerCompanyName,
        style: MobiTheme.text20BoldWhite,
      ),
      subtitle: cashback.transactionDeadlineToUse == ""
          ? Text(
              "${AppLocalizations.of(context).translate('date')} : ${DateFormat(resultingCreationDateFormat).format(
                DateFormat(incomingCreationDateFormat)
                    .parse(cashback.transactionCreationDateTime),
              )}",
              style: MobiTheme.text16BoldWhite,
            )
          : Text(
              "${AppLocalizations.of(context).translate('date')} : ${DateFormat(resultingCreationDateFormat).format(
                DateFormat(incomingCreationDateFormat)
                    .parse(cashback.transactionCreationDateTime),
              )}"
              "\n${AppLocalizations.of(context).translate('deadline')} : ${DateFormat(resultingDeadlineDateFormat).format(DateFormat(incomingDeadlineDateFormat).parse(cashback.transactionDeadlineToUse))}",
              style: MobiTheme.text16BoldWhite,
            ),
      isThreeLine: true,
      trailing: double.parse(cashback.sumCredit) > 0
          ? Text(
              "+ ${cashback.sumCredit} ${AppLocalizations.of(context).translate('moneySymbol')}",
              style: MobiTheme.text16BoldWhite,
            )
          : double.parse(cashback.sumDebit) > 0
              ? Text(
                  "- ${cashback.sumDebit} ${AppLocalizations.of(context).translate('moneySymbol')}",
                  style: MobiTheme.text16BoldWhite,
                )
              : null,
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return double.parse(cashback.sumCredit) > 0
                  ? Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0)), //this right here
                      child: Container(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (cashback.cashback != '0.00')
                                Text('CashBack reçu : + ' + cashback.cashback,
                                    style: TextStyle(fontSize: 20)),
                              if (cashback.cashbackTransferCredit != '0.00')
                                Text(
                                    'Crédit transféré : + ' +
                                        cashback.cashbackTransferCredit,
                                    style: TextStyle(fontSize: 20)),
                              if (cashback.vouchers != '0.00')
                                Text('Coupon reçu : + ' + cashback.vouchers,
                                    style: TextStyle(fontSize: 20)),
                              SizedBox(height: 20),
                              SizedBox(
                                width: 320.0,
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate('ok'),
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.white)),
                                  color: MobiTheme.colorCompanion,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : double.parse(cashback.sumDebit) > 0
                      ? Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0)), //this right here
                          child: Container(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (cashback.paymentbyCashback != '0.00')
                                    Text(
                                        'CashBack Utilisé : - ' +
                                            cashback.paymentbyCashback,
                                        style: TextStyle(fontSize: 20)),
                                  if (cashback.paymentbyCreditcard != '0.00')
                                    Text(
                                        'Carte de Crédit : - ' +
                                            cashback.paymentbyCreditcard,
                                        style: TextStyle(fontSize: 20)),
                                  if (cashback.cashbackTransfertDebit != '0.00')
                                    Text(
                                        'Cashback transféré : - ' +
                                            cashback.cashbackTransfertDebit,
                                        style: TextStyle(fontSize: 20)),
                                  if (cashback.reimbursmentCashback != '0.00')
                                    Text(
                                        'Cashback annulé : - ' +
                                            cashback.reimbursmentCashback,
                                        style: TextStyle(fontSize: 20)),
                                  if (cashback.canceledVouchers != '0.00')
                                    Text(
                                        'Coupon annulé : - ' +
                                            cashback.canceledVouchers,
                                        style: TextStyle(fontSize: 20)),
                                  if (cashback.usedVouchers != '0.00')
                                    Text(
                                        'Coupon utilisé : - ' +
                                            cashback.usedVouchers,
                                        style: TextStyle(fontSize: 20)),
                                  SizedBox(height: 20),
                                  SizedBox(
                                    width: 320.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .translate('ok'),
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white)),
                                      color: MobiTheme.colorCompanion,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : null;
            });
      },
    );
  }
}
