import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBarExample extends StatefulWidget {
  @override
  _RatingBarExampleState createState() => _RatingBarExampleState();
}

class _RatingBarExampleState extends State<RatingBarExample> {
  double _rating = 3.0;

  void _submitRating() {
    // Hiển thị hộp thoại thông báo cảm ơn
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cảm ơn!'),
          content: const Text('Cảm ơn bạn đã phản hồi!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đánh giá sự trải nghiệm của bạn'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Đánh giá',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, index) {
                // Sử dụng các biểu tượng mặt cười
                switch (index) {
                  case 0:
                    return const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.orange,
                    );
                  case 2:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.yellow,
                    );
                  case 3:
                    return const Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return const Icon(Icons.sentiment_neutral);
                }
              },
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Rating: $_rating',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitRating,
              child: const Text('Gửi phản hồi'),
            ),
          ],
        ),
      ),
    );
  }
}
