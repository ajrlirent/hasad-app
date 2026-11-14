import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CommandController extends GetxController {
  changepage(int current);
}

class CommandControllerImp extends CommandController {
  int currentpage = 0;
  late PageController pagecontrol;

  @override
  void onInit() {
    super.onInit();
    pagecontrol = PageController();
  }

  @override
  changepage(int current) {
    currentpage = current;
    update();
  }
}
