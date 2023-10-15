import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/transactions_file.dart';
import 'package:mobiwoom/core/models/requests/transfer_cashback.dart';
import 'package:mobiwoom/core/models/requests/user.dart';
import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/locator.dart';

class TransactionsService {
  Api _api = locator<Api>();

  getTransactions(LoginRequest request) async {
    return await _api.getTransactions(request);
  }

  getTransactionsFile(TransactionFileRequest request) async {
    return await _api.getTransactionsFile(request);
  }

 /* getAllClustersList(LoginRequest request) async {
    return await _api.getAllClustersList(request);
  }

  addNewCashBack(LoginRequest request) {
    return _api.addNewCashBack(request);
  }

  getCustomerFromNumber(LoginRequest loginRequest) {
    return _api.getCustomerFromCard(loginRequest);
  }

  addRecipient(User request) async {
    return await _api.addRecipient(request);
  }

  transferCashBacks(TransferCashBack transferCashBack) async {
    return await _api.transferCashBacks(transferCashBack);
  }*/
}
