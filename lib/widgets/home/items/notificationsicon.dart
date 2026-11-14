import 'package:hasad/controller/auth/login_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    MyServices myServices = Get.find();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * .03),
      child: GestureDetector(
        onTap: () {
          String? role = myServices.sharedprefs.getString("role");
          if (role == "provider" ||
              role == "provider_individual" ||
              role == "provider_society") {
            Get.toNamed(AppRoutesNames.notificationsScreenProvider);
          } else {
            Get.toNamed(AppRoutesNames.realNotificaitonScreenDemander);
          }
        },
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 50,
            maxHeight: 50,
          ),
          child: SvgPicture.asset(
            width: 25,
            height: 25,
            AppImageAsset.notifyIcon,
            color: Get.isDarkMode ? AppColor.primaryColor : AppColor.textColor,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
