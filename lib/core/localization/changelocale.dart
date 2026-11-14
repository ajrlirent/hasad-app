import 'package:hasad/controller/auth/login_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  late Locale langage;

  MyServices myservices = Get.find();

  changelang(String langcode) {
    Locale mylocale = Locale(langcode);
    myservices.sharedprefs.setString("lang", langcode);
    Get.updateLocale(mylocale); // Notify GetX to update the locale
  }

  @override
  void onInit() {
    String? currentlocale = myservices.sharedprefs.getString("lang");
    if (currentlocale == "ar") {
      langage = const Locale("ar");
    } else if (currentlocale == "fr") {
      langage = const Locale("fr");
    } else {
      langage = const Locale("fr");
    }
    super.onInit();
  }
}
