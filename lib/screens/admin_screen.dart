import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../config/config_url.dart';
import 'login_screen.dart';

class AdminScreen extends StatelessWidget {
  final String username;

  const AdminScreen({super.key, required this.username});

  Future<void> _logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the token from SharedPreferences
    String? token = prefs.getString('jwt_token');

    if (token != null) {
      // Send a logout request to the server
      final response = await http.post(
        Uri.parse("${Config_URL.baseUrl}Authenticate/logout"), // Your API URL for logout
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Send the token in the Authorization header
        },
      );

      if (response.statusCode == 200) {
        // If logout is successful, remove the token and any other user data
        await prefs.remove('jwt_token');
        await prefs.remove('roles');
        await prefs.remove('username');

        // Navigate to the Login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()), // Go to Login Screen
        );
      } else {
        // If logout fails, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // If no token is found, just log out locally
      await prefs.remove('jwt_token');
      await prefs.remove('roles');
      await prefs.remove('username');

      // Navigate to the Login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Go to Login Screen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logOut(context),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Welcome, $username!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
