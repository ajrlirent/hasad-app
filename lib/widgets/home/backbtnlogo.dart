import 'package:hasad/core/constants/imageassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Backbtnlogo extends StatelessWidget {
  const Backbtnlogo({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Get.back(),
      icon: Image.asset(AppImageAsset.logowithbackbtn,
        width: 30, // Adjust size if needed
        height: 30, // Adjust size if needed
      ),
    );
  }
}
