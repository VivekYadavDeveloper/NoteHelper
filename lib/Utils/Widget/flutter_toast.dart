import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Core/Utils/Constant/app_color.dart';

class FlutterToast {
  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
