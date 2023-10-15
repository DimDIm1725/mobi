import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/utils/constants.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/viewmodels/profile_model.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:mobiwoom/ui/widgets/custom_widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:mobiwoom/ui/widgets/ibackground4.dart';
import 'package:mobiwoom/ui/widgets/iinputField2.dart';
import 'package:mobiwoom/ui/widgets/ibutton3.dart';
import 'package:mobiwoom/ui/widgets/iinputField2Password.dart';

String resultingCreationDateFormat = 'dd/MM/yyyy';
String incomingCreationDateFormat = 'yyyy/MM/dd';
enum Sex { M, F }
Sex _character;

class ProfileView extends StatefulWidget {
  static const routeName = "ProfileView";
  // TODO what is it for ? to remove !
  bool isIndependent = true;

  @override
  _ProfileViewState createState() => _ProfileViewState();

  void setIsIndependent(bool isIndependent) {
    this.isIndependent = isIndependent;
  }
}

TextEditingController dobController = TextEditingController();

class _ProfileViewState extends State<ProfileView> {
  /* _save(ProfileModel model) {
    if (model.user.response.data.userEMail == null || model.user.response.data.userEMail.isEmpty) {
      BotToast.showText(
        text: AppLocalizations.of(context).translate('enter_email_address'),
      );
      return;
    }
    model.updateUser(context).then((value) {
      model.changeHappened = false;
      BotToast.showText(
          contentPadding: EdgeInsets.all(16),
          duration: Duration(seconds: 4),
          contentColor: value ? Colors.greenAccent : Colors.redAccent,
          text: value ? model.successMessage : model.errorMessage);
      if (value && widget.isIndependent) {
        Navigator.popAndPushNamed(context, "/");
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileModel>(onModelReady: (model) {
      model.getUser();
    }, builder: (context, model, child) {
      if (model.user == null) {
        return MobiAppBar(child: MobiLoader());
      } else {
        dobController.text = model.user.response.data.userBirthDay == ""
            ? ''
            : DateFormat(resultingCreationDateFormat).format(
                DateFormat(incomingCreationDateFormat)
                    .parse(model.user.response.data.userBirthDay));
        _character = null;
        if (model.user.response.data.userGender == '1') _character = Sex.M;
        if (model.user.response.data.userGender == '2') _character = Sex.F;
        return MobiAppBar(
          /*  actions: [
            MobiAction(
                onPressed: () {
                  _save(model);
                },
                icon: Icons.save,
                iconColor: model.changeHappened ? Colors.red : null),
          ],*/
          child: Scaffold(
            appBar: widget.isIndependent
                ? AppBar(
                    title: Text(
                      AppLocalizations.of(context).translate('add_details'),
                    ),
                    automaticallyImplyLeading: false,
                  )
                : null,
            body: ModalProgressHUD(
              inAsyncCall: model.state == ViewState.Busy,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Container(
                child: widget.isIndependent
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ProfileEditView(model),
                      )
                    : Consumer<DrawerAndToolbar>(
                        builder: (context, indexData, _) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ProfileEditView(model),
                        ),
                      ),
              ),
            ),
          ),
        );
      }
    });
  }
}

class ProfileEditView extends StatefulWidget {
  final ProfileModel profileModel;
  // bool isIndependent = true;

  ProfileEditView(this.profileModel);

  @override
  _ProfileEditViewState createState() => _ProfileEditViewState();

  /* void setIsIndependent(bool isIndependent) {
    this.isIndependent = isIndependent;
  }*/
}

class _ProfileEditViewState extends State<ProfileEditView> {
  _save(ProfileModel model) {
    if (model.user.response.data.userEMail == null ||
        model.user.response.data.userEMail.isEmpty) {
      BotToast.showText(
        text: AppLocalizations.of(context).translate('enter_email_address'),
      );
      return;
    }
    model.updateUser(context).then((value) {
      model.changeHappened = false;
      BotToast.showText(
          contentPadding: EdgeInsets.all(16),
          duration: Duration(seconds: 4),
          contentColor: value ? Colors.greenAccent : Colors.redAccent,
          text: value ? model.successMessage : model.errorMessage);
      /* if (value && widget.isIndependent) {
        Navigator.popAndPushNamed(context, "/");
      }*/
    });
  }

