import 'dart:convert';

import 'package:mathgame/config/config_url.dart';
import 'package:http/http.dart' as http;

class GameService{
  final String baseUrl = Config_URL.baseUrl;
  Future<bool> updatePoints(String username, int points) async {
    final url = '${baseUrl}Game/update-points'; // Update with your backend endpoint
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userName': username,
          'points': points,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }
}