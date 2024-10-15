import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rashi_network/utils/design_colors.dart';
import 'package:rashi_network/ui/theme/buttons/buttons.dart';
import 'package:rashi_network/ui/theme/container.dart';
import 'package:rashi_network/ui/theme/text.dart';
import 'package:rashi_network/views/cart/cart_address_select.dart';

class CartSummary extends StatefulWidget {
  const CartSummary({super.key});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.darkTeal2,
        title: const DesignText(
          'Cart Summary',
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
                Get.to(() => const CartAddress());
              },
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              label: Container(
                margin: const EdgeInsets.only(left: 4),
                child: const DesignText(
                  "Continue",
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: 700,
                ),
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PriceSummaryCard(title: 'MRP', price: 'Rs.50'.toString()),
              const SizedBox(height: 6),
              PriceSummaryCard(
                  title: 'Wallet Balance', price: 'Rs.0'.toString()),
              const SizedBox(height: 6),
              PriceSummaryCard(
                  title: 'Payable Amount', price: 'Rs.100'.toString()),
              const SizedBox(height: 6),
              PriceSummaryCard(title: 'GST (%2)', price: 'Rs.50'.toString()),
              const SizedBox(height: 6),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DesignText(
                    'Total Payable Amount',
                    fontSize: 14,
                    fontWeight: 600,
                  ),
                  DesignText(
                    'Rs.59',
                    fontSize: 14,
                    fontWeight: 600,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const DesignText(
                'Estimated Deievery By: 23rd Feb 2023',
                fontSize: 12,
                fontWeight: 400,
                color: AppColors.darkTeal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceSummaryCard extends StatelessWidget {
  const PriceSummaryCard({
    super.key,
    required this.title,
    required this.price, this.color,
  });
  final String title;
  final String price;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DesignText(
          title,
          fontSize: 14,
          fontWeight: 500,
          color: color,
        ),
        DesignText(
          price,
          fontSize: 14,
          fontWeight: 500,
          color: color,
        ),
      ],
    );
  }
}
