import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/login_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/views/account/contactless_card_view.dart';
import 'package:mobiwoom/app_language.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:provider/provider.dart';
import '../../shared/localization.dart';
import 'package:flutter/src/widgets/preferred_size.dart';
import 'package:mobiwoom/ui/widgets/ibackground4.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';
import 'package:mobiwoom/ui/widgets/iinputField2Password.dart';
import 'package:mobiwoom/ui/widgets/iappBar.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(title: Text(AppLocalizations.of(context).translate('register')), backgroundColor: Colors.transparent),
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
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[RegisterForm()]),
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

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool termsAgreed = false;
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      onModelReady: (model) {
        model.state == ViewState.Busy ? BotToast.showLoading() : BotToast.closeAllLoading();
      },
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
             
              child: Center(
                child: Image(image: AssetImage('images/logo.png')),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: CountryCodePicker(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                    onChanged: (value) async {
                      var appLanguage = Provider.of<AppLanguage>(context, listen: false);
                      await appLanguage.changeLanguage(Locale(value.code.toLowerCase()));
                    },
                    initialSelection: SharedPrefUtil.getUserCountryCode(),
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    showFlagMain: false,
                    alignLeft: false,
                    dialogSize: Size(280.0, 280.0),
                    boxDecoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(24)),
                    textStyle: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    hideMainText: false,
                    countryFilter: ['BE', 'FR', 'LU', 'DE', 'GB'],
                    hideSearch: true,
                  ),
                ),
                Flexible(
                  flex: 9,
                  child: IInputField2(
                    hint: AppLocalizations.of(context).translate('hint_username'),
                    icon: Icons.phone,
                    colorIcon:MobiTheme.colorIcon,
                    type: TextInputType.phone,
                    colorDefaultText: Colors.white,
                    onChangeText: (value) {
                      model.registerUser.userPhoneNumber = value;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            IInputField2(
              hint: AppLocalizations.of(context).translate('hint_name'),
              icon: Icons.person,
              colorIcon:MobiTheme.colorIcon,
              type: TextInputType.phone,
              colorDefaultText: Colors.white,
              onChangeText: (value) {
                model.registerUser.userFirstName = value;
              },
            ),

            SizedBox(height: 16),
            IInputField2(
              hint: AppLocalizations.of(context).translate('hint_last_name'),
              icon: Icons.person,
              colorIcon:MobiTheme.colorIcon,
              type: TextInputType.phone,
              colorDefaultText: Colors.white,
              onChangeText: (value) {
                model.registerUser.userLastName = value;
              },
            ),

            SizedBox(height: 16),
            IInputField2(
              hint: AppLocalizations.of(context).translate('hint_email'),
              icon: Icons.email,
              colorIcon:MobiTheme.colorIcon,
              type: TextInputType.phone,
              colorDefaultText: Colors.white,
              onChangeText: (value) {
                model.registerUser.userEmail = value;
              },
            ),

            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white),
                    child: Checkbox(
                      value: termsAgreed,
                      tristate: false,
                      onChanged: (state) {
                        setState(() {
                          termsAgreed = state;
                          if (termsAgreed) {
                            _showTCU(context);
                          }
                        });
                      },
                      checkColor: Colors.white,
                      activeColor: MobiTheme.colorIcon,
                    )),
                SizedBox(width: 16),
                Expanded(
                    child: Text(
                  AppLocalizations.of(context).translate('terms_and_conditions'),
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                )),
              ],
            ),
            SizedBox(height: 16),
            IButton3(
              pressButton: () async {
                String validation = model.getValidationMessage();
                if (termsAgreed) {
                  if (validation.isEmpty) {
                    BotToast.showLoading();
                    try {
                      bool response = await model.register();
                      BotToast.closeAllLoading();
                      if (response) {
                        showSuccessMessage(AppLocalizations.of(context).translate('registration_ok'));
                        SharedPrefUtil.setUserPhone(model.registerUser.userPhoneNumber);
                        Navigator.pop(context);
                      } else {
                        showErrorMessage(model.errorMessage);
                      }
                    } catch (e) {
                      print(e);
                    }
                    BotToast.closeAllLoading();
                  } else {
                    showErrorMessage(validation);
                  }
                } else {
                  showErrorMessage(AppLocalizations.of(context).translate('tac_agreement'));
                }
              },
              text:AppLocalizations.of(context).translate('register'),
              color: MobiTheme.colorCompanion,
              textStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color:Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showTCU(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            AppLocalizations.of(context).translate('terms_and_conditions_text'),
          ),
        );
      },
    );
  }
}
