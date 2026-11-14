import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalisationfromGPS extends StatelessWidget {
  const LocalisationfromGPS({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: InkWell(
        onTap: () {},
        child: Text(
          "localisationtext".tr,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}
