import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rashi_network/features/Authentication/Login/controler/login_cubit.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../ui/theme/buttons/buttons.dart';
import '../../../../ui/theme/text.dart';
import '../../../../ui/widgets/progress_circle.dart';
import '../../../../utils/design_colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController phoneNo = TextEditingController();
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
         bool isloading = false;
         if(state is Logining){
           isloading = state.isLoading ?? false;
         }
        return Form(
          key: formKey,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const DesignText(
                    'Welcome !',
                    fontSize: 20,
                    fontWeight: 600,
                  ),
                  const SizedBox(height: 10),
                  const DesignText(
                    'Enlightening Your Path with Astrology',
                    fontSize: 14,
                    fontWeight: 400,
                    color: AppColors.lightGrey1,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: phoneNo,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field Can't be empty";
                      } else if (val.length < 10) {
                        return "Mobile number must be 10 in digit";
                      }
                      return null;
                    },
                    onTapOutside: (event) {
                      final currentFocus = FocusScope.of(context);
                      if (currentFocus.focusedChild != null) {
                        currentFocus.focusedChild!.unfocus();
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Phone no',
                      filled: true,
                      isDense: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 8),
                        child: Text('+91'),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      contentPadding: EdgeInsets.all(16),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.darkGrey, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.lightGrey3, width: 1.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: AppColors.lightGrey3, width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.tapRed,
                            width: 2.0),
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: DesignButtons(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          context.read<LoginCubit>().login(phoneNo: phoneNo, context: context);
                        }
                      },
                      textLabel: 'Continue',
                      isTappedNotifier: ValueNotifier(false),
                      colorText: Colors.white,
                      fontSize: 14,
                      fontWeight: 600,
                      color: AppColors.darkTeal,
                      child: isloading
                          ? const DesignProgress(size: 18, color: Colors.white)
                          : const DesignText(
                        "Continue",
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );;
  }
}
