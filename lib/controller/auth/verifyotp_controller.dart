import 'dart:async';

import 'package:hasad/controller/auth/login_controller.dart';
import 'package:hasad/core/constants/routes_names.dart';

import 'package:get/get.dart';

abstract class VerifyOtoController extends GetxController {
  verifyotp(String otp);
  resendotp();
  starttimer(int seconds);
}

class VerifyotpControllerImp extends VerifyOtoController {
  MyServices myServices = Get.find();
  late String phoneNo;
  Timer? timer;
  int remainingseconds = 1;
  final time = "00:00".obs;

  @override
  verifyotp(String otp) {
    myServices.sharedprefs.setString("skip", "2");
    Get.offAllNamed(AppRoutesNames.signup);
  }

  @override
  resendotp() {
    starttimer(120);
  }

  @override
  starttimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainingseconds = seconds;
    timer = Timer.periodic(duration, (timer) {
      if (remainingseconds < 0) {
        timer.cancel();
      } else {
        int minutes = remainingseconds ~/ 60;
        int displayseconds = (remainingseconds % 60);
        time.value =
            "${minutes.toString().padLeft(2, "0")}:${displayseconds.toString().padLeft(2, "0")}";
        remainingseconds--;
      }
    });
  }

  @override
  void onInit() {
    phoneNo = "222222222";

    super.onInit();
  }

  @override
  void onReady() {
    starttimer(120);
    super.onReady();
  }
}
