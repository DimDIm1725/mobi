import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/models/responses/transactions.dart'
    as transactionsResponse;
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/transactions_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/views/sponsorship/sponsorships.dart';
import 'package:mobiwoom/ui/widgets/drawer.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

//String resultingCreationDateFormat = 'dd/MM/yyyy';
//String incomingCreationDateFormat = 'yyyy/MM/dd HH:mm:ss';

//String resultingDeadlineDateFormat = 'dd/MM/yyyy';
//String incomingDeadlineDateFormat = 'yyyy/MM/dd';

class TransactionsHistoryView extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionsHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        color: Color(0xff061f39),
        child: OtherWidget(),
      ),
    );
  }
}

/*class TransactionsWidget extends StatefulWidget {
  @override
  _TransactionsWidgetState createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
  @override
  Widget build(BuildContext context) {
    return BaseView<TransactionsHistoryModel>(
      onModelReady: (model) async {},
      builder: (context, model, child) {
        return Consumer<DrawerAndToolbar>(
          builder: (context, indexData, _) => Scaffold(
            drawer: MobiDrawer(),
            body:
                model.currentSelectedTab == 0 ? currentWidget() : OtherWidget(),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (currentIndex) {
                model.currentSelectedTab = currentIndex;
                model.setState(ViewState.Idle);
              },
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

class currentWidget extends StatefulWidget {
  currentWidget();

  @override
  _CurrentWidgetState createState() => _CurrentWidgetState();
}

class _CurrentWidgetState extends State<currentWidget> {
  Future<List<transactionsResponse.Row>> cashBacks;

  @override
  Widget build(BuildContext context) {
    return BaseView<TransactionsHistoryModel>(onModelReady: (model) async {
      cashBacks = model.getTransactions();
    }, builder: (context, model, child) {
      return MobiAppBar(
        child: ModalProgressHUD(
          color: Theme.of(context).scaffoldBackgroundColor,
          inAsyncCall: model.state == ViewState.Busy,
          child: Consumer<DrawerAndToolbar>(
            builder: (context, indexData, _) =>
                FutureBuilder<List<transactionsResponse.Row>>(
              future: cashBacks,
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    if (snapshot.data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.euro_symbol,
                              size: 72,
                              color: MobiTheme.nearlyBlack,
                            ),
                            SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('no_cashback_available'),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          SingleStat(
                            label: AppLocalizations.of(context)
                                .translate('current_transactions'),
                            value:"",
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) => TransactionListTile(
                              snapshot.data[index],
                              index,
                            ),
                            separatorBuilder: (_, __) => Divider(
                              indent: 72,
                              height: 4,
                            ),
                            itemCount: snapshot.data.length,
                          ),
                        ],
                      ),
                    );
                  }
                }

                return Container();
              },
            ),
          ),
        ),
      );
    });
  }
}*/

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
        lastDate: DateTime.now());
    if (picked != null && picked != selectedMonth) {
      selectedMonth = picked;
      setState(() {
        selectedMonth = picked;
     //   _monthDateController.text = DateFormat.yMMMM('fr').format(selectedMonth);
      });
    }
  }

 /* Future<Null> _selectYear(BuildContext context) async {
    final DateTime picked = await showMonthPicker(
        context: context,
        initialDate: selectedYear,
        firstDate: DateTime(2020),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedYear) {
      selectedYear = picked;
      setState(() {
        selectedYear = picked;
        _yearDateController.text = DateFormat.yMd('fr').format(selectedYear);
      });
    }
  }*/

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
                child: Column(
                  children: <Widget>[
                    SingleStat(
                      label: AppLocalizations.of(context)
                          .translate('enter_range_date'),
                      value: '',
                      color: MobiTheme.nearlyBlue,
                      style: Theme.of(context).textTheme.headline6
                    ),
                    SizedBox(height: 10),
                    Text(
                      'sélectionnez votre mois',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
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
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _monthDateController,
                        /*  onSaved: (String val) {
                            _setDate = val;
                          },*/
                          decoration: InputDecoration(
                              disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(top: 0.0)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  /*  Text(
                      'Choose End Date',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5),
                    ),
                    InkWell(
                      onTap: () {
                        _selectYear(context);
                      },
                      child: Container(
                        width: _width / 1.7,
                        height: _height / 9,
                        margin: EdgeInsets.only(top: 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.grey[200]),
                        child: TextFormField(
                          style: TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _yearDateController,
                          onSaved: (String val) {
                            _setDate = val;
                          },
                          decoration: InputDecoration(
                              disabledBorder:
                              UnderlineInputBorder(borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(top: 0.0)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),*/
                    MobiButton(
                        padding: const EdgeInsets.all(16),
                        text: AppLocalizations.of(context).translate('save'),
                        onPressed: () {
                          model.getTransactionsFile(selectedMonth);
                        }),
                  ],
                ),
              )),
            ),
          ));
        });
  }
}

