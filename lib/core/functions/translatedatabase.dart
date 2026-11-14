import 'package:hasad/controller/auth/login_controller.dart';

import 'package:get/get.dart';

translateDatabase(columnAr, columnFr) {
  MyServices myservices = Get.find();

  if (myservices.sharedprefs.getString("lang") == "ar") {
    return columnAr;
  } else {
    return columnFr;
  }
}
