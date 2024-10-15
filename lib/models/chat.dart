import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';


class Chat {
  String? id;
  List<String>? participants;
  List<Messages>? messages;

  Chat({
    required this.id,
    required this.participants,
    required this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List<String>.from(json['participants']);
    messages = List.from(json['messages']).map((m) => Messages.fromJson(m)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participants': participants,
      'messages': messages?.map((m) => m.toJson()).toList(),
    };
  }
}



enum MessageType { Text, Image }

class Messages {
  String? senderID;
  String? content;
  MessageType? messageType;
  Timestamp? sentAt;

  Messages({
    required this.senderID,
    required this.content,
    required this.messageType,
    required this.sentAt,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    senderID = json['senderID'];
    content = json['content'];
    sentAt = json['sentAt'];
    messageType = MessageType.values.byName(json['messageType']);
  }

  Map<String, dynamic> toJson() {
    return {
      "senderID": senderID,
      "content": content,
      "sentAt": sentAt,
      "messageType": messageType?.name,
    };
  }
}
