import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:rashi_network/ui/theme/text.dart';
import 'package:rashi_network/utils/design_colors.dart';
import 'package:rashi_network/views/home_controller.dart';

import '../../../services/api/api_access.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/snackbar.dart';
import 'controller/chatReq_controller.dart';

class RateAstrologerScreen extends StatefulWidget {
  final astrologer;
  final name;
  final Map<String, dynamic> astrologerProfile;

  const RateAstrologerScreen({super.key, required this.astrologer, required this.name, required this.astrologerProfile});

  @override
  State<RateAstrologerScreen> createState() => _RateAstrologerScreenState();
}

class _RateAstrologerScreenState extends State<RateAstrologerScreen> {
  final text = TextEditingController();
  double selectedRating = 3.0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.darkTeal2,
        title: const DesignText(
          'Rating',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //send to home screen
            Get.offAll(() => HomeController());
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkTeal2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(15),
          ),
          onPressed: () {
            Get.dialog(
                barrierDismissible: false,
                Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Opacity(
                                opacity: 0,
                                child: IconButton(
                                  onPressed: null,
                                  icon: Icon(Icons.close),
                                  color: AppColors.blackBackground,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                              const Expanded(
                                child: DesignText(
                                  'Thank You!',
                                  fontSize: 18,
                                  fontWeight: 600,
                                  color: AppColors.gold,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.offAll(() => HomeController());
                                },
                                icon: const Icon(Icons.close),
                                color: AppColors.blackBackground,
                                padding: EdgeInsets.zero,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 12),
                            child: DesignText(
                              'Thank you for sharing your valuable experience with us.',
                              fontSize: 16,
                              fontWeight: 400,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]),
                  ),
                ));
            Get.defaultDialog(
              onWillPop: () async {
                Get.offAll(() => HomeController());
                return false;
              },
              backgroundColor: Colors.white,
              content: Column(children: [
                Row(
                  children: [
                    const Opacity(
                      opacity: 0,
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(Icons.close),
                        color: AppColors.blackBackground,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const Expanded(
                      child: DesignText(
                        'Thank You!',
                        fontSize: 18,
                        fontWeight: 600,
                        color: AppColors.gold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.offAll(() => HomeController());
                      },
                      icon: const Icon(Icons.close),
                      color: AppColors.blackBackground,
                      padding: EdgeInsets.zero,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DesignText(
                    'Thank you for sharing your valuable experience with us.',
                    fontSize: 16,
                    fontWeight: 400,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
              title: '',
              actions: [const Text('')],
              barrierDismissible: true,
            );
          },
          child: const DesignText(
            'Skip',
            fontSize: 16,
            fontWeight: 500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Row(),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.green),
                  borderRadius:
                      BorderRadius.circular(60), // assuming height/width is 83
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    'https://thetaramandal.com/public/astrologer/${widget.astrologerProfile['photo']}',
                    height: 83,
                    width: 83,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              DesignText(
                widget.name,
                fontSize: 15,
                fontWeight: 700,
              ),
              const SizedBox(height: 6),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemSize: 30,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),

                onRatingUpdate: (rating) {
                  setState(() {
                    selectedRating = rating;
                  });
                  print(rating);
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DesignText(
                    'Share Your Feedback',
                    fontSize: 15,
                    fontWeight: 400,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: text,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Field Required";
                  }
                  return null;
                },
                onTapOutside: (event) {
                  final currentFocus = FocusScope.of(context);
                  if (currentFocus.focusedChild != null) {
                    currentFocus.focusedChild!.unfocus();
                  }
                },
                onChanged: (value) {
                  if (text.text.trim().length == 1 ||
                      text.text.trim().isEmpty) {
                    setState(() {});
                  }
                  /*if (openDocumentButtm) {
                    openDocumentButtm = false;
                    setState(() {});
                  }*/
                },
                decoration: InputDecoration(
                  hintText: 'Type Message',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: text.text.trim().isEmpty
                      ? null
                      : AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 30,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Material(
                              borderRadius: BorderRadius.circular(60),
                              clipBehavior: Clip.antiAlias,
                              child: IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  String reviewText = text.text.trim();
                                  ChatController.to.reviewRatingApi(
                                    data: {
                                      "astrologerid": widget.astrologer,
                                      "review": reviewText,
                                      "rating": selectedRating,
                                    },
                                    success: () {
                                    },
                                    error: (e) {
                                      showSnackBar(
                                        title: ApiConfig.error,
                                        message: e.toString(),
                                      );
                                    },
                                  );
                                  Get.dialog(
                                      barrierDismissible: false,
                                      Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Opacity(
                                                      opacity: 0,
                                                      child: IconButton(
                                                        onPressed: null,
                                                        icon: Icon(Icons.close),
                                                        color: AppColors
                                                            .blackBackground,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                    ),
                                                    const Expanded(
                                                      child: DesignText(
                                                        'Thank You!',
                                                        fontSize: 18,
                                                        fontWeight: 600,
                                                        color: AppColors.gold,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Get.offAll(() =>
                                                            HomeController());
                                                      },
                                                      icon: const Icon(
                                                          Icons.close),
                                                      color: AppColors
                                                          .blackBackground,
                                                      padding: EdgeInsets.zero,
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12),
                                                  child: DesignText(
                                                    'Thank you for sharing your valuable experience with us.',
                                                    fontSize: 16,
                                                    fontWeight: 400,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ));
                                  /* Get.defaultDialog(
                                    onWillPop: () async {
                                      Get.offAll(() => HomeController());
                                      return false;
                                    },
                                    backgroundColor: Colors.white,
                                    content: Column(children: [
                                      Row(
                                        children: [
                                          const Opacity(
                                            opacity: 0,
                                            child: IconButton(
                                              onPressed: null,
                                              icon: Icon(Icons.close),
                                              color: AppColors.blackBackground,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                          const Expanded(
                                            child: DesignText(
                                              'Thank You!',
                                              fontSize: 18,
                                              fontWeight: 600,
                                              color: AppColors.gold,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Get.offAll(
                                                  () => HomeController());
                                            },
                                            icon: const Icon(Icons.close),
                                            color: AppColors.blackBackground,
                                            padding: EdgeInsets.zero,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: DesignText(
                                          'Thank you for sharing your valuable experience with us.',
                                          fontSize: 16,
                                          fontWeight: 400,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ]),
                                    title: '',
                                    actions: [const Text('')],
                                    barrierDismissible: true,
                                  );*/
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding: const EdgeInsets.all(16),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.darkGrey, width: 1.0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.lightGrey3, width: 1.0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: AppColors.lightGrey3, width: 1.0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: AppColors.tapRed, width: 1.0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                minLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
