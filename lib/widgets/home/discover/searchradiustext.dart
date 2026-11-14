import 'package:hasad/controller/home/discover_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchRadiusText extends GetView<DiscoverControllerImp> {
  const SearchRadiusText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Row(
        children: [
          Text("radiussearchtext".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColor.secondaryColor,
                  fontFamily: "sans-serif",
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          Obx(
            () => Text("${controller.slidervalue}${"metricunit".tr}",
                style: const TextStyle(
                    fontFamily: "sans-serif",
                    fontWeight: FontWeight.w700,
                    fontSize: 17)),
          )
        ],
      ),
    );
  }
}
