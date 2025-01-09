import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config_url.dart';
import '../screens/models/classroom_models.dart';

class AssignmentService {
  final String baseUrl = Config_URL.baseUrl;

  Future<List<Assignment>> getAssignments(String classId) async {
    final url = '${baseUrl}Assignment/$classId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data =
            json.decode(response.body); // Explicitly type the decoded JSON
        return data
            .map((assignment) => Assignment.fromJson(assignment))
            .toList();
      } else {
        print('Error: Received ${response.statusCode} from API.');
        return [];
      }
    } on http.ClientException catch (e) {
      // Network-related issues
      print('ClientException: Failed to fetch assignments - $e');
      return [];
    } catch (e) {
      // Catch-all for other exceptions
      print('Exception: An unexpected error occurred - $e');
      return [];
    }
  }

  Future<Assignment?> getAssignmentById(int id) async {
    final url = '${baseUrl}Assignment/$id';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Assignment.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // Update assignment
  Future<bool> updateAssignment(int id, Assignment assignment) async {
    final url = '${baseUrl}Assignment/$id';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(assignment.toJson()),
      );

      if (response.statusCode == 204) {
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

  // Create new assignment
  Future<Assignment?> createAssignment(Assignment assignment) async {
    final url = '${baseUrl}Assignment';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(assignment.toJson()),
      );

      if (response.statusCode == 201) {
        return Assignment.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  // Delete assignment
  Future<bool> deleteAssignment(int id) async {
    final url = '${baseUrl}Assignment/$id';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 204) {
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
