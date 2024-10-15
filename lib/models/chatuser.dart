class ChatUser {
  ChatUser({
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.number,
    required this.pushToken,
  });
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String number;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    number = json['number'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['push_token'] = pushToken;
    data['number'] = number;
    return data;
  }
}