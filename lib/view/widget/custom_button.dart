import 'package:flutter/material.dart';
import 'package:note_helper/core/utils/constant/app.color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.title,
      required this.onTap,
      required this.color,
      this.isLoading = false});

  final String title;
  final bool isLoading;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: color,
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
                  style:  TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
