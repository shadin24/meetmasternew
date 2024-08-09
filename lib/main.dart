import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signup/screens/home/components/create_meeting.dart';
import 'package:signup/screens/home/components/my_meetings.dart';
import 'package:signup/screens/home/components/search.dart';
import 'package:signup/screens/home/profile_screen.dart';
import 'package:signup/screens/login.dart';
import 'package:signup/theme/theme.dart';
import 'dart:async';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meet Master', // Set the app title here
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: AppTheme.primaryColor,
        colorScheme: ColorScheme.light(
          primary: AppTheme.primaryColor,
          secondary: AppTheme.secondaryColor,
        ),
        iconTheme: const IconThemeData(
          color: AppTheme.primaryTextColor,
        ),
      ),
      home: SplashScreen(), // Set the splash screen widget here
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLoginScreen();
  }

  void _navigateToLoginScreen() {
    Timer(
      const Duration(seconds: 2), // Duration of the splash screen
          () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/icon.png', width: 80), // Replace with your own logo image path
            SizedBox(height: 20),
            Text(
              'Meet Master',
              style: TextStyle(
                color: AppTheme.primaryColor, // Replace with your desired text color
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
