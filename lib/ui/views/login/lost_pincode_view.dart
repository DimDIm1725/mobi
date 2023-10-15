import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/login_model.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';

import 'package:mobiwoom/ui/widgets/ibackground4.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';
import 'package:mobiwoom/ui/widgets/iinputField2Password.dart';
import 'package:mobiwoom/ui/widgets/iappBar.dart';

class LostPincodeScreen extends StatefulWidget {
  static const routeName = "LostPincodeScreen";

  @override
  _LostPincodeScreenState createState() => _LostPincodeScreenState();
}

class _LostPincodeScreenState extends State<LostPincodeScreen> {
  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color:MobiTheme.colorPrimary
            ),
            // child:IBackground4(
            //     width: windowWidth, colorsGradient: MobiTheme.colorsGradient),
          ),
          Center(
            child: Container(
              width: isLargeScreen(context) ? getLargeScreenWidth(context) : screenSize.width,
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[LostPinCodeForm()]),
              ),
            ),
          ),
          Container(
            child:IAppBar(context: context, text: "", color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class LostPinCodeForm extends StatefulWidget {
  @override
  _LostPinCodeFormState createState() => _LostPinCodeFormState();
}

class _LostPinCodeFormState extends State<LostPinCodeForm> {
  TextEditingController phoneNumberController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneNumberController.text = SharedPrefUtil.getUserPhone();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      onModelReady: (model) {
        model.state == ViewState.Busy ? BotToast.showLoading() : BotToast.closeAllLoading();
      },
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          width: isLargeScreen(context) ? getLargeScreenWidth(context) : MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
              
                child: Center(
                  child: Image(image: AssetImage('images/logo.png')),
                ),
              ),
              SizedBox(height: 16),
              IInputField2(
                hint: AppLocalizations.of(context).translate('hint_mobile'),
                icon: Icons.phone,
                colorIcon:MobiTheme.colorIcon,
                type: TextInputType.phone,
                colorDefaultText: Colors.white,
                controller: phoneNumberController,
              ),

              SizedBox(height: 16),
              IButton3(
                pressButton: () async {
                  if (phoneNumberController.text.isEmpty) {
                    BotToast.showText(
                        contentPadding: EdgeInsets.all(16),
                        //  animationDuration: Duration(seconds: 2),
                        duration: Duration(seconds: 4),
                        contentColor: Colors.redAccent,
                        text: AppLocalizations.of(context).translate('enter_valid_phone_number'));
                  } else {
                    BotToast.showLoading();
                    try {
                      bool response = await model.sendPincode(phoneNumberController.text);
                      BotToast.closeAllLoading();
                      if (response) {
                        BotToast.showText(
                            contentPadding: EdgeInsets.all(16),
                            //  animationDuration: Duration(seconds: 2),
                            duration: Duration(seconds: 4),
                            contentColor: Colors.greenAccent,
                            text: AppLocalizations.of(context).translate('pincode_sent_check'));
                      } else {
                        BotToast.showText(
                            contentPadding: EdgeInsets.all(16),
                            //  animationDuration: Duration(seconds: 2),
                            duration: Duration(seconds: 4),
                            contentColor: Colors.redAccent,
                            text: model.errorMessage);
                      }
                    } catch (e) {
                      print(e);
                    }
                    BotToast.closeAllLoading();
                  }
                },
                text:AppLocalizations.of(context).translate('sign_in'),
                color: MobiTheme.colorCompanion,
                textStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color:Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
