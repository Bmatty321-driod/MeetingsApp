import 'package:chirpmeeting/screen/first_view_screen.dart';
import 'package:chirpmeeting/screen/variables.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:chirpmeeting/theme/theme.dart' as Style;

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Style.Colors.mainColor,
      pages: [
        PageViewModel(
          title: "Welcome",
          body:
              "Welcome to ChirpMeeting, the best video conference meeting app",
          image: Center(
            child: Image.asset(
              'assets/images/welcome.png',
              height: 175,
            ),
          ),
          decoration: PageDecoration(
            bodyTextStyle: mystyle(20, Style.Colors.titleColor),
            titleTextStyle: mystyle(20, Style.Colors.titleColor),
          ),
        ),
        PageViewModel(
          title: "Join or Start Meetings",
          body: "Easy interface, Join or start meetings in a fast time",
          image: Center(
            child: Image.asset(
              'assets/images/conference.png',
              height: 150,
            ),
          ),
          decoration: PageDecoration(
            bodyTextStyle: mystyle(20, Style.Colors.titleColor),
            titleTextStyle: mystyle(20, Style.Colors.titleColor),
          ),
        ),
        PageViewModel(
          title: "Security",
          body:
              "Your Security is paramount to us. Our servers is relaible, secure and efficient ",
          image: Center(
            child: Image.asset(
              'assets/images/secure.png',
              height: 175,
            ),
          ),
          decoration: PageDecoration(
            bodyTextStyle: mystyle(20, Style.Colors.titleColor),
            titleTextStyle: mystyle(20, Style.Colors.titleColor),
          ),
        ),
      ],
      onDone: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstView()),
        );
      },
      onSkip: () {},
      showNextButton: true,
      next: const Icon(
        Icons.arrow_right,
        size: 45,
      ),
      skip: const Icon(
        Icons.skip_next,
      ),
      done: Text(
        "Done",
        style: mystyle(
          20,
          Style.Colors.titleColor,
        ),
      ),
    );
  }
}
