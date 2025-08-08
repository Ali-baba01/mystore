import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../utils/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = 'https://dummyjson.com';

  // Get all products
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['products'];
        return products.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading products: $e');
      // Return mock data for demo purposes
      return _getMockProducts();
    }
  }

  // Get products by category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$category'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['products'];
        return products.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products by category: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading products by category: $e');
      // Return mock data for demo purposes
      return _getMockProducts().where((product) => product.category == category).toList();
    }
  }

  // Get product by ID
  Future<ProductModel?> getProductById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ProductModel.fromJson(data);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading product by ID: $e');
      // Return mock data for demo purposes
      return _getMockProducts().firstWhere((product) => product.id == id);
    }
  }

  // Get categories from DummyJSON API
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      print('Making API call to: $baseUrl/products/categories');
      final response = await http.get(
        Uri.parse('$baseUrl/products/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Parsed data: $data');
        
        // The API already returns objects with slug, name, url properties
        final result = data.map((category) => {
          'slug': category['slug'] ?? '',
          'name': category['name'] ?? '',
          'url': category['url'] ?? '',
        }).toList();
        
        print('Final result: $result');
        return result;
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading categories: $e');
      // Return mock categories for demo purposes
      return _getMockCategories();
    }
  }

  // Get products for a specific category (using slug)
  Future<List<ProductModel>> getProductsForCategory(String categorySlug) async {
    try {
      print('=== API Service Debug ===');
      print('Making API call for category: $categorySlug');
      print('URL: $baseUrl/products/category/$categorySlug');
      
      final response = await http.get(
        Uri.parse('$baseUrl/products/category/$categorySlug'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> products = data['products'];
        print('Found ${products.length} products in API response');
        
        final result = products.map((json) => ProductModel.fromJson(json)).toList();
        print('Successfully parsed ${result.length} products');
        return result;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load products for category: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading products for category: $e');
      // Return mock data for demo purposes
      final mockProducts = _getMockProducts().where((product) => 
        product.category.toLowerCase() == categorySlug.toLowerCase()
      ).toList();
      print('Returning ${mockProducts.length} mock products for category: $categorySlug');
      return mockProducts;
    }
  }

  // Mock categories for demo purposes
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

  // Mock data for demo purposes
  List<ProductModel> _getMockProducts() {
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
  }
} 