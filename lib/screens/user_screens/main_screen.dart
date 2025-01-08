import 'package:flutter/material.dart';
import 'package:mathgame/screens/user_screens/classroom.dart';
import 'game_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String username; // Add username field

  const MainScreen({super.key, required this.username}); // Accept username as parameter

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      Container(),  // Placeholder for other screens
      ListView(),
      GameScreen(username: widget.username), // Game screen will be displayed when selected
      ClassroomScreen(username: widget.username),  // Pass username to ClassroomScreen
      ProfilePage1(),
    ];

  double _scale = 1.0; // Scale value for the button animation
    return Scaffold(
      appBar: AppBar(
        // title: Text('Main Screen',),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        children: [
          // Regular Bottom Navigation Bar
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                selectedItemColor: Colors.deepPurpleAccent, // Color of the selected label
                unselectedItemColor: Colors.grey, // Color of the unselected labels
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.leaderboard),
                    label: 'Leaderboard',
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox.shrink(), // Empty space for the Play button
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fitness_center),
                    label: 'Exercise',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Account',
                  ),
                ],
              ),
            ),
          ),
          // Custom Play button floating above the BottomNavigationBar
          Positioned(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 2; // Select "Play" when the button is pressed
                  // Animate button scale when pressed
                  _scale = 0.9; // Scale down the button slightly on tap
                });

                // Optionally, reset scale after a short delay
                Future.delayed(Duration(milliseconds: 100), () {
                  setState(() {
                    _scale = 1.0; // Reset the scale back to normal
                  });
                });
              },
              child: AnimatedScale(
                scale: _scale, // Use the scale animation
                duration: Duration(milliseconds: 200), // Animation duration
                curve: Curves.easeInOut, // Smooth easing for the animation
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.videogame_asset_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
