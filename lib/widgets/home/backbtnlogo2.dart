import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Backbtnlogo2 extends StatelessWidget {
  final double margin;

  const Backbtnlogo2({super.key, this.margin = 270});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: margin),
      child: IconButton(
          onPressed: () => Get.offNamed(AppRoutesNames.homepage),
          icon: Image.asset(AppImageAsset.logowithbackbtn)),
    );
  }
}
