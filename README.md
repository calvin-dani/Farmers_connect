# Farmers Connect 🌾

A comprehensive Flutter mobile application designed to connect farmers with modern agricultural tools and services. The app provides plant disease detection, weather information, marketplace functionality, and agricultural news to help farmers make informed decisions.

## 🚀 Features

### 🔐 Authentication System
- **Firebase Authentication** with email/password and Google Sign-in
- Secure user session management
- User profile management and sign-out functionality
- Cross-platform authentication support (Android & iOS)

### 🌱 Plant Disease Detection
- **TensorFlow Lite** integration for on-device ML inference
- Real-time plant disease detection using camera or gallery images
- Support for multiple plant diseases with confidence scoring
- Optimized for mobile performance with GPU acceleration

### 🌤️ Weather Service
- Location-based weather information using GPS
- Real-time weather data from OpenWeatherMap API
- Temperature, humidity, wind speed, and cloud coverage
- Location permission handling and error management

### 🛒 Marketplace
- Product listing and management system
- Product details and image display
- Create and manage agricultural products
- User-friendly marketplace interface

### 📰 News Bulletin
- Agricultural news and updates
- Mock API service for development
- News item display with images and headlines
- Real-time news fetching capability

### 🎨 User Interface
- Modern Material Design with green agricultural theme
- Responsive layout for different screen sizes
- Intuitive navigation with drawer menu
- Splash screen with app branding

## 🏗️ Project Architecture

### Directory Structure
```
lib/
├── auth.dart                    # Firebase authentication service
├── firebase_options.dart        # Firebase configuration
├── main.dart                    # App entry point
├── widget_tree.dart            # Main navigation logic
├── interface/
│   └── product.dart            # Product data model
├── screens/
│   ├── dashboard_page.dart     # Main dashboard
│   ├── home_page.dart          # User home screen
│   ├── login_register_page.dart # Authentication UI
│   ├── loginScreen.dart        # Login form
│   ├── signUpScreen.dart       # Registration form
│   ├── splash.dart             # Splash screen
│   ├── marketplace_page.dart   # Marketplace listing
│   ├── marketplace_details_page.dart # Product details
│   ├── marketplace_create_product.dart # Product creation
│   ├── plant_disease_detection_page.dart # ML detection UI
│   ├── weather_page.dart       # Weather information
│   ├── news_bulletin_page.dart # News display
│   └── miscellaneous_page.dart # Additional features
├── services/
│   ├── api_service.dart        # External API integration
│   └── mock_api_service.dart   # Mock data for development
└── widgets/
    ├── base_layout.dart        # Common layout components
    └── inputTextWidget.dart    # Reusable input components
```

### Technology Stack

#### Frontend
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Material Design** - UI/UX framework

#### Backend & Services
- **Firebase Authentication** - User management
- **Firebase Firestore** - Database (configured)
- **Firebase Storage** - File storage (configured)
- **OpenWeatherMap API** - Weather data
- **Google Sign-In** - Social authentication

#### Machine Learning
- **TensorFlow Lite** - On-device ML inference
- **Custom CNN Model** - Plant disease classification
- **Image Processing** - Camera and gallery integration

#### Development Tools
- **HTTP** - API communication
- **Image Picker** - Camera and gallery access
- **Geolocator** - Location services
- **Path Provider** - File system access
- **UUID** - Unique identifier generation

## 🛠️ Setup & Installation

### Prerequisites
- Flutter SDK (>=2.12.0)
- Dart SDK
- Android Studio / Xcode
- Firebase project setup

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/calvin-dani/Farmers_connect.git
   cd Farmers_connect
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project
   - Add Android app with package name: `com.example.logintunisia`
   - Add iOS app with bundle ID: `com.example.logintunisia`
   - Download and place configuration files:
     - `android/app/google-services.json`
     - `ios/Runner/GoogleService-Info.plist`

4. **API Configuration**
   - Get OpenWeatherMap API key
   - Update API key in `lib/services/api_service.dart`

5. **Run the application**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK version: 21
- Target SDK version: 33
- Permissions: Camera, Location, Internet

#### iOS
- Minimum iOS version: 11.0
- Required permissions: Camera, Location, Photo Library

## 📱 Usage

### Getting Started
1. Launch the app and wait for the splash screen
2. Sign up or log in using email/password or Google Sign-in
3. Access the main dashboard with feature cards

### Plant Disease Detection
1. Navigate to "Plant Disease Detection" from the dashboard
2. Take a photo or select from gallery
3. Wait for ML model analysis
4. View disease prediction with confidence score

### Weather Information
1. Access "Weather" from the dashboard
2. Allow location permissions
3. View current weather conditions
4. Check detailed weather metrics

### Marketplace
1. Go to "Marketplace" section
2. Browse available products
3. View product details
4. Create new product listings (if authenticated)

## 🔧 Development

### Code Organization
- **Screens**: UI components and page logic
- **Services**: API integration and business logic
- **Widgets**: Reusable UI components
- **Models**: Data structures and interfaces

### Key Design Patterns
- **State Management**: StatefulWidget for local state
- **Service Layer**: Centralized API communication
- **Repository Pattern**: Data access abstraction
- **Factory Pattern**: Object creation for models

### Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 🚀 Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build iOS app
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Commit Convention
We follow conventional commits:
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Test additions/changes
- `chore:` - Build process or auxiliary tool changes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Calvin Dani** - Project Lead & Developer

## 🙏 Acknowledgments

- TensorFlow Lite team for ML framework
- Firebase team for backend services
- OpenWeatherMap for weather data
- Flutter team for the amazing framework

## 📞 Support

For support, email support@farmersconnect.com or create an issue in the repository.

---

**Farmers Connect** - Empowering farmers with technology 🌾
