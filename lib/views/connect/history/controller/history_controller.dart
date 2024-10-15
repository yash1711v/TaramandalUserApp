import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:rashi_network/services/api/api_service.dart';
import 'package:rashi_network/services/shared_prefrence/pref_controller.dart';
import 'package:rashi_network/services/shared_prefrence/prefrence_helper.dart';

import '../../../../api/api.dart';
import '../../chat/new_chat/chat_screen_one.dart';

class HistoryController extends GetxController {
  static HistoryController get to => Get.put(HistoryController());

  RxMap<String, dynamic> userCallHistoryRes = <String, dynamic>{}.obs;
  // RxList waitingList = [].obs;

  Future<bool?> userCallHistoryApi({
    required Map params,
    Function? success,
    Function? error,
  }) async {
    log(params.toString(), name: 'PARAMS');
    PrefrenceDataController.to.token.value = await PreferencesHelper().getPreferencesStringData(PreferencesHelper.token) ?? '';
    log(PrefrenceDataController.to.token.value.toString(), name: 'TOEKN');
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.userCalllist,
          data: params,
          options: dio.Options(
            contentType: dio.Headers.jsonContentType,
            headers: {"Authorization": "Bearer ${PrefrenceDataController.to.token.value}"},
          ));

      if (response.statusCode == 200) {
        userCallHistoryRes.value = response.data;
        log(userCallHistoryRes.toString(), name: 'userCallHistoryRes');

        // log(analyticsRes.toString(), name: 'analyticsRes ');
        // waitingList.value = response.data;

        if (response.data != null) {
          if (response.data['status']) {
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message'] ?? 'Something went Wrong..');
            }
          }

          return true;
        } else {
          if (error != null) {
            error(response.data['message'] ?? 'Something went Wrong..');
          }
          return false;
        }
      } else {
        print(response.data);
        if (error != null) {
          error(response.data['message'] ?? 'Something went Wrong..');
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.data['message'] ?? "Something went wrong");
      }
    }
    return null;
  }

  RxMap<String, dynamic> userChatHistoryRes = <String, dynamic>{}.obs;
  // RxList waitingList = [].obs;

  Future<bool?> userChatHistoryApi({
    required Map params,
    Function? success,
    Function? error,
  }) async {
    log(params.toString(), name: 'PARAMS');
    PrefrenceDataController.to.token.value = await PreferencesHelper().getPreferencesStringData(PreferencesHelper.token) ?? '';
    log(PrefrenceDataController.to.token.value.toString(), name: 'TOEKN');
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.userChatlist,
          data: params,
          options: dio.Options(
            contentType: dio.Headers.jsonContentType,
            headers: {"Authorization": "Bearer ${PrefrenceDataController.to.token.value}"},
          ));

      if (response.statusCode == 200) {
        userChatHistoryRes.value = response.data;
        log(userChatHistoryRes.toString(), name: 'userChatHistoryRes');

        if (response.data != null) {
          if (response.data['status']) {
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message'] ?? 'Something went Wrong..');
            }
          }

          return true;
        } else {
          if (error != null) {
            error(response.data['message'] ?? 'Something went Wrong..');
          }
          return false;
        }
      } else {
        print(response.data);
        if (error != null) {
          error(response.data['message'] ?? 'Something went Wrong..');
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.data['message'] ?? "Something went wrong");
      }
    }
    return null;
  }



  RxMap<String, dynamic> chatInfoRes = <String, dynamic>{}.obs;

  Future<bool?> chatInfoApi({
    required Map params,
    Function? success,
    Function? error,
  }) async {
    log(params.toString(), name: 'PARAMS');
    PrefrenceDataController.to.token.value = await PreferencesHelper().getPreferencesStringData(PreferencesHelper.token) ?? '';
    log(PrefrenceDataController.to.token.value.toString(), name: 'TOEKN');
    try {
      dio.Response response = await dio.Dio().post(ApiConfig.chatInfo,
          data: params,
          options: dio.Options(
            contentType: dio.Headers.jsonContentType,
            headers: {"Authorization": "Bearer ${PrefrenceDataController.to.token.value}"},
          ));

      if (response.statusCode == 200) {
        chatInfoRes.value = response.data;
        log(chatInfoRes.toString(), name: 'chatInfoRes');

        if (response.data != null) {
          if (response.data['status']) {
            if (success != null) {
              success();
            }
          } else {
            if (error != null) {
              error(response.data['message'] ?? 'Something went Wrong..');
            }
          }

          return true;
        } else {
          if (error != null) {
            error(response.data['message'] ?? 'Something went Wrong..');
          }
          return false;
        }
      } else {
        print(response.data);
        if (error != null) {
          error(response.data['message'] ?? 'Something went Wrong..');
        }
      }
    } on dio.DioError catch (e) {
      if (error != null) {
        error(e.response?.data['message'] ?? "Something went wrong");
      }
    }
    return null;
  }

  chatDataFromFireStore({required String uid1, required String uid2}) async {
    Map<String, dynamic> messages = {};
    if(uid2.isNotEmpty && chatreqid.isNotEmpty){
      Api.getChatDataSingle(currentNumber, senderNumber).then((value) {
        Map<String, dynamic>  data = value.data() as Map<String, dynamic>;
         debugPrint('messages: $data');
      });
    }
  }

}
