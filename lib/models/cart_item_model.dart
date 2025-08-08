import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;

  CartItemModel({
    required this.product,
    required this.quantity,
    this.selectedSize,
    this.selectedColor,
  });

  double get totalPrice => product.price * quantity;

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      selectedSize: json['selectedSize'],
      selectedColor: json['selectedColor'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.product.id == product.id &&
        other.selectedSize == selectedSize &&
        other.selectedColor == selectedColor;
  }

  @override
  int get hashCode {
    return product.id.hashCode ^
        selectedSize.hashCode ^
        selectedColor.hashCode;
  }
} 