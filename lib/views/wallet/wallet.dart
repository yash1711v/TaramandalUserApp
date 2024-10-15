import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rashi_network/services/ad_service/get_ads.dart';
import 'package:rashi_network/services/api/api_service.dart';
import 'package:rashi_network/ui/custom/custom_text_form.dart';
import 'package:rashi_network/ui/theme/buttons/buttons.dart';
import 'package:rashi_network/ui/theme/text.dart';
import 'package:rashi_network/ui/widgets/progress_circle.dart';
import 'package:rashi_network/utils/design_colors.dart';
import 'package:rashi_network/utils/snackbar.dart';
import 'package:rashi_network/viewmodel/provider/appstate.dart';
import 'package:rashi_network/views/wallet/applly_coupen_screen.dart';
import 'package:rashi_network/views/wallet/controller/add_money_controller.dart';
import 'package:rashi_network/views/wallet/payment_information.dart';

import '../../utils/controller/get_profile_controller.dart';
import 'wallet_history_screen.dart';

class Wallet extends ConsumerStatefulWidget {
  const Wallet({super.key});

  @override
  ConsumerState<Wallet> createState() => _WalletState();
}

class _WalletState extends ConsumerState<Wallet> {
  final paymentText = TextEditingController();
  bool onWillPop = true;
  RxString appliedCoupen = ''.obs;
  RxString title = ''.obs;
  RxInt minAmount = 100.obs;
  RxInt AmountDeducted = 0.obs;

