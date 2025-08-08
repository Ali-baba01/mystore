# MyStore - Modern E-commerce Flutter App

A modern, clean, and feature-rich e-commerce mobile application built with Flutter and GetX for state management.

## 🚀 Features

- **Splash Screen**: Beautiful animated splash screen with app branding
- **Home Screen**: Featured products, categories, and product grid
- **Categories**: Browse products by category
- **Product Details**: Detailed product information with images
- **Shopping Cart**: Add/remove items, quantity management
- **Favorites**: Save and manage favorite products
- **User Profile**: User information and settings
- **Modern UI**: Clean, responsive design following Material Design 3
- **State Management**: GetX for efficient state management
- **Navigation**: Smooth navigation with GetX routing

## 📱 Screens

1. **Splash Screen** - App introduction with animations
2. **Home Screen** - Main dashboard with featured products
3. **Categories Screen** - Browse products by category
4. **Cart Screen** - Shopping cart management
5. **Favorites Screen** - Saved products
6. **Profile Screen** - User profile and settings

## 🛠 Tech Stack

- **Framework**: Flutter
- **State Management**: GetX
- **Navigation**: GetX Routing
- **Image Loading**: Cached Network Image
- **HTTP Client**: HTTP package
- **Local Storage**: Shared Preferences
- **UI Components**: Material Design 3

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  shared_preferences: ^2.2.2
  http: ^1.1.0
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.9
  intl: ^0.19.0
```

## 🏗 Project Structure

```
lib/
├── controllers/          # GetX Controllers
│   ├── product_controller.dart
│   └── cart_controller.dart
├── models/              # Data Models
│   ├── product_model.dart
│   └── cart_item_model.dart
├── screens/             # UI Screens
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── categories_screen.dart
│   ├── cart_screen.dart
│   ├── favorites_screen.dart
│   └── profile_screen.dart
├── widgets/             # Reusable Widgets
│   ├── product_card.dart
│   └── category_card.dart
├── utils/               # Utilities
│   ├── app_theme.dart
│   └── app_constants.dart
└── main.dart           # App Entry Point
```

## 🎨 Design Features

- **Modern UI**: Clean and intuitive interface
- **Responsive Design**: Works on different screen sizes
- **Smooth Animations**: Engaging user experience
- **Color Scheme**: Professional blue theme
- **Typography**: Consistent text styling
- **Icons**: Material Design icons throughout

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mystore
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📋 API Integration

The app is designed to work with REST APIs. Update the API endpoints in `app_constants.dart`:

```dart
static const String baseUrl = 'https://your-api-url.com';
static const String productsEndpoint = '/products';
static const String categoriesEndpoint = '/categories';
```

## 🔧 Configuration

### Theme Configuration
Edit `lib/utils/app_theme.dart` to customize colors, typography, and other theme properties.

### Constants
Update `lib/utils/app_constants.dart` to modify app-wide constants, routes, and API endpoints.

## 📱 Screenshots

[Add screenshots here]

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX team for the excellent state management solution
- Unsplash for the sample product images

## 📞 Support

For support and questions, please open an issue in the repository.

---

**Built with ❤️ using Flutter and GetX**
