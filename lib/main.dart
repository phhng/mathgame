import 'package:flutter/material.dart';
import 'package:mathgame/login_screen.dart';
import 'package:mathgame/screens/user_screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Ensure all async code runs before the app starts
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  String username = prefs.getString('username') ?? ''; // Get the username from SharedPreferences

  await dotenv.load(fileName: ".env");

  runApp(MyApp(isLoggedIn: isLoggedIn, username: username)); // Pass username to MyApp
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String username; // Add a field for username

  const MyApp({Key? key, required this.isLoggedIn, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Facebook-like Interface',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn
          ? MainScreen(username: username) // Pass username to MainScreen
          : LoginScreen(),
    );
  }
}
