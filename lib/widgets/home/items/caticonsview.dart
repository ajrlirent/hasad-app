// class CatIconsView extends GetView<ItemsControllerImp> {
//   const CatIconsView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: Get.height * .18,
//       width: Get.width,
//       child: ListView.separated(
//           physics: const ClampingScrollPhysics(),
//           scrollDirection: Axis.horizontal,
//           itemBuilder: (context, index) => InkWell(
//                 onTap: () {
//                   controller.displayItems(controller.selectedCats[index].id!);
//                 },
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundColor: AppColor.backgroundColor,
//                       child: Image.asset(
//                         controller.selectedCats[index].icon!,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     SizedBox(
//                       width: Get.width * .25,
//                       child: Text(
//                         controller.selectedCats[index].name!,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                             fontWeight: FontWeight.w700,
//                             color: AppColor.backgroundColor,
//                             fontSize: 10),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//           separatorBuilder: (context, index) => const SizedBox(
//                 width: 10,
//               ),
//           itemCount: controller.selectedCats.length),
//     );
//   }
// }import 'package:hasad/controller/home/items_controller.dart';
import 'package:hasad/controller/home/items_controller.dart';
import 'package:hasad/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class CatIconsView extends GetView<ItemsControllerImp> {
//   const CatIconsView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Retrieve the typeId from the arguments passed from CategoriesView
//     final arguments = Get.arguments;
//     final int? typeId = arguments != null && arguments['typeId'] != null
//         ? arguments['typeId'] is int
//             ? arguments['typeId']
//             : int.tryParse(arguments['typeId'].toString() ?? '')
//         : 1; // Default to 1 if typeId is null

//     // Debugging the typeId retrieved
//     print('Received typeId in CatIconsView: $typeId');

//     return SizedBox(
//       height: Get.height * .18,
//       width: Get.width,
//       child: GetBuilder<ItemsControllerImp>(
//         builder: (controller) {
//           return ListView.separated(
//             physics: const ClampingScrollPhysics(),
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) => InkWell(
//               onTap: () async {
//                 final int categoryId = controller.selectedCats[index].id;
//                 final String categoryLabel =
//                     controller.selectedCats[index].label;
//                 final String trimmedLabel = categoryLabel.trim().toLowerCase();

//                 // Debugging category label and ID
//                 print('Selected Category: $categoryLabel');
//                 print('Trimmed Category Label: $trimmedLabel');

//                 // Save selected category id and label in SharedPreferences
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 await prefs.setString('category_id', categoryId.toString());
//                 await prefs.setString('category_label', trimmedLabel);

//                 // Store the typeId in SharedPreferences
//                 await prefs.setInt(
//                     'typeId', typeId ?? 1); // Ensure typeId is saved

//                 String orderType = '';

//                 // Determine the category order type based on typeId
//                 if (typeId == 1) {
//                   // Handle typeId == 1
//                   if (trimmedLabel == "service transport") {
//                     orderType = "Transportation";
//                   } else if (trimmedLabel == "attachement") {
//                     orderType = "Attachment";
//                   } else {
//                     orderType =
//                         "Vehicle"; // Default to "Vehicle" if the label doesn't match any of the above
//                   }
//                 } else if (typeId == 2) {
//                   orderType = "Equipment"; // If typeId is 2, it's "Equipment"
//                 }

//                 // Debugging the determined orderType
//                 print('Determined orderType: $orderType');

//                 // Call controller to display items based on the selected category
//                 controller.displayItems(categoryId);
//               },
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: MediaQuery.of(context).size.width *
//                         0.1, // Adjust the size of the avatar
//                     backgroundColor: AppColor.backgroundColor,
//                     child: Image.asset(
//                       'assets/images/${controller.selectedCats[index].value}.png',
//                       width: MediaQuery.of(context).size.width * 0.1,
//                       height: MediaQuery.of(context).size.width * 0.1,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Icon(Icons.category,
//                             size: MediaQuery.of(context).size.width * 0.075);
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   SizedBox(
//                     width: Get.width * .25,
//                     child: Text(
//                       controller.selectedCats[index].label,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         color: AppColor.backgroundColor,
//                         fontSize: 10,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             separatorBuilder: (context, index) => const SizedBox(width: 10),
//             itemCount: controller.selectedCats.length,
//           );
//         },
//       ),
//     );
//   }
// }

class CatIconsView extends GetView<ItemsControllerImp> {
  final ScrollController scrollController;
  const CatIconsView({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final int? typeId = arguments != null && arguments['typeId'] != null
        ? arguments['typeId'] is int
            ? arguments['typeId']
            : int.tryParse(arguments['typeId'].toString() ?? '')
        : 1;

    return SizedBox(
      height: Get.height * .18,
      width: Get.width,
      child: GetBuilder<ItemsControllerImp>(
        builder: (controller) {
          return ListView.separated(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => InkWell(
              onTap: () async {
                final int categoryId = controller.selectedCats[index].id;

                // Save selected category id in SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('category_id', categoryId.toString());

                // Display the selected items
                controller.displayItems(categoryId);

                // Scroll to the top of the ListView
                scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.1,
                    backgroundColor: AppColor.backgroundColor,
                    child: Image.asset(
                      'assets/images/${controller.selectedCats[index].value}.png',
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.category,
                            size: MediaQuery.of(context).size.width * 0.075);
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: Get.width * .25,
                    child: Text(
                      controller.selectedCats[index].label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColor.backgroundColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: controller.selectedCats.length,
          );
        },
      ),
    );
  }
}
