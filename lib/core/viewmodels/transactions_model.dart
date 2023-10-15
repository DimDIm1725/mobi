import 'dart:async';
import 'dart:collection';

import 'package:mobiwoom/core/models/requests/login.dart' as requestLogin;
import 'package:mobiwoom/core/models/requests/transfer_cashback.dart' as tranCashBkReq;
import 'package:mobiwoom/core/models/requests/user.dart' as userReq;
import 'package:mobiwoom/core/models/requests/transactions_file.dart' as transactionFileReq;
import 'package:mobiwoom/core/models/responses/add_cashback.dart' as addCashbackResponse;
import 'package:mobiwoom/core/models/responses/transactions.dart' as transactionsResponse;
import 'package:mobiwoom/core/models/responses/cluster.dart';
import 'package:mobiwoom/core/models/responses/login.dart' as loginRes;
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/services/transactions_service.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/application.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/locator.dart';
import 'package:mobiwoom/ui/shared/localization.dart';

class TransactionsHistoryModel extends BaseModel {
  TransactionsService transactionsService = locator<TransactionsService>();

  var currentSelectedTab = 0;
  userReq.User user = locator<userReq.User>();
  String recipientName;
  tranCashBkReq.TransferCashBack transferCashBack = locator<tranCashBkReq.TransferCashBack>();
  bool showErrorMessage = false;

  TransactionsModel() {
    user.data = userReq.Data();
    transferCashBack.data = tranCashBkReq.Data();
  }

  Future<List<transactionsResponse.Row>> getTransactions() async {
    setState(ViewState.Busy);
    loginRes.LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
        // TODO waiting for new api from DEV
        api: 'CashBackAndVouchersList',
        userBrowserType: getAccountBrowserType(),
        language: loginResponse.response.data.userLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        userUniversalKey: loginResponse.response.userPhoneNumber,
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    transactionsResponse.Transactions response = await transactionsService.getTransactions(loginRequest);
    setState(ViewState.Idle);
    if (response.error != null) {
      errorMessage = response.error;
    } else {
      if (response.response.errorNumber == '0') {
        successMessage = "";
        return response.response.data.row;
      } else {
        errorMessage = response.response.message;
      }
    }

    return null;
  }

