import 'package:flutter/material.dart';
import 'package:signup/animation/animated_content.dart';
import 'package:signup/common/widgets/auth_prompt_row.dart';
import 'package:signup/common/widgets/auth_text_field.dart';
import 'package:signup/common/widgets/common_button.dart';
import 'package:signup/screens/login.dart';
import 'package:signup/theme/theme.dart';
import 'package:signup/util/navigation.dart';
import 'package:signup/util/validators.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key});
  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Image.asset(
                    "assets/images/search_scan.png",
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sign up',
                      style: AppTheme.headingStyle,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    AnimatedContent(
                      show: true,
                      leftToRight: 0.0,
                      topToBottom: -1.0,
                      time: 1000,
                      child: AuthTextField(
                        controller: _emailController,
                        label: 'Email',
                        validator: Validators.email,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AnimatedContent(
                      show: true,
                      leftToRight: 0.0,
                      topToBottom: -3.0,
                      time: 1000,
                      child: AuthTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText: 'Create Password',
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
                      height: 15,
                    ),
                    AnimatedContent(
                      show: true,
                      leftToRight: 0.0,
                      topToBottom: 3.0,
                      time: 1200,
                      child: AuthTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hintText: 'Confirm Password',
                        validator: (value) => Validators.confirmPassword(
                          value,
                          _passwordController.text,
                        ),
                        obscureText: !_showConfirmPassword,
                        onToggleObscure: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
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
                        label: 'Create account',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            pushScreen(context, const LoginScreen());
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AuthPromptRow(
                      question: ' have an account?',
                      actionLabel: 'Log In ',
                      onActionTap: () =>
                          pushScreen(context, const LoginScreen()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
