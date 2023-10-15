import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

String kAppName = "BonjourCard";
String kApplicationToken = "cfae6bbcfa2d0cc75cee0c49574ba95d3bfa";
String kAppVersion = "5.0";
String kVersion = "";
String kAppID = "";
String kApiLanguage = "FR";
bool kGpsEnabled = false;
bool kGpstest = false;
bool inParkingSession = false;
CameraPosition kGooglePlex;
LatLng lastMapPosition;
double currentZoom = 17;

String kReturnCode = "";
String kActionUrl = "https://3ds-acs.test.modirum.com/mdpayacs/3ds-method";
String kActionMethod = "POST";
String kPareqFieldName = "threeDSMethodData";
String kPareqFieldValue =
    "eyAidGhyZWVEU1NlcnZlclRyYW5zSUQiIDogIjlhZGY4ZTAyLTlkOWEtNTkwMC04MDAwLTAwMDAwMDcwNjk1OSIsICJ0aHJlZURTTWV0aG9kTm90aWZpY2F0aW9uVVJMIiA6ICIiaHR0cHM6Ly9wcmVwcm9kYXBpLm1vYml3b29tLmNvbS8_QXBpPVVzZXJHZXQlMjZBcHBsaWNhdGlvblRva2VuPWRiOTVjZGE5ZTgzOTFiY2Y0N2JhN2I2YjVhNDBiNzQ1M2JmOGNiJTI2TGFuZ3VhZ2U9RlIiIiB9";
String kMdFieldName = "MD";
String kMdFieldValue = "28767e30-3781-47c1-b1d7-d4bd7c1d4ccc";
String kThreeDSServerTransID = "28767e30-3781-47c1-b1d7-d4bd7c1d4ccc";
//String kThreeDSecuretermUrl = "https://payline.mobiwoom.com/receive_form.php";
String kThreeDSecure_NotificationURL = "https://payline.mobiwoom.com/receive_form.php";

// TODO get these params from Api Startup ?

String kApiKey = "AIzaSyA8JBJ0jslecLFwYbdpO80nIdbQY9AWhBc";
String kAuthDomain = "bonjourcard.firebaseapp.com";
String kDatabaseURL = "https://bonjourcard.firebaseio.com";
String kProjectId = "bonjourcard";
String kStorageBucket = "bonjourcard.appspot.com";
String kMessagingSenderId = "70543702123";
String kAppId = "1:70543702123:web:a8bb6ef3b4e5dbb2ead92e";
String kMeasurementId = "G-RPKBQCSL9Z";

FirebaseApp app;
FirebaseOptions get firebaseOptions => const FirebaseOptions(
  appId: "1:70543702123:web:a8bb6ef3b4e5dbb2ead92e",
  apiKey: 'AIzaSyA8JBJ0jslecLFwYbdpO80nIdbQY9AWhBc',
  projectId: 'bonjourcard',
  messagingSenderId: '70543702123',
);