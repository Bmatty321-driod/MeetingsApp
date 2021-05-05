import 'dart:io';

import 'package:chirpmeeting/screen/variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chirpmeeting/theme/theme.dart' as Style;
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class JoinMeeting extends StatefulWidget {
  @override
  _JoinMeetingState createState() => _JoinMeetingState();
}

class _JoinMeetingState extends State<JoinMeeting> {
  TextEditingController nameController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  bool isVideoMuted = true;
  bool isAudioMuted = true;
  String username = '';

  Future<DocumentSnapshot> getUserData() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    return await userCollection.document(currentUser.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        return Scaffold(
          backgroundColor: Style.Colors.mainColor,
          body: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    "Enter Your Meeting Code",
                    style: mystyle(20, Style.Colors.titleColor),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  PinCodeTextField(
                    controller: roomController,
                    appContext: context,
                    length: 6,
                    autoDisposeControllers: false,
                    animationCurve: Curves.easeInOut,
                    textStyle: const TextStyle(
                        fontSize: 20,
                        color: Style.Colors.titleColor,
                        fontWeight: FontWeight.bold),
                    animationType: AnimationType.fade,
                    backgroundColor: Style.Colors.mainColor,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                    ),
                    animationDuration: Duration(microseconds: 300),
                    onChanged: (value) {},
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelStyle: mystyle(
                        15.0,
                        Style.Colors.titleColor,
                      ),
                      labelText: "Name (Optional)",
                    ),
                    style:
                        mystyle(20.0, Style.Colors.titleColor, FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  CheckboxListTile(
                    value: isVideoMuted,
                    onChanged: (value) {
                      setState(() {
                        isVideoMuted = value;
                      });
                    },
                    title: Text(
                      "Video Muted",
                      style: mystyle(
                        18.0,
                        Style.Colors.titleColor,
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    value: isAudioMuted,
                    onChanged: (value) {
                      setState(() {
                        isAudioMuted = value;
                      });
                    },
                    title: Text(
                      "Audio Muted",
                      style: mystyle(
                        18.0,
                        Style.Colors.titleColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Optional, you can customise your settings in the meeting",
                    textAlign: TextAlign.center,
                    style: mystyle(
                      15.0,
                      Style.Colors.titleColor,
                    ),
                  ),
                  Divider(
                    height: 46.0,
                    thickness: 2.0,
                    color: Style.Colors.mainColor,
                  ),
                  InkWell(
                    onTap: () {
                      joinMeeting();
                      setState(() {
                        username = snapshot.data.data["name"];
                      });
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 54.0,
                      decoration: BoxDecoration(
                        gradient:
                            LinearGradient(colors: GradientColors.dimBlue),
                      ),
                      child: Center(
                        child: Text(
                          "Join Meeting",
                          style: mystyle(20, Style.Colors.mainColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  joinMeeting() async {
    try {
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false
      };
      if (Platform.isAndroid) {
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      var options = JitsiMeetingOptions()
        ..room = roomController.text
        ..userDisplayName =
            nameController.text == '' ? username : nameController.text
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags);

      await JitsiMeet.joinMeeting(options);
    } catch (e) {
      print("Error: $e");
    }
  }
}
