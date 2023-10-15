import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mobiwoom/core/models/requests/base_request.dart';
import 'package:mobiwoom/core/models/requests/card.dart';
import 'package:mobiwoom/core/models/requests/contact_less_card.dart';
import 'package:mobiwoom/core/models/requests/license.dart';
import 'package:mobiwoom/core/models/requests/login.dart';
import 'package:mobiwoom/core/models/requests/parkingStart.dart';
import 'package:mobiwoom/core/models/requests/parkingStop.dart';
import 'package:mobiwoom/core/models/requests/partner.dart';
import 'package:mobiwoom/core/models/requests/pincode.dart';
import 'package:mobiwoom/core/models/requests/sendToken.dart';
import 'package:mobiwoom/core/models/requests/sponsor_user.dart';
import 'package:mobiwoom/core/models/requests/taxi_check.dart';
import 'package:mobiwoom/core/models/requests/ticket_machine.dart';
import 'package:mobiwoom/core/models/requests/transfer_cashback.dart';
import 'package:mobiwoom/core/models/requests/transactions_file.dart';
import 'package:mobiwoom/core/models/requests/user.dart' as userRequest;
import 'package:mobiwoom/core/models/responses/add_cashback.dart' as addCashBackResponse;
import 'package:mobiwoom/core/models/responses/transactionsfile.dart' as transactionsFileResponse;
import 'package:mobiwoom/core/models/responses/card.dart' as cardResponse;
import 'package:mobiwoom/core/models/responses/cashback.dart' as cashbackResponse;
import 'package:mobiwoom/core/models/responses/transactions.dart' as transactionsResponse;
import 'package:mobiwoom/core/models/responses/cluster.dart' as clusterResponse;
import 'package:mobiwoom/core/models/responses/contact_less_card.dart' as contactLessCardRes;
import 'package:mobiwoom/core/models/responses/license.dart' as licenceRes;
import 'package:mobiwoom/core/models/responses/login.dart' as loginResponse;
import 'package:mobiwoom/core/models/responses/new_credit_card.dart' as newCreditCardRes;
import 'package:mobiwoom/core/models/responses/notification.dart' as notification;
import 'package:mobiwoom/core/models/responses/parkingStart.dart' as pkStartResponse;
import 'package:mobiwoom/core/models/responses/parkingStop.dart' as pkStopResponse;
import 'package:mobiwoom/core/models/responses/partner.dart' as partnerRes;
import 'package:mobiwoom/core/models/responses/payline.dart' as payRes;
import 'package:mobiwoom/core/models/responses/sendToken.dart' as tokenResponse;
import 'package:mobiwoom/core/models/responses/ticket_machine.dart' as tktResponse;
import 'package:mobiwoom/core/models/user.dart' as userResponse;
import 'package:mobiwoom/core/utils/app_config.dart';
import 'package:mobiwoom/core/utils/utils.dart';

class Api {
  static BaseOptions _options = new BaseOptions(
    // baseUrl: "https://prodapi.mobiwoom.com",
    baseUrl: "https://preprodapi.mobiwoom.com",
    connectTimeout: 10000,
    receiveTimeout: 10000,
  );
  Dio _dio = new Dio(_options);

  String requestTimeStamp;

  Api() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      String authorization =
          sha256.convert(utf8.encode(requestTimeStamp + ',' + kApplicationToken)).toString(); // data being hashed
      options.headers.addAll({"Authorization": authorization, "Content-type": "application/json"});
      print("=============REQUEST==============");
      print(options.headers);
      print("=============REQUEST==============");

