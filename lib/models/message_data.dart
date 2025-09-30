class MessageData {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;

  MessageData({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
