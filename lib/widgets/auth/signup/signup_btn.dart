import 'package:hasad/controller/auth/signup_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupBtn extends StatelessWidget {
  final VoidCallback onPressed;

  const SignupBtn({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 100),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 20)),
        child: Text(
          "signupbtn".tr,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColor.primaryColor),
        ),
      ),
    );
  }
}
