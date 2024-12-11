import 'package:flutter/material.dart';
import 'navi_bar/app_bar.dart';
import 'navi_bar/search_bar.dart';
import 'screens/login_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/listview_screen.dart';
import 'screens/profile_screen.dart';
import 'navi_bar/dropdown.dart'; //3 examples
import 'navi_bar/navi_rail.dart';
import 'navi_bar/custom_tab_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CustomTabBarsPage(),
    );
  }
}
