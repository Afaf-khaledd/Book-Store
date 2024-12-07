import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/CartItemModel.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isBookInCart(String userId, String bookId) async {
    try {
      final cartDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(bookId)
          .get();
      return cartDoc.exists;
    } catch (e) {
      throw Exception('Error checking if book is in cart: $e');
    }
  }

  Future<void> addToCart(String userId, CartItemModel item) async {
    try {
      final cartRef = _firestore.collection('users').doc(userId).collection('cart');
      final cartItemDoc = cartRef.doc(item.bookId);

      final existingItem = await cartItemDoc.get();
      if (existingItem.exists) {
        await cartItemDoc.update({
          'quantity': FieldValue.increment(item.quantity),
        });
      } else {
        await cartItemDoc.set(item.toJson());
      }
      await _updateTotalPrice(userId);
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  Future<void> updateQuantity(String userId, String bookId, int quantityChange) async {
    try {
      final cartItemRef = _firestore.collection('users').doc(userId).collection('cart').doc(bookId);

      await cartItemRef.update({
        'quantity': FieldValue.increment(quantityChange),
      });

      final updatedItem = await cartItemRef.get();
      if (updatedItem.exists && updatedItem['quantity'] <= 0) {
        await cartItemRef.delete();
      }
      await _updateTotalPrice(userId);
    } catch (e) {
      throw Exception('Failed to update item quantity: $e');
    }
  }

  Future<void> removeFromCart(String userId, String bookId) async {
    try {
      await _firestore.collection('users').doc(userId).collection('cart').doc(bookId).delete();
      await _updateTotalPrice(userId);
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  Future<List<CartItemModel>> fetchCartItems(String userId) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userId).collection('cart').get();
      return snapshot.docs.map((doc) => CartItemModel.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Failed to fetch cart items: $e');
    }
  }
  Future<void> _updateTotalPrice(String userId) async {
    try {
      final cartItems = await fetchCartItems(userId);
      double totalPrice = 0.0;

      for (var item in cartItems) {
        totalPrice += item.price * item.quantity;
      }

      await _firestore.collection('users').doc(userId).update({
        'totalCartPrice': totalPrice,
      });
    } catch (e) {
      throw Exception('Failed to update total price: $e');
    }
  }
}
