/*import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mobiwoom/core/models/requests/card.dart';
import 'package:mobiwoom/core/models/requests/contact_less_card.dart';
import 'package:mobiwoom/core/models/requests/license.dart';
import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/parkingStart.dart';
import 'package:mobiwoom/core/models/requests/parkingStop.dart';
import 'package:mobiwoom/core/models/requests/partner.dart';
import 'package:mobiwoom/core/models/requests/pincode.dart';
import 'package:mobiwoom/core/models/requests/sponsor_user.dart';
import 'package:mobiwoom/core/models/requests/taxi_check.dart';
import 'package:mobiwoom/core/models/requests/ticket_machine.dart';
import 'package:mobiwoom/core/models/requests/transfer_cashback.dart';
import 'package:mobiwoom/core/models/responses/base_bank_response.dart';
import 'package:mobiwoom/core/models/responses/cluster.dart' as clusterResponse;
import 'package:mobiwoom/core/models/responses/contact_less_card.dart' as contactLessCardRes;
import 'package:mobiwoom/core/models/responses/license.dart' as licenceRes;
import 'package:mobiwoom/core/models/responses/login.dart' as loginResponse;
import 'package:mobiwoom/core/models/responses/cashback.dart' as cashbackResponse;
import 'package:mobiwoom/core/models/responses/add_cashback.dart' as addCashBackResponse;
import 'package:mobiwoom/core/models/responses/new_credit_card.dart' as newCreditCardRes;
import 'package:mobiwoom/core/models/responses/partner.dart' as partnerRes;
import 'package:mobiwoom/core/models/responses/payline.dart' as payRes;
import 'package:mobiwoom/core/models/responses/ticket_machine.dart' as tktResponse;
import 'package:mobiwoom/core/models/responses/parkingStart.dart' as pkStartResponse;
import 'package:mobiwoom/core/models/responses/parkingStop.dart' as pkStopResponse;
import 'package:mobiwoom/core/models/responses/card.dart' as cardResponse;
import 'package:mobiwoom/core/models/user.dart' as userResponse;
import 'package:mobiwoom/core/models/requests/user.dart' as userRequest;
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/models/requests/base_request.dart';
import 'package:mobiwoom/core/models/responses/notification.dart' as notification;
import 'package:mobiwoom/core/utils/shared_pref_util.dart';
import 'package:mobiwoom/core/utils/utils.dart';
import 'package:xml_parser/xml_parser.dart';

class ApiXml {
  static BaseOptions _options = new BaseOptions(
    //  baseUrl: "https://prodapi.mobiwoom.com",
    baseUrl: "https://preprodapi.mobiwoom.com",
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );
  Dio _dio = new Dio(_options);

  String requestTimeStamp;

  ApiXml() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      return options; //continue
    }, onResponse: (Response response) async {
      print("=============RESPONSE XML==============");
      print(response);
      print("=============RESPONSE XML==============");
      return response; // continue
    }, onError: (DioError e) async {
      print(e);
      return e; //continue
    }));
  }*/

 /* Future<XmlDocument> getCardList(dynamic data) async {
    try {
      payRes.PaylineData paylineData = await SharedPrefUtil.getPaylineData();
      String basicAuth = 'Basic ' +
          base64Encode(utf8
              .encode('${paylineData.response.data.paylineMerchantId}:${paylineData.response.data.paylineAccessKey}'));
      var headers = {'Authorization': basicAuth, 'Content-Type': 'application/xml'};
      _dio.options.headers.addAll(headers);
      print("XXXXXXXX${paylineData.response.data.paylineServer}");
      print("DATA $data");
      print("basicAuth $basicAuth");
      Response response = await _dio.post(paylineData.response.data.paylineServer, data: data);
      return XmlDocument.fromString(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }*/

 /* Future<XmlDocument> getTokenFromBank(dynamic data) async {
    try {
      payRes.PaylineData paylineData = await SharedPrefUtil.getPaylineData();
      String basicAuth = 'Basic ' +
          base64Encode(utf8
              .encode('${paylineData.response.data.paylineMerchantId}:${paylineData.response.data.paylineAccessKey}'));
      var headers = {'Authorization': basicAuth, 'Content-Type': 'application/xml'};
      _dio.options.headers.addAll(headers);
      Response response = await _dio.post(paylineData.response.data.paylineWebServer, data: data);
      return XmlDocument.fromString(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }*/

 /* Future<XmlDocument> addBankCard(dynamic data) async {
    try {
      payRes.PaylineData paylineData = await SharedPrefUtil.getPaylineData();
      String basicAuth = 'Basic ' +
          base64Encode(utf8
              .encode('${paylineData.response.data.paylineMerchantId}:${paylineData.response.data.paylineAccessKey}'));
      var headers = {'Authorization': basicAuth, 'Content-Type': 'application/xml'};
      _dio.options.headers.addAll(headers);
      Response response = await _dio.post(paylineData.response.data.paylineWebServer, data: data);
      return XmlDocument.fromString(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }*/

 /* Future<BaseBankResponse> deleteCardFromBank(String token, String cardId) async {
    try {
      payRes.PaylineData paylineData = await SharedPrefUtil.getPaylineData();
      print("${paylineData.response.data.paylineServicesServer}/$token/wallet/card/$cardId");
      String basicAuth = 'Basic ' +
          base64Encode(utf8
              .encode('${paylineData.response.data.paylineMerchantId}:${paylineData.response.data.paylineAccessKey}'));
      var headers = {'Authorization': basicAuth, 'Content-Type': 'application/json'};
      _dio.options.headers.addAll(headers);
      Response response =
          await _dio.delete("${paylineData.response.data.paylineServicesServer}/$token/wallet/card/$cardId");
      print(response.data);
      BaseBankResponse baseBankResponse = BaseBankResponse.fromJson(response.data);

      return baseBankResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseBankResponse.withError("$error");
    }
  }*/

 /* Future<BaseBankResponse> setMainCardFromBank(String token, String cardId) async {
    try {
      print("setMainCardFromBank $cardId");
      payRes.PaylineData paylineData = await SharedPrefUtil.getPaylineData();
      print("${paylineData.response.data.paylineServicesServer}/$token/wallet");
      String basicAuth = 'Basic ' +
          base64Encode(utf8
              .encode('${paylineData.response.data.paylineMerchantId}:${paylineData.response.data.paylineAccessKey}'));
      var headers = {'Authorization': basicAuth, 'Content-Type': 'application/json'};
      _dio.options.headers.addAll(headers);
      Response response = await _dio.put("${paylineData.response.data.paylineServicesServer}/$token/wallet",
          data: {"action": 0, "walletCardIndex": cardId});
      print(response.data);
      BaseBankResponse baseBankResponse = BaseBankResponse.fromJson(response.data);

      return baseBankResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BaseBankResponse.withError("$error");
    }
  }*/

 /* Future<dynamic> activateToken(String url) async {
    try {
      payRes.PaylineData paylineData = await SharedPrefUtil.getPaylineData();
      String basicAuth = 'Basic ' +
          base64Encode(utf8
              .encode('${paylineData.response.data.paylineMerchantId}:${paylineData.response.data.paylineAccessKey}'));
      var headers = {'Authorization': basicAuth};
      _dio.options.headers.addAll(headers);
      Response response = await _dio.get(url);
      print(response.data);
      return response.data;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }*/
//}
