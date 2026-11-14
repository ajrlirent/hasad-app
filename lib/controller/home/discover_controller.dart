import 'package:get/get.dart';

abstract class DiscoverController extends GetxController {
  changeLocation();
  changeSearchRadius(int distance);
}

class DiscoverControllerImp extends DiscoverController {
  var slidervalue = 20.obs;
  @override
  changeLocation() {}

  @override
  changeSearchRadius(int distance) {
    slidervalue.value = distance;
    update();
  }
}
