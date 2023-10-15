import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
//import 'package:firebase/firebase.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/models/responses/payline.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/card_model.dart';
import 'package:mobiwoom/main.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:mobiwoom/webview/webviewx.dart' as webx;
import 'package:webview_flutter/webview_flutter.dart';

class ThreeDSecureBankView extends StatefulWidget {
  String url;
  String returnUrl;
  String cancelUrl;
  String token;

  static const routeName = "ThreeDSecureBankView";

  ThreeDSecureBankView();

  @override
  ThreeDSecureBankViewState createState() => ThreeDSecureBankViewState();
}

class ThreeDSecureBankViewState extends State<ThreeDSecureBankView> {
  WebViewController _controller;
  webx.WebViewXController _xController;
  bool showWebView = true;
  bool closeStatus = true;
  StreamSubscription<Event> _firebaselistener;

  @override
  void initState() {
    super.initState();
    //  _firebaselistener.cancel();
    initFirebaseRealtimeDB();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _firebaselistener.cancel();
  }

  Future<void> initFirebaseRealtimeDB() async {
    LoginResponse response = SharedPrefUtil.getCurrentUser();
    assert(app != null);
    print('Initialized $app');

    DatabaseReference _counterRef = FirebaseDatabase.instance
        .reference()
        .child("users/${response.response.userId}/creditcard");

    String errormessage;
    String errorcode;

    _firebaselistener = _counterRef.onChildChanged.listen((e) {
      DataSnapshot datasnapshot = e.snapshot;
      dynamic parsedRes = jsonDecode(datasnapshot.value);
      errorcode = parsedRes[0];
      errormessage = parsedRes[1];

      if (closeStatus) {
        print("Data came from firebase onChildChanged");

        BotToast.showText(
            contentPadding: EdgeInsets.all(16),
            //  animationDuration: Duration(seconds: 2),
            duration: Duration(seconds: 4),
            contentColor:
                errorcode == "00000" ? Colors.greenAccent : Colors.redAccent,
            text: errormessage);

        Navigator.pop(context);
        closeStatus = false;
      }
    });

    _counterRef.onChildAdded.listen((e) {
      print("Data came from firebase onChildAdded");
      DataSnapshot datasnapshot = e.snapshot;
      print(datasnapshot.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CardModel>(onModelReady: (cardModel) {
      // String returnUrl = "https://payline.mobiwoom.com/close.html";
      // TODO not used ? as we can GO BACK in app ... no cancel button !
      String cancelUrl =
          "http://payline.mobiwoom.com/examples/demos/web.php?e=cancelUrl";

      cardModel.addCard().then((value) async {
        if (value.error == null) {
          // don't need to test this , if value == null
          //  if (value.response.data.paylineRedirectUrl != null) {
          PaylineData paylineData = await SharedPrefUtil.getPaylineData();
          widget.returnUrl = "${paylineData.response.data.paylineReturnUrl}";
          //  widget.cancelUrl = cancelUrl;

          /* if (kIsWeb) {
            widget.url =
            "${paylineData.response.data
                .paylineServicesServer}/payline_web.php?token=${value.response
                .data.paylineToken}";
            //  widget.url = "https://payline.mobiwoom.com/payline_web.php?token=${value.response.data.paylineToken}";
            //  widget.url = "https://payline.mobiwoom.com/prod.php?token=${value.response.data.paylineToken}";
            //  widget.url = value.response.data.paylineRedirectUrl;
          } else {
            widget.url =
            "${paylineData.response.data
                .paylineServicesServer}/payline_device.php?token=${value
                .response.data.paylineToken}";
            //   widget.url = "https://payline.mobiwoom.com/payline_device.php?token=${value.response.data.paylineToken}";
            //  widget.url = "https://payline.mobiwoom.com/prod2.php?token=${value.response.data.paylineToken}";
            //  widget.url = value.response.data.paylineRedirectUrl;
          }*/
          widget.url = value.response.data.paylineRedirectUrl;
          widget.token = value.response.data.paylineToken;
          cardModel.setState(ViewState.Idle);
          //  }
        } else {
          cardModel.setState(ViewState.Idle);
          BotToast.showText(
              contentPadding: EdgeInsets.all(16),
              //  animationDuration: Duration(seconds: 2),
              duration: Duration(seconds: 4),
              contentColor: Colors.redAccent,
              text: AppLocalizations.of(context).translate('error_occured'));
          Navigator.pop(context);
        }
      });
    }, builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('add_new_card'),
          ),
        ),
        body: widget.returnUrl != null
            ? showWebView
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: kIsWeb
                        ? webx.WebViewX(
                            key: ValueKey('webviewx'),
                            javascriptMode: webx.JavascriptMode.unrestricted,
                            //    initialContent: "Test",
                            //    initialSourceType: webx.SourceType.HTML,
                            //   onPageStarted: (page) => onPageStarted(page, model),
                            //   onPageFinished: onPageFinished,
                            onWebViewCreated: (controller) {
                              _xController = controller;
                              _xController.loadContent(
                                  widget.url, webx.SourceType.URL);
                            },
                            jsContent: {},
                            /*  dartCallBacks: {
                              webx.DartCallback(
                                name: 'MobiwoomCallback',
                                callBack: (msg) {
                                },
                              )
                            },*/
                          )
                        : WebView(
                            debuggingEnabled: true,
                            javascriptMode: JavascriptMode.unrestricted,
                            initialUrl: widget.url,
                            //  onPageStarted: (page) => onPageStarted(page, model),
                            //   onPageFinished: onPageFinished,
                            //  userAgent: Platform.isIOS ? "Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148":null,
                            onWebViewCreated:
                                (WebViewController webViewController) {
                              _controller = webViewController;
                            },
                          ),
                  )
                : Container()
            : MobiLoader(),
      );
    });
  }

  Future<void> onPageFinished(String page) async {
    //   print("onPageFinihsed $page");
    // _xController.getContent().then((value) => value.source);
  }

  void onPageStarted(String page, CardModel model) {
    print("onPageStarted $page");
    String fullReturnUrl = widget.returnUrl /*+ "?token=" + widget.token*/;
    if (page.startsWith(fullReturnUrl)) {
      print("returnUrl found");
      Navigator.pop(context);
      setState(() {
        showWebView = false;
      });
      /*   model.sendToken(widget.token).then((tokenResponse) {
        bool status;
        String message;
        if (tokenResponse.error == null) {
          if (tokenResponse.response.errorNumber == null) {
            status = false;
          } else if (tokenResponse.response.errorNumber == "0") {
            message = AppLocalizations.of(context).translate('card_added_successfully');
            status = true;
          } else {
            if (tokenResponse.response.message is LinkedHashMap) {
              message = tokenResponse.response.message["#cdata-section"];
            } else {
              message = tokenResponse.response.message;
            }
            status = false;
          }
        } else {
          message = tokenResponse.error;
          status = false;
        }
        BotToast.showText(
            contentPadding: EdgeInsets.all(16),
            //  animationDuration: Duration(seconds: 2),
            duration: Duration(seconds: 4),
            contentColor: status ? Colors.greenAccent : Colors.redAccent,
            text: message);
        Navigator.pop(context);
        setState(() {
          showWebView = false;
        });
      });*/
    } else if (page.startsWith(widget.cancelUrl)) {
      //   print("cancelUrl found");
      Navigator.pop(context);
      setState(() {
        showWebView = false;
      });
    }
  }
}
