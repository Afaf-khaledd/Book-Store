import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/CartItemModel.dart';
import '../../../data/repoistry/CartRepo.dart';
import '../AuthCubit/auth_cubit.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  CartCubit(this._cartRepository) : super(CartInitial());

  Future<void> fetchCart(String userId) async {
    emit(CartLoading());
    try {
      final items = await _cartRepository.fetchCartItems(userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError('Failed to load cart: $e'));
    }
  }
  Future<bool> isInCart(String? userId, String bookId) async {
    if (userId == null) {
      return false;
    }
    try {
      return await _cartRepository.isBookInCart(userId, bookId);
    } catch (e) {
      debugPrint('Error checking cart status: $e');
      return false;
    }
  }
  Future<void> addToCart(String userId, CartItemModel item) async {
    try {
      await _cartRepository.addToCart(userId, item);
      await fetchCart(userId);
    } catch (e) {
      emit(CartError('Failed to add item to cart: $e'));
    }
  }

  Future<void> updateQuantity(String userId, String bookId, int quantityChange) async {
    try {
      await _cartRepository.updateQuantity(userId, bookId, quantityChange);
      await fetchCart(userId);
    } catch (e) {
      emit(CartError('Failed to update item quantity: $e'));
    }
  }

  Future<void> removeFromCart(String userId, String bookId) async {
    try {
      await _cartRepository.removeFromCart(userId, bookId);
      await fetchCart(userId);
    } catch (e) {
      emit(CartError('Failed to remove item from cart: $e'));
    }
  }
  Future<void> clearCartState() async {
    emit(CartLoaded([]));
  }
}