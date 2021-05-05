import 'package:chirpmeeting/screen/HomePage.dart';
import 'package:chirpmeeting/screen/first_view_screen.dart';
import 'package:chirpmeeting/screen/intro_screen.dart';
import 'package:chirpmeeting/screen/sign_up_screen.dart';
import 'package:chirpmeeting/services/auth_services.dart';
import 'package:chirpmeeting/widget/provider.dart';

import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PageNavigate(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeController(),
          '/signUp': (BuildContext context) =>
              SignUpViews(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) =>
              SignUpViews(authFormType: AuthFormType.signIn),
        },
      ),
    );
  }
}

class PageNavigate extends StatefulWidget {
  @override
  _PageNavigateState createState() => _PageNavigateState();
}

class _PageNavigateState extends State<PageNavigate> {
  bool isSigned = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSigned == false ? IntroScreen() : HomePage(),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? HomePage() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
