import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';

class AddEquipmentbtn extends StatelessWidget {
  final String prompt;
  final void Function()? onpressed;
  const AddEquipmentbtn({
    super.key,
    required this.prompt,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 3,
            backgroundColor: AppColor.backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12)),
        onPressed: onpressed,
        child: Text(
          prompt,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 23,
              color: AppColor.primaryColor),
        ),
      ),
    );
  }
}
