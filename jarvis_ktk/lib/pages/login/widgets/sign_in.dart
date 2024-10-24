import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/colors.dart';

class SignInView extends StatelessWidget {
  final VoidCallback onSignUpPressed;
  final VoidCallback onForgotPasswordPressed;

  SignInView(this.onSignUpPressed, this.onForgotPasswordPressed);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            child: TextButton(
              onPressed: onForgotPasswordPressed, // Nhấn vào để quên mật khẩu
              child: Text('Forgot password?',
                  style: TextStyle(color: Colors.grey)),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
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
              },
              child: Text('Login',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 16),
          Container(
            child: TextButton(
              onPressed:
                  onSignUpPressed, // Nhấn vào để chuyển sang Sign Up page
              child: RichText(
                text: TextSpan(
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
          ),
          Expanded(
            flex: 0,
            child: FractionallySizedBox(
              widthFactor: 0.75,
              child: Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("or", style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            flex: 0,
            child: FractionallySizedBox(
                widthFactor: 0.75,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent, // Nền trong suốt
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                          color: Colors.black,
                          width: 0.6), // Thêm viền nếu muốn
                    ),
                    elevation: 0, // Bỏ hiệu ứng nổi của nút
                  ),
                  icon: Image.asset('assets/google_logo.png', height: 24),
                  label: Text('Sign in with google'),
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
