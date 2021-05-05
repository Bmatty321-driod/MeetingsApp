import 'package:chirpmeeting/screen/variables.dart';
import 'package:chirpmeeting/screen/video_conference/create_meeting.dart';
import 'package:chirpmeeting/screen/video_conference/join_meeting.dart';
import 'package:flutter/material.dart';
import 'package:chirpmeeting/theme/theme.dart' as Style;

class VideoConferenceScreen extends StatefulWidget {
  @override
  _VideoConferenceScreenState createState() => _VideoConferenceScreenState();
}

class _VideoConferenceScreenState extends State<VideoConferenceScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  tabBuild(String name) {
    return Container(
      width: 150,
      height: 50,
      child: Card(
        color: Style.Colors.titleColor,
        child: Center(
          child: Text(
            name,
            style: mystyle(15, Style.Colors.mainColor, FontWeight.w700),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Style.Colors.mainColor,
        title: Text(
          "ChirpMeetings",
          style: mystyle(
            20,
            Style.Colors.titleColor,
            FontWeight.w700,
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            tabBuild("Joint Meeting"),
            tabBuild("Create Meeting"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          JoinMeeting(),
          CreateMeeting(),
        ],
      ),
    );
  }
}
