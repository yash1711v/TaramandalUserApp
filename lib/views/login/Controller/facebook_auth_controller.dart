import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rashi_network/views/home_controller.dart';

class FacebookAuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final RxMap userData = {}.obs;

  void login() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      isLoggedIn.value = true;
      userData.value = result.accessToken!.toJson();
      Get.to(() =>  HomeController());
    }
  }

  // void logout() async {
  //   await FacebookAuth.instance.logOut();
  //   isLoggedIn.value = false;
  //   userData.value = null;
  // }
}