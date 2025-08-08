import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  int get itemCount => items.length;

  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(ProductModel product, {int quantity = 1, String? size, String? color}) {
    final existingIndex = items.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (existingIndex >= 0) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + quantity,
      );
    } else {
      items.add(CartItemModel(
        product: product,
        quantity: quantity,
        selectedSize: size,
        selectedColor: color,
      ));
    }
  }

  void removeItem(String productId, {String? size, String? color}) {
    items.removeWhere((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);
  }

  void updateQuantity(String productId, int quantity, {String? size, String? color}) {
    final index = items.indexWhere((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);

    if (index >= 0) {
      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index] = items[index].copyWith(quantity: quantity);
      }
    }
  }

  void clear() {
    items.clear();
  }

  bool isInCart(String productId, {String? size, String? color}) {
    return items.any((item) =>
        item.product.id == productId &&
        item.selectedSize == size &&
        item.selectedColor == color);
  }

  int getQuantity(String productId, {String? size, String? color}) {
    final item = items.firstWhere(
      (item) =>
          item.product.id == productId &&
          item.selectedSize == size &&
          item.selectedColor == color,
      orElse: () => CartItemModel(
        product: ProductModel(
          id: '', 
          name: '', 
          description: '', 
          price: 0, 
          imageUrl: '', 
          category: ''
        ), 
        quantity: 0
      ),
    );
    return item.quantity;
  }
} 