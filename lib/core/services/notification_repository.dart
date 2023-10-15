import 'package:mobiwoom/core/services/api.dart';
import 'package:mobiwoom/core/models/requests/base_request.dart';
import 'package:mobiwoom/core/models/responses/notification.dart'
    as notification;
import 'package:mobiwoom/locator.dart';

class NotificationService {
  Api _api = locator<Api>();
  Future<notification.Notification> getNotifications(
      BaseRequest request) async {
    return _api.getNotifications(request);
  }
}
