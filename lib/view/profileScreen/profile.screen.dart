import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:note_helper/view/widget/custom_button.dart';
import 'package:note_helper/view/widget/resuable.widget.dart';
import '../../core/model/post.model.dart';
import '../widget/flutter.toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  PostModel? postModel;

  /*Create Firebase Storage Instance For Using Storage*/
  firebase_storage.FirebaseStorage firebaseStorage =
      firebase_storage.FirebaseStorage.instance;

  /*After Creating This Go To Upload button*/

  /*Create Image Picker instance*/
  final picker = ImagePicker();
  XFile? _image;

/* Pick Image Form Gallery*/
  Future selectFileFromDevice(BuildContext context) async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);
      });
    }
  }

  User? user = FirebaseAuth.instance.currentUser;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('User');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("P R O F I L E"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return StreamBuilder(
              stream: databaseRef.ref.child(user!.uid).onValue,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  /* Now Create a Map For Fetch Data*/
                  Map<Object?, dynamic> map =
                      snapshot.data.snapshot.value as Map<Object?, dynamic>;
                  return Column(
                    children: <Widget>[
                      const SizedBox(height: 15),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    selectFileFromDevice(context);
                                    debugPrint("Pick Image");
                                  },
                                  child: Container(
                                    height: 130,
                                    width: 130,
                                    decoration: const BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: map['profileImage'].toString() ==
                                              ""
                                          ? const Icon(Icons.person)
                                          : Image(
                                              image: NetworkImage(
                                                  map['profileImage']
                                                      .toString()),
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                              errorBuilder: (context, object,
                                                  errorBuilder) {
                                                return const Icon(Icons.error,
                                                    color: Colors.red);
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 100, top: 20),
                            child: CircleAvatar(
                              child: Icon(Icons.add_a_photo),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      CustomButton(
                          title: "Upload",
                          isLoading: isLoading,
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            /*Create Firebase_Storage With Reference Instance and Create folder With User UID */
                            firebase_storage.Reference ref = firebase_storage
                                .FirebaseStorage.instance
                                .ref('/profileFolder/   ${user!.uid}');

                            /* Now Firebase_Storage with UploadTask to Upload the File */
                            firebase_storage.UploadTask uploadTask =
                                ref.putFile(
                              File(_image!.path),
                            );
                            Future.value(uploadTask).then((value) async {
                              var newURl = await ref.getDownloadURL();
                              databaseRef.child(user!.uid).set({
                                'email': user!.email,
                                'uid': user!.uid,
                                'profileImage': newURl.toString(),
                                'onlineStatus': 'noOne',
                              });
                              setState(() {
                                isLoading = false;
                              });
                              FlutterToast().toastMessage("Image Updated");
                              debugPrint(newURl.toString());
                            }).onError((error, stackTrace) {
                              debugPrint(error.toString());
                              FlutterToast().toastMessage(error.toString());
                            });
                          }),
                      ReusableWidget(
                        iconData: Icons.email_rounded,
                        title: 'Email',
                        value: map['email'],
                      )
                    ],
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Something Went Wrong",
                      style: TextStyle(fontSize: 25),
                    ),
                  );
                }
              });
        }),
      ),
    );
  }
}
