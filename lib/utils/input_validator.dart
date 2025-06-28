import 'dart:convert';

class InputValidator {
  // Email validation
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Password validation
  static bool isValidPassword(String password) {
    if (password.length < 6) return false;
    // Check for at least one letter and one number
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    return hasLetter && hasNumber;
  }

  // Name validation
  static bool isValidName(String name) {
    if (name.isEmpty || name.length < 2) return false;
    // Only allow letters, spaces, hyphens, and apostrophes
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    return nameRegex.hasMatch(name);
  }

  // Age validation
  static bool isValidAge(int age) {
    return age > 0 && age <= 120;
  }

  // Weight validation
  static bool isValidWeight(double weight) {
    return weight > 0 && weight <= 500; // kg
  }

  // Height validation
  static bool isValidHeight(double height) {
    return height > 0 && height <= 300; // cm
  }

  // Sanitize string input
  static String sanitizeString(String input) {
    if (input.isEmpty) return input;
    // Remove potentially dangerous characters
    return input
        .replaceAll(RegExp(r'[<>"\']'), '')
        .trim();
  }

  // Sanitize email
  static String sanitizeEmail(String email) {
    return email.toLowerCase().trim();
  }

  // Validate and sanitize JSON input
  static Map<String, dynamic>? validateJson(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Validate URL
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Validate search query
  static bool isValidSearchQuery(String query) {
    if (query.isEmpty) return true;
    // Limit length and check for dangerous characters
    if (query.length > 100) return false;
    final dangerousChars = RegExp(r'[<>"\']');
    return !dangerousChars.hasMatch(query);
  }

  // Sanitize search query
  static String sanitizeSearchQuery(String query) {
    return query
        .replaceAll(RegExp(r'[<>"\']'), '')
        .trim();
  }

  // Validate meal data
  static bool isValidMealData(Map<String, dynamic> data) {
    final requiredFields = ['name', 'category', 'ingredients', 'instructions'];
    for (final field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        return false;
      }
    }
    
    // Validate name
    if (data['name'] is! String || data['name'].toString().isEmpty) {
      return false;
    }
    
    // Validate ingredients list
    if (data['ingredients'] is! List) {
      return false;
    }
    
    return true;
  }

  // Validate user data
  static bool isValidUserData(Map<String, dynamic> data) {
    final requiredFields = ['name', 'email', 'healthGoal', 'age', 'gender'];
    for (final field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        return false;
      }
    }
    
    // Validate email
    if (!isValidEmail(data['email'].toString())) {
      return false;
    }
    
    // Validate age
    if (data['age'] is! int || !isValidAge(data['age'])) {
      return false;
    }
    
    return true;
  }
} 