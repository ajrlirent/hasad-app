import 'package:hasad/controller/add/addequipment_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckPhoneNumber extends StatelessWidget {
  final bool checker;
  final String phone;
  const CheckPhoneNumber({
    super.key,
    required this.checker,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GetBuilder<AddequipmentControllerImp>(
          builder: (controller) => Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            side: const BorderSide(color: AppColor.secondaryColor, width: 2),
            activeColor: AppColor.primaryColor,
            value: controller.ischecked1,
            onChanged: (val) {
              controller.ischecked1 = val!;
              controller.update();
            },
            checkColor: AppColor.secondaryColor,
          ),
        ),
        Text(
          phone,
          style: const TextStyle(
              color: AppColor.secondaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
