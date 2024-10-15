import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:rashi_network/ui/custom/design_single_tap.dart';
import 'package:rashi_network/ui/theme/container.dart';
import 'package:rashi_network/ui/theme/text.dart';
import 'package:rashi_network/utils/design_colors.dart';
import 'package:rashi_network/utils/design_utlis.dart';
import 'package:rashi_network/utils/snackBar.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CallDetailScreen extends ConsumerStatefulWidget {
  final Map callData;
  const CallDetailScreen({super.key, required this.callData});

  @override
  ConsumerState<CallDetailScreen> createState() => _CallDetailScreenState();
}

class _CallDetailScreenState extends ConsumerState<CallDetailScreen> {
  /* @override
  void initState() {
    // TODO: implement initState
    CallChatController.to.callHistoryDetailApi(data: {"id": widget.callId});
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    print(widget.callData);
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: AppColors.darkTeal2,
          title: const DesignText(
            'Call Detail',
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
              Get.back();
            },
          ),
          actions: const [
            // IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            // const SizedBox(width: 14),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            (widget.callData['status'] ?? '-') == 'in-progress'
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: FloatingActionButton.extended(
                          backgroundColor: AppColors.darkTeal,
                          onPressed: () {
                            if ((widget.callData['recordingurl'] != '') &&
                                (widget.callData['recordingurl'] != null)) {

                              DesignUtlis.launchURL(
                                '${widget.callData['recordingurl']}',
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              showSnackBar(
                                  title: "Error",
                                  message:
                                      'Recording is not available for this call');
                            }
                          },
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          label: const DesignText(
                            "Call Recording",
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: 600,
                          )),
                    ),
                  ),
        body: /*CallChatController.to.callHistoryDetailResponse.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator(
                        color: AppColors.darkTeal,
                      ),
                      */ /*Image.asset('assets/img/no_data.png',
                          height: 120, width: 120),
                      SizedBox(height: 20),
                      DesignText(
                        "Ohhh!! There is no Ongoing Calls",
                        fontSize: 18,
                        fontWeight: 400,
                        color: AppColors.lightGrey1,
                      ),*/ /*
                    ],
                  ),
                )
              :*/
            Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DesignContainer(
            color: AppColors.white,
            // height: 140,
            child: Column(
              children: [
                Row(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.green),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            (widget.callData['profileimage'] ?? '') != ''
                                ? 'https://thetaramandal.com/public/astrologer/${(widget.callData['profileimage'] ?? '')}'
                                : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzHQv_th9wq3ivQ1CVk7UZRxhbPq64oQrg5Q&usqp=CAU',
                          ),
                          fit: BoxFit.cover,
                        )
                        // assuming height/width is 83
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    children: [
                      DesignText(
                        widget.callData['name'] ?? '-',
                        fontSize: 18,
                        fontWeight: 600,
                      ),
                      const SizedBox(height: 2),
                      DesignText(
                        'Date: ${widget.callData['call_starttime'] ?? 0}',
                        fontSize: 12,
                        fontWeight: 500,
                        color: AppColors.lightGrey1,
                      ),
                      DesignText(
                        'Call rate: Rs.${widget.callData['call_price'] ?? 0}/min',
                        fontSize: 12,
                        fontWeight: 500,
                        color: AppColors.lightGrey1,
                      ),
                      DesignText(
                        'Duration: ${widget.callData['callduration'] ?? ''} seconds',
                        fontSize: 12,
                        fontWeight: 500,
                        color: AppColors.lightGrey1,
                      ),
                      DesignText(
                        'Deduction: ${widget.callData['callcharges'] ?? '0'}',
                        fontSize: 12,
                        fontWeight: 500,
                        color: AppColors.red,
                      ),
                      /*  const DesignText(
                                            'Birth Place: Mumbai',
                                            fontSize: 12,
                                            fontWeight: 500,
                                            color: AppColors.lightGrey1,
                                          ),
                                          const DesignText(
                                            'Gender: Male',
                                            fontSize: 12,
                                            fontWeight: 500,
                                            color: AppColors.lightGrey1,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 31,
                                                width: 90,
                                                child: DesignButtons(
                                                  onPressed: () async {
                                                    Get.to(() => const ChatScreen(
                                                        name: 'Sanjay Gupta'));
                                                  },
                                                  textLabel: 'Accept',
                                                  isTappedNotifier:
                                                      ValueNotifier(false),
                                                  sideWidth: 1,
                                                  colorText: Colors.white,
                                                  borderSide: true,
                                                  colorBorderSide:
                                                      AppColors.darkTeal1,
                                                  fontSize: 12,
                                                  fontWeight: 700,
                                                  color: AppColors.darkTeal1,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              SizedBox(
                                                height: 31,
                                                width: 90,
                                                child: DesignButtons(
                                                  onPressed: () async {},
                                                  textLabel: 'Decline',
                                                  isTappedNotifier:
                                                      ValueNotifier(false),
                                                  sideWidth: 1,
                                                  colorText: AppColors.darkTeal1,
                                                  borderSide: true,
                                                  colorBorderSide:
                                                      AppColors.darkTeal1,
                                                  fontSize: 12,
                                                  fontWeight: 700,
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                            ],
                                          ),*/
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
