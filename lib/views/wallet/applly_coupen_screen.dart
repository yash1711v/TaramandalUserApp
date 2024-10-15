import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rashi_network/payment_test.dart';
import 'package:rashi_network/services/api/api_service.dart';
import 'package:rashi_network/ui/theme/text.dart';
import 'package:rashi_network/ui/widgets/material_iconbtn.dart';
import 'package:rashi_network/utils/design_colors.dart';
import 'package:rashi_network/views/cart/cart_summary.dart';
import 'package:rashi_network/views/wallet/controller/add_money_controller.dart';
import 'package:rashi_network/views/wallet/wallet_payment_confirmation.dart';

import '../../utils/snackbar.dart';

class ApplyCoupenScreen extends StatefulWidget {
  final bool isCashBack;
  final String amount;
  final String coupen;
  final String discountedAmount;
  final String gstAmount;
  final String totalAmount;
  final String money;
  const ApplyCoupenScreen(
      {super.key,
      this.isCashBack = false,
      required this.totalAmount,
      required this.money,
        required this.discountedAmount,
      required this.gstAmount,
      required this.amount,
      required this.coupen});

  @override
  State<ApplyCoupenScreen> createState() => _ApplyCoupenScreenState();
}

class _ApplyCoupenScreenState extends State<ApplyCoupenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.darkTeal2,
        title: const DesignText(
          'Payment Information',
          color: Colors.white,
          fontSize: 20,
          fontWeight: 600,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 45,
          width: double.infinity,
          child: FloatingActionButton.extended(
              backgroundColor: AppColors.darkTeal,
              onPressed: () {
                AddMoneyController.to.addMoneyApi(
                    params: {
                      "amount": int.parse(widget.amount),
                      "couponcode": widget.coupen,
                    },
                    success: () {
                      log(
                          AddMoneyController.to.addMoneyRes['data']
                                  ?['paymenturl'] ??
                              "null",
                          name: 'REDIRECT URL');
                      if ((AddMoneyController.to.addMoneyRes['data']
                                  ?['paymenturl'] ??
                              null) ==
                          null) {
                        showSnackBar(
                            title: ApiConfig.error,
                            message: 'Something Went Wrong Try Again');
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CcavenuePaymentScreen(
                                paymentRequestUrl: AddMoneyController
                                    .to.addMoneyRes['data']['paymenturl'],
                              ),
                            ));
                      }
                    },
                    error: (e) {
                      showSnackBar(
                          title: ApiConfig.error, message: e.toString());
                    });
              },
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              label: Container(
                margin: const EdgeInsets.only(left: 4),
                child: const DesignText(
                  "Proceed",
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: 700,
                ),
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            PriceSummaryCard(
                title: 'Recharge Amount', price: 'Rs.${widget.money}'),
            const SizedBox(height: 8),
            PriceSummaryCard(
                title: 'Coupon',
                price: '-Rs.${widget.discountedAmount}',
                  color: Colors.red,
            ),
            const SizedBox(height: 8),
            PriceSummaryCard(
                title: 'GST(18%)',
                price:
                    'Rs.${widget.gstAmount}',),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const DesignText(
                  'Payable Amount',
                  fontSize: 16,
                  fontWeight: 600,
                ),
                DesignText(
                  'Rs.${widget.totalAmount}',
                  fontSize: 16,
                  fontWeight: 600,
                ),
              ],
            ),
            const SizedBox(height: 10),
            !widget.isCashBack
                ? const SizedBox()
                : Container(
                    clipBehavior: Clip.antiAlias,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(width: 1, color: AppColors.darkTeal)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: DesignText(
                              '100 % Extra on recharge of Rs 50',
                              fontSize: 14,
                              fontWeight: 500,
                              color: AppColors.darkTeal,
                            ),
                          ),
                          MaterialIconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
            !widget.isCashBack ? const SizedBox() : const SizedBox(height: 10),
            !widget.isCashBack
                ? const SizedBox()
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.done,
                        color: AppColors.darkTeal,
                      ),
                      SizedBox(width: 6),
                      Flexible(
                        child: DesignText(
                          'Rs.50 Cashback in wallet with this recharge',
                          fontSize: 14,
                          fontWeight: 500,
                          color: AppColors.darkTeal,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
