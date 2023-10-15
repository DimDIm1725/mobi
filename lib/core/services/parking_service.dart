import 'package:mobiwoom/core/models/requests/parkingStart.dart';
import 'package:mobiwoom/core/models/requests/parkingStop.dart';
import 'package:mobiwoom/core/models/requests/ticket_machine.dart';
import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/locator.dart';

class ParkingService {
  Api _api = locator<Api>();

  getAllTicketMachinesForLocation(TicketMachineRequest request) {
    return _api.getAllTicketMachinesForLocation(request);
  }

  startParkingSession(ParkingStartRequest parkingStartRequest) {
    return _api.startParkingSession(parkingStartRequest);
  }

  stopParkingSession(ParkingStopRequest parkingStopRequest) {
    return _api.stopParkingSession(parkingStopRequest);
  }
}
