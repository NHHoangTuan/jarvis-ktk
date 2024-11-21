import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jarvis_ktk/data/network/auth_api.dart';
import 'package:jarvis_ktk/utils/colors.dart';

import '../../../services/service_locator.dart';

class SignUpView extends StatefulWidget {
  final VoidCallback onLoginPressed;

  SignUpView(this.onLoginPressed);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // Biến trạng thái để quản lý việc ẩn/hiện mật khẩu

  bool _isLoading = false;
  String? _errorMessage;

  bool _validateInputs() {
    if (_emailController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _errorMessage = "All fields are required");
      return false;
    }
    if (!_emailController.text.contains('@')) {
      setState(() => _errorMessage = "Invalid email format");
      return false;
    }
    // if (_passwordController.text.length < 6) {
    //   setState(() => _errorMessage = "Password must be at least 6 characters");
    //   return false;
    // }
    setState(() => _errorMessage = null);
    return true;
  }

  Future<void> _handleSignUp() async {
    //showToast("chua check validate");

    if (!_validateInputs()) {
      showToast(_errorMessage!);
      return;
    }

    //showToast("da check validate");

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authApi = getIt<AuthApi>();
      final response = await authApi.signUp(
        _usernameController.text,
        _passwordController.text,
        _emailController.text,
      );

      if (response.statusCode == 201) {
        // Chuyển về màn login sau khi đăng ký thành công
        showToast("Registration successful. Please login.");
        widget.onLoginPressed();
      } else {
        // Parse error message từ response data
        final details = response.data['details'] as List;
        if (details.isNotEmpty) {
          final issue = details[0]['issue'] as String;
          setState(() => _errorMessage = issue);
          showToast(_errorMessage!);
        }
      }
    } catch (e) {
      setState(() => _errorMessage = "Registration failed. Please try again.");
      showToast(_errorMessage!);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

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
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Enter your username',
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
              onPressed: _isLoading ? null : _handleSignUp,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Register',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: widget.onLoginPressed, // Nhấn vào để quay lại Login page
            child: RichText(
              text: const TextSpan(
                text: "Already have an account? ",
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
