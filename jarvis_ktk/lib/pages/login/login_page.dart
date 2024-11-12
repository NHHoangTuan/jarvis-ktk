import 'package:flutter/material.dart';
import 'package:jarvis_ktk/pages/login/widgets/sign_in.dart';
import 'package:jarvis_ktk/pages/login/widgets/sign_up.dart';
import 'package:jarvis_ktk/pages/login/widgets/forgot_password.dart';
import 'package:jarvis_ktk/utils/colors.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';

const double borderRadius = 25.0;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginScreens { signIn, signUp, forgotPassword }

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  LoginScreens currentScreen = LoginScreens.signIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.blue[50],
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResizedImage(imagePath: 'assets/logo.png', height: 100, width: 100),
                  SizedBox(width: 10),
                  Text('Jarvis',
                      style:
                          TextStyle(fontSize: 44, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Column(
                children: <Widget>[
                  if (currentScreen != LoginScreens.forgotPassword) ...[
                    Expanded(
                      flex: 1,
                      child: FractionallySizedBox(
                        widthFactor: 0.75,
                        child: _menuBar(context),
                      ),
                    ),
                  ],
                  Expanded(
                    flex: 9,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: _buildCurrentScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (currentScreen) {
      case LoginScreens.signIn:
        return SignInView(
          _onSignupButtonPress,
          _onForgotPasswordButtonPress,
        );
      case LoginScreens.signUp:
        return SignUpView(_onLoginButtonPress);
      case LoginScreens.forgotPassword:
        return ForgotPasswordView(
          _onLoginButtonPress,
        );
    }
  }

  Widget _menuBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 50.0,
      decoration: const BoxDecoration(
        color: SimpleColors.lightBlue,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: InkWell(
              borderRadius:
                  const BorderRadius.all(Radius.circular(borderRadius)),
              onTap: _onLoginButtonPress,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (currentScreen == LoginScreens.signIn)
                    ? const BoxDecoration(
                        gradient: LinearGradient(
                          colors: GradientColors.blueOcean,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                      )
                    : null,
                child: Text(
                  "Sign in",
                  style: (currentScreen == LoginScreens.signIn)
                      ? const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)
                      : const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius:
                  const BorderRadius.all(Radius.circular(borderRadius)),
              onTap: _onSignupButtonPress,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: (currentScreen == LoginScreens.signUp)
                    ? const BoxDecoration(
                        gradient: LinearGradient(
                          colors: GradientColors.blueOcean,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius)),
                      )
                    : null,
                child: Text(
                  "Sign up",
                  style: (currentScreen == LoginScreens.signUp)
                      ? const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)
                      : const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLoginButtonPress() {
    setState(() {
      currentScreen = LoginScreens.signIn;
    });
  }

  void _onSignupButtonPress() {
    setState(() {
      currentScreen = LoginScreens.signUp;
    });
  }

  void _onForgotPasswordButtonPress() {
    setState(() {
      currentScreen = LoginScreens.forgotPassword;
    });
  }
}
