import 'package:hasad/controller/home/items_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:hasad/core/constants/imageassets.dart';
import 'package:hasad/core/constants/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hasad/constant/ApiLinkNames.dart';
import 'package:hasad/core/cache/app_network_image.dart';

// class SelectAddItemsView extends GetView<ItemsControllerImp> {
//   const SelectAddItemsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: Get.height * .65,
//       child: GetBuilder<ItemsControllerImp>(
//         builder: (controller) => controller.selectedCatItems.isEmpty
//             ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Lottie.asset(AppImageAsset.empty, repeat: true),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "No items available. Please try again later.",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               )
//             : ListView.separated(
//                 itemCount: controller.selectedCatItems.length,
//                 physics: const BouncingScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 itemBuilder: (context, index) {
//                   final item = controller.selectedCatItems[index];
//                   String? imageUrl = constructImageUrl(item.photo);

//                   debugPrint("Item ID: ${item.id}");
//                   debugPrint("Category ID: ${item.categoryId}");
//                   debugPrint("Image URL for ${item.label}: $imageUrl");

//                   return Column(
//                     children: [
//                       SizedBox(
//                         height: Get.height * .24,
//                         child: imageUrl != null
//                             ? AppNetworkImage(
//                                 imageUrl,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     Container(
//                                   color: Colors.grey,
//                                   child: const Center(
//                                     child: Text("No Image Available"),
//                                   ),
//                                 ),
//                               )
//                             : Container(
//                                 color: Colors.grey,
//                                 child: const Center(
//                                   child: Text("No Image Available"),
//                                 ),
//                               ),
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           SizedBox(
//                             width: 150,
//                             child: Text(
//                               item.label ?? "No Label",
//                               textAlign: TextAlign.center,
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w700, fontSize: 15),
//                             ),
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               elevation: 2,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(11),
//                               ),
//                               backgroundColor: AppColor.backgroundColor,
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 13, horizontal: 6),
//                             ),
//                             // onPressed: () async {
//                             //   Get.dialog(
//                             //     Center(child: CircularProgressIndicator()),
//                             //     barrierDismissible: false,
//                             //   );

//                             //   SharedPreferences prefs =
//                             //       await SharedPreferences.getInstance();
//                             //   await prefs.setString(
//                             //       'id', item.id?.toString() ?? '');
//                             //   await prefs.setString('category_id',
//                             //       item.categoryId?.toString() ?? '');
//                             //   await prefs.setString('label', item.label ?? '');
//                             //   await prefs.setString(
//                             //       'image_url', imageUrl ?? '');

//                             //   Get.back(); // Close loading dialog
//                             //   Get.offNamed(AppRoutesNames.addequipment);
//                             // },
//                             onPressed: () async {
//                               SharedPreferences prefs =
//                                   await SharedPreferences.getInstance();

//                               // Save the selected item's details, including sub_category_id
//                               await prefs.setString(
//                                   'id',
//                                   controller.selectedCatItems[index].id
//                                       .toString());
//                               await prefs.setString(
//                                 'category_id',
//                                 controller.selectedCatItems[index].categoryId
//                                     .toString(),
//                               );
//                               await prefs.setString(
//                                 'sub_category_id', // Ensure sub_category_id is saved
//                                 controller.selectedCatItems[index].id
//                                     .toString(),
//                               );
//                               await prefs.setString('label',
//                                   controller.selectedCatItems[index].label);
//                               await prefs.setString(
//                                   'image_url', imageUrl ?? '');

//                               // Debugging: Verify saved data
//                               print("Saved to SharedPreferences:");
//                               print(
//                                   "  id=${controller.selectedCatItems[index].id}");
//                               print(
//                                   "  category_id=${controller.selectedCatItems[index].categoryId}");
//                               print(
//                                   "  sub_category_id=${controller.selectedCatItems[index].id}");
//                               print(
//                                   "  label=${controller.selectedCatItems[index].label}");

//                               Get.offNamed(AppRoutesNames
//                                   .addequipment); // Navigate to the next screen
//                             },
//                             child: Text(
//                               "itemSubCatSelectnbtn".tr,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 15,
//                                 color: AppColor.primaryColor,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: Get.height * .09),
//                     ],
//                   );
//                 },
//                 separatorBuilder: (context, index) => const SizedBox(width: 10),
//               ),
//       ),
//     );
//   }

//   String? constructImageUrl(String? url) {
//     if (url == null || url.isEmpty) return null;
//     if (url.startsWith('public/')) {
//       url = url.replaceFirst('public/', 'storage/');
//     }
//     if (!url.startsWith('http')) {
//       url = '${ApiLinkNames.server}/$url';
//     }
//     return url;
//   }
// }
class SelectAddItemsView extends GetView<ItemsControllerImp> {
  final ScrollController scrollController;
  const SelectAddItemsView({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * .65,
      child: GetBuilder<ItemsControllerImp>(
        builder: (controller) {
          if (controller.selectedCatItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(AppImageAsset.empty, repeat: true),
                  const SizedBox(height: 10),
                  const Text(
                    "No items available. Please try again later.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            controller: scrollController, // Assign ScrollController here
            itemCount: controller.selectedCatItems.length,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (index >= controller.selectedCatItems.length) {
                return const SizedBox.shrink();
              }
              final item = controller.selectedCatItems[index];
              String? imageUrl = constructImageUrl(item.photo);

              return Column(
                children: [
                  SizedBox(
                    height: Get.height * .24,
                    child: imageUrl != null
                        ? AppNetworkImage(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey,
                              child: const Center(
                                child: Text("No Image Available"),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey,
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
                          item.label ?? "No Label",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          backgroundColor: AppColor.backgroundColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 13, horizontal: 6),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          // Save the selected item's details, including sub_category_id
                          await prefs.setString('id',
                              controller.selectedCatItems[index].id.toString());
                          await prefs.setString(
                            'category_id',
                            controller.selectedCatItems[index].categoryId
                                .toString(),
                          );
                          await prefs.setString(
                            'sub_category_id',
                            controller.selectedCatItems[index].id.toString(),
                          );
                          await prefs.setString('label',
                              controller.selectedCatItems[index].label);
                          await prefs.setString('image_url', imageUrl ?? '');

                          Get.offNamed(AppRoutesNames.addequipment);
                        },
                        child: Text(
                          "itemSubCatSelectnbtn".tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * .09),
                ],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10),
          );
        },
      ),
    );
  }

  String? constructImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('public/')) {
      url = url.replaceFirst('public/', 'storage/');
    }
    if (!url.startsWith('http')) {
      url = '${ApiLinkNames.server}/$url';
    }
    return url;
  }
}
