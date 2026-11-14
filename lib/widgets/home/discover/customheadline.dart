import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomHeadline extends StatelessWidget {
  const CustomHeadline({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      "discoverHeadline1".tr,
      textAlign: TextAlign.left,
      style: const TextStyle(
          fontFamily: "sans-serif", fontWeight: FontWeight.w700, fontSize: 27),
    );
  }
}
