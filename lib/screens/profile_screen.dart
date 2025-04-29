import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding the keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          // app bar
          appBar: AppBar(
            title: Text('Profile Screen'),
          ),

          // floating button to log out
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                // show progress dialog
                Dialogs.showProgressBar(context);

                // set active status to false
                await APIs.updateActiveStatus(false);

                // sign out from app
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    // remove progress dialog
                    Navigator.pop(context);
                    // remove homescreen
                    Navigator.pop(context);

                    APIs.auth = FirebaseAuth.instance;

                    // replacing home screen with login screen
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  });
                });
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // for adding some space
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),

                    // display user profile pic
                    Stack(
                      children: [
                        // profile picture
                        _image != null
                            ?
                            // local image
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            :
                            // image from server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  // placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(CupertinoIcons.person),
                                ),
                              ),

                        // edit image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),

                    // for adding some space
                    SizedBox(
                      height: mq.height * .03,
                    ),

                    // display user email
                    Text(
                      widget.user.email,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),

                    // for adding some space
                    SizedBox(
                      height: mq.height * .05,
                    ),

                    // name input field
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (value) => APIs.me.name = value ?? '',
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blueAccent,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'e.g Happy Singh',
                          label: Text('Name')),
                    ),

                    // for adding some space
                    SizedBox(
                      height: mq.height * .02,
                    ),

                    // about input field
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (value) => APIs.me.about = value ?? '',
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.info,
                            color: Colors.blueAccent,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'e.g Feeling Great',
                          label: Text('About')),
                    ),

                    // for adding some space
                    SizedBox(
                      height: mq.height * .05,
                    ),

                    // update profile button
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackbar(
                                context, 'Profile Updated Successfully!');
                          });
                        }
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 28,
                      ),
                      label: Text(
                        'Update Details',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        minimumSize: Size(mq.width * .5, mq.height * .06),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }

  // bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              // pick profile picture label
              Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),

              // for adding some space
              SizedBox(
                height: mq.height * .02,
              ),

              // buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);

                        if (image != null) {
                          log('Image Path: ${image.path} -- MimeType: ${image.mimeType}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/add_image.png')),
                  // take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);

                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
