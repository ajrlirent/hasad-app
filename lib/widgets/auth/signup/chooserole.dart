import 'package:hasad/controller/auth/signup_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChooseRole extends StatelessWidget {
  const ChooseRole({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupControllerImp>(
      builder: (controller) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppColor.backgroundColor, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  AppImageAsset.roleIcon,
                  height: 30,
                  width: 30,
                )),
            Expanded(
              flex: 7,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(20),
                  iconEnabledColor: AppColor.backgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  value: controller.role,
                  items: const [
                    DropdownMenuItem(
                      value: "provider",
                      child: Text("fournisseur"),
                    ),
                    DropdownMenuItem(
                      value: "demander",
                      child: Text("bénéficiaire"),
                    ),
                  ],
                  onChanged: (val) {
                    controller.setRole(val!);
                  },
                  hint: const Text("Choisissez votre rôle"),
                  isExpanded: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseTargetAudiance extends StatelessWidget {
  const ChooseTargetAudiance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupControllerImp>(
      builder: (controller) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppColor.backgroundColor, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                flex: 1,
                child: SvgPicture.asset(
                  AppImageAsset.roleIcon,
                  height: 30,
                  width: 30,
                )),
            Expanded(
              flex: 7,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(20),
                  iconEnabledColor: AppColor.backgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  value: controller.type,
                  items: const [
                    DropdownMenuItem(
                      value: "society",
                      child: Text("Société"),
                    ),
                    DropdownMenuItem(
                      value: "individuel",
                      child: Text("Individuel"),
                    ),
                  ],
                  onChanged: (val) {
                    controller.setType(val!);
                  },
                  hint: const Text("Choisissez votre cible"),
                  isExpanded: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
