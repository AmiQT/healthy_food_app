import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/security_config.dart';

class ExternalRecipeService {
  static Future<Map<String, dynamic>?> fetchRandomMeal() async {
    try {
      final url = Uri.parse('${SecurityConfig.recipeApiUrl}/random.php');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          ...SecurityConfig.securityHeaders,
        },
      ).timeout(
        Duration(seconds: SecurityConfig.networkTimeoutSeconds),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          return data['meals'][0];
        }
      } else {
        throw Exception('Failed to fetch meal: HTTP ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: Unable to connect to recipe service');
      } else if (e is FormatException) {
        throw Exception('Invalid response format from recipe service');
      } else {
        throw Exception('Error fetching random meal: $e');
      }
    }
    return null;
  }
  
  static Future<List<Map<String, dynamic>>> searchMeals(String query) async {
    try {
      // Validate and sanitize search query
      if (query.isEmpty || query.length > SecurityConfig.maxSearchQueryLength) {
        throw Exception('Invalid search query');
      }
      
      final sanitizedQuery = query.trim().replaceAll(RegExp(r'[<>"\']'), '');
      final url = Uri.parse('${SecurityConfig.recipeApiUrl}/search.php?s=$sanitizedQuery');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          ...SecurityConfig.securityHeaders,
        },
      ).timeout(
        Duration(seconds: SecurityConfig.networkTimeoutSeconds),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['meals'] != null) {
          return List<Map<String, dynamic>>.from(data['meals']);
        }
        return [];
      } else {
        throw Exception('Failed to search meals: HTTP ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: Unable to connect to recipe service');
      } else if (e is FormatException) {
        throw Exception('Invalid response format from recipe service');
      } else {
        throw Exception('Error searching meals: $e');
      }
    }
  }
}
