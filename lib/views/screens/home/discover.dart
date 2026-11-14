import 'package:hasad/controller/auth/login_controller.dart';
import 'package:hasad/controller/home/discover_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/widgets/home/discover/categoriesview.dart';
import 'package:hasad/widgets/home/discover/customheadline.dart';
import 'package:hasad/widgets/home/discover/mylocationinfo.dart';
import 'package:hasad/widgets/home/discover/searchbox.dart';
import 'package:hasad/widgets/home/homepagelogo.dart';
import 'package:hasad/widgets/home/items/notificationsicon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Discover extends GetView<DiscoverControllerImp> {
  const Discover({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DiscoverControllerImp());
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: Get.width * .02,
          ),
          height: Get.height,
          width: Get.width,
          margin: const EdgeInsets.only(top: 3),
          child: Form(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Ensure items are spaced properly
                  children: [
                    const Expanded(
                      child:
                          HomepageLogo(), // Use Expanded or Flexible to prevent overflow
                    ),
                    SizedBox(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            String route = Get.find<MyServices>()
                                        .sharedprefs
                                        .getString("role") ==
                                    "provider"
                                ? "Provider Page"
                                : "Demander Page";
                            print("Navigating to: $route");
                            Get.toNamed(route == "Provider Page"
                                ? AppRoutesNames.notificationsScreenProvider
                                : AppRoutesNames
                                    .realNotificaitonScreenDemander);
                          },
                          child: Transform.scale(
                            scale:
                                1.5, // Increase the scale to make the icon larger
                            child: const NotificationIcon(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      MyLocationtext(),
                      LocationDropDownBtn(),
                      // SearchBox(),
                      CustomHeadline(),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 23),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppColor.secondaryColor),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CategoriesView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
