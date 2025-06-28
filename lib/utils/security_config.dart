class SecurityConfig {
  // API endpoints
  static const String firebaseApiUrl = 'https://firebaseapp.com';
  static const String recipeApiUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Timeout configurations
  static const int networkTimeoutSeconds = 30;
  static const int authTimeoutSeconds = 60;

  // Rate limiting
  static const int maxLoginAttempts = 5;
  static const int maxApiRequestsPerMinute = 60;

  // Input validation limits
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;
  static const int maxPasswordLength = 128;
  static const int maxSearchQueryLength = 100;

  // File upload limits
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];

  // Security headers
  static const Map<String, String> securityHeaders = {
    'X-Content-Type-Options': 'nosniff',
    'X-Frame-Options': 'DENY',
    'X-XSS-Protection': '1; mode=block',
  };

  // Allowed domains for external requests
  static const List<String> allowedDomains = [
    'firebaseapp.com',
    'googleapis.com',
    'gstatic.com',
    'themealdb.com',
  ];

  // Sensitive data fields that should be masked in logs
  static const List<String> sensitiveFields = [
    'password',
    'token',
    'apiKey',
    'secret',
    'privateKey',
  ];
}
