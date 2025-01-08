import 'package:flutter/material.dart';
import '../config/config_url.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _sendOtp(); // Automatically send OTP when the screen loads
  }

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final response = await OTPAuth.sendOtp(phoneNumber: widget.phoneNumber);

    setState(() {
      _isLoading = false;
      _message = response['message'];
    });

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Failed to send OTP'),
          backgroundColor: response['success'] == true
              ? Colors.green
              : Colors.red,
        ),
      );
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final response = await OTPAuth.verifyOtp(
      phoneNumber: widget.phoneNumber,
      otp: _otpController.text,
    );

    setState(() {
      _isLoading = false;
      _message = response['message'] ?? response['error'];
    });

    if (response['message'] != null) {
      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: Colors.green,
        ),
      );

      // Return success to the previous screen
      Navigator.pop(context, true);
    } else if (response['error'] != null) {
      // Error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['error']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display the message in case of error or success
            if (_message != null)
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
            const SizedBox(height: 20),

            // OTP input field
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nhập mã OTP',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),

            // Verify OTP button with loading indicator
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : const Text(
                      'Xác minh OTP',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class OTPAuth {
  // Method to send OTP
  static Future<Map<String, dynamic>> sendOtp(
      {required String phoneNumber}) async {
    try {
      final url =
          '${Config_URL.baseUrl}Otp/send-otp'; // API endpoint to send OTP
      print(url);
      print('phone number: $phoneNumber');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(phoneNumber),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print('Error: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to send OTP. Please try again later.',
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  // Method to verify OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final url =
          '${Config_URL.baseUrl}Otp/verify-otp'; // API endpoint to verify OTP
      print(url);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'otp': otp,
        }),
      );
      print('phone: $phoneNumber, otp: $otp');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'OTP verified successfully',
        };
      } else {
        print('Error: ${response.statusCode}');
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'error': data['error'] ?? 'Invalid OTP or verification failed',
          'details': data['details'] ?? '',
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {
        'success': false,
        'error': 'An error occurred: $e',
        'details': '',
      };
    }
  }
}
