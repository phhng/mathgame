import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/config_url.dart';
import '../screens/models/classroom_models.dart';

class QuizzService {
  final String baseUrl = Config_URL.baseUrl;

  Future<List<Quiz>> getQuizzes(String classId) async {
    final url = '${baseUrl}classrooms/$classId/quizzes';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((quiz) => Quiz.fromJson(quiz)).toList();
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
