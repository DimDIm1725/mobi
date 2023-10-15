import 'dart:async';

//import 'package:firebase_cloud_messaging_interop/firebase_cloud_messaging_interop.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
//import 'package:firebase/firebase.dart' as firebase;

class FBMessaging {
  FBMessaging();

  static FBMessaging _instance;
  //static FirebaseMessagingWeb fcm;
  //
  static StreamController _controller = StreamController<Map<String, dynamic>>.broadcast();

  static FBMessaging get instance {
    if (_instance == null) {
      // _instance = FBMessaging();
      // fcm = FirebaseMessagingWeb(
      //     publicVapidKey: "BMqzxMdlMBgQFYCO2cBQ8deKO_LOtBwegGpaM3SnVSNV0RwThWhxDaPSxeNDn_IU0MmIHweGeWIESymee5ddFjY");
      // fcm.onTokenRefresh(() async => SharedPrefUtil.setFCMToken(await fcm.getToken()));
      // fcm.onMessage((message) {
      //   print("Message came $message");
      //   _controller.sink.add(message);
      // });
    }
    return _instance;
  }

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void close() {
    _controller?.close();
  }

  Future requestPermission() {
    //  return fcm.requestNotificationPermissions();
  }

  Future<String> getToken([bool force = false]) async {
    // return fcm.getToken();
  }
}
