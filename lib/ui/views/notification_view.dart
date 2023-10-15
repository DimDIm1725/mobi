import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobiwoom/core/models/drawer_toolbar.dart';
import 'package:mobiwoom/core/viewmodels/facebook_model.dart';
import 'package:mobiwoom/ui/shared/mobi_app_bar.dart';
import 'package:mobiwoom/ui/views/base_view.dart';
import 'package:provider/provider.dart';
import 'package:system_settings/system_settings.dart';
import 'package:mobiwoom/ui/shared/localization.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/ui/shared/app_theme.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geolocator/geolocator.dart';

Position locationData;

class NotificationView extends StatefulWidget {
  @override
  _NotificationViewState createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    if (AppLifecycleState.resumed == state && kGpstest) {
      locationData = await getCurrentLocation();
      kGpsEnabled = locationData != null;

      if (kGpsEnabled) {
        setState(() {});
      }
    } else {
      //   print("Status not Resumed :" + state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MobiAppBar(
      child: Consumer<DrawerAndToolbar>(builder: (context, indexData, _) {
        return BaseView<FacebookModel>(
            onModelReady: (model) async {},
            builder: (context, model, child) {
              return Scaffold(
                body: Center(
                  child: FutureBuilder<List<PostSchema>>(
                    future: kGpsEnabled ? model.getFbPosts() : null,
                    builder: (context, AsyncSnapshot<List<PostSchema>> snapshot) {
                      if (!kGpsEnabled) {
                        BotToast.showText(
                            contentPadding: EdgeInsets.all(16),
                            //   animationDuration: Duration(seconds: 2),
                            duration: Duration(seconds: 4),
                            contentColor: Colors.redAccent,
                            text: (AppLocalizations.of(context).translate('location_service_required') +
                                '\n' +
                                AppLocalizations.of(context).translate('facebook_location_required')));
                        return Scaffold(
                            body: Center(
                                child: RaisedButton(
                          onPressed: () {
                            if (kIsWeb) {
                              BotToast.showText(
                                  contentPadding: EdgeInsets.all(16),
                                  //   animationDuration: Duration(seconds: 2),
                                  duration: Duration(seconds: 4),
                                  contentColor: Colors.redAccent,
                                  text: 'Activez la geolocation dans votre navigateur');
                              didChangeAppLifecycleState(AppLifecycleState.resumed);
                            } else {
                              SystemSettings.location();
                            }
                            kGpstest = true;
                          },
                          child: Text(AppLocalizations.of(context).translate('location_service_required')),
                        )));
                      } else if (model.loginResponse.response.data.systemUrl == null ||
                          model.loginResponse.response.data.systemUrl == "") {
                        return Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.new_releases_sharp,
                                  size: 72,
                                  color: MobiTheme.nearlyBlack,
                                ),
                                SizedBox(height: 16),
                                Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Center(
                                        child: Text(
                                      AppLocalizations.of(context).translate('no_facebook_news'),
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ))),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                ),
                              ],
                            ),
                          ),
                        );
                        /*       return Container(
                            // TODO UI improve - send picture
                            child: Text(AppLocalizations.of(context).translate(
                                'no_facebook_news')),
                          );*/
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            PostSchema data = snapshot.data[index];
                            return data.embedded.media.length > 0
                                ? InkWell(
                                child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(
                                            data.title.values.first,
                                            //   maxLines: 2,
                                            //   overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context).textTheme.subtitle2,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Image.network(data.embedded.media[0].sourceUrl),
                                        ],
                                      ),
                                    ),
                                  ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(data.title.values.first),
                                      content: SingleChildScrollView(
                                      child: Html(
                                          data: data.content.values.first,
                                        //   maxLines: 2,
                                        //   overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(AppLocalizations.of(context).translate('ok'), style: TextStyle(fontSize: 20.0)),
                                        )
                                      ],
                                    );
                                  });
                            },
                            )
                                : Container();
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
                      }
                    },
                  ),
                ),
              );
            });
      }),
    );
  }
}

Widget myList(var theList) {
  return ListView.separated(
      separatorBuilder: (context, index) => Divider(
            thickness: 1,
          ),
      shrinkWrap: true,
      itemCount: theList.length,
      itemBuilder: (context, index) {
        print(theList[index].imagesUrl);
        var data = theList[index];
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Color(0xFFF0F0F0),
              child: ListTile(
                title: Text(data.title),
                subtitle: SizedBox(
                  height: 120,
                  width: 300,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => VerticalDivider(
                      thickness: 1,
                    ),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: data.imagesUrl.length,
                    itemBuilder: (context, index) => Image.network(data.imagesUrl[index]),
                  ),
                ),
              ),
            ));
      });
}
