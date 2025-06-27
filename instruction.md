AI Agent Development Prompt:
Objective:
Develop a fully functional mobile application, Healthy Meal App, for the Android platform using Flutter and Dart, integrated with Firebase for data storage and authentication. The app aims to assist users in improving their dietary habits by offering personalized meal recommendations, health tracking, meal orders, and premium features like cooking videos and exclusive recipes.

Core Functional Requirements:
Authentication System

Implement a robust user registration and login system.

Store user information (name, email, health goals, age, gender) securely in Firebase Authentication and Firestore.

Allow for session persistence using SharedPreferences for smooth user experience.

Meal Recommendation and Information System

Display personalized meal suggestions based on user health goals (e.g., weight loss, muscle gain).

Show detailed meal information, including nutrition facts, ingredients, and preparation steps.

Implement an option to add meals to favorites and add meals to cart for later purchase.

Premium Subscription Features

Provide exclusive access to premium recipes with detailed step-by-step instructions.

Implement a premium toggle to allow users to access exclusive content (use local flags to simulate access control).

E-Commerce and Ordering System

Enable users to purchase meals via the Shopping Cart system.

Implement a simulated checkout process with order tracking and status updates (e.g., pending, delivered).

Health and Nutrition Tracking

Track user health metrics like BMI, weight, height, and daily calorie intake.

Display a health summary card on the home page showing user's current weight, BMI, and calories consumed.

Search and Discover Meals

Provide meal search functionality based on meal name or ingredients, with options for category filtering (e.g., vegetarian, gluten-free).

Integrate Google Maps API for location-based meal filtering to help users discover meals from nearby locations.

Display meal recommendations in a Discover section for random meal selection.

User Notifications

Set up a notification system to send updates on new meals, motivational messages, and subscription reminders.

Use Firestore to simulate and manage push notifications within the app.

User Profile Management

Allow users to manage their profiles, including editing personal information (name, email, health goals).

Allow users to track their health goals and update them as needed.

Provide theme customization options (Dark/Light mode toggle).

UI/UX Design

Follow a dark mode theme design with modern Material Design 3 components.

Ensure that the UI is responsive, smooth, and optimized for mobile devices only.

Use Poppins font from Google Fonts and maintain consistent spacing and borders.

State Management

Use Provider for state management throughout the app, including handling user authentication, shopping cart, meal favorites, and theme preferences.

Technical Requirements:
Tech Stack

Frontend: Flutter & Dart

Backend: Firebase (Firestore, Authentication, Storage)

Maps Integration: Google Maps API

State Management: Provider

Storage: Firebase Firestore for meal data and user profiles

Media: Firebase Storage for images and videos (or placeholder links for now)

Design Specifications

Primary Color: Mint Green (#A6E3B4)

Primary Background: Deep Green-Black (#101311)

Text Colors: White (#FFFFFF) for headers and light grey (#CFCFCF) for body text.

Font: Poppins, with varying weights for hierarchy.

Iconography: Material Design icons (outlined and filled versions for dynamic state changes).

Performance Considerations

Implement image caching using the CachedNetworkImage package for meal images.

Use lazy loading for lists and optimized widget rebuilds to ensure smooth performance on all devices.

Ensure state optimization to minimize unnecessary widget rebuilds.

Testing & Debugging

Write unit tests for backend services (authentication, meal data) and widget tests for UI components.

Implement integration testing for end-to-end app functionality, including data persistence and API interactions.

Use error handling and user feedback mechanisms (e.g., SnackBars, dialogs) for a better user experience.

Deliverables:
Mobile App (Flutter Codebase):

Complete mobile app with all implemented features as described above.

Firebase integration files and setup (mock data or placeholder integration as needed).

Fully functional Android version (no need for iOS).

Documentation:

Provide detailed project documentation, including architecture design, UI/UX design, and testing strategies.

Ensure that code is well-commented, explaining the purpose and functionality of key components.

Demo:

Working Demo to show the full user journey: register → browse → add to cart → checkout → track order → profile management.

Firebase Setup: Firebase Auth for login, Firestore for user and meal data, and Firebase Storage for media content.

Future Enhancements (Post-Implementation):
Push Notifications: Implement real-time notifications to alert users about new meals, offers, and health tips.

Payment Integration: Add real payment processing once the app is finalized for production.

Google Maps Integration: Implement location-based delivery and meal discovery.

Image Upload: Allow users to upload their profile pictures and meal photos.

Offline Functionality: Implement offline data caching for meal information and user profiles.