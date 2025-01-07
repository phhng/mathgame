import 'package:flutter/material.dart';

import 'package:mathgame/screens/games/counting_game.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int _selectedBox = -1; // No box is selected initially

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game screen with boxes
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Row 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBox(context, 0, 'Học đếm'),
                      _buildBox(context, 1, 'Box 2'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Row 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBox(context, 2, 'Box 3'),
                      _buildBox(context, 3, 'Box 4'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build a box with animation and interaction
  Widget _buildBox(BuildContext context, int index, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBox = index;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _navigateToScreen(index),
          ),
        );
        Future.delayed(Duration(milliseconds: 150), () {
          setState(() {
            _selectedBox = -1;
          });
        });
      },
      child: AnimatedScale(
        scale: _selectedBox == index ? 0.95 : 1.0,
        duration: Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.all(20),
          height: 150,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.pinkAccent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              if (_selectedBox == index)
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.6),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _navigateToScreen(int boxIndex) {
  switch (boxIndex) {
    case 0:
      return const CountingGame(); // Replace with your actual screen
    case 1:
      // return const Box2Screen(); // Replace with your actual screen
    case 2:
      // return const Box3Screen(); // Replace with your actual screen
    case 3:
      // return const Box4Screen(); // Replace with your actual screen
    default:
      return const Center(child: Text('No screen available'));
  }
}