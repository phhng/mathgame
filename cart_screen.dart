import 'package:flutter/material.dart';
import 'package:nhom4/models/productPost.dart';

class CartScreen extends StatefulWidget {
  final List<productPost> cart;
  final int userPoints;
  final Function(int) updateUserPoints;

  const CartScreen({
    super.key,
    required this.cart,
    required this.userPoints,
    required this.updateUserPoints,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Tính tổng giá trị giỏ hàng
  int getCartTotal() {
    int total = 0;
    for (var product in widget.cart) {
      total += product.price ?? 0;
    }
    return total;
  }

  // Hiển thị hộp thoại nhận thông tin giao hàng
  void showShippingInfoDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thông tin nhận hàng'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Họ và Tên',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Số Điện Thoại',
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa Chỉ',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // Kiểm tra ràng buộc thông tin
                if (nameController.text.isEmpty ||
                    phoneController.text.isEmpty ||
                    addressController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Vui lòng nhập đủ thông tin.')),
                  );
                } else if (!RegExp(r'^\d{10}$')
                    .hasMatch(phoneController.text)) {
                  // Ràng buộc số điện thoại 10 chữ số
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Số điện thoại phải gồm 10 số.')),
                  );
                } else {
                  // Thanh toán nếu đủ thông tin
                  checkout(
                    nameController.text,
                    phoneController.text,
                    addressController.text,
                  );
                  Navigator.of(context).pop(); // Đóng hộp thoại
                }
              },
              child: const Text('Xác Nhận'),
            ),
          ],
        );
      },
    );
  }

  // Thanh toán bằng điểm tích lũy
  void checkout(String name, String phone, String address) {
    int total = getCartTotal();
    if (total > widget.userPoints) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn không đủ điểm để đổi quà.')),
      );
    } else {
      setState(() {
        // Giảm điểm của người dùng
        widget.updateUserPoints(widget.userPoints - total);
        widget.cart.clear(); // Xóa giỏ hàng sau khi thanh toán
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đổi quà thành công!\nNgười nhận: $name\nSĐT: $phone\nĐịa chỉ: $address',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: widget.cart.isEmpty
          ? const Center(child: Text('Giỏ hàng của bạn trống!'))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Hiển thị danh sách sản phẩm trong giỏ hàng
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.cart.length,
                      itemBuilder: (context, index) {
                        final product = widget.cart[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 5,
                          child: ListTile(
                            leading: product.image != null
                                ? Image.network(product.image!,
                                    width: 50, height: 50, fit: BoxFit.cover)
                                : const Icon(Icons.image, size: 50),
                            title: Text(product.name ?? 'Không tên'),
                            subtitle: Text('Giá: ${product.price} VND'),
                          ),
                        );
                      },
                    ),
                  ),
                  // Hiển thị tổng cộng và điểm người dùng
                  Text('Tổng cộng: ${getCartTotal()} VND'),
                  Text('Điểm hiện có: ${widget.userPoints}'),
                  const SizedBox(height: 10),
                  // Nút "Đổi điểm lấy quà"
                  ElevatedButton(
                    onPressed: showShippingInfoDialog,
                    child: const Text('Đổi điểm lấy quà'),
                  ),
                ],
              ),
            ),
    );
  }
}
