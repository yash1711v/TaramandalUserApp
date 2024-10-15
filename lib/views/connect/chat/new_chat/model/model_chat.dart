class Message {
  String? type;
  int? senderId;
  int? recipientId;
  int? reqId;
  String? textMessage;
  String? date;
  String? time;
  int? is_live;

  Message({
    this.type,
    this.senderId,
    this.recipientId,
    this.reqId,
    this.textMessage,
    this.date,
    this.time,
    this.is_live
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      type: json['type'] ?? '',
      senderId: json['sender_id'] ?? 0,
      recipientId: json['recipient_id'] ?? 0,
      reqId: json['reqid'] ?? 0,
      textMessage: json['message'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      is_live: json['is_live'] ?? 0
    );
  }

  //fromDynamic
  factory Message.fromDynamic(dynamic json) {
    return Message(
      type: json['type'] ?? 'chat_message',
      senderId: int.parse(json['outgoing_msg_id']) ?? 0,
      recipientId: int.parse(json['incoming_msg_id']) ?? 0,
      reqId: json['reqid'] ?? 0,
      textMessage: json['text_message'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      is_live: json['is_live'] ?? 1
    );
  }
}