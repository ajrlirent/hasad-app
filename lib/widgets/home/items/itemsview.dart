// import 'package:hasad/controller/home/items_controller.dart';
// import 'package:hasad/core/constants/color.dart';
// import 'package:hasad/core/constants/imageassets.dart';
// import 'package:hasad/core/constants/routes_names.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

// class ItemsView extends GetView<ItemsControllerImp> {
//   const ItemsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: Get.height * .65,
//       child: GetBuilder<ItemsControllerImp>(
//         builder: (controller) => controller.selectedCatItems.isEmpty
//             ? Center(
//                 child: Lottie.asset(AppImageAsset.empty, repeat: true),
//               )
//             : ListView.separated(
//                 itemCount: controller.selectedCatItems.length,
//                 physics: const BouncingScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 itemBuilder: (context, index) => Column(
//                   children: [
//                     SizedBox(
//                       height: Get.height * .24,
//                       child: controller.selectedCatItems[index].photo != null
//                           ? AppNetworkImage(
//                               controller.selectedCatItems[index].photo!,
//                               fit: BoxFit.cover,
//                             )
//                           : Container(
//                               color: Colors.grey, // Placeholder color or widget
//                               child: const Center(
//                                 child: Text("No Image Available"),
//                               ),
//                             ),
//                     ),
//                     const SizedBox(height: 5),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         SizedBox(
//                           width: 150,
//                           child: Text(
//                             controller.selectedCatItems[index].label,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w700, fontSize: 15),
//                           ),
//                         ),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               elevation: 2,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(11)),
//                               backgroundColor: AppColor.backgroundColor,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 13, horizontal: 6)),
//                           onPressed: () {
//                             Get.toNamed(AppRoutesNames.demande, arguments: {
//                               "isitemhaveanotherdetails": controller
//                                   .selectedCatItems[index].haveattachments
//                             });
//                           },
//                           child: Text(
//                             "itemsactionbtn".tr,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 15,
//                                 color: AppColor.primaryColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: Get.height * .09,
//                     )
//                   ],
//                 ),
//                 separatorBuilder: (context, index) => const SizedBox(
//                   width: 10,
//                 ),
//               ),
//       ),
//     );
//   }
// }
import 'package:hasad/controller/home/items_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:hasad/data/models/itemsmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasad/core/cache/app_network_image.dart';

class ItemsView extends GetView<ItemsControllerImp> {
  const ItemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .65,
      child: GetBuilder<ItemsControllerImp>(
        builder: (controller) {
          if (controller.selectedCatItems.isEmpty) {
            return const Center(
              child: Text('No items available'), // Or use Lottie if needed
            );
          } else {
            return ListView.separated(
              itemCount: controller.selectedCatItems.length,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final ItemsModel item = controller.selectedCatItems[index];

                return Column(
                  children: [
                    SizedBox(
                      height: Get.height * .24,
                      child: item.photo != null
                          ? AppNetworkImage(
                              item.photo!, // Display image if photo exists
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey, // Placeholder if no image
                              child: const Center(
                                child: Text("No Image Available"),
                              ),
                            ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            item.label,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11)),
                              backgroundColor: AppColor.backgroundColor,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 6)),
                          onPressed: () async {
                            // Retrieve the typeId from arguments passed via Get.toNamed
                            final arguments = Get.arguments;
                            final int? typeId = arguments?['typeId']
                                as int?; // Retrieve typeId from arguments

                            // Retrieve categoryLabel from SharedPreferences
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String? categoryLabel =
                                prefs.getString('category_label');

                            // Trim and normalize the categoryLabel
                            final String trimmedLabel =
                                categoryLabel?.trim().toLowerCase() ?? '';

                            // Debugging prints
                            print('Selected Sub-Category: ${item.label}');
                            print('Under Category: $categoryLabel');
                            print(
                                'Retrieved typeId: $typeId'); // Debugging to check the typeId

                            String categoryType = '';

                            // Check if typeId is valid
                            if (typeId == null) {
                              print("Error: typeId is null or unsupported.");
                              return;
                            }

                            // Check type based on typeId and categoryLabel
                            if (typeId == 1) {
                              // Handle Construction Vehicle cases
                              if (trimmedLabel == "service transport") {
                                categoryType = "Transportation Vehicle";
                                print(
                                    "Form Type: type two - Transportation Vehicle");
                              } else if (trimmedLabel == "attachement") {
                                categoryType = "Construction Attachment";
                                print(
                                    "Form Type: type three - Construction Attachment");
                              } else if (item.categoryId == 1 ||
                                  item.categoryId == 2 ||
                                  item.categoryId == 3 ||
                                  item.categoryId == 4 ||
                                  item.categoryId == 5 ||
                                  item.categoryId == 6 ||
                                  item.categoryId == 7 ||
                                  item.categoryId == 8) {
                                categoryType = "Construction Vehicle";
                                print(
                                    "Form Type: type one - Construction Vehicle");
                              }
                            } else if (typeId == 2) {
                              // Handle Construction Equipment cases
                              if (item.categoryId >= 1 &&
                                  item.categoryId <= 7) {
                                categoryType = "Construction Equipment";
                                print(
                                    "Form Type: type four - Construction Equipment");
                              }
                            } else {
                              // Handle unknown or unsupported types
                              print("Unknown or unsupported typeId: $typeId");
                            }

                            // Navigate to the next form
                            Get.toNamed(AppRoutesNames.demande, arguments: {
                              "typeId": item.categoryId.toString(),
                              "isitemhaveanotherdetails": item.haveattachments,
                              "label": item.label, // Sub-category label
                              "photo": item.photo, // Pass photo if available
                              "sub_category_id":
                                  item.id, // Pass sub_category_id dynamically
                              "categoryLabel":
                                  categoryLabel, // Pass category label
                              "categoryType":
                                  categoryType, // Pass the determined category type
                            });
                          },
                          child: const Text(
                            "Select",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: AppColor.primaryColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * .09,
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10),
            );
          }
        },
      ),
    );
  }
}
