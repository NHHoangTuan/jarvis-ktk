import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/home_page.dart';
import 'package:jarvis_ktk/utils/colors.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';

class SignInView extends StatefulWidget {
  final VoidCallback onSignUpPressed;
  final VoidCallback onForgotPasswordPressed;

  SignInView(this.onSignUpPressed, this.onForgotPasswordPressed);

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // Biến trạng thái để quản lý việc ẩn/hiện mật khẩu

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText =
                        !_obscureText; // Thay đổi trạng thái ẩn/hiện mật khẩu
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed:
                widget.onForgotPasswordPressed, // Nhấn vào để quên mật khẩu
            child: const Text('Forgot password?',
                style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: GradientColors.blueOcean,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: () {
                // Xử lý đăng nhập
                // Điều hướng đến HomePage khi nhấn nút "Login"
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('Login',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed:
                widget.onSignUpPressed, // Nhấn vào để chuyển sang Sign Up page
            child: RichText(
              text: const TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: "Register",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 0,
            child: FractionallySizedBox(
              widthFactor: 0.75,
              child: Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("or", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 0,
            child: FractionallySizedBox(
                widthFactor: 0.75,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                    // Nền trong suốt
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(
                          color: Colors.black,
                          width: 0.6), // Thêm viền nếu muốn
                    ),
                    elevation: 0, // Bỏ hiệu ứng nổi của nút
                  ),
                  icon: const ResizedImage(
                    imagePath: 'assets/google_logo.png',
                    height: 24,
                    width: 24,
                  ),
                  label: const Text('Sign in with google'),
                  onPressed: () {
                    // Xử lý khi nhấn vào nút
                  },
                )),
          ),
        ],
      ),
    );
  }
}
