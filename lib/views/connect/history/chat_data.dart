import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../utils/design_colors.dart';
import '../../../api/api.dart';
import '../../../ui/theme/text.dart';
import '../../../utils/controller/get_profile_controller.dart';
import 'controller/history_controller.dart';

class ChatData extends StatefulWidget {
  final int requestId;
  final name;
  const ChatData(this.requestId, this.name, {Key? key}): super(key: key);

  @override
  _ChatDataState createState() => _ChatDataState();
}

class _ChatDataState extends State<ChatData> {
  ChatUser? currentUser;
  ChatUser? otherChatUser;

  @override
  void initState() {
    super.initState();
    currentUser = ChatUser(id: currentNumber, firstName: "User");
    otherChatUser = ChatUser(id: senderNumber, firstName: widget.name);
    HistoryController.to.chatInfoApi(
      params: {"chatreqid": widget.requestId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text(widget.name),
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
              inputDecoration: InputDecoration(
                hintText: 'You are in View Mode',
                border: InputBorder.none,
              ),
              inputDisabled: true,
              alwaysShowSend: false,
            ),
            currentUser: currentUser!,
            onSend: (message){},
            messages: messages,
          );
        },
      ),);
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