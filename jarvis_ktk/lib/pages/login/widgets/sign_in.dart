import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/colors.dart';

import '../../../data/network/auth_api.dart';
import '../../../services/service_locator.dart';

class SignInView extends StatefulWidget {
  final VoidCallback onSignUpPressed;
  final VoidCallback onForgotPasswordPressed;

  const SignInView(this.onSignUpPressed, this.onForgotPasswordPressed, {super.key});

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // Biến trạng thái để quản lý việc ẩn/hiện mật khẩu
  bool _isLoading = false;
  String? _errorMessage;

  // Validate input
  bool _validateInputs() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = "Email and password are required");
      return false;
    }
    if (!_emailController.text.contains('@')) {
      setState(() => _errorMessage = "Invalid email format");
      return false;
    }
    return true;
  }

  // Handle login
  Future<void> _handleSignIn() async {
    if (!_validateInputs()) {
      showSnackbar(_errorMessage!);
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authApi = getIt<AuthApi>();
      final response = await authApi.signIn(
        _emailController.text,
        _passwordController.text,
      );

      if (response.statusCode == 200) {
        // Get user info after login
        await authApi.getUserInfo();

        // Navigate to home page
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        // Parse error message từ response data
        final details = response.data['details'] as List;
        if (details.isNotEmpty) {
          final issue = details[0]['issue'] as String;
          setState(() => _errorMessage = issue);
          showSnackbar(_errorMessage!);
        }
      }
    } catch (e) {
      setState(() => _errorMessage = "Network error occurred");
      showSnackbar(_errorMessage!);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
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
              onPressed: _isLoading ? null : _handleSignIn,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Login',
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
        ],
      ),
    );
  }
}
