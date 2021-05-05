import 'package:chirpmeeting/screen/profile_screen.dart';
import 'package:chirpmeeting/screen/variables.dart';
import 'package:chirpmeeting/screen/video_conference_screen.dart';
// import 'package:chirpmeeting/services/auth_services.dart';
// import 'package:chirpmeeting/widget/provider.dart';
import 'package:flutter/material.dart';
import 'package:chirpmeeting/theme/theme.dart' as Style;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 0;
  List pageOptions = [
    VideoConferenceScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Style.Colors.mainColor,
          selectedItemColor: Style.Colors.titleColor,
          unselectedItemColor: Style.Colors.secondColor,
          selectedLabelStyle: mystyle(16, Style.Colors.titleColor),
          unselectedLabelStyle: mystyle(16, Style.Colors.mainColor),
          currentIndex: page,
          onTap: (index) {
            setState(() {
              page = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              title: Text("Video call"),
              icon: Icon(
                Icons.video_call,
                size: 30,
              ),
            ),
            BottomNavigationBarItem(
              title: Text("Profile"),
              icon: Icon(
                Icons.person,
                size: 30,
              ),
            ),
          ]),
      body: pageOptions[page],
    );
  }
}
