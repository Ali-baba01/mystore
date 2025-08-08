import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(Product product, {int quantity = 1, String? size, String? color}) {
    final existingIndex = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      _items.add(CartItem(
        product: product,
        quantity: quantity,
        selectedSize: size,
        selectedColor: color,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productId, {String? size, String? color}) {
    _items.removeWhere((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity, {String? size, String? color}) {
    final index = _items.indexWhere((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId, {String? size, String? color}) {
    return _items.any((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);
  }

  int getQuantity(String productId, {String? size, String? color}) {
    final item = _items.firstWhere(
      (item) =>
          item.product.id == productId &&
          item.selectedSize == size &&
          item.selectedColor == color,
      orElse: () => CartItem(product: Product(id: '', name: '', description: '', price: 0, imageUrl: '', category: ''), quantity: 0),
    );
    return item.quantity;
  }
} 