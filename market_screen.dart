import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhom4/models/productPost.dart';
import 'package:shimmer/shimmer.dart';
import '../config/config_url.dart';
import 'cart_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  late Future<List<productPost>> _posts;
  List<productPost> cart = [];
  int userPoints = 1000;

  @override
  void initState() {
    super.initState();
    _posts = fetchPosts();
  }

  Future<List<productPost>> fetchPosts() async {
    final String baseUrl = "${Config_URL.baseUrl}ProDuctApi";
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          return [];
        }
        return data.map((item) => productPost.fromJson(item)).toList();
      } else {
        print('Không thể tải sản phẩm: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Lỗi khi lấy sản phẩm: $e');
      return [];
    }
  }

  void addToCart(productPost product) {
    setState(() {
      if (!cart.contains(product)) {
        cart.add(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} đã được thêm vào giỏ hàng!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} đã có trong giỏ hàng!')),
        );
      }
    });
  }

  Widget shimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi điểm thưởng'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    cart: cart,
                    userPoints: userPoints,
                    updateUserPoints: (newPoints) {
                      setState(() {
                        userPoints = newPoints;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<productPost>>(
        future: _posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7, // Adjust the aspect ratio of each item
              ),
              itemCount: 6, // Placeholder shimmer count
              itemBuilder: (context, index) => shimmerEffect(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Không thể tải sản phẩm. Vui lòng thử lại sau.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Không có sản phẩm.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            List<productPost> posts = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7, // Adjust the aspect ratio of each item
              ),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                productPost post = posts[index];
                return Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: post.image != null
                            ? Image.network(
                                post.image!,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image, size: 50),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.name ?? 'Không có tên',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.description ?? 'Không có mô tả',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${post.price} Điểm',
                              style: const TextStyle(
                                  color: Colors.pinkAccent, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          addToCart(post);
                        },
                        child: const Text(
                          'Thêm vào giỏ hàng',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
