import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String orderId;
  String userId;
  DateTime date;
  int totalCost;
  String status;
  List<OrderItem> items;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.date,
    required this.totalCost,
    required this.status,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'date': date,
      'totalCost': totalCost,
      'status': status,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'],
      userId: map['userId'],
      date: (map['date'] as Timestamp).toDate(),
      totalCost: map['totalCost'],
      status: map['status'],
      items: List<OrderItem>.from(map['items']?.map((item) => OrderItem.fromMap(item)) ?? []),
    );
  }
}

class OrderItem {
  String bookId;
  String bookTitle;
  int quantity;
  int costPerItem;
  int totalCost;

  OrderItem({
    required this.bookId,
    required this.bookTitle,
    required this.quantity,
    required this.costPerItem,
    required this.totalCost,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'bookTitle': bookTitle,
      'quantity': quantity,
      'costPerItem': costPerItem,
      'totalCost': totalCost,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      bookId: map['bookId'],
      bookTitle: map['bookTitle'],
      quantity: map['quantity'],
      costPerItem: map['costPerItem'],
      totalCost: map['totalCost'],
    );
  }
}
