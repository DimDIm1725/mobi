import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/ticket_machine.dart';
import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/locator.dart';

class TicketMachinesService {
  Api _api = locator<Api>();

  getAllActivities(LoginRequest request) async {
    return await _api.getAllActivities(request);
  }

  getAllTicketMachinesForLocation(TicketMachineRequest request) async {
    return await _api.getAllTicketMachinesForLocation(request);
  }
}
