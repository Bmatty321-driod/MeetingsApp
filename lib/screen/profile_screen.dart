import 'dart:io';
import 'package:chirpmeeting/screen/edit_profile_screen.dart';
import 'package:chirpmeeting/screen/variables.dart';
import 'package:chirpmeeting/services/auth_services.dart';
import 'package:chirpmeeting/widget/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chirpmeeting/theme/theme.dart' as Style;
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File imagePath;
  Future<DocumentSnapshot> getUserData() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    return await userCollection.document(currentUser.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Style.Colors.mainColor,
            body: Stack(
              children: [
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2.5,
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: GradientColors.darkOcean),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Style.Colors.titleColor,
                        child: ClipOval(
                          child: SizedBox(
                            height: 180.0,
                            width: 180.0,
                            child: Image.network(
                              snapshot.data.data["photoUrl"],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 235.0,
                      ),
                      Text(
                        snapshot.data.data["name"],
                        style: mystyle(30, Style.Colors.titleColor),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 40.0,
                          decoration: BoxDecoration(
                            gradient:
                                LinearGradient(colors: GradientColors.dimBlue),
                          ),
                          child: Center(
                            child: Text(
                              "Edit Profile",
                              style: mystyle(16, Style.Colors.mainColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      InkWell(
                        onTap: () async {
                          try {
                            AuthService auth = Provider.of(context).auth;
                            await auth.signOut();
                          } catch (e) {}
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 40.0,
                          decoration: BoxDecoration(
                            gradient:
                                LinearGradient(colors: GradientColors.dimBlue),
                          ),
                          child: Center(
                            child: Text(
                              "Sign Out",
                              style: mystyle(16, Style.Colors.mainColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Text("No data");
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
