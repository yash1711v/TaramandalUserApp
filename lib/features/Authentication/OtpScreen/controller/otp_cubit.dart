import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../api/api.dart';
import '../../../../services/api/api_access.dart';
import '../../../../services/firebase/auth_servoces.dart';
import '../../../../services/shared_prefrence/pref_controller.dart';
import '../../../../services/shared_prefrence/prefrence_helper.dart';
import '../../../../utils/design_utlis.dart';
import '../../../../views/home.dart';
import '../../../../views/login/take_email_screen.dart';

part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(const Otp());
  Future<void> verifyOtp(String otp,String phoneNumber,String verificationId) async {
    emit(const Otp(isloading: true));
    // API call to verify OTP
    String _otp = otp;
    if (otp.toString().trim().length == 4){
      await ApiAccess()
          .attemptLogIn(phone: phoneNumber)
          .then((attemptLogIn) {
        if (attemptLogIn != '') {
          // AuthService()
          //     .phoneOPTVerify(
          //     verificationId,
          //     textEditingController
          //         .map((e) => e.text)
          //         .toList()
          //         .join()
          //         .toString())
          //     .then((value) async {
          //   log(attemptLogIn.toString(),
          //       name: 'Attempt LOGIN API ');
          //   if (value) {
          //     log(attemptLogIn['data']['token'], name: 'TOKEN');
          //     PrefrenceDataController.to.token.value =
          //         (attemptLogIn['data']['token'] ?? '')
          //             .toString();
          //     PrefrenceDataController.to.id.value =
          //         (attemptLogIn['data']['uid'] ?? '').toString();
          //     await PreferencesHelper().setPreferencesStringData(
          //         PreferencesHelper.token,
          //         PrefrenceDataController.to.token.value);
          //     await PreferencesHelper().setPreferencesStringData(
          //         PreferencesHelper.uID,
          //         PrefrenceDataController.to.id.value);
          //     /* Secure.setAccessKey(
          //                       attemptLogIn['data']['token'].toString());*/
          //
          //     if (((attemptLogIn['data']['email']) != null) &&
          //         ((attemptLogIn['data']['email'] ?? '')
          //             .toString()
          //             .isNotEmpty)) {
          //       await Api.createUser().then((value) {
          //         Get.offAll(() => HomeScreen());
          //       });
          //     } else {
          //       Get.offAll(() => TakeEmailScreen());
          //     }
          //     /*  if (mounted) {
          //
          //                   }*/
          //   } else {
          //     DesignUtlis.flutterToast("Please Check your OTP");
          //     emit(const Otp(isloading: false));
          //   }
          // });
        } else {
          emit(const Otp(isloading: false));
          DesignUtlis.flutterToast("Please Try Again");
        }
      });
    }

    emit(const Otp(isloading: false));
  }
}
