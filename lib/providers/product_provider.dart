import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _favorites = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get favorites => _favorites;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  List<Product> get filteredProducts {
    if (_selectedCategory == 'All') {
      return _products;
    }
    return _products.where((product) => product.category == _selectedCategory).toList();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void loadProducts() {
    setLoading(true);
    
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      _products = _getMockProducts();
      setLoading(false);
    });
  }

  void toggleFavorite(String productId) {
    final productIndex = _products.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      final product = _products[productIndex];
      final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);
      _products[productIndex] = updatedProduct;
      
      if (updatedProduct.isFavorite) {
        _favorites.add(updatedProduct);
      } else {
        _favorites.removeWhere((product) => product.id == productId);
      }
      
      notifyListeners();
    }
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        name: 'Wireless Bluetooth Headphones',
        description: 'High-quality wireless headphones with noise cancellation',
        price: 89.99,
        originalPrice: 129.99,
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
        category: 'Electronics',
        rating: 4.5,
        reviewCount: 128,
      ),
      Product(
        id: '2',
        name: 'Smart Watch Series 5',
        description: 'Advanced smartwatch with health monitoring features',
        price: 299.99,
        originalPrice: 399.99,
        imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
        category: 'Electronics',
        rating: 4.8,
        reviewCount: 256,
      ),
      Product(
        id: '3',
        name: 'Premium Cotton T-Shirt',
        description: 'Comfortable and stylish cotton t-shirt',
        price: 24.99,
        imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
        category: 'Clothing',
        rating: 4.2,
        reviewCount: 89,
      ),
      Product(
        id: '4',
        name: 'Running Shoes Pro',
        description: 'Professional running shoes with advanced cushioning',
        price: 129.99,
        originalPrice: 159.99,
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
        category: 'Sports',
        rating: 4.6,
        reviewCount: 203,
      ),
      Product(
        id: '5',
        name: 'Coffee Maker Deluxe',
        description: 'Automatic coffee maker with programmable features',
        price: 79.99,
        imageUrl: 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=400',
        category: 'Home',
        rating: 4.3,
        reviewCount: 156,
      ),
      Product(
        id: '6',
        name: 'Yoga Mat Premium',
        description: 'Non-slip yoga mat with carrying strap',
        price: 34.99,
        imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
        category: 'Sports',
        rating: 4.4,
        reviewCount: 78,
      ),
      Product(
        id: '7',
        name: 'Wireless Charger',
        description: 'Fast wireless charging pad for smartphones',
        price: 49.99,
        originalPrice: 69.99,
        imageUrl: 'https://images.unsplash.com/photo-1601972599720-36938d4ecd31?w=400',
        category: 'Electronics',
        rating: 4.1,
        reviewCount: 92,
      ),
      Product(
        id: '8',
        name: 'Denim Jacket Classic',
        description: 'Timeless denim jacket for all occasions',
        price: 89.99,
        imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=400',
        category: 'Clothing',
        rating: 4.7,
        reviewCount: 134,
      ),
    ];
  }
} 