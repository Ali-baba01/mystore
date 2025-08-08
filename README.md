# MyStore - Flutter E-Commerce App

A complete Flutter e-commerce application with modern UI design and full functionality.

Features

Core Features
- **Product Catalog**: Browse all products with search functionality
- **Category Management**: View products by categories
- **Favorites System**: Add/remove products to favorites
- **Product Details**: Detailed product information with ratings
- **User Profile**: Account management screen
- **Search Functionality**: Search across all products and categories

 UI/UX Features
- **Modern Design**: Clean and professional interface
- **Responsive Layout**: Optimized for different screen sizes
- **Smooth Animations**: Engaging user experience
- **Dark Theme**: Elegant dark color scheme
- **Pixel Perfect**: Exact design implementation

### 🔧 Technical Features
- **GetX State Management**: Efficient state management
- **API Integration**: DummyJSON API for products and categories
- **Cached Images**: Fast image loading with caching
- **Navigation**: Smooth screen transitions
- **Error Handling**: Robust error management

 Screens

1. **Splash Screen**: Beautiful welcome screen with animations
2. **Home Screen**: Product listing with search and filtering
3. **Categories Screen**: Browse products by category
4. **Product Details**: Detailed product view with ratings
5. **Favorites Screen**: Saved products management
6. **Profile Screen**: User account and settings

##  Tech Stack

- **Framework**: Flutter
- **State Management**: GetX
- **API**: DummyJSON
- **Image Caching**: cached_network_image
- **UI Components**: Material Design
- **Fonts**: Google Fonts (Poppins, Playfair Display)

##  Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  http: ^1.1.0
  cached_network_image: ^3.3.0
  google_fonts: ^6.1.0
```

##  Getting Started


1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/mystore.git
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

## 📱 App Structure

```
lib/
├── controllers/          # GetX controllers
├── models/              # Data models
├── providers/           # State providers
├── screens/             # UI screens
├── services/            # API services
├── utils/               # Utilities and constants
├── widgets/             # Reusable widgets
└── main.dart           # App entry point
```

##  Key Features Implementation

### State Management
- Uses GetX for efficient state management
- Reactive programming with RxList and RxBool
- Automatic UI updates on state changes

### API Integration
- Fetches products from DummyJSON API
- Category-based product filtering
- Real-time search functionality

### UI Components
- Custom product cards with ratings
- Category grid layout
- Responsive search bars
- Professional navigation

## 🔧 Configuration

### API Configuration
The app uses DummyJSON API endpoints:
- Products: `https://dummyjson.com/products`
- Categories: `https://dummyjson.com/products/categories`

### Theme Configuration
- Primary Color: `#0C0C0C`
- Text Colors: Black and White
- Fonts: Poppins and Playfair Display
![1](https://github.com/user-attachments/assets/ca838e3a-7f7b-4d25-8203-06260155d464)







 **Star this repository if you found it helpful!**