  Future<Null> _selectDate(BuildContext context, ProfileModel model) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      model.changeHappened = true;
      selectedDate = picked;
      // dobController.text = DateFormat(kDateFormat).format(selectedDate);
      print(selectedDate);
      model.user.response.data.userBirthDay =
          DateFormat(incomingCreationDateFormat).format(selectedDate);
      dobController.text = model.user.response.data.userBirthDay == ""
          ? ''
          : DateFormat(resultingCreationDateFormat).format(
              DateFormat(incomingCreationDateFormat)
                  .parse(model.user.response.data.userBirthDay));
      print(model.user.response.data.userBirthDay);
      model.setState(ViewState.Idle);
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileModel model = widget.profileModel;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          IInputField2(
            hint: AppLocalizations.of(context).translate('phone'),
            icon: Icons.smartphone,
            initialValue: model.user.response.userPhoneNumber,
            readOnly: true,
            colorIcon: MobiTheme.colorIcon,
            type: TextInputType.phone,
            colorDefaultText: Colors.white,
            onChangeText: (newText) {
              model.user.response.userPhoneNumber = newText;
              model.changeHappened = true;
              model.setState(ViewState.Idle);
            },
          ),
          SizedBox(height: 10),
          Container(
            //  height: 70.0,
            decoration: BoxDecoration(
                border: Border.all(color: MobiTheme.borderColor),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(50, 0, 0, 0),
                      blurRadius: 1.0,
                      spreadRadius: 0.4)
                ],
                color: MobiTheme.colorBackground),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RadioListTile<Sex>(
                        title: Text(
                            AppLocalizations.of(context).translate('male'),
                            style: TextStyle(color: Colors.white)),
                        value: Sex.M,
                        activeColor: MobiTheme.colorIcon,
                        groupValue: _character,
                        onChanged: (Sex value) {
                          setState(() {
                            _character = value;
                            model.user.response.data.userGender = '1';
                            model.changeHappened = true;
                            model.setState(ViewState.Idle);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<Sex>(
                        title: Text(
                            AppLocalizations.of(context).translate('female'),
                            style: TextStyle(color: Colors.white)),
                        value: Sex.F,
                        activeColor: MobiTheme.colorIcon,
                        groupValue: _character,
                        onChanged: (Sex value) {
                          setState(() {
                            model.user.response.data.userGender = '2';
                            _character = value;
                            model.changeHappened = true;
                            model.setState(ViewState.Idle);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          IInputField2(
            hint: AppLocalizations.of(context).translate('last_name'),
            icon: Icons.person,
            initialValue: model.user.response.data.userLastName,
            colorIcon: MobiTheme.colorIcon,
            colorDefaultText: Colors.white,
            onChangeText: (newText) {
              model.user.response.data.userLastName = newText;
              setState(() {
                model.changeHappened = true;
                model.setState(ViewState.Idle);
              });
            },
          ),
          SizedBox(height: 10),
          IInputField2(
            hint: AppLocalizations.of(context).translate('first_name'),
            icon: Icons.person,
            initialValue: model.user.response.data.userFirstName,
            colorIcon: MobiTheme.colorIcon,
            colorDefaultText: Colors.white,
            onChangeText: (newText) {
              model.user.response.data.userFirstName = newText;
              setState(() {
                model.changeHappened = true;
                model.setState(ViewState.Idle);
              });
            },
          ),
          SizedBox(height: 10),
          IInputField2(
            hint: AppLocalizations.of(context).translate('date_of_birth'),
            icon: Icons.date_range,
            controller: dobController,
            readOnly: true,
            colorIcon: MobiTheme.colorIcon,
            colorDefaultText: Colors.white,
            onTap: () {
              _selectDate(context, model);
            },
          ),
          SizedBox(height: 10),
          IInputField2(
            initialValue: model.user.response.data.userEMail,
            hint: AppLocalizations.of(context).translate('email'),
            type: TextInputType.emailAddress,
            icon: Icons.email,
            colorIcon: MobiTheme.colorIcon,
            colorDefaultText: Colors.white,
            onChangeText: (newText) {
              model.user.response.data.userEMail = newText;
              setState(() {
                model.changeHappened = true;
                model.setState(ViewState.Idle);
              });
            },
          ),
          SizedBox(height: 10),
          IInputField2(
            initialValue: model.user.response.data.userAddress,
            hint: AppLocalizations.of(context).translate('address'),
            icon: Icons.contact_mail,
            colorIcon: MobiTheme.colorIcon,
            colorDefaultText: Colors.white,
            onChangeText: (newText) {
              model.user.response.data.userAddress = newText;
              setState(() {
                model.changeHappened = true;
                model.setState(ViewState.Idle);
              });
            },
          ),
          SizedBox(height: 10),
          IInputField2(
            initialValue: model.user.response.data.userZipCode,
            hint: AppLocalizations.of(context).translate('postal_code'),
            icon: Icons.local_post_office,
            colorIcon: MobiTheme.colorIcon,
            colorDefaultText: Colors.white,
            onChangeText: (newText) {
              model.user.response.data.userZipCode = newText;
              setState(() {
                model.changeHappened = true;
                model.setState(ViewState.Idle);
              });
            },
          ),
          SizedBox(height: 10),
          IInputField2(
            initialValue: model.user.response.data.userCity,
            hint: AppLocalizations.of(context).translate('city'),
            icon: Icons.location_city,
            colorIcon: MobiTheme.colorIcon,
            colorDefaultText: Colors.white,
            onChangeText: (newText) {
              model.user.response.data.userCity = newText;
              setState(() {
                model.changeHappened = true;
                model.setState(ViewState.Idle);
              });
            },
          ),
          SizedBox(height: 16),
          IButton3(
            pressButton: () {
              _save(model);
            },
            text: AppLocalizations.of(context).translate('sign_in'),
            color: MobiTheme.colorCompanion,
            textStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
