import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/data/datasource/static/static.dart';
import 'package:hasad/widgets/home/backbtnlogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hasad/controller/add/addequipment_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCategoriesView extends StatelessWidget {
  const AddCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final AddequipmentControllerImp controller =
        Get.find<AddequipmentControllerImp>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Back button logo at the top, similar to an app bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: const Backbtnlogo(),
              ),
            ),
            // The rest of your body content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "discoverHeadline1".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: "sans-serif",
                          fontWeight: FontWeight.w700,
                          fontSize: 27),
                    ),
                    SizedBox(
                      width: Get.width,
                      height: Get.height * .55,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: typelist.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              // Save the typelist ID as an integer in SharedPreferences
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setInt('typeId',
                                  typelist[index].id!); // Save typeId as int

                              // Debugging: Print the stored typeId
                              print(
                                  'Stored typeId in AddCategoriesView: ${typelist[index].id!}');

                              // Navigate to the next screen with the selected typeId
                              Get.toNamed(AppRoutesNames.addCategorieItems,
                                  arguments: {"typeId": typelist[index].id!});
                            },
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    typelist[index].image!,
                                    width: 330,
                                    fit: BoxFit.fill,
                                    height: 330,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  typelist[index].name!.tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
