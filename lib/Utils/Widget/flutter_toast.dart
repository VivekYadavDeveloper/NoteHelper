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
        textColor: AppColors.secondaryColor,
        fontSize: 16.0);
  }
}
