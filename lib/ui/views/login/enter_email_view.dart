import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/login_model.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';

class EnterEmailScreen extends StatefulWidget {
  static const routeName = "EnterEmailScreen";
  LoginResponse loginResponse;

  @override
  _EnterEmailScreenState createState() => _EnterEmailScreenState();

  void setUser(LoginResponse loginResponse) {
    this.loginResponse = loginResponse;
  }
}

class _EnterEmailScreenState extends State<EnterEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('enter_email_screen')),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: ResponsiveLayout(child: EnterEmailForm(widget.loginResponse)),
        ),
      ),
    );
  }
}

class EnterEmailForm extends StatefulWidget {
  LoginResponse loginResponse;

  EnterEmailForm(this.loginResponse);

  @override
  _EnterEmailFormState createState() => _EnterEmailFormState();
}

class _EnterEmailFormState extends State<EnterEmailForm> {
  String email;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
        onModelReady: (model) {
          model.state == ViewState.Busy ? BotToast.showLoading() : BotToast.closeAllLoading();
        },
        builder: (context, model, child) => Column(
              children: <Widget>[
                MobiTextFormField(
                  prefixIcon: Icon(
                    Icons.email,
                  ),
                  label: AppLocalizations.of(context).translate('hint_email'),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: MobiButton(
                        color: Colors.red,
                        text: AppLocalizations.of(context).translate('refuse'),
                        onPressed: () {
                          logoutUser(context: context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: MobiButton(
                        text: AppLocalizations.of(context).translate('verify_email'),
                        color: Colors.teal,
                        onPressed: () {
                          if (email != null && email.isNotEmpty) {
                            model.setState(ViewState.Busy);
                            widget.loginResponse.response.data.userEMail = email;
                            model.setEmailForUser(widget.loginResponse).then((value) {
                              BotToast.showText(
                                  contentPadding: EdgeInsets.all(16),
                               //   animationDuration: Duration(seconds: 2),
                                  duration: Duration(seconds: 4),
                                  contentColor: value ? Colors.greenAccent : Colors.redAccent,
                                  text: value
                                      ? AppLocalizations.of(context).translate('email_updated_success') + AppLocalizations.of(context).translate('valid_email')
                                      : AppLocalizations.of(context).translate('error_occured'));
                              if (value) {
                                SharedPrefUtil.setCurrentUser(widget.loginResponse);
                                Navigator.popAndPushNamed(context, "/");
                              }
                            });
                          } else {
                            BotToast.showText(text: AppLocalizations.of(context).translate('enter_email_address'));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }
}
