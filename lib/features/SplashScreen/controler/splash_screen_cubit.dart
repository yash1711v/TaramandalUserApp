import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rashi_network/features/Authentication/Login/controler/login_cubit.dart';

import '../../../services/shared_prefrence/pref_controller.dart';
import '../../../services/shared_prefrence/prefrence_helper.dart';
import '../../../views/home_controller.dart';
import '../../Authentication/Login/view/login_Screen.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit(super.initialState);

  void checkUserLoggedIn() {
    getToken();
    emit(const SplashScreenCheckUserLoggedIn(isUserLoggedIn: false));
  }

  Future getToken() async {
    PrefrenceDataController.to.token.value = await PreferencesHelper().getPreferencesStringData(PreferencesHelper.token) ?? '';
    PrefrenceDataController.to.fcmToken.value = await FirebaseMessaging.instance.getToken() ?? '';

    Timer(const Duration(seconds: 5), () {
      if (PrefrenceDataController.to.token.value != '') {
        Get.offAll(() =>  const HomeController());
      } else {
        Get.offAll(() =>  const LoginScreen());
      }
    });
  }
}