/*getAllTableRows(BuildContext context, List<transactionsResponse.Row> cashBackList,
    List<double> cashbacks,
    {bool isVoucher = false}) {
  List<TableRow> rows = [];
  double total = 0;
  rows.add(getTableHeader(context));
  for (transactionsResponse.Row cashback in cashBackList) {
    if (cashback.transactionIsVoucher.toLowerCase() == isVoucher.toString()) {
      total += double.parse(cashback.transactionAmount);
      TableRow row = TableRow(children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateFormat(resultingCreationDateFormat).format(
                DateFormat(incomingCreationDateFormat)
                    .parse(cashback.transactionCreationDateTime),
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              cashback.partnerCompanyName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(cashback.transactionAmount),
            )),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateFormat(resultingDeadlineDateFormat).format(
                DateFormat(incomingDeadlineDateFormat)
                    .parse(cashback.transactionDeadlineToUse),
              ),
            ),
          ),
        ),
      ]);
      rows.add(row);
    }
  }
  cashbacks.add(total);
  return rows;
}

TableRow getTableHeader(BuildContext context) {
  return TableRow(
      decoration: BoxDecoration(color: MobiTheme.nearlyBlue),
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('date'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('location'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
          ),
        ),
        TableCell(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.attach_money,
                        color: Colors.white,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('amount'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
            )),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.update,
                      color: Colors.white,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('deadline'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
          ),
        ),
      ]);
}*/

/*class TransactionListTile extends StatelessWidget {
  final colors = [
    MobiTheme.nearlyBlue,
    MobiTheme.red,
    MobiTheme.yellow,
    MobiTheme.green,
    MobiTheme.purple,
  ];

  final transactionsResponse.Row cashback;
  final int index;

  TransactionListTile(this.cashback, this.index);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: Card(
        child: Container(
          decoration: BoxDecoration(
            color: colors[index % colors.length],
            borderRadius: BorderRadius.circular(48),
          ),
          child: SizedBox(
            height: 48,
            width: 48,
            child: Icon(Icons.euro_symbol, color: Colors.white),
          ),
        ),
        elevation: 8,
        shadowColor: colors[index % colors.length],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(48)),
      ),
      title: Text(
        cashback.partnerCompanyName,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "${AppLocalizations.of(context).translate('date')} : ${DateFormat(resultingCreationDateFormat).format(
          DateFormat(incomingCreationDateFormat)
              .parse(cashback.transactionCreationDateTime),
        )}"
        "\n${AppLocalizations.of(context).translate('deadline')} : ${DateFormat(resultingDeadlineDateFormat).format(
          DateFormat(incomingDeadlineDateFormat)
              .parse(cashback.transactionDeadlineToUse),
        )}",
      ),
      isThreeLine: true,
      trailing: Text(
        "${AppLocalizations.of(context).translate('moneySymbol')} ${cashback.transactionAmount}",
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}*/
