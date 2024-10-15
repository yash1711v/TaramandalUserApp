import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/design_utlis.dart';
import '../../../../views/login/otp_screen.dart';
import '../../OtpScreen/view/otp_screen.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({required TextEditingController phoneNo, required BuildContext context}) async {
    emit(const Logining(isLoading: true));
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${phoneNo.text}',
      verificationCompleted:
          (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        emit(const Logining(isLoading: false));
        DesignUtlis.flutterToast(e.message.toString());
      },
      timeout: const Duration(seconds: 60),
      codeSent: (String verificationId, int? resendToken) {
        emit(const Logining(isLoading: false));
        log('MSG SENT');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                //OtpScreen()
                OTPScreen(
              verificationId: verificationId,
              resendToken: resendToken!,
              phoneNumber: phoneNo.text,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('MSG TIMEOUT');
      },
    );
  }
}
