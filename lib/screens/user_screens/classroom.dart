import 'package:flutter/material.dart';

import 'package:mathgame/services/classroom_service.dart'; // Service for API calls
import 'package:mathgame/screens/models/classroom_models.dart';

class ClassroomScreen extends StatefulWidget {
  final String username;

  const ClassroomScreen({super.key, required this.username});

  @override
  _ClassroomScreenState createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  final ClassroomService _classroomService = ClassroomService();
  List<Classroom> _enrolledClasses = [];  // Store the classrooms the user is enrolled in

  @override
  void initState() {
    super.initState();
    _loadUserClassrooms();
  }

  // Fetch classrooms the user is enrolled in
  Future<void> _loadUserClassrooms() async {
    final classrooms = await _classroomService.getClassroomsByUser(widget.username);
    setState(() {
      _enrolledClasses = classrooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _enrolledClasses.isEmpty
          ? Center(child: Text("Không tìm thấy lớp học."))
          : ListView.builder(
        itemCount: _enrolledClasses.length,
        itemBuilder: (context, index) {
          final classroom = _enrolledClasses[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            height: 150,  // Adjust height as needed
            child: Card(
              color: Colors.deepPurpleAccent[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),  // Rounded corners
              ),
              elevation: 4,  // Shadow for the card
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      classroom.className ?? 'N/A',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),  // Space between elements
                    Text(
                      classroom.hostUsername ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showClassIdDialog,
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> enrollClassroom(String classId) async {
    try {
      // Fetch classroom details by ID
      final classroom = await _classroomService.getClassroomById(classId);
      if (classroom == null) {
        // Classroom not found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy mã lớp học')),
        );
        return;
      }

      // Enroll user in the classroom
      bool isEnrolled = await _classroomService.enrollInClassroom(classId, widget.username); // Replace 'user123' with dynamic user ID
      if (isEnrolled) {
        // Enrollment successful
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tham gia lớp học thành công')),
        );
      } else {
        // Enrollment failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi tham gia lớp học')),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xảy ra lỗi, vui lòng thử lại')),
      );
      print('Exception during enrollment: $e');
    }
  }

  void showClassIdDialog() {
    final TextEditingController classIdController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tham gia lớp học'),
          content: TextField(
            controller: classIdController,
            maxLength: 7, // Limit input length to 7 characters
            decoration: const InputDecoration(
              hintText: 'Nhập mã lớp học',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String classId = classIdController.text.trim();
                if (classId.isEmpty) {
                  // Show message if the classId is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập mã lớp học')),
                  );
                } else if (classId.length != 7) {
                  // Show message if the classId is not valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mã lớp không hợp lệ')),
                  );
                } else {
                  // Enroll the user in the classroom
                  await enrollClassroom(classId);
                  Navigator.pop(context); // Close the dialog after enrolling
                }
              },
              child: const Text('Tham gia'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

}

// void main() async {
//   await dotenv.load(); // Load .env file for base URL
//   runApp(MaterialApp(
//     home: ClassroomScreen(),
//     theme: ThemeData(primarySwatch: Colors.deepPurple),
//   ));
// }
