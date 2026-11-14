import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';

class Actionbtn extends StatelessWidget {
  final Color bgcolor;
  final String action;
  final VoidCallback? onpressed;
  const Actionbtn({
    super.key,
    this.onpressed,
    required this.bgcolor,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Expanded(
          flex: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                backgroundColor: bgcolor,
                foregroundColor: AppColor.primaryColor),
            onPressed: onpressed,
            child: Text(
              action,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          )),
    );
  }
}
