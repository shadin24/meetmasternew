import 'package:flutter/material.dart';
import 'package:signup/animation/animated_content.dart';
import 'package:signup/screens/home/components/profile_menu_widget.dart';
import 'package:signup/screens/home/components/create_meeting.dart'; // Import CreateMeetingPage
import 'package:signup/screens/home/components/my_meetings.dart'; // Import MeetingListPage
import 'package:signup/screens/home/components/search.dart'; // Import SearchMeetingPage
import 'package:signup/theme/theme.dart';
import '../login.dart';

class ProfileScreen extends StatelessWidget {
  final String email;

  const ProfileScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: AnimatedContent(
          show: true,
          leftToRight: -1.0,
          topToBottom: 0.0,
          time: 1500,
          child: Text(
            'HOME',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Make the font bold
              color: AppTheme.primaryColor, // Ensure the text color matches the foreground color
            ),
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryColor,
        actions: [
          // Logout button in the AppBar
          AnimatedContent(
            show: true,
            leftToRight: -1.0,
            topToBottom: 0.0,
            time: 1500,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.power_settings_new, color: AppTheme.primaryColor),
                    SizedBox(width: 8),
                    Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16), // Add spacing to ensure it's aligned
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Center the profile information and button
              Center(
                child: Column(
                  children: [
                    // Replace with your profile image (person icon)
                    AnimatedContent(
                      show: true,
                      leftToRight: 0.0,
                      topToBottom: -5.0,
                      time: 1500,
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200], // Optional: background color
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey[800], // Color of the person icon
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedContent(
                      show: true,
                      leftToRight: 0.0,
                      topToBottom: -5.0,
                      time: 1500,
                      child: Text(
                        email,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              // Add other elements like menu items
              AnimatedContent(
                show: true,
                leftToRight: -1.0,
                topToBottom: 0.0,
                time: 1500,
                child: Column(
                  children: [
                    ProfileMenuWidget(
                      title: "Create Meetings",
                      icon: Icons.add,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateMeetingPage(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuWidget(
                      title: "My Meetings",
                      icon: Icons.calendar_today,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingListPage(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuWidget(
                      title: "Search Meetings",
                      icon: Icons.search,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchMeetingPage(),
                          ),
                        );
                      },
                    ),
                    ProfileMenuWidget(
                      title: "Logout",
                      icon: Icons.power_settings_new,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
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
