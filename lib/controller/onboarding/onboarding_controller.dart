import 'package:hasad/controller/auth/login_controller.dart';
import 'package:hasad/core/constants/routes_names.dart';

import 'package:hasad/data/datasource/static/static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class OnboardingController extends GetxController {
  next();
  onpagechanged(int index);
  skip();
}

class OnboardingControllerImp extends OnboardingController {
  int currentpage = 0;
  late PageController pagecontrol;
  MyServices myservices = Get.find();

  @override
  next() {
    currentpage++;
    if (currentpage > onboardingList.length - 1) {
      myservices.sharedprefs.setString("skip", "1"); // Save onboarding status
      Get.offAllNamed(
          AppRoutesNames.login); // Redirect to login after onboarding
    } else {
      pagecontrol.animateToPage(currentpage,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    }
  }

  @override
  onpagechanged(int index) {
    currentpage = index;
    update();
  }

  @override
  skip() {
    myservices.sharedprefs.setString("skip", "1"); // Save skip status
    Get.offAllNamed(AppRoutesNames.login); // Redirect to login page
  }

  @override
  void onInit() {
    pagecontrol = PageController();
    super.onInit();
  }
}
