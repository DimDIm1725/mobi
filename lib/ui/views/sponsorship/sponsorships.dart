import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/profile_model.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/shared/navigation_util.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';

String resultingCreationDateFormat = 'dd/MM/yyyy';
String incomingCreationDateFormat = 'yyyy/MM/dd HH:mm:ss';

String resultingDeadlineDateFormat = 'dd/MM/yyyy';
String incomingDeadlineDateFormat = 'yyyy/MM/dd';

class SponsorshipView extends StatefulWidget {
  @override
  _SponsorshipViewState createState() => _SponsorshipViewState();
}

class _SponsorshipViewState extends State<SponsorshipView> {
  @override
  Widget build(BuildContext context) {
    return SponsorshipWidget();
  }
}

class SponsorshipWidget extends StatefulWidget {
  @override
  _SponsorshipWidgetState createState() => _SponsorshipWidgetState();
}

class _SponsorshipWidgetState extends State<SponsorshipWidget> {
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(onModelReady: (model) async {
      await model.getUser();
    }, builder: (context, model, child) {
      return Consumer<DrawerAndToolbar>(
        builder: (context, indexData, _) => MobiAppBar(
          child: ModalProgressHUD(
            inAsyncCall: model.state == ViewState.Busy,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: model.user != null
                  ? Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: SingleStat(
                                  label: "VIP",
                                  value: model
                                      .user.response.data.userVipStatusCount,
                                  color: MobiTheme.nearlyBlue,
                                  style: Theme.of(context).textTheme.headline4),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: SingleStat(
                                  label: AppLocalizations.of(context)
                                      .translate('sponsored'),
                                  value: model.user.response.data
                                      .userSponsoredUsersCount,
                                  color: MobiTheme.purple,
                                  style: Theme.of(context).textTheme.headline4),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        SingleStat(
                            label: AppLocalizations.of(context)
                                .translate('remaining_sponsorships'),
                            value:
                                '${getRemainingSponsorCounts(model.user.response.data.userMaxSponsoredUsers, model.user.response.data.userSponsoredUsersCount)}',
                            color: MobiTheme.red,
                            style: MobiTheme.text16BoldWhite),
                        SizedBox(height: 16),
                        MobiText(
                          textStyle: MobiTheme.text16BoldWhite,
                          text: AppLocalizations.of(context)
                              .translate('sponsor_free_coupon_offer'),
                        ),
                        SizedBox(height: 16),
                        IButton3(
                          pressButton: () { showReferFriendDialog(context, model);}, 
                          text:AppLocalizations.of(context).translate('refer_friend_uppercase'),
                          color: MobiTheme.colorCompanion,
                          textStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color:Colors.white),
                        ),
                        SizedBox(height: 16),
                        IButton3(
                          pressButton: () {  
                            indexData.currentIndex = kPartnersListScreen;
                            model.setState(ViewState.Idle);
                          }, 
                          text:AppLocalizations.of(context).translate('list_partners_uppercase'),
                          color: MobiTheme.colorCompanion,
                          textStyle: TextStyle(fontSize:16, fontWeight: FontWeight.w800, color:Colors.white),
                        ),
                      ],
                    )
                  : Container(),
            ),
          ),
        ),
      );
    });
  }

  void showReferFriendDialog(BuildContext context, ProfileModel model) {
    showDialog(
        context: context,
        child: ModalProgressHUD(
          inAsyncCall: model.state == ViewState.Busy,
          child: AlertDialog(
            title: Text(
                AppLocalizations.of(context).translate('sponsor_new_user')),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  IInputField2(
                    hint: AppLocalizations.of(context).translate('mobile_number'),
                    initialValue: model.sponsorUserRequest.data.userPhoneNumber,
                    icon:Icons.phone,
                    colorIcon:MobiTheme.colorIcon,
                    type: TextInputType.phone,
                    colorDefaultText: Colors.white,
                    onChangeText: (newText) {
                      model.sponsorUserRequest.data.userPhoneNumber = newText;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  IInputField2(
                    hint: AppLocalizations.of(context).translate('first_name'),
                    initialValue: model.sponsorUserRequest.data.userFirstName,
                    icon:Icons.person,
                    colorIcon:MobiTheme.colorIcon,
                    colorDefaultText: Colors.white,
                    onChangeText: (newText) {
                      model.sponsorUserRequest.data.userFirstName = newText;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  IInputField2(
                    hint: AppLocalizations.of(context).translate('last_name'),
                    initialValue: model.sponsorUserRequest.data.userLastName,
                    icon:Icons.person,
                    colorIcon:MobiTheme.colorIcon,
                    colorDefaultText: Colors.white,
                    onChangeText: (newText) {
                      model.sponsorUserRequest.data.userLastName = newText;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  IInputField2(
                    hint: AppLocalizations.of(context).translate('email'),
                    initialValue: model.sponsorUserRequest.data.userEMail,
                    icon:Icons.email,
                    colorIcon:MobiTheme.colorIcon,
                    type: TextInputType.emailAddress,
                    colorDefaultText: Colors.white,
                    onChangeText: (newText) {
                      model.sponsorUserRequest.data.userEMail = newText;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MobiButton(
                          color: Colors.red,
                          text:
                              AppLocalizations.of(context).translate('cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: MobiButton(
                          color: Colors.green,
                          text: AppLocalizations.of(context).translate('ok'),
                          onPressed: () {
                            BotToast.showLoading();
                            model.sponsorUser().then((value) {
                              BotToast.showText(
                                  contentPadding: EdgeInsets.all(16),
                                  //   animationDuration: Duration(seconds: 2),
                                  duration: Duration(seconds: 4),
                                  contentColor: value
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  text: value
                                      ? model.successMessage
                                      : model.errorMessage);
                              BotToast.closeAllLoading();
                              if (value) {
                                Navigator.pop(context);
                                model.getUser();
                              }
                            });
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  String getRemainingSponsorCounts(
      String userMaxSponsoredUsers, String userSponsoredUsersCount) {
    try {
      int userMaxSponsors = int.parse(userMaxSponsoredUsers);
      int userSponsoredUsers = int.parse(userSponsoredUsersCount);
      return (userMaxSponsors - userSponsoredUsers).toString();
    } catch (e) {
      return 'NA';
    }
  }
}

class SingleStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final TextStyle style;

  SingleStat({this.label, this.value, this.color, this.style});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      shadowColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(label, style: MobiTheme.text20BoldWhite),
            ),
            Visibility(
              visible: value.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Text(
                        value,
                        style: style.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
