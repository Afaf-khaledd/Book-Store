class NotificationModel {
  final String orderId;
  final String userId;
  final String status;

  NotificationModel({
    required this.orderId,
    required this.userId,
    required this.status,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'status': status,
    };
  }
}