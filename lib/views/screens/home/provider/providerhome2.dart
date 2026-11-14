import 'package:hasad/controller/home/providerhome_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/widgets/home/providerhome/provider_widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Providerhome2 extends StatelessWidget {
  const Providerhome2({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProviderhomeControllerImp());
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutesNames.addequipment),
        backgroundColor: AppColor.backgroundColor,
        child: const Icon(
          Icons.add,
          size: 16,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            children: const [
              Header(),
              SizedBox(
                height: 50,
              ),
              // ItemStatusCard(
              //     image: AppImageAsset.pleteuse,
              //     title: "JCB EXCVATOR SE 550",
              //     subtitle: "Vehicle",
              //     year: "2006",
              //     price: "20k DZD/J 300k DZD/M",
              //     icon: AppImageAsset.activeIcon,
              //     status: "Active",
              //     bgcolor: AppColor.activeservicecolor),
              // ItemStatusCard(
              //   image: AppImageAsset.minipelle,
              //   title: "HANDAR Mini pelle ",
              //   subtitle: "Vehicle",
              //   year: "2012",
              //   price: "12k DZD/J 250 DZD/M",
              //   icon: AppImageAsset.horsserviceIcon,
              //   status: "Hors service",
              //   bgcolor: AppColor.horsservicecolor,
              //   id: "equipment_id_123", // Pass the equipment ID
              //   type: "equipment", // Specify the type
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
