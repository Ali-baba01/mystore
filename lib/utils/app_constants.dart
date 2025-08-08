class AppConstants {
  // Routes
  static const String splashRoute = '/splash';
  static const String homeRoute = '/home';
  static const String categoriesRoute = '/categories';
  static const String productsRoute = '/products';
  static const String productDetailsRoute = '/product-details';
  static const String cartRoute = '/cart';
  static const String favoritesRoute = '/favorites';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';

  // Categories
  static const List<String> categories = [
    'All',
    'Electronics',
    'Clothing',
    'Sports',
    'Home',
    'Books',
    'Beauty',
    'Toys',
  ];

  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.example.com';
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/categories';
  static const String cartEndpoint = '/cart';
  static const String favoritesEndpoint = '/favorites';

  // App Info
  static const String appName = 'MyStore';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Modern E-commerce App';

  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 500);

  // Sizes
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double cardElevation = 2.0;
} 