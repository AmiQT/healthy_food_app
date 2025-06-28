# 🍎 Healthy Food App

A comprehensive healthy food and meal planning app built with Flutter that helps users discover nutritious recipes, track their meals, and maintain a healthy lifestyle.

## ✨ Features

- 🍎 **Meal Discovery**: Browse and discover healthy recipes
- 📊 **Nutritional Tracking**: Monitor your daily nutrition intake
- ❤️ **Favorites**: Save and organize your favorite recipes
- 🛒 **Shopping Cart**: Plan your grocery shopping with meal ingredients
- 👤 **User Profiles**: Personalized experience with user accounts
- 🌙 **Dark/Light Theme**: Choose your preferred app appearance
- 🔔 **Notifications**: Get reminded about meal times and updates
- 📱 **Offline Access**: Access recipes even without internet
- 🗺️ **Location Services**: Find nearby healthy food options
- 💳 **Payment Integration**: Secure payment processing for premium features

## 📱 Screenshots

[Add screenshots of your app here - take screenshots of the main screens and add them to a `screenshots/` folder]

## 🚀 Installation

### From F-Droid (Recommended)
1. Install F-Droid from [f-droid.org](https://f-droid.org)
2. Search for "Healthy Food App"
3. Install the app
4. Create an account or sign in
5. Start exploring healthy meals!

### Manual Installation
1. Download the APK from the releases page
2. Enable "Install from unknown sources" in your Android settings
3. Install the APK
4. Launch the app and enjoy!

## 🛠️ Development

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Android Studio / VS Code
- Android SDK
- Git

### Setup
```bash
# Clone the repository
git clone https://github.com/AmiQT/healthy_food_app.git

# Navigate to the project directory
cd healthy_food_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Building for Release
```bash
# Build APK for F-Droid
flutter build apk --release

# Build App Bundle for Google Play Store
flutter build appbundle --release
```

## 🏗️ Architecture

This app is built using:
- **Flutter**: Cross-platform UI framework
- **Provider**: State management
- **Firebase**: Backend services (Auth, Firestore, Storage)
- **Material Design 3**: Modern UI components

### Project Structure
```
lib/
├── models/          # Data models
├── providers/       # State management
├── screens/         # UI screens
├── services/        # External services
├── utils/           # Utilities and constants
└── widgets/         # Reusable UI components
```

## 🔧 Configuration

### Firebase Setup
1. Create a Firebase project
2. Add your Android app to Firebase
3. Download `google-services.json` and place it in `android/app/`
4. Configure Firebase services in your project

### Environment Variables
Create a `.env` file for sensitive configuration:
```
FIREBASE_API_KEY=your_api_key
RECIPE_API_KEY=your_recipe_api_key
```

## 🤝 Contributing

We welcome contributions! Please feel free to submit a Pull Request.

### How to Contribute
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Write tests for new features

## 🐛 Bug Reports

If you find a bug, please create an issue on GitHub with:
- A clear description of the problem
- Steps to reproduce the issue
- Expected vs actual behavior
- Device and OS information
- Screenshots (if applicable)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- The open-source community for various packages
- All contributors and users of this app

## 📞 Support

- **GitHub Issues**: [Report bugs or request features](https://github.com/yourusername/healthy_food_app/issues)
- **Email**: [your-email@domain.com]
- **Website**: [your-website.com]

## 🔄 Changelog

### Version 1.0.0
- Initial release
- Basic meal discovery and management
- User authentication
- Shopping cart functionality
- Dark/light theme support

---

**Made with ❤️ for healthy living**