import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mathgame/config/config_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // URL for the API login endpoint
  String get apiUrl => "${Config_URL.baseUrl}Authenticate/login";

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool status = data['status'];
        if (!status) {
          return {"success": false, "message": data['message']};
        }

        // Get the token from the response
        String token = data['token'];

        // Decode the JWT token to get user information (e.g., username, role)
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // Extract the role from the decoded token (assuming it's stored as 'roles')
        String role = data['roles'] ?? 'User'; // Role is directly retrieved from the response

        // Save token and role into SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);  // Save token
        await prefs.setString('roles', role);  // Save role

        return {
          "success": true,
          "token": token,
          "decodedToken": decodedToken,
          "roles": role,  // Return role from the response
        };
      } else {
        // If status code is not 200, treat it as a login failure
        return {"success": false, "message": "Failed to login: ${response.statusCode}"};
      }
    } catch (e) {
      // Handle network or parsing errors
      return {"success": false, "message": "Network error: $e"};
    }
  }
}
