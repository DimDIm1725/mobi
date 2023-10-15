import 'dart:async';
import 'package:mobiwoom/core/models/responses/login.dart';
import 'package:mobiwoom/core/viewmodels/base_model.dart';
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:wordpress_api/wordpress_api.dart';

class FacebookModel extends BaseModel {
  LoginResponse loginResponse = SharedPrefUtil.getCurrentUser();
//  FacebookPost fbp = FacebookPost();

  Future<List<PostSchema>> getFbPosts() async {
    WordPressAPI wp = new WordPressAPI('');
    if (loginResponse.response.data.systemUrl == 'https://prod.mobiwoom.com/feed.php?city=metz') {
      wp = WordPressAPI('https://metz.bonjourcard.com');
    } else if (loginResponse.response.data.systemUrl == 'https://prod.mobiwoom.com/feed.php?city=cagnes') {
      wp = WordPressAPI('https://cagnes.bonjourcard.com');
    } else if (loginResponse.response.data.systemUrl == '148366468909949') {
      wp = WordPressAPI('https://metz.bonjourcard.com');
    } else if (loginResponse.response.data.systemUrl == '468596253630994') {
      wp = WordPressAPI('https://cagnes.bonjourcard.com');
    } else {
      wp = null;
    }

    final posts = await wp.getPosts(args: {"_embed": true});
    return posts;
  }

}
