import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rashi_network/views/home.dart';
import 'package:rashi_network/views/home_controller.dart';

import '../../../../api/api.dart';
import '../../../../models/chat.dart';
import '../controller/chatReq_controller.dart';

String chatreqid = "";
class ChatScreenPage extends StatefulWidget {
  final int requestId;
  final int receiverId;
  final name;
  final String max_chat_duration;
  final Map<String, dynamic> astrologerProfile;

  const ChatScreenPage(
      this.requestId, this.receiverId, this.name, this.max_chat_duration,
      {Key? key, required this.astrologerProfile})
      : super(key: key);

  @override
  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  late Duration duration;
  Timer? timer;
  ChatUser? currentUser;
  ChatUser? otherChatUser;
  ChatController timerController = Get.put(ChatController());

  @override
  void initState() {
    chatreqid = widget.requestId.toString();
    currentUser = ChatUser(id: currentNumber, firstName: "User");
    otherChatUser = ChatUser(id: senderNumber, firstName: widget.name);
    timerController.duration.value =
        timerController.parseDuration(widget.max_chat_duration);
    timerController.startTimer(
        context: context, reqid: widget.requestId.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show dialog only if it's not already displayed
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Warning"),
            content: const Text("If you Switch the screen or minimize the app, the chat will be ended."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    });
    super.initState();
  }

  dispose() {
    timerController.timer?.cancel();
    chatreqid = "";
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            leading: TextButton(
              child: const Text(
                "End",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                timerController.endChatApi(data: {
                  "chatreqid": widget.requestId,
                });
                Api.endChat(
                  currentUserUid: currentNumber,
                  otherUserUid: senderNumber,
                );
                timerController.chatEnd.value = false;
                Get.offAll(() => const HomeController());
                senderNumber = "";
                
              },
            ),
            title: Text(widget.name),
            actions: [
              Obx(() => Text(timerController
                  .formatDuration(timerController.duration.value))),
              const SizedBox(width: 10),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: Api.getChatData(currentNumber, senderNumber),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            // Ensure chatData is not null and is a Map<String, dynamic>
            Map<String, dynamic>? chatData =
            snapshot.data as Map<String, dynamic>?;

            List<ChatMessage> messages = [];

            if (chatData!["chattingOngoing"] == false) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Show dialog only if it's not already displayed
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Chat Ended"),
                      content: const Text("Chat has been ended by the user"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if(chatData["chattingOngoing"] != false) {
                              timerController.endChatApi(data: {
                                "chatreqid": widget.requestId,
                              });
                            Api.endChat(
                              currentUserUid: currentNumber,
                              otherUserUid: senderNumber,
                            );
                          }
                          Get.offAll(() => const HomeController());
                            timerController.chatEnd.value = false;
                            senderNumber = "";
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              });

            }

            messages = _getMessages(chatData!["messages"]);

            return DashChat(
              messageListOptions: const MessageListOptions(
                showFooterBeforeQuickReplies: true,
                showDateSeparator: true,
              ),
              messageOptions: const MessageOptions(
                showOtherUsersAvatar: false,
                showCurrentUserAvatar: false,
                showTime: true,
              ),
              inputOptions: const InputOptions(
                alwaysShowSend: true,
              ),
              currentUser: currentUser!,
              onSend: _sendMessage,
              messages: messages,
            );
          },
        ),);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours);
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    Timestamp? sentAt = Timestamp.fromDate(chatMessage.createdAt);
    Messages message = Messages(
        senderID: currentNumber,
        content: chatMessage.text,
        messageType: MessageType.Text,
        sentAt: sentAt);

    Api.sendChat(
        currentUserUid: currentNumber,
        otherUserUid: senderNumber,
        message: message);
  }

  List<ChatMessage> _getMessages(List<dynamic> messagesChat) {
    List<ChatMessage> messages = [];
    debugPrint('messages: $messagesChat');
    for (var message in messagesChat) {
      messages.add(ChatMessage(
        text: message['content'],
        user: message['senderID'] == currentUser!.id.toString()
            ? currentUser!
            : otherChatUser!,
        createdAt: DateTime.now(),
      ));
    }
    messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return messages;
  }
}
