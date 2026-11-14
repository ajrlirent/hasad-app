import 'package:hasad/controller/home/items_controller.dart';
import 'package:hasad/views/screens/add/SelectAddItemsView.dart'; // Capitalize the file name
import 'package:hasad/widgets/home/backbtnlogo.dart';
import 'package:hasad/widgets/home/items/caticonsview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class AddCatItems extends StatelessWidget {
//   const AddCatItems({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => ItemsControllerImp());

//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Back button logo at the top, similar to an app bar
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: const Backbtnlogo(),
//               ),
//             ),
//             // The rest of your body content
//             Expanded(
//               child: SizedBox(
//                 width: Get.width,
//                 height: Get.height,
//                 child: GetBuilder<ItemsControllerImp>(
//                   builder: (controller) {
//                     return ListView(
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         const SizedBox(height: 5),
//                         const CatIconsView(),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 15),
//                           child: Text(
//                             "itemsHeadline1".tr,
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w600, fontSize: 22),
//                           ),
//                         ),
//                         const SelectAddItemsView(), // Use the correct class name here
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class AddCatItems extends StatelessWidget {
  const AddCatItems({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ItemsControllerImp());
    final ScrollController scrollController = ScrollController();

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
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: GetBuilder<ItemsControllerImp>(
                  builder: (controller) {
                    return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 5),
                        CatIconsView(scrollController: scrollController),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "itemsHeadline1".tr,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 22),
                          ),
                        ),
                        SelectAddItemsView(scrollController: scrollController),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
