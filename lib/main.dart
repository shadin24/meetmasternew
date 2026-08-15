import 'package:flutter/foundation.dart';
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
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      debugPrint('Uncaught framework error: ${details.exception}\n${details.stack}');
    };

    try {
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );
    } catch (error, stackTrace) {
      // A device refusing the orientation lock must not stop the app.
      debugPrint('Could not lock orientation: $error\n$stackTrace');
    }

    runApp(const MyApp());
  }, (error, stackTrace) {
    debugPrint('Uncaught error: $error\n$stackTrace');
  });
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
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigateToLoginScreen();
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _navigateToLoginScreen() {
    _navigationTimer = Timer(
      const Duration(seconds: 2), // Duration of the splash screen
          () {
        if (!mounted) return;
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