  @override
  void initState() {
    GetProfileController.to.getProfileApi(params: {});
    // TODO: implement initState
    GetAds.to.loadBannerAd();
    AddMoneyController.to.getCoupons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      AddMoneyController.to.getDiscountedAmount(
          amount: paymentText.text,
          CounponCode: appliedCoupen.value);
    });

    final appState = ref.watch(appStateRef);
    return WillPopScope(
      onWillPop: () async {
        return onWillPop;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.darkTeal2,
          title: const DesignText(
            'My Wallet',
            color: Colors.white,
            fontSize: 20,
            fontWeight: 600,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => const WalletHistoryScreen());
              },
              icon: const Icon(
                Icons.history,
                size: 25,
                color: AppColors.white,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 70,
          color: Colors.white,
          child: AdWidget(
            ad: GetAds.to.bannerAd,
          ),
        ),
        body: SingleChildScrollView(
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DesignText(
                    'Available Balance',
                    fontSize: 16,
                    fontWeight: 500,
                  ),
                  DesignText(
                    'Rs. ${GetProfileController.to.profileRes['data']?['userdetail']?['walletamount'] ?? '0.00'}',
                    fontSize: 16,
                    fontWeight: 400,
                  ),
                  const SizedBox(height: 20),
                  const DesignText(
                    'Please enter the amount',
                    fontSize: 16,
                    fontWeight: 500,
                  ),
                  const SizedBox(height: 10),
                  DesignFormField(
                    controller: paymentText,
                    hintText: 'Enter Amount',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 5),
                  const DesignText(
                    '*Note: Amount should be greater than Rs.100',
                    fontSize: 12,
                    fontWeight: 400,
                    color: AppColors.lightGrey1,
                  ),
                  const SizedBox(height: 5),
                  const DesignText(
                    '*Note: The Recharge value should be in Multiple of Rs.10.',
                    fontSize: 12,
                    fontWeight: 400,
                    color: AppColors.lightGrey1,
                  ),
                  Obx(() {
                    return appliedCoupen.value != ''
                        ? const SizedBox(height: 20)
                        : const SizedBox();
                  }),
                  Obx(() {
                    return appliedCoupen.value != ''
                        ? DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            color: AppColors.darkTeal,
                            strokeWidth: 1,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            dashPattern: [10, 5],
                            // borderPadding: EdgeInsets.all(8),
                            child: Row(children: [
                              Expanded(
                                child: DesignText(
                                  '$title',
                                  fontSize: 18,
                                  fontWeight: 600,
                                  color: AppColors.darkTeal,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    appliedCoupen.value = '';
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.darkTeal,
                                  ))
                            ]),
                          )
                        : const SizedBox();
                  }),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: DesignButtons(
                      onPressed: () async {
                        AddMoneyController.to.getDiscountedAmount(
                            amount: paymentText.text,
                            CounponCode: appliedCoupen.value);

                        if (paymentText.text.isEmpty) {
                          showSnackBar(
                              title: ApiConfig.error,
                              message: 'Please Enter Amount');
                        } else if (int.parse(paymentText.text) % 10 != 0) {
                          showSnackBar(
                              title: ApiConfig.error,
                              message: 'Amount Should be multiple of Rs.10');
                        } else if (int.parse(paymentText.text.toString()) >=
                            minAmount.value) {
                          // showP
                          if (appliedCoupen.value != '') {

                            if (AddMoneyController
                                .to.amounts.value.isNotEmpty) {
                              if(AddMoneyController.to.amounts.value['message'] != "" && AddMoneyController.to.amounts.value['message'] != null){
                                showSnackBar(
                                    title: ApiConfig.error,
                                    message: AddMoneyController.to.amounts.value['message']);
                              } else {
                                Get.to(() => ApplyCoupenScreen(
                                  amount: paymentText.text.toString(),
                                  coupen: appliedCoupen.value.toString(),
                                  discountedAmount: AddMoneyController.to.amounts.value['coupondiscount'].toString(),
                                  totalAmount: AddMoneyController.to.amounts.value['totalamount'].toString(),
                                  money: AddMoneyController.to.amounts.value['money'].toString().toString(),
                                  gstAmount:  AddMoneyController.to.amounts.value['gstamount'].toString(),
                                ));
                              }

                            }
                          }
                          else {
                            Get.to(() => PaymentInformation(
                                  isCashBack: false,
                                  amount: paymentText.text,
                                ));
                          }
                        } else {
                          showSnackBar(
                              title: ApiConfig.error,
                              message:
                                  'Amount Should be greater than Rs.${minAmount.value}');
                        }
                      },
                      textLabel: 'Add Money',
                      isTappedNotifier: ValueNotifier(false),
                      colorText: Colors.white,
                      fontSize: 14,
                      fontWeight: 600,
                      color: AppColors.darkTeal,
                      child: !onWillPop
                          ? const DesignProgress(color: Colors.white)
                          : const DesignText(
                              'Add Money',
                              fontSize: 12,
                              fontWeight: 600,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const DesignText(
                    'Applicable Coupon',
                    fontSize: 16,
                    fontWeight: 500,
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: AddMoneyController.to.coupens.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            appliedCoupen.value = AddMoneyController.to.coupens
                                    .elementAt(index)
                                    .id ??
                                "";
                            minAmount.value = AddMoneyController.to.coupens
                                    .elementAt(index)
                                    .minOrderAmount ??
                                100;
                            title.value = AddMoneyController.to.coupens
                                    .elementAt(index)
                                    .title ??
                                "";
                            int.parse(AddMoneyController.to.coupens
                                    .elementAt(index)
                                    .amountDeducted ??
                                "0");
                            AddMoneyController.to.getDiscountedAmount(
                                amount: paymentText.text,
                                CounponCode: appliedCoupen.value);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/img/BackgroundImageCoupon.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Text(AddMoneyController.to.coupens
                                              .elementAt(index)
                                              .title ??
                                          "")),
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          appliedCoupen.value =
                                              AddMoneyController.to.coupens
                                                      .elementAt(index)
                                                      .id ??
                                                  "";
                                          minAmount.value = AddMoneyController
                                                  .to.coupens
                                                  .elementAt(index)
                                                  .minOrderAmount ??
                                              100;
                                          title.value = AddMoneyController
                                                  .to.coupens
                                                  .elementAt(index)
                                                  .title ??
                                              "";
                                          AmountDeducted.value = int.parse(
                                              AddMoneyController.to.coupens
                                                      .elementAt(index)
                                                      .amountDeducted ??
                                                  "0");
                                          debugPrint(
                                              'AmountDeducted: $AmountDeducted');
                                          AddMoneyController.to.getDiscountedAmount(
                                              amount: paymentText.text,
                                              CounponCode: appliedCoupen.value);
                                        },
                                        child: const Text("Apply"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
