import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class DemandeController extends GetxController {
  demandeItem();
  addQte();
  substractQte();
  selectdate(BuildContext context);
}

class DemandeControllerImp extends DemandeController {
  late TextEditingController datepickercontroller;
  int qte = 1;
  int duree = 1;
  String? besoin;
  late bool isitemhaveanotherdetails;
  @override
  void onInit() {
    super.onInit();
    datepickercontroller = TextEditingController();
    isitemhaveanotherdetails = Get.arguments["isitemhaveanotherdetails"];
  }

  @override
  demandeItem() {}

  @override
  selectdate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2010),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());
    if (picked != null) {
      datepickercontroller.text = picked.toString().split(" ")[0];
    }
    update();
  }

  @override
  addQte() {
    qte++;
    update();
  }

  @override
  substractQte() {
    qte != 1 ? qte-- : null;
    update();
  }

  setBesoin(String? val) {
    besoin = val;
    update();
  }

  addDuration() {
    duree++;
    update();
  }

  substractDuration() {
    duree != 1 ? duree-- : null;
    update();
  }
}
