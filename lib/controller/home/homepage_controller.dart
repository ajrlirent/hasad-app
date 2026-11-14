import 'package:hasad/core/constants/color.dart';

import 'package:hasad/widgets/home/navbar_with_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class HomeScreenController extends GetxController {
  pageNavigation(int pageindex);
}

class HomeScreenControllerImp extends HomeScreenController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  int currentpage = 0;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  pageNavigation(int pageindex) {
    currentpage = pageindex;
    update();
  }

  changeIcon() {
    if (currentpage == 0) {
      return const Icon(
        NavbarIcons.homeinactive,
        color: AppColor.backgroundColor,
      );
    }
    if (currentpage == 1) {
      return const Icon(
        NavbarIcons.discoverinactive,
        color: AppColor.backgroundColor,
      );
    }
    if (currentpage == 2) {
      return const Icon(
        Icons.person,
        color: AppColor.backgroundColor,
      );
    }
    update();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
