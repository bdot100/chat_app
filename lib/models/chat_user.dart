class ChatUser {
  ChatUser({
    required this.id,
    required this.isOnline,
    required this.pushToken,
    required this.createdAt,
    required this.image,
    required this.email,
    required this.about,
    required this.lastActive,
    required this.name,
  });
  late String id;
  late bool isOnline;
  late String pushToken;
  late String createdAt;
  late String image;
  late String email;
  late String about;
  late String lastActive;
  late String name;

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    isOnline = json['is_online'] ?? '';
    pushToken = json['push_token'] ?? '';
    createdAt = json['created_at'] ?? '';
    image = json['image'] ?? '';
    email = json['email'] ?? '';
    about = json['about'] ?? '';
    lastActive = json['last_active'] ?? '';
    name = json['name'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['is_online'] = isOnline;
    data['push_token'] = pushToken;
    data['created_at'] = createdAt;
    data['image'] = image;
    data['email'] = email;
    data['about'] = about;
    data['last_active'] = lastActive;
    data['name'] = name;
    return data;
  }
}
