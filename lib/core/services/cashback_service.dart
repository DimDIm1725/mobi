import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/transfer_cashback.dart';
import 'package:mobiwoom/core/models/requests/user.dart';
import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/locator.dart';

class CashBackService {
  Api _api = locator<Api>();

  getAllCashBackAndVouchersList(LoginRequest request) async {
    return await _api.getAllCashBackAndVouchersList(request);
  }

  getCurrentMonthTransactions(LoginRequest request) async {
    return await _api.getCurrentMonthTransactions(request);
  }

  getAllClustersList(LoginRequest request) async {
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
  }
}