  Future<bool>getTransactionsFile(DateTime selectedMonth) async {
    setState(ViewState.Busy);
    bool status = false;
    loginRes.LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    transactionFileReq.TransactionFileRequest transactionsRequest = new transactionFileReq.TransactionFileRequest(
      data: transactionFileReq.Data(
        // TODO waiting for new api from DEV
        api: 'TransactionsHistoryLink',
      //  userBrowserType: getAccountBrowserType(),
        language: loginResponse.response.data.userLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        userUniversalKey: loginResponse.response.userPhoneNumber,
        userPinCode: userPincode,
        year: selectedMonth.year.toString(),
        month: selectedMonth.month.toString(),
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    var file = await transactionsService.getTransactionsFile(transactionsRequest);
    setState(ViewState.Idle);
    if (file.error != null) {
      errorMessage = file.error;
    } else {
      if (file.response.errorNumber == '0') {
        successMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('sentbyemail');
        status = true;
      } else {
        errorMessage = file.response.message;
        status = false;
      }
    }
    return status;
  }

 /* Future<Cluster> getAllClustersList() async {
    bool status = false;
    loginRes.LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
        api: 'ClustersList',
        userBrowserType: getAccountBrowserType(),
        language: loginResponse.response.data.userLanguage,
        userUniversalKey: loginResponse.response.userPhoneNumber,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        commonApiLanguage: kApiLanguage,
        commonApiVersion: kAppVersion,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    Cluster response = await transactionsService.getAllClustersList(loginRequest);
    if (response.response.errorNumber == '0') {
      successMessage = "";
      return response;
    } else {
      if (response.response.message is LinkedHashMap) {
        errorMessage = response.response.message["#cdata-section"];
      } else {
        errorMessage = response.response.message;
      }
    }
    setState(ViewState.Idle);
    return null;
  }

  Future<bool> addNewCashBack(String text) async {
    bool status = false;
    setState(ViewState.Busy);
    loginRes.LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
        api: 'TransactionAddNewCashBackPending',
        userBrowserType: getAccountBrowserType(),
        language: loginResponse.response.data.userLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        userUniversalKey: loginResponse.response.userPhoneNumber,
        commonApiVersion: kAppVersion,
        commonApiLanguage: kApiLanguage,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
        cashBackPendingToken: text,
      ),
    );
    addCashbackResponse.AddCashBack response = await transactionsService.addNewCashBack(loginRequest);
    setState(ViewState.Idle);
    if (response.error != null) {
      errorMessage = response.error;
    } else {
      if (response.response.errorNumber == '0') {
        successMessage = AppLocalizations.of(locator<Application>().navigatorKey.currentContext)
            .translate('cashback_added_successfully');
        status = true;
      } else {
        errorMessage = response.response.message;
      }
    }
    return status;
  }

  Future<bool> getCustomerFromCard(String number) async {
    bool status = false;
    setState(ViewState.Busy);
    loginRes.LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    requestLogin.LoginRequest loginRequest = new requestLogin.LoginRequest(
      data: requestLogin.Data(
        api: 'UserParseLite',
        userUniversalKey: number,
        userBrowserType: getAccountBrowserType(),
        language: loginResponse.response.data.userLanguage,
        userPhoneCountry: loginResponse.response.userPhoneCountry,
        commonApiLanguage: kApiLanguage,
        commonApiVersion: kAppVersion,
        applicationVersion: kVersion,
        applicationToken: kApplicationToken,
      ),
    );
    LoginResponse response = await transactionsService.getCustomerFromNumber(loginRequest);
    if (response.response.errorNumber == '0') {
      successMessage = "";
      recipientName = '${response.response.data.userFirstName} ${response.response.data.userLastName}';
      status = true;
    } else {
      if (response.response.message is LinkedHashMap) {
        errorMessage = response.response.message["#cdata-section"];
      } else {
        errorMessage = response.response.message;
      }

      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }

  Future<bool> transferCashBacks() async {
    bool status = false;
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    print('TransactionAddNewTransfer start');
    transferCashBack.data.api = 'TransactionAddNewTransfer';
    transferCashBack.data.fromUserPhoneNumber = loginResponse.response.userPhoneNumber;
    transferCashBack.data.fromUserPhoneCountry = loginResponse.response.userPhoneCountry;
    transferCashBack.data.fromUserPinCode = userPincode;
    transferCashBack.data.toUserPhoneCountry = loginResponse.response.userPhoneCountry;
    transferCashBack.data.applicationVersion = kVersion;
    transferCashBack.data.commonApiVersion = kAppVersion;
    transferCashBack.data.commonApiLanguage = kApiLanguage;
    transferCashBack.data.applicationToken = kApplicationToken;
    print(transferCashBack.toJson());
    LoginResponse response = await transactionsService.transferCashBacks(transferCashBack);

    if (response.response.errorNumber == '0') {
      successMessage =
          '${AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('cashback_sent_successfully_to')} $recipientName';
      status = true;
    } else {
      if (response.response.message is LinkedHashMap) {
        errorMessage = response.response.message["#cdata-section"];
      } else {
        errorMessage = response.response.message;
      }

      status = false;
    }
    print('TransactionAddNewTransfer end');

    setState(ViewState.Idle);
    return status;
  }

  Future<bool> addRecipient() async {
    bool status = false;
    setState(ViewState.Busy);
    LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
    String userPincode = await SharedPrefUtil.getUserPincode();
    user.data.api = 'UserAddNew';
    user.data.userCountry = loginResponse.response.data.userCountry;
    user.data.userLanguage = loginResponse.response.data.userLanguage;
    user.data.userUniversalKey = loginResponse.response.userPhoneNumber;
    user.data.userPhoneCountry = loginResponse.response.userPhoneCountry;
    user.data.applicationVersion = kVersion;
    user.data.applicationToken = kApplicationToken;
    user.data.commonApiLanguage = kApiLanguage;
    user.data.commonApiVersion = kAppVersion;
    print(user.data.userUniversalKey);
    LoginResponse response = await transactionsService.addRecipient(user);

    if (response.response.errorNumber == '0') {
      successMessage =
          AppLocalizations.of(locator<Application>().navigatorKey.currentContext).translate('user_added_successfully');
      status = true;
    } else {
      if (response.response.message is LinkedHashMap) {
        errorMessage = response.response.message["#cdata-section"];
      } else {
        errorMessage = response.response.message;
      }

      status = false;
    }
    setState(ViewState.Idle);
    return status;
  }*/
}
