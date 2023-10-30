// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:note_helper/core/utils/constant/app.color.dart';
//
// class ProfileController with ChangeNotifier {
//   final picker = ImagePicker();
//   XFile? _image;
//
//   XFile? get image => _image;
//
// /* Pick Image Form Gallery*/
//   Future selectFileFromDevice(BuildContext context) async {
//     final pickedFile =
//         await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
//
//     if (pickedFile != null) {
//
//       _image = XFile(pickedFile.path);
//
//     }
//   }
//
//   /* Pick Image Form Camera*/
//   Future selectCameraImage(BuildContext context) async {
//     final pickedFile =
//         await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
//
//     if (pickedFile != null) {
//       _image = XFile(pickedFile.path);
//     }
//   }
//
//   void pickImage(context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             content: Container(
//               height: 120,
//               child: Column(
//                 children: <Widget>[
//                   ListTile(
//                     onTap: () {
//                       selectCameraImage(context);
//                       Navigator.pop(context);
//                     },
//                     leading: Icon(
//                       Icons.camera,
//                       color: AppColors.appBarColor,
//                     ),
//                     title: Text("Camera"),
//                   ),
//                   ListTile(
//                     onTap: () {
//                       selectFileFromDevice(context);
//                       Navigator.pop(context);
//                     },
//                     leading: Icon(
//                       Icons.image,
//                       color: AppColors.appBarColor,
//                     ),
//                     title: Text("Gallery"),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
