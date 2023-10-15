import 'package:flutter/material.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';

class ContactUsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MobiAppBar(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              AppLocalizations.of(context)
                  .translate('contact_us_suggestion_message'),
              style: MobiTheme.text20BoldWhite,
            ),
            SizedBox(height: 16),
            IButton3(
              pressButton: () async { await launch('http://metz.bonjourcard.com/contact/');}, 
              text:AppLocalizations.of(context).translate('hello_card_form_uppercase'),
              color: MobiTheme.colorCompanion,
              textStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color:Colors.white),
            ),
            SizedBox(height: 16),
            IButton3(
              pressButton: () async { await launch('https://www.facebook.com/BonjourMetz/');}, 
              text:'Facebook'.toUpperCase(),
              color: MobiTheme.colorCompanion,
              textStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color:Colors.white),
            ),
            SizedBox(height: 16),
            IButton3(
              pressButton: () async { await launch('https://twitter.com/Bonjour_Metz');}, 
              text: 'Twitter'.toUpperCase(),
              color: MobiTheme.colorCompanion,
              textStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color:Colors.white),
            ),
            SizedBox(height: 16),
            IButton3(
              pressButton: () {  _showTCU(context);}, 
              text: AppLocalizations.of(context).translate('see_t_n_c'),
              color: MobiTheme.colorCompanion,
              textStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color:Colors.white),
            ),
            SizedBox(height: 16),
            IButton3(
              pressButton:  () => launch("tel:+33387753935"),
              text: AppLocalizations.of(context).translate('callme'),
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
