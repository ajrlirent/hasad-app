import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonsRow extends StatelessWidget {
  const ButtonsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primaryColor,
              backgroundColor: AppColor.backgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            ),
            onPressed: () {
              // Handle Accepter button click
              print("Accepter clicked");
            },
            child: const Text(
              "Accepter",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primaryColor,
              backgroundColor: AppColor.backgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            ),
            onPressed: () {
              // Handle Modifier button click
              print("Modifier clicked");
            },
            child: const Text(
              "Modifier",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColor.primaryColor,
              backgroundColor: AppColor.secondaryColor,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            ),
            onPressed: () {
              // Handle Annuler button click
              print("Annuler clicked");
            },
            child: const Text(
              "Annuler",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
