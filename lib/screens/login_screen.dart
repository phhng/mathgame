import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mathgame/screens/admin_screen.dart';
import 'package:mathgame/screens/user_screens/main_screen.dart';
import 'package:mathgame/screens/registration_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mathgame/utils/auth.dart';
import 'package:mathgame/screens/teacher_screens/teacher_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false; // Biến để lưu trạng thái checkbox
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _checkToken();
    _loadRememberMe(); // Kiểm tra trạng thái "Ghi nhớ đăng nhập"
  }

  Future<void> _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? rememberMe = prefs.getBool('remember_me');
    if (rememberMe != null && rememberMe) {
      String? username = prefs.getString('username');
      String? token = prefs.getString('jwt_token');
      String? role = prefs.getString('roles');
      if (token != null && username != null) {
        // Nếu có token và username thì tự động đăng nhập
        /*if (role == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminScreen(username: username)),
          );
        } else*/ if(role == "Teacher"){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TeacherScreen(username: username)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(username: username)),
          );
        }
      }
    }
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    String? username = prefs.getString('username');
    String? savedRole = prefs.getString('roles');

    if (!mounted) return;

    if (token != null && username != null) {
      /*if (savedRole == "Admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen(username: username)),
        );
      } else */if(savedRole == "Teacher"){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TeacherScreen(username: username)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(username: username)),
        );
      }
    }
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    Map<String, dynamic> result = await Auth.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.containsKey('success') && result['success'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = result['token'] ?? '';

      String role = result['roles'] ?? '';
      await prefs.setString('jwt_token', token);
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('roles', role);
      await prefs.setBool('remember_me', _rememberMe); // Lưu trạng thái ghi nhớ đăng nhập

      if (role == 'Teacher') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TeacherScreen(username: _usernameController.text)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(username: _usernameController.text)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Tên đăng nhập hoặc mật khẩu không đúng'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _handleFacebookLogin() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final String accessToken = result.accessToken!.tokenString;
        Map<String, dynamic> apiResult = await Auth.loginWithFacebook(accessToken);

        if (apiResult.containsKey('success') && apiResult['success'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String token = apiResult['token'] ?? '';
          String role = apiResult['roles'] ?? '';

          await prefs.setString('jwt_token', token);
          await prefs.setString('username', 'Facebook User'); // Cập nhật với tên người dùng từ API nếu cần
          await prefs.setString('roles', role);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen(username: 'Facebook User')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(apiResult['message'] ?? 'Đăng nhập bằng Facebook thất bại')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook login failed: ${result.message}')),
        );
      }
    } catch (e) {
      print('Error during Facebook login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi trong quá trình đăng nhập Facebook')),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('jwt_token', googleAuth.idToken ?? '');
        prefs.setString('username', googleUser.displayName ?? 'Google User');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(username: googleUser.displayName ?? 'Google User')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi đăng nhập bằng Google: $error')),
      );
    }
  }

  Future<void> _handleGuestLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', 'Khách');
    await prefs.setString('roles', 'Guest');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(username: 'Khách')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 40),
                _buildTextField(_usernameController, 'Số điện thoại hoặc email', false),
                const SizedBox(height: 12),
                _buildTextField(_passwordController, 'Mật khẩu', true),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildLoginOption(FontAwesomeIcons.facebook, Colors.blue, _handleFacebookLogin),
                    _buildLoginOption(FontAwesomeIcons.google, Colors.red, _handleGoogleLogin),
                    _buildLoginOption(Icons.person, Colors.grey[700]!, _handleGuestLogin), // Đăng nhập khách
                  ],
                ),
                const SizedBox(height: 20),
                // Thêm checkbox ghi nhớ đăng nhập
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Ghi nhớ đăng nhập'),
                  ],
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Đăng nhập', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Chưa có tài khoản? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                      },
                      child: const Text('Đăng ký ngay', style: TextStyle(color: Colors.deepPurpleAccent)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        )
            : null,
      ),
    );
  }

  Widget _buildLoginOption(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}