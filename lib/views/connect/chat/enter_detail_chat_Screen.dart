import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rashi_network/ui/custom/custom_text_form.dart';
import 'package:rashi_network/ui/theme/text.dart';
import 'package:rashi_network/utils/controller/get_profile_controller.dart';
import 'package:rashi_network/utils/design_colors.dart';

import '../../../api/api.dart';
import '../../../models/chat.dart';
import '../../../services/api/api_access.dart';
import '../../../utils/commonWidget.dart';
import 'controller/chatReq_controller.dart';
import 'new_chat/chat_screen_one.dart';

class EnterDetailChatScreen extends StatefulWidget {
  final Map<String, dynamic> astrologerProfile;
  final int astrologer_id;
  final name;

  EnterDetailChatScreen(
      {super.key,
      required this.astrologerProfile,
      required this.astrologer_id,
      this.name});

  @override
  State<EnterDetailChatScreen> createState() => _EnterDetailChatScreenState();
}

class _EnterDetailChatScreenState extends State<EnterDetailChatScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  TextEditingController birthTime = TextEditingController();
  TextEditingController birthLocation = TextEditingController();
  String? gender;
  String? relation;
  String? employement;
  TextEditingController profession = TextEditingController();
  TextEditingController message = TextEditingController();
  bool sendChatRequest = false;

  Timer? _timer;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
      setState(() {
        birthDate.text = formattedDate;
      });
    }
  }

  RxInt totalWaitingTime = 0.obs;

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedtime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedtime != null) {
      setState(() {
        birthTime.text = pickedtime.format(context).toString();
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  int parseDurationInSeconds(String durationString) {
    List<String> parts = durationString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    return hours * 3600 + minutes * 60 + (seconds - 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.darkTeal2,
        title: const DesignText(
          'Enter Details',
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
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (widget.astrologerProfile['is_busy'] == 'no' &&
                      widget.astrologerProfile['available_chat'] == 'yes') {
                    ///add from
                    totalWaitingTime.value = 0;

                    bool? status;

                    !sendChatRequest
                        ? await ChatController.to.sendChatRequestApi(
                            data: {
                              "astrologerid": widget.astrologer_id,
                              "userid": GetProfileController
                                      .to.profileRes["data"]?['user']?["id"] ??
                                  0,
                              "name": name.text,
                              "dob": birthDate.text,
                              "birthtime": birthTime.text,
                              "birthlocation": birthLocation.text,
                              "gender": gender,
                              "relationshipstatus": relation,
                              "employmentstatus": employement,
                              "profession": profession.text,
                              "message": message.text,
                            },
                          ).then((value) {
                            sendChatRequest = false;
                            status = value;
                          })
                        : () {
                            status = false;
                          };

                    sendChatRequest = true;

                    print(status);

                    if (status == false) {
                      insufficientBalancePopup(
                          context,
                          "${double.parse((widget.astrologerProfile['chat_price'] ?? 0).toString())}",
                          "chat");
                      return;
                    }

                    ///to
                    _timer = Timer.periodic(
                      const Duration(seconds: 3),
                      (_) {
                        log('TIMER');
                        var chatrequestid =
                            ChatController.to.sendChatRequestRes['detail']
                                    ['chat_request_id'] ??
                                0;
                        print('Shivam ${chatrequestid}');
                        ChatController.to.chatStatusApi(
                          data: {
                            "chatreqid": chatrequestid,
                          },
                          success: () async {
                            if (totalWaitingTime.value >= 120) {
                              log('CaNcel');
                              ChatController.to.chatStatusRes['data']
                                  ?['status'] = 3;
                              _timer?.cancel();
                              ChatController.to.chatNoAnswerApi(
                                data: {
                                  "chatreqid": chatrequestid,
                                },
                              );

                              Get.back();
                              Get.snackbar(
                                'Sorry!',
                                'Astrologer is not responding. Please try again later.',
                                backgroundColor: AppColors.darkTeal,
                                colorText: Colors.white,
                              );
                            }
                            var chat_request_id =
                                ChatController.to.sendChatRequestRes['detail']
                                        ['chat_request_id'] ??
                                    0;
                            var max_chat_duration =
                                ChatController.to.sendChatRequestRes['detail']
                                        ['max_chat_duration'] ??
                                    '';

                            print(max_chat_duration);
                            if ((ChatController.to.chatStatusRes['data']
                                        ?['status'] ??
                                    0) ==
                                1) {
                              _timer?.cancel();
                              bool chatExists;

                              await ApiAccess()
                                  .getAstrologerNumber(
                                      astrologerId:
                                          widget.astrologer_id.toString())
                                  .then((value) async {
                                debugPrint('Astrologer Number: $value');
                                if (value.isNotEmpty && value != null) {
                                  await Api.checkChatExists(
                                          currentUserUid: currentNumber,
                                          otherUserUid: senderNumber)
                                      .then((value) async {
                                    chatExists = value;
                                    if (!chatExists) {
                                      await Api.createChat(
                                              currentUserUid: currentNumber,
                                              otherUserUid: senderNumber)
                                          .then((value) {});
                                    } else {
                                      Api.startedChatting(
                                          currentUserUid: currentNumber,
                                          otherUserUid: senderNumber);
                                    }
                                  });
                                }
                              });
                              String Data =
                                  "name: ${name.text}\ndob: ${birthDate.text}\nbirthtime: ${birthTime.text}\nbirthlocation: ${birthLocation.text}\ngender: ${gender}\nrelationshipstatus: ${relation}\nemploymentstatus: ${employement}\nprofession: ${profession.text}\nmessage: ${message.text}\n ";
                               Timestamp? sentAt =
                                  Timestamp.fromDate(DateTime.now());
                              Messages mess = Messages(
                                  senderID: currentNumber,
                                  content: Data,
                                  messageType: MessageType.Text,
                                  sentAt: sentAt);

                              Api.sendChat(
                                  currentUserUid: currentNumber,
                                  otherUserUid: senderNumber,
                                  message: mess);
                              await Future.delayed(const Duration(seconds: 4));
                              Get.back();
                              Get.to(() => ChatScreenPage(
                                  chat_request_id,
                                  widget.astrologer_id,
                                  widget.name,
                                  max_chat_duration,
                                  astrologerProfile: widget.astrologerProfile));
                            }
                            log((ChatController.to.chatStatusRes['data'] ?? 0)
                                .toString());
                          },
                        );
                        totalWaitingTime.value = totalWaitingTime.value + 3;
                        log(totalWaitingTime.value.toString(),
                            name: "totalWaitingTime");
                      },
                    );
                    Get.dialog(
                        Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: WillPopScope(
                            onWillPop: () async {
                              _timer?.cancel();
                              GetProfileController.to.getProfileApi(params: {});
                              return true;
                            },
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
                                        Obx(() {
                                          return Expanded(
                                            child: DesignText(
                                              (ChatController.to.chatStatusRes['data']
                                                              ?['status'] ??
                                                          0) ==
                                                      0
                                                  ? 'Pending...'
                                                  : (ChatController.to.chatStatusRes[
                                                                      'data']
                                                                  ?['status'] ??
                                                              0) ==
                                                          1
                                                      ? 'Accepted ...'
                                                      : (ChatController.to.chatStatusRes['data']?[
                                                                      'status'] ??
                                                                  0) ==
                                                              2
                                                          ? 'Completed...'
                                                          : (ChatController.to.chatStatusRes['data']
                                                                          ?['status'] ??
                                                                      0) ==
                                                                  3
                                                              ? 'Declined...'
                                                              : (ChatController.to.chatStatusRes['data']?['status'] ?? 0) == 4
                                                                  ? 'Unanswered'
                                                                  : (ChatController.to.chatStatusRes['data']?['status'] ?? 0) == 5
                                                                      ? 'Failedtoconnect'
                                                                      : 'Connecting...',
                                              fontSize: 18,
                                              fontWeight: 600,
                                              color: AppColors.gold,
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        }),
                                        IconButton(
                                          onPressed: () {
                                            _timer?.cancel();
                                            GetProfileController.to
                                                .getProfileApi(params: {});
                                            Get.back();
                                          },
                                          icon: const Icon(Icons.close),
                                          color: AppColors.blackBackground,
                                          padding: EdgeInsets.zero,
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Obx(() {
                                        return DesignText(
                                          (ChatController.to.chatStatusRes['data']
                                                          ?['status'] ??
                                                      0) ==
                                                  0
                                              ? 'Please Wait Astrologer will accept Your Request And after that you can chat.'
                                              : (ChatController.to.chatStatusRes['data']
                                                              ?['status'] ??
                                                          0) ==
                                                      1
                                                  ? 'Astrologer has Accepted the chat Request.'
                                                  : (ChatController.to.chatStatusRes['data']
                                                                  ?['status'] ??
                                                              0) ==
                                                          2
                                                      ? 'Your chat with Astrologer has been Completed'
                                                      : (ChatController.to.chatStatusRes['data']
                                                                      ?[
                                                                      'status'] ??
                                                                  0) ==
                                                              3
                                                          ? 'Astrologer has Decline the chat Request.'
                                                          : (ChatController.to.chatStatusRes['data']
                                                                          ?['status'] ??
                                                                      0) ==
                                                                  4
                                                              ? 'Your chat with Astrologer is Ongoing'
                                                              : 'Astrologer Will Connect Soon..',
                                          fontSize: 16,
                                          fontWeight: 400,
                                          textAlign: TextAlign.center,
                                        );
                                      }),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        barrierDismissible: false);
                  } else {
                    Get.dialog(Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
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
                                  'Sorry!',
                                  fontSize: 18,
                                  fontWeight: 600,
                                  color: AppColors.gold,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.back();
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DesignText(
                              widget.astrologerProfile['available_chat'] == 'no'
                                  ? 'The Astrologer is not available for chat. Select another astrologer for chatting or wait for some time and try again.'
                                  : 'The Astrologer is busy with another chat. Select another astrologer for chatting or wait for some time and try again.',
                              fontSize: 16,
                              fontWeight: 400,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]),
                      ),
                    ));
                  }
                }
              },
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              label: Container(
                margin: const EdgeInsets.only(left: 4),
                child: const DesignText(
                  "Submit",
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
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DesignFormField(
                  controller: name,
                  hintText: 'Enter name',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter Your Name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DesignFormField(
                  controller: birthDate,
                  hintText: 'Enter birth date',
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter Your Birth Date";
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                ),
                const SizedBox(height: 10),
                DesignFormField(
                  controller: birthTime,
                  hintText: 'Enter birth time',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter Your Birth Time";
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: () {
                    _selectTime(context);
                  },
                ),
                const SizedBox(height: 10),
                DesignFormField(
                  controller: birthLocation,
                  hintText: 'Enter birth Location',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Please Enter Your Birth Time";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: gender,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field Required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Gender',
                    filled: true,
                    isDense: true,
                    fillColor: Colors.transparent,
                    // hintStyle: TextStyle(color: DesignColor.darkGrey),
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
                      borderSide:
                          BorderSide(color: AppColors.tapRed, width: 2.0),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    // Update the selected gender when a new value is chosen
                    setState(() {
                      gender = newValue;
                    });
                  },
                  items: <String>['Male', 'Female'].map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: relation,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Field Required";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select Relationship status',
                    filled: true,
                    isDense: true,
                    fillColor: Colors.transparent,
                    // hintStyle: TextStyle(color: DesignColor.darkGrey),
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
                      borderSide:
                          BorderSide(color: AppColors.tapRed, width: 2.0),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    // Update the selected gender when a new value is chosen
                    setState(() {
                      relation = newValue;
                    });
                  },
                  items: <String>['Married', 'Unmarried', 'Single', 'Divorce']
                      .map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: employement,
                  decoration: const InputDecoration(
                    hintText: 'Select Employment Status',
                    filled: true,
                    isDense: true,
                    fillColor: Colors.transparent,
                    // hintStyle: TextStyle(color: DesignColor.darkGrey),
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
                      borderSide:
                          BorderSide(color: AppColors.tapRed, width: 2.0),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    // Update the selected gender when a new value is chosen
                    setState(() {
                      employement = newValue;
                    });
                  },
                  items: <String>['Working', 'Job', 'Business', 'Housewives']
                      .map((String gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                DesignFormField(
                  controller: profession,
                  hintText: 'Enter Profession',
                ),
                const SizedBox(height: 10),
                DesignFormField(
                  controller: message,
                  hintText: 'Enter message',
                  maxLines: 3,
                ),
                const DesignText(
                    '*Disclaimer: Please provide accurate predictions for better results',
                    fontSize: 12,
                    fontWeight: 400),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
