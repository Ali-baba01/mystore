import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> favorites = <ProductModel>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxBool _isInitialized = false.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    // Auto-load products when controller is initialized
    if (!_isInitialized.value) {
      _isInitialized.value = true;
      loadProducts();
      loadCategories();
    }
  }

  List<ProductModel> get filteredProducts {
    try {
      if (selectedCategory.value == 'All') {
        return products;
      }
      return products.where((product) => product.category == selectedCategory.value).toList();
    } catch (e) {
      print('Error getting filtered products: $e');
      return [];
    }
  }

  void setLoading(bool loading) {
    try {
      isLoading.value = loading;
      update(); // Update UI when loading state changes
    } catch (e) {
      print('Error setting loading state: $e');
    }
  }

  void setSelectedCategory(String category) {
    try {
      if (category.isNotEmpty && category != selectedCategory.value) {
        print('Setting selected category from "${selectedCategory.value}" to "$category"');
        selectedCategory.value = category;
        // Clear products when category changes to ensure fresh data
        products.clear();
      }
    } catch (e) {
      print('Error setting selected category: $e');
    }
  }

  Future<void> loadProducts() async {
    try {
      print('Starting to load products...');
      setLoading(true);
      update(); // Update UI immediately to show loading
      
      // Use API service to load products
      final loadedProducts = await _apiService.getProducts();
      print('Loaded ${loadedProducts.length} products from API');
      
      products.value = loadedProducts;
      setLoading(false);
      update(); // Notify UI to update
      print('Products loaded successfully');
    } catch (e) {
      print('Error loading products: $e');
      // Fallback to mock data if API fails
      print('Using fallback mock products');
      products.value = _getMockProducts();
      setLoading(false);
      update(); // Notify UI to update
      print('Mock products loaded successfully');
    }
  }

  Future<void> loadCategories() async {
    try {
      print('Loading categories from API...');
      final loadedCategories = await _apiService.getCategories();
      print('Categories loaded: ${loadedCategories.length}');
      print('Categories data: $loadedCategories');
      categories.value = loadedCategories;
    } catch (e) {
      print('Error loading categories: $e');
      // Fallback to mock categories
      print('Using fallback mock categories');
      categories.value = _getMockCategories();
    }
  }

  Future<void> loadProductsByCategory(String categorySlug) async {
    try {
      setLoading(true);
      update(); // Update UI to show loading
      
      // Clear existing products first to ensure fresh data
      products.clear();
      print('Cleared existing products, loading for category: $categorySlug');
      
      final loadedProducts = await _apiService.getProductsForCategory(categorySlug);
      print('Loaded ${loadedProducts.length} products for category: $categorySlug');
      
      // Set the products after loading
      products.value = loadedProducts;
      
      setLoading(false);
      update(); // Notify UI to update
    } catch (e) {
      print('Error loading products by category: $e');
      // Fallback to filtered mock data
      final mockProducts = _getMockProducts();
      products.value = mockProducts.where((product) => product.category == categorySlug).toList();
      setLoading(false);
      update(); // Notify UI to update
    }
  }

  void toggleFavorite(String productId) {
    try {
      if (productId.isEmpty) return;
      
      final productIndex = products.indexWhere((product) => product.id == productId);
      if (productIndex != -1) {
        final product = products[productIndex];
        final updatedProduct = product.copyWith(isFavorite: !product.isFavorite);
        products[productIndex] = updatedProduct;
        
        if (updatedProduct.isFavorite) {
          favorites.add(updatedProduct);
        } else {
          favorites.removeWhere((product) => product.id == productId);
        }
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  List<Map<String, dynamic>> _getMockCategories() {
    return [
      {'slug': 'smartphones', 'name': 'Smartphones', 'url': 'https://dummyjson.com/products/category/smartphones'},
      {'slug': 'laptops', 'name': 'Laptops', 'url': 'https://dummyjson.com/products/category/laptops'},
      {'slug': 'fragrances', 'name': 'Fragrances', 'url': 'https://dummyjson.com/products/category/fragrances'},
      {'slug': 'skincare', 'name': 'Skincare', 'url': 'https://dummyjson.com/products/category/skincare'},
      {'slug': 'groceries', 'name': 'Groceries', 'url': 'https://dummyjson.com/products/category/groceries'},
      {'slug': 'home-decoration', 'name': 'Home Decoration', 'url': 'https://dummyjson.com/products/category/home-decoration'},
    ];
  }

  List<ProductModel> _getMockProducts() {
    try {
      return [
        ProductModel(
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
        ProductModel(
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
        ProductModel(
          id: '3',
          name: 'Premium Cotton T-Shirt',
          description: 'Comfortable and stylish cotton t-shirt',
          price: 24.99,
          imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
          category: 'Clothing',
          rating: 4.2,
          reviewCount: 89,
        ),
        ProductModel(
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
        ProductModel(
          id: '5',
          name: 'Coffee Maker Deluxe',
          description: 'Automatic coffee maker with programmable features',
          price: 79.99,
          imageUrl: 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=400',
          category: 'Home',
          rating: 4.3,
          reviewCount: 156,
        ),
        ProductModel(
          id: '6',
          name: 'Yoga Mat Premium',
          description: 'Non-slip yoga mat with carrying strap',
          price: 34.99,
          imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
          category: 'Sports',
          rating: 4.4,
          reviewCount: 78,
        ),
        ProductModel(
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
        ProductModel(
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
    } catch (e) {
      print('Error getting mock products: $e');
      return [];
    }
  }
} 