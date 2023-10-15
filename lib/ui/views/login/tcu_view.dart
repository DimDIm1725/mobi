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
import 'package:mobiwoom/ui/views/login/enter_email_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  static const routeName = "TermsAndConditionsScreen";
  LoginResponse loginResponse;

  @override
  _TermsAndConditionsScreenState createState() => _TermsAndConditionsScreenState();

  void setUser(LoginResponse loginResponse) {
    this.loginResponse = loginResponse;
  }
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('terms_and_conditions_title')),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ResponsiveLayout(
          child: TermsAndConditionsForm(widget.loginResponse),
        ),
      ),
    );
  }
}

class TermsAndConditionsForm extends StatefulWidget {
  final LoginResponse loginResponse;

  TermsAndConditionsForm(this.loginResponse);

  @override
  _TermsAndConditionsFormState createState() => _TermsAndConditionsFormState();
}

class _TermsAndConditionsFormState extends State<TermsAndConditionsForm> {
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      onModelReady: (model) {
        model.state == ViewState.Busy ? BotToast.showLoading() : BotToast.closeAllLoading();
      },
      builder: (context, model, child) => Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('accept_terms_to_continue'),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 16),
          MobiButton(
            padding: const EdgeInsets.all(16),
            text: AppLocalizations.of(context).translate('see_t_n_c'),
            onPressed: () {
              _showTCU(context);
            },
          ),
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).translate('click_accept_message'),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MobiButton(
                  padding: const EdgeInsets.all(16),
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
                  padding: const EdgeInsets.all(16),
                  color: Colors.teal,
                  text: AppLocalizations.of(context).translate('accept'),
                  onPressed: () {
                    model.setState(ViewState.Busy);
                    model.acceptTCUForUser(widget.loginResponse).then((value) {
                      BotToast.showText(
                          contentPadding: EdgeInsets.all(16),
                        //  animationDuration: Duration(seconds: 2),
                          duration: Duration(seconds: 4),
                          contentColor: value ? Colors.greenAccent : Colors.redAccent,
                          text: value
                              ? AppLocalizations.of(context).translate('tcu_accepted')
                              : AppLocalizations.of(context).translate('error_occured'));
                      if (value) {
                        if (widget.loginResponse.response.data.userEMail == null ||
                            widget.loginResponse.response.data.userEMail.isEmpty) {
                          Navigator.popAndPushNamed(context, EnterEmailScreen.routeName,
                              arguments: widget.loginResponse);
                        } else {
                          SharedPrefUtil.setCurrentUser(widget.loginResponse);
                          Navigator.popAndPushNamed(context, "/");
                        }
                      }
                    });
                  },
                ),
              )
            ],
          )
        ],
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
