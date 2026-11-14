import 'package:hasad/controller/home/providerhome_controller.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/widgets/home/backbtnlogo.dart';
import 'package:hasad/widgets/home/providerhome/provider_widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSuccess extends GetView<ProviderhomeControllerImp> {
  const AddSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    controller.inservice = true;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          margin: const EdgeInsets.only(top: 10),
          child: ListView(
            children: [
              const Backbtnlogo(),
              const SizedBox(
                height: 50,
              ),
              Image.asset(AppImageAsset.providerhomeSuccess),
              Text(
                "addsuccessHeadline1".tr,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              AddEquipmentBtn(
                prompt: "addsuccessbtn".tr,
                onpressed: () => Get.toNamed(AppRoutesNames.providerhome2),
              )
            ],
          ),
        ),
      ),
    );
  }
}
