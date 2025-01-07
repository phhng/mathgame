import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config_url.dart';
import '../screens/models/classroom_models.dart';


class AssignmentService {
  final String baseUrl = Config_URL.baseUrl;

  Future<List<Assignment>> getAssignments(String classId) async {
    final url = '${baseUrl}classrooms/$classId/assignments';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((assignment) => Assignment.fromJson(assignment)).toList();
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
