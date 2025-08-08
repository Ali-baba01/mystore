class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final List<String> images;
  final Map<String, dynamic> specifications;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFavorite = false,
    this.images = const [],
    this.specifications = const {},
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] ?? '').toString(), // Convert to string since DummyJSON returns int
      name: json['title'] ?? '', // DummyJSON uses 'title' instead of 'name'
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      imageUrl: json['thumbnail'] ?? '', // DummyJSON uses 'thumbnail' instead of 'imageUrl'
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['stock'] ?? 0, // DummyJSON uses 'stock' instead of 'reviewCount'
      isFavorite: json['isFavorite'] ?? false,
      images: List<String>.from(json['images'] ?? []),
      specifications: json['specifications'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'isFavorite': isFavorite,
      'images': images,
      'specifications': specifications,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    String? category,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
    List<String>? images,
    Map<String, dynamic>? specifications,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      images: images ?? this.images,
      specifications: specifications ?? this.specifications,
    );
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountPercentage {
    if (!hasDiscount || originalPrice == null) return 0.0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }
} 