import 'package:chirpmeeting/screen/variables.dart';
import 'package:flutter/material.dart';
import 'package:chirpmeeting/theme/theme.dart' as Style;
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:uuid/uuid.dart';

class CreateMeeting extends StatefulWidget {
  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  String code = '';

  createYourCode() {
    setState(() {
      code = Uuid().v1().substring(0, 6);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Text(
              "Create and share code with your friends",
              style: mystyle(
                20.0,
                Style.Colors.titleColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Code:",
                style: mystyle(
                  30.0,
                  Style.Colors.titleColor,
                ),
              ),
              Text(
                code,
                style: mystyle(
                  30,
                  Style.Colors.titleColor,
                  FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25.0,
          ),
          InkWell(
            onTap: () => createYourCode(),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 50.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: GradientColors.dimBlue),
              ),
              child: Center(
                child: Text(
                  "Create Your Code",
                  style: mystyle(20, Style.Colors.mainColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
