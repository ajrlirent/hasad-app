import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AjouteAttachmentText extends StatelessWidget {
  const AjouteAttachmentText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "ajouteattachementtext".tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ],
    );
  }
}
