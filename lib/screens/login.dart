import 'package:flutter/material.dart';
import 'package:signup/animation/animated_content.dart';
import 'package:signup/common/widgets/auth_prompt_row.dart';
import 'package:signup/common/widgets/auth_text_field.dart';
import 'package:signup/common/widgets/common_button.dart';
import 'package:signup/screens/home/profile_screen.dart';
import 'package:signup/screens/sign_up_screen.dart';
import 'package:signup/theme/theme.dart';
import 'package:signup/util/navigation.dart';
import 'package:signup/util/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: Image.asset(
                  "assets/images/login.png",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Log In',
                      style: AppTheme.headingStyle,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    AnimatedContent(
                      show: true,
                      leftToRight: 0.0,
                      topToBottom: 1.0,
                      time: 1000,
                      child: AuthTextField(
                        controller: _emailController,
                        label: 'Email',
                        validator: Validators.email,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AnimatedContent(
                      show: true,
                      leftToRight: 0.0,
                      topToBottom: 3.0,
                      time: 1400,
                      child: AuthTextField(
                        controller: _passController,
                        label: 'Password',
                        validator: Validators.password,
                        obscureText: !_showPassword,
                        onToggleObscure: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    AnimatedContent(
                      show: true,
                      leftToRight: 0.0,
                      topToBottom: 5.0,
                      time: 1500,
                      child: CommonButton(
                        height: 50,
                        width: double.infinity,
                        label: 'Log In',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            pushScreen(
                              context,
                              ProfileScreen(email: _emailController.text),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AuthPromptRow(
                      question: 'Don’t have an account?',
                      actionLabel: 'Sign Up',
                      onActionTap: () =>
                          pushScreen(context, const SingUpScreen()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
