import 'dart:io';
import 'package:chirpmeeting/screen/variables.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chirpmeeting/theme/theme.dart' as Style;
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File imagePath;
  bool validate = false;
  TextEditingController nameController = TextEditingController();
  Future<DocumentSnapshot> getUserData() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    return await userCollection.document(currentUser.uid).get();
  }

  updateProfile() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    return await userCollection.document(currentUser.uid).updateData({
      'name': nameController.text,
    });
  }

  Future handleImage(ImageSource imageSource) async {
    final image = await ImagePicker().getImage(source: imageSource);
    setState(() {
      imagePath = File(image.path);
    });
  }

  Future uploadPic(BuildContext context) async {
    setState(() {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile Updated'),
        ),
      );
    });
    String fileName = basename(imagePath.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imagePath);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    var currentUser = await FirebaseAuth.instance.currentUser();
    return await userCollection
        .document(currentUser.uid)
        .updateData({"photoUrl": downloadUrl});
  }

  //  compressImage() async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   Im.Image imageFile = Im.decodeImage(imagePath.readAsBytesSync());
  //   final compressedImageFile = File('$path/img_$postId.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
  //   setState(() {
  //     file = compressedImageFile;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        title: Text(
          " Edit Profile",
          style: mystyle(
            20.0,
            Style.Colors.titleColor,
          ),
        ),
      ),
      body: FutureBuilder(
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
                      height: MediaQuery.of(context).size.height / 2.4,
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
                              child: (imagePath != null)
                                  ? Image.file(
                                      imagePath,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.network(
                                      snapshot.data.data["photoUrl"],
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 50.0,
                        ),
                        child: IconButton(
                          iconSize: 24.0,
                          icon: Icon(
                            Icons.photo_camera,
                            color: Style.Colors.titleColor,
                            size: 30.0,
                          ),
                          onPressed: () {
                            handleImage(ImageSource.gallery);
                          },
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 189.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 40.0, left: 40.0),
                          child: TextField(
                            controller: nameController,
                            style: mystyle(16, Style.Colors.titleColor),
                            decoration: InputDecoration(
                              labelText: "Update Display Name",
                              errorText: validate
                                  ? 'Display Name can\'t be empty'
                                  : null,
                              labelStyle: mystyle(15, Style.Colors.titleColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              nameController.text.isEmpty
                                  ? validate = true
                                  : validate = false;
                            });
                            uploadPic(context);
                            updateProfile();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 40.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: GradientColors.dimBlue),
                            ),
                            child: Center(
                              child: Text(
                                "Update Now",
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
      ),
    );
  }
}
