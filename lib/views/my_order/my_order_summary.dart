import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rashi_network/services/ad_service/get_ads.dart';
import 'package:rashi_network/utils/design_colors.dart';
import 'package:rashi_network/ui/theme/text.dart';
import 'package:rashi_network/views/cart/cart_address_select.dart';

class MyorderSummary extends StatefulWidget {
  const MyorderSummary({super.key});

  @override
  State<MyorderSummary> createState() => _MyorderSummaryState();
}

class _MyorderSummaryState extends State<MyorderSummary> {
  @override
  void initState() {
    // TODO: implement initState
    GetAds.to.loadBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.darkTeal2,
        title: const DesignText(
          'Order Summary',
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
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70,
        color: Colors.white,
        child: AdWidget(
          ad: GetAds.to.bannerAd,
        ),
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
                Get.back();
              },
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              label: Container(
                margin: const EdgeInsets.only(left: 4),
                child: const DesignText(
                  "Go back",
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
              const SizedBox(height: 6),
              PriceSummaryCard(title: 'MRP', price: 'Rs.50'.toString()),
              const SizedBox(height: 8),
              PriceSummaryCard(
                  title: 'Wallet Balance', price: 'Rs.0'.toString()),
              const SizedBox(height: 8),
              PriceSummaryCard(
                  title: 'Payable Amount', price: 'Rs.100'.toString()),
              const SizedBox(height: 8),
              PriceSummaryCard(title: 'GST (%2)', price: 'Rs.50'.toString()),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
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
              const SizedBox(height: 6),
              const Divider(color: AppColors.darkTeal, height: 20),
              const SizedBox(height: 6),
              const DesignText(
                'Order Details',
                fontSize: 16,
                fontWeight: 500,
              ),
              const SizedBox(height: 12),
              PriceSummaryCard(
                title: 'Delivery Date:',
                price: '23rd April 2023'.toString(),
              ),
              const SizedBox(height: 12),
              PriceSummaryCard(
                title: 'Paid using',
                price: 'UPI'.toString(),
              ),
              const SizedBox(height: 12),
              const PriceSummaryCard(
                title: 'Deliever To:',
                price:
                    'Sai Siddhi Building Kajupada, Ab hinav Nagar, Borivali East',
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
    required this.price,
  });
  final String title;
  final String price;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DesignText(
          title,
          fontSize: 14,
          fontWeight: 500,
        ),
        const SizedBox(width: 12),
        Flexible(
          child: DesignText(
            price,
            fontSize: 14,
            fontWeight: 500,
          ),
        ),
      ],
    );
  }
}
