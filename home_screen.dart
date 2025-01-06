import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart'; // Import card_swiper package
import 'language_screen.dart';
import 'market_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedLanguage = 'Tiếng Việt'; // Default language

  // Titles for the AppBar
  final List<String> _titles = [
    'Trang Chủ',
    'Thông Tin Cá Nhân',
    'Tin Nhắn',
    'Hẹn Giờ',
    'Phần Thưởng',
    'Xếp Hạng',
  ];

  // Pages for each navigation item
  final List<Widget> _pages = [
    HomeContent(),
    Center(child: Text('Thông Tin Cá Nhân')),
    Center(child: Text('Tin Nhắn')),
    Center(child: Text('Hẹn Giờ')),
    MarketScreen(),
    Center(child: Text('Xếp Hạng')),
  ];

  // Handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Navigate to LanguageScreen and handle the selected language
  void _navigateToLanguageScreen() async {
    String? selectedLanguage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LanguageScreen(currentLanguage: _selectedLanguage),
      ),
    );

    if (selectedLanguage != null) {
      setState(() {
        _selectedLanguage = selectedLanguage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedLanguage == 'Tiếng Việt'
              ? _titles[_selectedIndex]
              : _titles[_selectedIndex]
                  .replaceAll('Trang Chủ', 'Home')
                  .replaceAll('Thông Tin Cá Nhân', 'Profile')
                  .replaceAll('Tin Nhắn', 'Messages')
                  .replaceAll('Hẹn Giờ', 'Timer')
                  .replaceAll('Phần Thưởng', 'Rewards')
                  .replaceAll('Xếp Hạng', 'Ranking'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _navigateToLanguageScreen,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.pinkAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: _selectedLanguage == 'Tiếng Việt' ? 'Trang Chính' : 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: _selectedLanguage == 'Tiếng Việt' ? 'Cá Nhân' : 'Profile',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.message),
              label:
                  _selectedLanguage == 'Tiếng Việt' ? 'Tin Nhắn' : 'Messages',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.timer),
              label: _selectedLanguage == 'Tiếng Việt' ? 'Hẹn Giờ' : 'Timer',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart),
              label:
                  _selectedLanguage == 'Tiếng Việt' ? 'Phần Thưởng' : 'Rewards',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.diamond_outlined),
              label: _selectedLanguage == 'Tiếng Việt' ? 'Xếp Hạng' : 'Ranking',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Tiếp tục học/vv'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          margin: EdgeInsets.symmetric(horizontal: 20),
          color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'Hiển thị điểm/level\nStreaks',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200, // Height of the swiper
          child: Swiper(
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return CarouselItem(label: 'Chế độ ${index + 1}');
            },
            autoplay: true, // Enable auto-play
            viewportFraction: 0.8, // Show part of the next/previous items
            scale: 0.9, // Scale effect for the centered item
          ),
        ),
      ],
    );
  }
}

class CarouselItem extends StatelessWidget {
  final String label;

  const CarouselItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
