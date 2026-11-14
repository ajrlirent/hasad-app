import 'package:hasad/controller/home/demanderhome_controller.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/widgets/home/homepagelogo.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Demanderhome2 extends StatelessWidget {
  const Demanderhome2({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DemanderhomeControllerImp());
    return Scaffold(
      body: SafeArea(
        child: Container(
            width: Get.width,
            height: Get.height,
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: HomepageLogo(),
                ),
                SizedBox(
                  height: Get.height * .2,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Vous n'avez pas commandez d'équipements, ajoutez le vôtre maintenant",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                  ),
                ),
                Image.asset(AppImageAsset.providerhomeEmpty),
              ],
            )),
      ),
    );
  }
}
