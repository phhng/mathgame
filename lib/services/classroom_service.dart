import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mathgame/config/config_url.dart';

import '../screens/models/classroom_models.dart';

class ClassroomService {

  final String baseUrl = Config_URL.baseUrl;

  Future<Map<String, dynamic>?> getClassroomById(String classId) async {
    final url = '${baseUrl}Classroom/$classId';
    print('API URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('Classroom data: $data'); // Access fields directly
        return data; // Returns the raw JSON
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<bool> enrollInClassroom(String classId, String username) async {
    final url = '${baseUrl}Classroom/$classId/enroll';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Error from enroll with username: ${response.statusCode}, ${username}');
        return false;
      }

    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  Future<List<Classroom>> getClassroomsByUser(String username) async {
    final url = '${baseUrl}Classroom/by-user/$username';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body) as List;
        return data.map((classroom) => Classroom.fromJson(classroom)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }
}
