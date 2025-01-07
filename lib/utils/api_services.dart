import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/config_url.dart';

class ApiService {
  final String baseUrl = Config_URL.baseUrl;

  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> body) async {
    final String url = '$baseUrl$endpoint';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      return response;
    } catch (e) {
      throw Exception("Error during POST request: $e");
    }
  }

  Future<http.Response> getRequest(String endpoint) async {
    final String url = '$baseUrl$endpoint';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      return response;
    } catch (e) {
      throw Exception("Error during GET request: $e");
    }
  }
}
