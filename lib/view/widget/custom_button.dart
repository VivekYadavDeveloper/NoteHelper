import 'package:flutter/material.dart';
import 'package:note_helper/core/utils/constant/app.color.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.isLoading = false});

  final String title;
  bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.appBarColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