      return options; //continue
    }, onResponse: (Response response) async {
      print("=============RESPONSE==============");
      //  print(response);
      print("=============RESPONSE==============");
      return response; // continue
    }, onError: (DioError e) async {
      print(e);
      return e; //continue
    }));
  }

  Future<notification.Notification> getNotifications(BaseRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = request.data.commonTimeStamp;
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post(
        "",
        data: request.toJson(),
      );
      notification.Notification notificationTemp =
          notification.Notification.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(notificationTemp.response.processToken);
      } catch (e) {
        print(e);
      }

      return notificationTemp;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return notification.Notification.withError("$error");
    }
  }

  Future<loginResponse.LoginResponse> login(LoginRequest request) async {
    try {
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      double processToken = Random().nextDouble() * 9999999999999;
      request.data.commonProcessToken = processToken.toInt().toString();
      request.data.commonTimeStamp = requestTimeStamp;
      print(request.toJson());
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  Future<loginResponse.LoginResponse> sendPincode(BaseRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  Future<userResponse.User> getUser(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      userResponse.User user = userResponse.User.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(user.response.processToken);
      } catch (e) {
        print(e);
      }
      return user;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return userResponse.User.withError("$error");
    }
  }

  Future<dynamic> updateUser(userRequest.User userReq) async {
    try {
      userReq.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      userReq.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: userReq.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  getAllSavedCards(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      cardResponse.Card card = cardResponse.Card.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(card.response.processToken);
      } catch (e) {
        print(e);
      }
      return card;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return cardResponse.Card.withError("$error");
    }
  }

  setAsMainCard(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      cardResponse.Card card = cardResponse.Card.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(card.response.processToken);
      } catch (e) {
        print(e);
      }
      return card;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return cardResponse.Card.withError("$error");
    }
  }

  Future<cardResponse.Card> deleteCard(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      cardResponse.Card card = cardResponse.Card.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(card.response.processToken);
      } catch (e) {
        print(e);
      }
      return card;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return cardResponse.Card.withError("$error");
    }
  }

  addCard(CardRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      print('addcard' + request.toJson().toString());
      Response response = await _dio.post("", data: request.toJson());
      newCreditCardRes.NewCreditCardResponse card =
          newCreditCardRes.NewCreditCardResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(card.response.processToken);
      } catch (e) {
        print(e);
      }
      return card;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return newCreditCardRes.NewCreditCardResponse.withError("$error");
    }
  }

  sendToken(TokenRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      print('sendToken' + request.toJson().toString());
      Response response = await _dio.post("", data: request.toJson());
      tokenResponse.TokenResponse card =
          tokenResponse.TokenResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(card.response.processToken);
      } catch (e) {
        print(e);
      }
      return card;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return newCreditCardRes.NewCreditCardResponse.withError("$error");
    }
  }

  Future<contactLessCardRes.ContactLessCard> getAllContactLessCards(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      contactLessCardRes.ContactLessCard card =
          contactLessCardRes.ContactLessCard.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(card.response.processToken);
      } catch (e) {
        print(e);
      }
      return card;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return contactLessCardRes.ContactLessCard.withError("$error");
    }
  }

  Future<contactLessCardRes.ContactLessCard> addContactLessCard(ContactLessCardRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = request.data.commonTimeStamp;
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post(
        "",
        data: request.toJson(),
      );

      contactLessCardRes.ContactLessCard card =
          contactLessCardRes.ContactLessCard.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(card.response.processToken);
      } catch (e) {
        print(e);
      }
      return card;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return contactLessCardRes.ContactLessCard.withError("$error");
    }
  }

  Future<contactLessCardRes.ContactLessCard> deleteContactLessCard(ContactLessCardRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = request.data.commonTimeStamp;
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post(
        "",
        data: request.toJson(),
      );

      contactLessCardRes.ContactLessCard card =
          contactLessCardRes.ContactLessCard.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(card.response.processToken);
      } catch (e) {
        print(e);
      }
      return card;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return contactLessCardRes.ContactLessCard.withError("$error");
    }
  }

  getAllSavedLicenses(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      licenceRes.LicenseResponse licenseResponse =
          licenceRes.LicenseResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(licenseResponse.response.processToken);
      } catch (e) {
        print(e);
      }
      return licenseResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return licenceRes.LicenseResponse.withError("$error");
    }
  }

  setAsMainPlate(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  deleteLicensePlate(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  addLicensePlate(LicenseRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  changePincode(PincodeRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  getAllTicketMachinesForLocation(TicketMachineRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      tktResponse.TicketMachineResponse ticketMachineResponse =
          tktResponse.TicketMachineResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(ticketMachineResponse.response.processToken);
      } catch (e) {
        print(e);
      }
      return ticketMachineResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return tktResponse.TicketMachineResponse.withError("$error");
    }
  }

  startParkingSession(ParkingStartRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      pkStartResponse.ParkingStartResponse loginRes =
          pkStartResponse.ParkingStartResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  stopParkingSession(ParkingStopRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      pkStopResponse.ParkingStopResponse loginRes =
          pkStopResponse.ParkingStopResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  getCustomerFromCard(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  sendTaxiCheck(TaxiCheckRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  addRecipient(userRequest.User request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      print(request.toJson());
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  getAllActivities(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  getAllPartnersByGeoLocation(PartnerRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      partnerRes.PartnerResponse partnerResponse =
          partnerRes.PartnerResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(partnerResponse.response.processToken);
      } catch (e) {
        print(e);
      }
      return partnerResponse;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return partnerRes.PartnerResponse.withError("$error");
    }
  }

  getAllCashBackAndVouchersList(LoginRequest request) async {
    try {
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonProcessToken = getProcessToken();
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      cashbackResponse.CashBack cashBack =
          cashbackResponse.CashBack.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(cashBack.response.processToken);
      } catch (e) {
        print(e);
      }
      return cashBack;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return cashbackResponse.CashBack.withError("$error");
    }
  }

  getCurrentMonthTransactions(LoginRequest request) async {
    try {
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonProcessToken = getProcessToken();
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      cashbackResponse.CashBack cashBack =
      cashbackResponse.CashBack.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(cashBack.response.processToken);
      } catch (e) {
        print(e);
      }
      return cashBack;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return cashbackResponse.CashBack.withError("$error");
    }
  }

  getTransactions(LoginRequest request) async {
    try {
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonProcessToken = getProcessToken();
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      transactionsResponse.Transactions transactions =
      transactionsResponse.Transactions.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(transactions.response.processToken);
      } catch (e) {
        print(e);
      }
      return transactions;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return cashbackResponse.CashBack.withError("$error");
    }
  }

  getTransactionsFile(TransactionFileRequest request) async {
    try {
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonProcessToken = getProcessToken();
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      transactionsResponse.Transactions transactions =
      transactionsResponse.Transactions.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(transactions.response.processToken);
      } catch (e) {
        print(e);
      }
      return transactions;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return cashbackResponse.CashBack.withError("$error");
    }
  }

  getAllClustersList(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      clusterResponse.Cluster cluster = clusterResponse.Cluster.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(cluster.response.processToken);
      } catch (e) {
        print(e);
      }
      return cluster;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return clusterResponse.Cluster.withError("$error");
    }
  }

  addNewCashBack(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      addCashBackResponse.AddCashBack addCashBack =
          addCashBackResponse.AddCashBack.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(addCashBack.response.processToken);
      } catch (e) {
        print(e);
      }
      return addCashBack;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return addCashBackResponse.AddCashBack.withError("$error");
    }
  }

  transferCashBacks(TransferCashBack request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  sponsorUser(SponsorUser user) async {
    try {
      user.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      user.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: user.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  registerUser(userRequest.User userRequest) async {
    try {
      userRequest.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      userRequest.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: userRequest.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return loginResponse.LoginResponse.withError("$error");
    }
  }

  acceptTCUForUser(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return addCashBackResponse.AddCashBack.withError("$error");
    }
  }

  setEmailForUser(LoginRequest request) async {
    try {
      request.data.commonProcessToken = getProcessToken();
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      loginResponse.LoginResponse loginRes =
          loginResponse.LoginResponse.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(loginRes.response.processToken);
      } catch (e) {
        print(e);
      }
      return loginRes;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return addCashBackResponse.AddCashBack.withError("$error");
    }
  }

  String getSanitizedData(String data) {
    data = data.replaceAll("\n", " ");
    data = data.replaceAll(r"\'", "'");
    return data;
  }

  getApplicationStartData(LoginRequest request) async {
    try {
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonProcessToken = getProcessToken();
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      payRes.PaylineData paylineData = payRes.PaylineData.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(paylineData.response.processToken);
      } catch (e) {
        print(e);
      }
      return paylineData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return payRes.PaylineData.withError("$error");
    }
  }

  /* getCardList(LoginRequest request) async {
    try {
      requestTimeStamp = DateFormat('yyyy/MM/dd HH:mm:ss.SSS').format(DateTime.now());
      request.data.commonProcessToken = getProcessToken();
      request.data.commonTimeStamp = requestTimeStamp;
      Response response = await _dio.post("", data: request.toJson());
      payRes.PaylineData paylineData = payRes.PaylineData.fromJson(json.decode(getSanitizedData(response.data)));
      try {
        setProcessToken(paylineData.response.processToken);
      } catch (e) {
        print(e);
      }
      return paylineData;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return payRes.PaylineData.withError("$error");
    }
  }*/
}
