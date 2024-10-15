import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rashi_network/features/Authentication/OtpScreen/controller/otp_cubit.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../ui/theme/text.dart';
import '../../../../ui/widgets/progress_circle.dart';
import '../../../../utils/design_colors.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    listenForCode();
    SmsAutoFill().getAppSignature.then((signature) {
      debugPrint(signature);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 42,
                          ),
                          const Center(
                            child: Text(
                              'OTP Verification',
                              style: TextStyle(
                                  color: const Color(0xFF232C63),
                                  fontSize: 24,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const Center(
                              child: Text(
                                "Check your messages. We've sent\nyou the PIN at (+91) ${9971104827}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    height: 1.5),
                              )),
                          const SizedBox(
                            height: 66,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 350,
                                height: 50,
                                child: PinFieldAutoFill(
                                  decoration: BoxLooseDecoration(
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      radius: const Radius.circular(12),
                                      strokeColorBuilder: PinListenColorBuilder(
                                        AppColors.darkGrey,
                                        AppColors.darkGrey,
                                      )),
                                  codeLength: 6,
                                  currentCode: _otpController.text,
                                  controller: _otpController,
                                  cursor: Cursor(
                                      color: Colors.black,
                                      enabled: true,
                                      width: 2,
                                      height: 22),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 45,
                              ),
                              BlocBuilder<OtpCubit, OtpState>(
                                builder: (context, state) {
                                  bool isloading = false;
                                  if (state is Otp) {
                                    isloading = state.isloading ?? false;
                                  }
                                  return DesignText(
                                    'Resend OTP',
                                    fontSize: 14,
                                    fontWeight: 400,
                                    color: !isloading
                                        ? AppColors.green
                                        : AppColors.lightGrey1,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 114,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  BlocBuilder<OtpCubit, OtpState>(
                    builder: (context, state) {
                      bool isloading = false;
                      if (state is Otp) {
                        isloading = state.isloading ?? false;
                      }
                      return ElevatedButton(
                          onPressed: () {},
                          child: isloading
                              ? const DesignProgress(
                              size: 18, color: Colors.white)
                              : const DesignText(
                            "Continue",
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: 600,
                          ));
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 3,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void codeUpdated() {
    try {
      if (code != null) {
        _otpController.text = code!;
         // context.read<OtpCubit>().verifyOtp(_otpController.text);
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
